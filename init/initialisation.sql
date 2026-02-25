SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. SUPPRESSION (RESET)
DROP TABLE IF EXISTS Inscription;
DROP TABLE IF EXISTS Prerequis;
DROP TABLE IF EXISTS Structure_Parcours;
DROP TABLE IF EXISTS Catalogue_Mention;
DROP TABLE IF EXISTS Etudiant;
DROP TABLE IF EXISTS Parcours;
DROP TABLE IF EXISTS UE;
DROP TABLE IF EXISTS Mention;

SET FOREIGN_KEY_CHECKS = 1;

-- 2. CREATION
CREATE TABLE Mention (
                         id_mention VARCHAR(50),
                         nom_mention VARCHAR(100) NOT NULL,
                         PRIMARY KEY (id_mention)
);

CREATE TABLE UE (
                    code_ue VARCHAR(20),
                    nom_ue VARCHAR(100) NOT NULL,
                    nb_credits INT CHECK (nb_credits IN (3, 6)),
                    PRIMARY KEY (code_ue)
);

CREATE TABLE Parcours (
                          id_parcours VARCHAR(50),
                          nom_parcours VARCHAR(100) NOT NULL,
                          id_mention VARCHAR(50),
                          PRIMARY KEY (id_parcours),
                          FOREIGN KEY (id_mention) REFERENCES Mention(id_mention)
);

CREATE TABLE Etudiant (
                          num_etu INT,
                          nom VARCHAR(50) NOT NULL,
                          prenom VARCHAR(50) NOT NULL,
                          date_naissance DATE, -- NOUVELLE COLONNE
                          id_parcours VARCHAR(50),
                          PRIMARY KEY (num_etu),
                          FOREIGN KEY (id_parcours) REFERENCES Parcours(id_parcours)
);

CREATE TABLE Catalogue_Mention (
                                   id_mention VARCHAR(50),
                                   code_ue VARCHAR(20),
                                   PRIMARY KEY (id_mention, code_ue),
                                   FOREIGN KEY (id_mention) REFERENCES Mention(id_mention),
                                   FOREIGN KEY (code_ue) REFERENCES UE(code_ue)
);

CREATE TABLE Structure_Parcours (
                                    id_parcours VARCHAR(50),
                                    code_ue VARCHAR(20),
                                    est_obligatoire BOOLEAN DEFAULT FALSE,
                                    PRIMARY KEY (id_parcours, code_ue),
                                    FOREIGN KEY (id_parcours) REFERENCES Parcours(id_parcours),
                                    FOREIGN KEY (code_ue) REFERENCES UE(code_ue)
);

CREATE TABLE Prerequis (
                           code_ue VARCHAR(20),
                           code_ue_requise VARCHAR(20),
                           PRIMARY KEY (code_ue, code_ue_requise),
                           FOREIGN KEY (code_ue) REFERENCES UE(code_ue),
                           FOREIGN KEY (code_ue_requise) REFERENCES UE(code_ue)
);

CREATE TABLE Inscription (
                             num_etu INT,
                             code_ue VARCHAR(20),
                             annee_univ VARCHAR(9),
                             semestre INT, -- Modifié en INT pour calculs (1, 2, 3, 4, 5, 6)
                             statut_validation VARCHAR(20) DEFAULT 'en_cours',
                             PRIMARY KEY (num_etu, code_ue, annee_univ, semestre),
                             FOREIGN KEY (num_etu) REFERENCES Etudiant(num_etu),
                             FOREIGN KEY (code_ue) REFERENCES UE(code_ue)
);

-- 3. INSERTION DE DONNEES

-- MENTIONS
INSERT INTO Mention VALUES ('MIASHS', 'Mathématiques et Informatique Appliquées aux SHS');
INSERT INTO Mention VALUES ('INFO', 'Informatique Fondamentale');
INSERT INTO Mention VALUES ('ECO', 'Economie et Gestion');

-- PARCOURS
INSERT INTO Parcours VALUES ('MIAGE', 'Méthodes Informatiques Appliquées à la Gestion', 'MIASHS');
INSERT INTO Parcours VALUES ('BIGDATA', 'Science des Données', 'MIASHS');
INSERT INTO Parcours VALUES ('DEV', 'Développement Logiciel', 'INFO');
INSERT INTO Parcours VALUES ('GESTION', 'Gestion des Entreprises', 'ECO');

-- UE
INSERT INTO UE VALUES ('INTRO_JAVA', 'Introduction Java', 6);
INSERT INTO UE VALUES ('JAVA_AVANCE', 'Java Avancé', 6);
INSERT INTO UE VALUES ('WEB_STATIC', 'Web HTML/CSS', 3);
INSERT INTO UE VALUES ('WEB_DYN', 'Web Dynamique PHP', 6);
INSERT INTO UE VALUES ('BDD_SQL', 'Bases de Données Relationnelles', 6);
INSERT INTO UE VALUES ('ALGO_TRI', 'Algorithmique et Tris', 6);
INSERT INTO UE VALUES ('RESEAU', 'Réseaux IP', 3);
INSERT INTO UE VALUES ('STATS_DESC', 'Statistiques Descriptives', 3);
INSERT INTO UE VALUES ('PROBA', 'Probabilités', 6);
INSERT INTO UE VALUES ('COMPTA', 'Comptabilité Générale', 6);
INSERT INTO UE VALUES ('MARKETING', 'Introduction au Marketing', 3);
INSERT INTO UE VALUES ('ANGLAIS_1', 'Anglais S1', 3);
INSERT INTO UE VALUES ('ANGLAIS_2', 'Anglais S2', 3);
INSERT INTO UE VALUES ('SPORT', 'Sport - Badminton', 3);
INSERT INTO UE VALUES ('RHETORIQUE', 'Art Oratoire', 3);

