#!/bin/bash
 
echo "Stopping existing application..."
docker compose down
 
echo "Starting application..."
docker compose up -d
 
echo "Checking application status..."
docker compose ps
 
echo "Application deployment completed."