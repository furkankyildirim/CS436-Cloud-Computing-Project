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
        id = response.json().get('user', {}).get('_id')
        
        return token, id
    
    @task
    def register_and_test(self):
        # Generate random credentials for each new user
        random_email = ''.join(random.choices(string.ascii_lowercase, k=20)) + "@example.com"
        random_password = "123456"

        # Register new user

        
        multipart_data = MultipartEncoder(
            fields={
                'firstName': 'John',
                'lastName': 'Doe',
                'email': random_email,
                'password': random_password,
                'picturePath': '',
                'friends': '[]',  # assuming friends is an empty list initially
                'location': 'New York',
                'occupation': 'Developer'
            }
        )
        
        response = self.client.post("/auth/register", data=multipart_data,
                                     headers={'Content-Type': multipart_data.content_type})
        
        print(f"Registration status code: {response.status_code}")
        
        # If registration successful, login and test other routes
        if response.status_code == 201:
            token, id = self.login(random_email, random_password)
            
            # Test other routes with the obtained token
            self.test_routes(token, id)
    
    def test_routes(self, token, id):
        headers = {"Authorization": f"Bearer {token}"}
        
        # Test other routes here
        self.create_post(headers, id)
        self.get_user(headers)
        #self.get_posts(headers)
        
    
    def get_user(self, headers):
        id = "6652eac17154d5be6ceade89"
        response = self.client.get("/users/6652eac17154d5be6ceade89", headers=headers)
        print(f"Get user status code: {response.status_code}")
    
    #def get_posts(self, headers):
        #response = self.client.get("/posts", headers=headers)
        #print(f"Get posts status code: {response.status_code}")

    def create_post(self, headers, id):

        # Path to the image file
        image_path = "/Users/furkankyildirim/Desktop/Ekran Resmi 2024-05-26 20.55.04.png"

        # Ensure the image file exists
        if os.path.exists(image_path):
            # Create the multipart form data with the image file
            multipart_data = MultipartEncoder(
                fields={
                    "userId": id,
                    "description": "Hello World",
                    "picture": (os.path.basename(image_path), open(image_path, 'rb'), 'image/jpeg')
                }
            ) 
            # Set headers with content type and authorization
            headers_with_content = {
                    'Content-Type': multipart_data.content_type,
                    'Authorization': headers['Authorization']
                }
            
            response = self.client.post("/posts", data=multipart_data,
                                        headers=headers_with_content)
            
            print(f"Create Posts status code: {response.status_code}")


class MyLoadTest(HttpUser):
    tasks = [MyTaskSet] 
    wait_time = between(1, 5) 



