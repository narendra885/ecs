[
  {
    "essential": true,
    "memory": 256,
    "name": "myapp",
    "cpu": 256,
    "image": "240055317661.dkr.ecr.us-east-1.amazonaws.com/test:latest",
    "workingDirectory": "/app",
    "command": ["python", "app.py"],
    "portMappings": [
        {
            "containerPort": 80,
            "hostPort": 80
        }
    ]
  }
]

