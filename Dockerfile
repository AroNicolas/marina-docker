# Étape 1 : build du projet OCaml marina
FROM ocaml/opam:debian-12 as builder

WORKDIR /marina
RUN sudo apt update && sudo apt install -y make ocaml ocamlbuild

# Clone le projet marina
COPY ./marina /marina
RUN make

# Étape 2 : image finale avec Python et Flask
FROM python:3.11-slim

WORKDIR /app

# Copie le binaire OCaml compilé
COPY --from=builder /marina/marina ./marina/marina
RUN chmod +x ./marina/marina

# Copie le serveur Flask et les dépendances
COPY app.py requirements.txt ./
RUN pip install -r requirements.txt

# Copie le dossier marina si besoin pour autres fichiers
COPY ./marina ./marina

# Expose le port Flask
EXPOSE 10000

# Lance Flask
CMD ["python", "app.py"]
