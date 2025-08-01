# Étape 1 : image de base avec OCaml
FROM ocaml/opam:ubuntu-22.04 as build

WORKDIR /marina

# Installer make, ocamlbuild et dépendances
RUN sudo apt-get update && \
    sudo apt-get install -y make ocaml ocamlbuild git

# Cloner le projet marina
RUN git clone https://github.com/hei-school/marina.git .

# Construire le binaire marina
RUN make

# Étape 2 : image finale plus légère avec Python et le binaire seulement
FROM python:3.10-slim

# Installer Flask
RUN pip install flask

# Copier le binaire marina depuis l'étape de build
COPY --from=build /marina/marina /app/marina

# Copier ton script Flask (assure-toi qu'il s'appelle app.py)
COPY app.py /app/app.py

WORKDIR /app

# Expose le port (ici 5000, tu peux adapter selon besoin)
EXPOSE 5000

# Lance gunicorn au lieu de flask dev server
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]