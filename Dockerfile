# Étape 1 : image de base avec OCaml
FROM ocaml/opam:ubuntu-22.04 as build

WORKDIR /marina

# Installer make, ocamlbuild et dépendances
RUN sudo apt-get update && \
    sudo apt-get install -y make ocaml ocamlbuild

# Copier le dossier marina local
COPY ./marina /marina

# Construire le binaire marina
RUN make

# Étape 2 : image finale plus légère avec Python et le binaire seulement
FROM python:3.10-slim

# Installer Flask et gunicorn
RUN pip install flask gunicorn

# Copier le binaire marina depuis l'étape de build
COPY --from=build /marina/marina /app/marina

# Copier ton script Flask
COPY app.py /app/app.py

WORKDIR /app

# Expose le port 5000
EXPOSE 5000

# Lance gunicorn en mode production
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]