#!/usr/bin/python3
# -*- coding: UTF-8 -*-
import socket

# Paramètres du serveur
SERVER_ADDRESS = '127.0.0.1'  # Adresse IP du serveur (localhost)
SERVER_PORT = 8080            # Port utilisé par le serveur

def send_message(sock, message):
    """Envoyer un message au serveur et recevoir la réponse"""
    sock.sendall(message.encode())  # Envoi du message au serveur
    response = sock.recv(1024).decode()  # Réception de la réponse
    print(f"Réponse du serveur: {response.strip()}")
    return response


def interactive_client():
    """Client interactif qui permet à l'utilisateur d'envoyer des commandes au serveur"""
    # Créer un socket TCP/IP
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        # Se connecter au serveur
        sock.connect((SERVER_ADDRESS, SERVER_PORT))
        print(f"Connecté au serveur {SERVER_ADDRESS}:{SERVER_PORT}")
        print("Instructions :\n"
              "- Saisir 'IDCARD <numéro>' pour envoyer un ID de carte\n"
              "- Saisir 'IDREADER <numéro>' pour envoyer un ID de lecteur\n"
              "- Saisir 'exit' pour quitter le client\n")

        while True:
            # Lire l'entrée de l'utilisateur
            user_input = input("> ")

            if user_input.lower() == "exit":
                print("Déconnexion du serveur...")
                break  # Sortir de la boucle pour fermer le client

            # Envoyer la commande au serveur
            response = send_message(sock, user_input)

            # Si la réponse contient un code ou une erreur, informer l'utilisateur
            if response:
                # Vérifier les différentes réponses possibles
                if "UNAUTHORISED" in response:
                    print("Accès non autorisé.")
                elif "CARDNO" in response:
                    print("Erreur: Carte invalide.")
                elif "READERNO" in response:
                    print("Erreur: Lecteur invalide.")
                elif "READEROK" in response:
                    print("Lecteur valide.")
                elif "CARDOK" in response:  # Ajout de la vérification de CARDOK
                    print("Carte valide.")
                elif "ACCESS DENIED" in response:
                    print("Accès refusé à cette salle.")
                elif "ACCESS GRANTED" in response:
                    print("Accès accordé à cette salle.")
                else:
                    print("Message non reconnu, veuillez vérifier votre commande.")


if __name__ == "__main__":
    interactive_client()
