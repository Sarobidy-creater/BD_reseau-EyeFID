#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <winsock2.h>
#include <ws2tcpip.h>

#define PORT 8080
#define BUFFER_SIZE 100

#define CARD_OK "CARDOK\n"
#define READER_OK "READEROK\n"
#define READER_NO "READERNO\n"
#define CARD_NO "CARDNO\n"
#define UNKNOWN "UNKNOWN MESSAGE\n"

// Définition des structures pour les cartes d'accès et les lecteurs
typedef struct {
    int id_carte;
    char date_activation[11]; // format YYYY-MM-DD
    char date_expiration[11]; // format YYYY-MM-DD
    int est_active; // 1 pour vrai, 0 pour faux
    int niveau_acces; // Niveau d'accès associé
} CarteAcces;

typedef struct {
    int id_reader;
    char name[20]; // Nom ou autre détail pour le lecteur
} Reader;

// Données simulées
CarteAcces cartes[] = {
    {1, "2024-01-01", "2024-12-31", 1, 2},
    {2, "2023-05-10", "2023-12-31", 0, 3},
    {3, "2024-02-01", "2024-11-30", 1, 4},
    {4, "2023-07-15", "2024-07-14", 1, 5},
    {5, "2022-09-01", "2023-08-31", 0, 1}
};

// Liste des lecteurs valides
Reader readers[] = {
    {1, "Lecteur 1"},
    {2, "Lecteur 2"},
    {3, "Lecteur 3"},
};

// Fonction de vérification de la carte d'accès
int verifCard(int idCard) {
    for (int i = 0; i < sizeof(cartes) / sizeof(cartes[0]); i++) {
        if (cartes[i].id_carte == idCard && cartes[i].est_active) {
            return 1; // Carte valide
        }
    }
    return 0; // Carte invalide
}

int main() {
    // Initialisation de Winsock
    WSADATA wsaData;
    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
        printf("Échec de l'initialisation de Winsock. Code d'erreur : %d\n", WSAGetLastError());
        return 1;
    }

    int server_fd, client_fd;
    struct sockaddr_in address;
    int addrlen = sizeof(address);
    char buffer[BUFFER_SIZE];

    // Configuration du socket serveur
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    // Création du socket
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == INVALID_SOCKET) {
        perror("Échec de la création du socket");
        WSACleanup();
        exit(EXIT_FAILURE);
    }

    // Attachement du socket au port
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("Échec du bind");
        WSACleanup();
        exit(EXIT_FAILURE);
    }

    // Mise en écoute des connexions entrantes
    listen(server_fd, 1);
    printf("Le serveur écoute sur le port %d...\n", PORT);

    // Acceptation d'une connexion client
    if ((client_fd = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen)) == INVALID_SOCKET) {
        perror("Échec de l'acceptation");
        WSACleanup();
        exit(EXIT_FAILURE);
    }

    // Boucle principale de communication
    while (1) {
        memset(buffer, 0, BUFFER_SIZE); // Réinitialisation du buffer

        // Réception du message du client
        if (recv(client_fd, buffer, BUFFER_SIZE, 0) <= 0) {
            perror("recv");
            break;
        }
    
        printf("Message reçu : %s", buffer);
    
        // Gestion de la commande IDCARD
        if (strncmp(buffer, "IDCARD ", 7) == 0) {
            int idCard = atoi(buffer + 7); // Convertir le numéro de carte en entier
            if (verifCard(idCard)) {
                send(client_fd, CARD_OK, strlen(CARD_OK), 0);
            } else {
                send(client_fd, CARD_NO, strlen(CARD_NO), 0);
            }
        } 
        // Gestion de la commande IDREADER
        else if (strncmp(buffer, "IDREADER ", 9) == 0) {
            int idReader = atoi(buffer + 9); // Récupérer l'ID du lecteur
            int valid_reader = 0; // Drapeau pour vérifier la validité du lecteur
            for (int i = 0; i < sizeof(readers) / sizeof(readers[0]); i++) {
                if (readers[i].id_reader == idReader) {
                    valid_reader = 1; // Lecteur trouvé
                    break;
                }
            }
            if (valid_reader) {
                send(client_fd, READER_OK, strlen(READER_OK), 0);
            } else {
                send(client_fd, READER_NO, strlen(READER_NO), 0);
            }
        }
        // Si message inconnu
        else {
            send(client_fd, UNKNOWN, strlen(UNKNOWN), 0);
            printf("Message inconnu\n");
        }
    }

    // Fermeture des connexions
    closesocket(client_fd);
    closesocket(server_fd);
    WSACleanup();
    return 0;
}
