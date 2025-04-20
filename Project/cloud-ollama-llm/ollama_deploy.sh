#!/bin/bash

# setup user log file
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Start running user script: $(date)"
set -xe

# Install Docker
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Install and start docker service
sudo docker run -d \
  -v ollama:/root/.ollama \
  -p 11434:11434 \
  --name ollama ollama/ollama

echo "Waiting for Ollama to start..."
until [ "$(sudo docker inspect -f '{{.State.Running}}' ollama)" == "true" ]; do
  sleep 5
done
echo "Ollama started."

# Pull the model
sudo docker exec ollama ollama pull ${ollama_model}