#!/bin/bash
# Mise à jour du système
sudo apt-get update -y
sudo apt-get upgrade -y

# Installation des prérequis pour Docker
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Ajout de la clé officielle Docker
curl -fsSL https://docker.com | sudo apt-key add -

# Ajout du dépôt Docker dans les sources Ubuntu
sudo add-apt-repository "deb [arch=amd64] https://docker.com $(lsb_release -cs) stable"

# Installation finale de Docker
sudo apt-get update -y
sudo apt-get install -y docker-ce

# Démarrage et activation de Docker au boot du serveur
sudo systemctl start docker
sudo systemctl enable docker

# Autoriser l'utilisateur admin à utiliser Docker sans "sudo"
sudo usermod -aG docker moncefadmin

