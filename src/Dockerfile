# 1. Utiliser une image de base Linux ultra-légère optimisée pour Python
FROM python:3.9-slim

# 2. Définir le dossier de travail à l'intérieur du conteneur
WORKDIR /app

# 3. Copier notre script IA local à l'intérieur du conteneur
COPY app.py .

# 4. Déclarer la commande magique qui va s'exécuter au démarrage du conteneur
CMD ["python", "app.py"]

