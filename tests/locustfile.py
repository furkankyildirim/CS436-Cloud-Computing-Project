from locust import HttpUser, TaskSet, task, between
from requests_toolbelt.multipart.encoder import MultipartEncoder
import os
import random
import string

class MyTaskSet(TaskSet):
    def login(self, email, password):
        # Send a POST request to the authentication endpoint to obtain the token
        response = self.client.post("/auth/login", json={"email": email, "password": password})
        
        # Extract the token from the response
        token = response.json().get("token")
        
        return token
    
    @task
    def register_and_test(self):
        # Generate random credentials for each new user
        random_email = ''.join(random.choices(string.ascii_lowercase, k=5)) + "@example.com"
        random_password = ''.join(random.choices(string.ascii_letters + string.digits, k=10))

        # Register new user
        file_path = 'client/public/logo192.png'
        if not os.path.exists(file_path):
            print(f"File not found: {file_path}")
            return
        
        multipart_data = MultipartEncoder(
            fields={
                'firstName': 'John',
                'lastName': 'Doe',
                'email': random_email,
                'password': random_password,
                'picture': ('image.png', open(file_path, 'rb'), 'image/png'),
                'friends': '[]',  # assuming friends is an empty list initially
                'location': 'New York',
                'occupation': 'Developer'
            }
        )
        
        response = self.client.post("/auth/register", data=multipart_data,
                                     headers={'Content-Type': multipart_data.content_type})
        
        print(f"Registration status code: {response.status_code}")
        
        # If registration successful, login and test other routes
        if response.status_code == 200:
            token = self.login(random_email, random_password)
            
            # Test other routes with the obtained token
            self.test_routes(token)
    
    def test_routes(self, token):
        headers = {"Authorization": f"Bearer {token}"}
        
        # Test other routes here
        self.get_user(headers)
        self.get_posts(headers)
    
    def get_user(self, headers):
        response = self.client.get("/users/{id}", headers=headers)
        print(f"Get user status code: {response.status_code}")
    
    def get_posts(self, headers):
        response = self.client.get("/posts", headers=headers)
        print(f"Get posts status code: {response.status_code}")

class MyLoadTest(HttpUser):
    tasks = [MyTaskSet]
    wait_time = between(1, 5)  # Simulate a wait time between 1 and 5 seconds between tasks



