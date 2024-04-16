# CS436-Project

 # Project Group Members:
 Doruk Benli 29182 - Ege Öztaş 28828 - Furkan K. Yıldırım 35145 - Nisa Erdal 28943

# Backend project and Description:
Our application is a social media platform like Instagram where users can post pictures and share their thoughts.
Users will be able to create accounts, add friends, like posts, comment on posts, and also view statistics about profile views. 
In  addition, users can also link their social media accounts and display them in their profiles.

# Cloud Architecture:

For our backend, which is developed with Express.js and Node.js, we will opt for Google Compute Engine (GCE). We've chosen Compute Engine for its flexibility and control over the computing environment.
We will manually configure our virtual machines, ensuring they are well-optimized for our application’s performance needs and allowing us to customize the scaling as necessary.

Should we decide to embrace a container-focused strategy down the line, we are aware that Google Kubernetes Engine (GKE) or Cloud Run stand ready as alternatives for orchestrating Docker containers or adopting a serverless architecture.

Our choice for the database is MongoDB Atlas, which will be hosted in its fully managed cloud service. We'll make the integration seamless with GCP and select a region that minimizes latency to ensure prompt responses within our app.

Even though we do not require automated CI/CD pipelines at this stage, we are prepared to implement them using GitHub Actions to automate our deployment processes for the backend when the need arises.

# CLoud Architecture Diagram:

![Ekran görüntüsü 2024-04-16 165401](https://github.com/egeoztass/CS436-Project/assets/120418840/5e68b773-48f3-4d48-a0c8-859bf59609d2)