-- CATALOGUE
INSERT INTO Catalogue_Mention VALUES ('MIASHS', 'INTRO_JAVA'), ('MIASHS', 'JAVA_AVANCE'), ('MIASHS', 'BDD_SQL'), ('MIASHS', 'STATS_DESC'), ('MIASHS', 'COMPTA');
INSERT INTO Catalogue_Mention VALUES ('INFO', 'INTRO_JAVA'), ('INFO', 'JAVA_AVANCE'), ('INFO', 'ALGO_TRI'), ('INFO', 'WEB_STATIC'), ('INFO', 'WEB_DYN');
INSERT INTO Catalogue_Mention VALUES ('ECO', 'COMPTA'), ('ECO', 'MARKETING'), ('ECO', 'STATS_DESC');

-- STRUCTURE PARCOURS
INSERT INTO Structure_Parcours VALUES ('MIAGE', 'INTRO_JAVA', TRUE), ('MIAGE', 'BDD_SQL', TRUE), ('MIAGE', 'COMPTA', TRUE), ('MIAGE', 'WEB_STATIC', FALSE);
INSERT INTO Structure_Parcours VALUES ('DEV', 'ALGO_TRI', TRUE), ('DEV', 'INTRO_JAVA', TRUE), ('DEV', 'WEB_DYN', TRUE);

-- PREREQUIS
INSERT INTO Prerequis VALUES ('JAVA_AVANCE', 'INTRO_JAVA'), ('WEB_DYN', 'WEB_STATIC'), ('WEB_DYN', 'INTRO_JAVA'), ('BDD_SQL', 'ALGO_TRI'), ('ANGLAIS_2', 'ANGLAIS_1');

-- ==========================================
-- ETUDIANTS (Avec date de naissance)
-- ==========================================
INSERT INTO Etudiant VALUES (101, 'Snow', 'Jon', '2002-12-05', 'MIAGE');
INSERT INTO Etudiant VALUES (102, 'Simpson', 'Homer', '1985-05-12', 'MIAGE');
INSERT INTO Etudiant VALUES (103, 'Granger', 'Hermione', '2003-09-19', 'DEV');
INSERT INTO Etudiant VALUES (104, 'Potter', 'Harry', '2003-07-31', 'DEV');
INSERT INTO Etudiant VALUES (105, 'Nook', 'Tom', '1995-10-18', 'GESTION');
INSERT INTO Etudiant VALUES (201, 'Lannister', 'Tyrion', '1982-06-11', 'MIAGE');
INSERT INTO Etudiant VALUES (202, 'Stark', 'Arya', '2005-04-15', 'DEV');
INSERT INTO Etudiant VALUES (203, 'Targaryen', 'Daenerys', '2002-05-01', 'BIGDATA');
INSERT INTO Etudiant VALUES (204, 'Skywalker', 'Luke', '2001-09-25', 'DEV');
INSERT INTO Etudiant VALUES (205, 'Stark', 'Tony', '1990-05-29', 'DEV');
INSERT INTO Etudiant VALUES (206, 'Wayne', 'Bruce', '1995-02-19', 'GESTION');
INSERT INTO Etudiant VALUES (207, 'Croft', 'Lara', '1998-02-14', 'BIGDATA');
INSERT INTO Etudiant VALUES (208, 'Danvers', 'Carol', '1997-10-10', 'MIAGE');
INSERT INTO Etudiant VALUES (209, 'Baggins', 'Frodo', '2002-09-22', 'GESTION');
INSERT INTO Etudiant VALUES (210, 'Wick', 'John', '1992-09-12', 'MIAGE');

-- ==========================================
-- INSCRIPTIONS (Semestres : 1=S1, 2=S2, 3=S3, 4=S4, 5=S5, 6=S6)
-- ==========================================

