-- Table UTILISATEUR
CREATE TABLE UTILISATEUR (
    id_utilisateur SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    adresse TEXT,
    telephone VARCHAR(15),
    mail VARCHAR(100)
);

-- Table ETUDIANT (hérite de UTILISATEUR)
CREATE TABLE ETUDIANT (
    id_etudiant SERIAL PRIMARY KEY,
    cursus VARCHAR(100),
    FOREIGN KEY (id_etudiant) REFERENCES UTILISATEUR(id_utilisateur)
);

-- Table PERSONNEL (hérite de UTILISATEUR)
CREATE TABLE PERSONNEL (
    id_personnel SERIAL PRIMARY KEY,
    type_personnel VARCHAR(50),
    FOREIGN KEY (id_personnel) REFERENCES UTILISATEUR(id_utilisateur)
);

-- Table VISITEUR
CREATE TABLE VISITEUR (
    id_visiteur SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    contact VARCHAR(15),
    raison_visite TEXT,
    date_arrivee DATE,
    duree_visite INTERVAL
);

-- Table COURS
CREATE TABLE COURS (
    id_cours SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    horaires TEXT
);

-- Table SALLE
CREATE TABLE SALLE (
    id_salle SERIAL PRIMARY KEY,
    numero INT,
    batiment VARCHAR(100),
    etage INT,
    nb_salle INT,
    nb_salle_bat INT,
    niveau_acces_requis INT
);

-- Table CARTE_D'ACCES
CREATE TABLE CARTE_DACCES (
    id_carte SERIAL PRIMARY KEY,
    date_activation DATE,
    date_expiration DATE,
    est_active BOOLEAN
);

-- Table POLITIQUE_D'ACCES
CREATE TABLE POLITIQUE_DACCES (
    id_politique SERIAL PRIMARY KEY,
    role VARCHAR(50),
    jours_autorisees VARCHAR(100),
    heures_autorisees VARCHAR(100),
    niveau_acces INT
);

-- Table ASSISTER (relation entre ETUDIANT et COURS)
CREATE TABLE ASSISTER (
    id_etudiant INT,
    id_cours INT,
    PRIMARY KEY (id_etudiant, id_cours),
    FOREIGN KEY (id_etudiant) REFERENCES ETUDIANT(id_etudiant),
    FOREIGN KEY (id_cours) REFERENCES COURS(id_cours)
);

-- Table INVITER (relation entre UTILISATEUR et VISITEUR)
CREATE TABLE INVITER (
    id_utilisateur INT,
    id_visiteur INT,
    PRIMARY KEY (id_utilisateur, id_visiteur),
    FOREIGN KEY (id_utilisateur) REFERENCES UTILISATEUR(id_utilisateur),
    FOREIGN KEY (id_visiteur) REFERENCES VISITEUR(id_visiteur)
);

-- Table DEROULER (relation entre COURS et SALLE)
CREATE TABLE DEROULER (
    id_cours INT,
    id_salle INT,
    PRIMARY KEY (id_cours, id_salle),
    FOREIGN KEY (id_cours) REFERENCES COURS(id_cours),
    FOREIGN KEY (id_salle) REFERENCES SALLE(id_salle)
);

-- Table ENSEIGNER (relation entre PERSONNEL et COURS)
CREATE TABLE ENSEIGNER (
    id_personnel INT,
    id_cours INT,
    PRIMARY KEY (id_personnel, id_cours),
    FOREIGN KEY (id_personnel) REFERENCES PERSONNEL(id_personnel),
    FOREIGN KEY (id_cours) REFERENCES COURS(id_cours)
);

-- Table MODIFIER (relation entre PERSONNEL et CARTE_DACCES)

CREATE TABLE MODIFIER (
    id_log_modif SERIAL PRIMARY KEY,
    id_personnel INT,
    id_carte INT,
    date_modif TIMESTAMP,
    acces_precedent TEXT,
    FOREIGN KEY (id_personnel) REFERENCES PERSONNEL(id_personnel),
    FOREIGN KEY (id_carte) REFERENCES CARTE_DACCES(id_carte)
);


CREATE TABLE POSSEDER (
    id_carte INT,
    id_utilisateur INT,
    PRIMARY KEY (id_carte, id_utilisateur),
    FOREIGN KEY (id_carte) REFERENCES CARTE_DACCES(id_carte),
    FOREIGN KEY (id_utilisateur) REFERENCES UTILISATEUR(id_utilisateur)
);

-- Table RECEVOIR (relation entre VISITEUR et CARTE_DACCES)
CREATE TABLE RECEVOIR (
    id_visiteur INT,
    id_carte INT,
    PRIMARY KEY (id_visiteur, id_carte),
    FOREIGN KEY (id_visiteur) REFERENCES VISITEUR(id_visiteur),
    FOREIGN KEY (id_carte) REFERENCES CARTE_DACCES(id_carte)
);

-- Table LECTEUR
CREATE TABLE LECTEUR (
    id_lecteur SERIAL PRIMARY KEY,
    code VARCHAR(50)
);

-- Table CONTENIR (relation entre LECTEUR et SALLE)
CREATE TABLE CONTENIR (
    id_lecteur INT,
    id_salle INT,
    PRIMARY KEY (id_lecteur, id_salle),
    FOREIGN KEY (id_lecteur) REFERENCES LECTEUR(id_lecteur),
    FOREIGN KEY (id_salle) REFERENCES SALLE(id_salle)
);

-- Table GENERER (relation entre SALLE et CARTE_DACCES)

CREATE TABLE GENERER (
    id_log_acces SERIAL PRIMARY KEY,
    id_salle INT,
    id_carte INT,
    date_acces DATE,
    heure_acces TIME,
    acces_donne BOOLEAN,
    FOREIGN KEY (id_salle) REFERENCES SALLE(id_salle),
    FOREIGN KEY (id_carte) REFERENCES CARTE_DACCES(id_carte)
);

-- Table UTILISER (relation entre CARTE_DACCES et POLITIQUE_DACCES)
CREATE TABLE UTILISER (
    id_carte INT,
    id_politique INT,
    PRIMARY KEY (id_carte, id_politique),
    FOREIGN KEY (id_carte) REFERENCES CARTE_DACCES(id_carte),
    FOREIGN KEY (id_politique) REFERENCES POLITIQUE_DACCES(id_politique)
);

-- Insérer des données dans la table salle
INSERT INTO salle (numero, batiment, etage, nb_salle, nb_salle_bat, niveau_acces_requis)
VALUES 
(101, 'Batiment A', 1, 10, 50, 2),
(202, 'Batiment B', 2, 5, 30, 3),
(303, 'Batiment C', 3, 8, 40, 4),
(404, 'Batiment D', 4, 6, 25, 5),
(505, 'Batiment E', 5, 12, 60, 6);

-- Insérer des données dans la table carte_dacces
INSERT INTO carte_dacces (date_activation, date_expiration, est_active)
VALUES 
('2024-01-01', '2024-12-31', TRUE),
('2023-05-10', '2023-12-31', FALSE),
('2024-02-01', '2024-11-30', TRUE),
('2023-07-15', '2024-07-14', TRUE),
('2022-09-01', '2023-08-31', FALSE);