-- 1. Jon Snow (MIAGE) : L2 validée (S3, S4), en L3 (S5)
INSERT INTO Inscription VALUES (101, 'INTRO_JAVA', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (101, 'ALGO_TRI', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (101, 'ANGLAIS_1', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (101, 'WEB_STATIC', '2022-2023', 4, 'valide');
INSERT INTO Inscription VALUES (101, 'JAVA_AVANCE', '2023-2024', 5, 'en_cours');
INSERT INTO Inscription VALUES (101, 'BDD_SQL', '2023-2024', 5, 'en_cours');
INSERT INTO Inscription VALUES (101, 'COMPTA', '2023-2024', 5, 'en_cours');

-- 2. Homer Simpson (MIAGE) : Bloqué en L2 (S3)
INSERT INTO Inscription VALUES (102, 'INTRO_JAVA', '2022-2023', 3, 'echoue');
INSERT INTO Inscription VALUES (102, 'ALGO_TRI', '2022-2023', 3, 'echoue');
INSERT INTO Inscription VALUES (102, 'SPORT', '2022-2023', 4, 'valide');
INSERT INTO Inscription VALUES (102, 'INTRO_JAVA', '2023-2024', 3, 'en_cours');
INSERT INTO Inscription VALUES (102, 'ALGO_TRI', '2023-2024', 3, 'en_cours');

-- 3. Hermione Granger (DEV) : Major de promo, déjà en S5
INSERT INTO Inscription VALUES (103, 'INTRO_JAVA', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (103, 'ALGO_TRI', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (103, 'WEB_STATIC', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (103, 'WEB_DYN', '2022-2023', 4, 'valide');
INSERT INTO Inscription VALUES (103, 'JAVA_AVANCE', '2023-2024', 5, 'valide');
INSERT INTO Inscription VALUES (103, 'RHETORIQUE', '2023-2024', 5, 'en_cours');

-- 4. Harry Potter (DEV) : Retard sur Java
INSERT INTO Inscription VALUES (104, 'ALGO_TRI', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (104, 'INTRO_JAVA', '2022-2023', 3, 'echoue');
INSERT INTO Inscription VALUES (104, 'INTRO_JAVA', '2023-2024', 3, 'en_cours');
INSERT INTO Inscription VALUES (104, 'WEB_STATIC', '2023-2024', 3, 'en_cours');

-- 5. Tom Nook (GESTION) : L1
INSERT INTO Inscription VALUES (105, 'COMPTA', '2023-2024', 1, 'en_cours');
INSERT INTO Inscription VALUES (105, 'MARKETING', '2023-2024', 1, 'en_cours');

-- 6. Tyrion Lannister (MIAGE) : Très bon en oratoire et stats
INSERT INTO Inscription VALUES (201, 'ANGLAIS_1', '2023-2024', 5, 'en_cours');
INSERT INTO Inscription VALUES (201, 'STATS_DESC', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (201, 'RHETORIQUE', '2022-2023', 4, 'valide');

-- 7. Arya Stark (DEV) : L1 en découverte
INSERT INTO Inscription VALUES (202, 'ANGLAIS_1', '2023-2024', 1, 'en_cours');
INSERT INTO Inscription VALUES (202, 'WEB_STATIC', '2023-2024', 1, 'en_cours');
INSERT INTO Inscription VALUES (202, 'SPORT', '2023-2024', 1, 'en_cours');

-- 8. Daenerys Targaryen (BIGDATA) : L3 S5
INSERT INTO Inscription VALUES (203, 'ANGLAIS_1', '2023-2024', 5, 'en_cours');
INSERT INTO Inscription VALUES (203, 'STATS_DESC', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (203, 'PROBA', '2023-2024', 5, 'en_cours');

-- 9. Luke Skywalker (DEV) : S'oriente réseaux
INSERT INTO Inscription VALUES (204, 'INTRO_JAVA', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (204, 'RESEAU', '2022-2023', 4, 'valide');
INSERT INTO Inscription VALUES (204, 'JAVA_AVANCE', '2023-2024', 5, 'en_cours');

-- 10. Tony Stark (DEV) : A tout validé
INSERT INTO Inscription VALUES (205, 'INTRO_JAVA', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (205, 'ALGO_TRI', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (205, 'WEB_DYN', '2023-2024', 5, 'en_cours');

-- 11. Bruce Wayne (GESTION)
INSERT INTO Inscription VALUES (206, 'COMPTA', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (206, 'MARKETING', '2022-2023', 4, 'valide');
INSERT INTO Inscription VALUES (206, 'STATS_DESC', '2023-2024', 5, 'en_cours');

-- 12. Lara Croft (BIGDATA)
INSERT INTO Inscription VALUES (207, 'STATS_DESC', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (207, 'ALGO_TRI', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (207, 'BDD_SQL', '2023-2024', 5, 'en_cours');

-- 13. Carol Danvers (MIAGE)
INSERT INTO Inscription VALUES (208, 'INTRO_JAVA', '2023-2024', 1, 'en_cours');
INSERT INTO Inscription VALUES (208, 'COMPTA', '2023-2024', 1, 'en_cours');

-- 14. Frodo Baggins (GESTION) : Repique la compta
INSERT INTO Inscription VALUES (209, 'COMPTA', '2022-2023', 3, 'echoue');
INSERT INTO Inscription VALUES (209, 'COMPTA', '2023-2024', 3, 'en_cours');
INSERT INTO Inscription VALUES (209, 'MARKETING', '2023-2024', 3, 'en_cours');

-- 15. John Wick (MIAGE)
INSERT INTO Inscription VALUES (210, 'BDD_SQL', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (210, 'SPORT', '2023-2024', 5, 'en_cours');