SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ==========================================
-- 1. SUPPRESSION (RESET)
-- ==========================================
DROP TABLE IF EXISTS Inscription;
DROP TABLE IF EXISTS Prerequis;
DROP TABLE IF EXISTS Structure_Parcours;
DROP TABLE IF EXISTS Catalogue_Mention;
DROP TABLE IF EXISTS Etudiant;
DROP TABLE IF EXISTS Parcours;
DROP TABLE IF EXISTS UE;
DROP TABLE IF EXISTS Mention;

SET FOREIGN_KEY_CHECKS = 1;

-- ==========================================
-- 2. CREATION DES TABLES
-- ==========================================
CREATE TABLE Mention (
                         id_mention INT,
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
                          id_parcours INT,
                          nom_parcours VARCHAR(100) NOT NULL,
                          id_mention INT, -- CORRIGÉ EN INT
                          PRIMARY KEY (id_parcours),
                          FOREIGN KEY (id_mention) REFERENCES Mention(id_mention)
);

CREATE TABLE Etudiant (
                          num_etu INT,
                          nom VARCHAR(50) NOT NULL,
                          prenom VARCHAR(50) NOT NULL,
                          date_naissance DATE,
                          id_parcours INT, -- CORRIGÉ EN INT
                          PRIMARY KEY (num_etu),
                          FOREIGN KEY (id_parcours) REFERENCES Parcours(id_parcours)
);

CREATE TABLE Catalogue_Mention (
                                   id_mention INT, -- CORRIGÉ EN INT
                                   code_ue VARCHAR(20),
                                   PRIMARY KEY (id_mention, code_ue),
                                   FOREIGN KEY (id_mention) REFERENCES Mention(id_mention),
                                   FOREIGN KEY (code_ue) REFERENCES UE(code_ue)
);

CREATE TABLE Structure_Parcours (
                                    id_parcours INT, -- CORRIGÉ EN INT
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
                             semestre INT,
                             statut_validation VARCHAR(20) DEFAULT 'en_cours',
                             PRIMARY KEY (num_etu, code_ue, annee_univ, semestre),
                             FOREIGN KEY (num_etu) REFERENCES Etudiant(num_etu),
                             FOREIGN KEY (code_ue) REFERENCES UE(code_ue)
);

-- ==========================================
-- 3. INSERTION DE DONNEES
-- ==========================================

-- MENTIONS (1 = MIASHS, 2 = INFO, 3 = ECO)
INSERT INTO Mention VALUES (1, 'Mathématiques et Informatique Appliquées aux SHS');
INSERT INTO Mention VALUES (2, 'Informatique Fondamentale');
INSERT INTO Mention VALUES (3, 'Economie et Gestion');

-- PARCOURS (1 = MIAGE, 2 = BIGDATA, 3 = DEV, 4 = GESTION)
INSERT INTO Parcours VALUES (1, 'Méthodes Informatiques Appliquées à la Gestion', 1);
INSERT INTO Parcours VALUES (2, 'Science des Données', 1);
INSERT INTO Parcours VALUES (3, 'Développement Logiciel', 2);
INSERT INTO Parcours VALUES (4, 'Gestion des Entreprises', 3);

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

-- CATALOGUE MENTIONS (Mises à jour avec 1, 2, 3)
INSERT INTO Catalogue_Mention VALUES (1, 'INTRO_JAVA'), (1, 'JAVA_AVANCE'), (1, 'BDD_SQL'), (1, 'STATS_DESC'), (1, 'COMPTA');
INSERT INTO Catalogue_Mention VALUES (2, 'INTRO_JAVA'), (2, 'JAVA_AVANCE'), (2, 'ALGO_TRI'), (2, 'WEB_STATIC'), (2, 'WEB_DYN');
INSERT INTO Catalogue_Mention VALUES (3, 'COMPTA'), (3, 'MARKETING'), (3, 'STATS_DESC');

-- STRUCTURE PARCOURS (Mises à jour avec 1, 2, 3, 4)
INSERT INTO Structure_Parcours VALUES (1, 'INTRO_JAVA', TRUE), (1, 'BDD_SQL', TRUE), (1, 'COMPTA', TRUE), (1, 'WEB_STATIC', FALSE);
INSERT INTO Structure_Parcours VALUES (3, 'ALGO_TRI', TRUE), (3, 'INTRO_JAVA', TRUE), (3, 'WEB_DYN', TRUE);

-- PREREQUIS
INSERT INTO Prerequis VALUES ('JAVA_AVANCE', 'INTRO_JAVA'), ('WEB_DYN', 'WEB_STATIC'), ('WEB_DYN', 'INTRO_JAVA'), ('BDD_SQL', 'ALGO_TRI'), ('ANGLAIS_2', 'ANGLAIS_1');

-- ==========================================
-- ETUDIANTS (Mises à jour avec 1, 2, 3, 4)
-- ==========================================
-- Tes 15 premiers étudiants
INSERT INTO Etudiant VALUES (101, 'Snow', 'Jon', '2002-12-05', 1);
INSERT INTO Etudiant VALUES (102, 'Simpson', 'Homer', '1985-05-12', 1);
INSERT INTO Etudiant VALUES (103, 'Granger', 'Hermione', '2003-09-19', 3);
INSERT INTO Etudiant VALUES (104, 'Potter', 'Harry', '2003-07-31', 3);
INSERT INTO Etudiant VALUES (105, 'Nook', 'Tom', '1995-10-18', 4);
INSERT INTO Etudiant VALUES (201, 'Lannister', 'Tyrion', '1982-06-11', 1);
INSERT INTO Etudiant VALUES (202, 'Stark', 'Arya', '2005-04-15', 3);
INSERT INTO Etudiant VALUES (203, 'Targaryen', 'Daenerys', '2002-05-01', 2);
INSERT INTO Etudiant VALUES (204, 'Skywalker', 'Luke', '2001-09-25', 3);
INSERT INTO Etudiant VALUES (205, 'Stark', 'Tony', '1990-05-29', 3);
INSERT INTO Etudiant VALUES (206, 'Wayne', 'Bruce', '1995-02-19', 4);
INSERT INTO Etudiant VALUES (207, 'Croft', 'Lara', '1998-02-14', 2);
INSERT INTO Etudiant VALUES (208, 'Danvers', 'Carol', '1997-10-10', 1);
INSERT INTO Etudiant VALUES (209, 'Baggins', 'Frodo', '2002-09-22', 4);
INSERT INTO Etudiant VALUES (210, 'Wick', 'John', '1992-09-12', 1);

-- Les 20 Nouveaux Étudiants (Promo 300 !)
INSERT INTO Etudiant VALUES (301, 'Kenobi', 'Obi-Wan', '1998-08-15', 3);
INSERT INTO Etudiant VALUES (302, 'Organa', 'Leia', '2001-11-20', 4);
INSERT INTO Etudiant VALUES (303, 'Solo', 'Han', '1999-07-13', 1);
INSERT INTO Etudiant VALUES (304, 'Ripley', 'Ellen', '1992-01-07', 2);
INSERT INTO Etudiant VALUES (305, 'Connor', 'Sarah', '1995-05-14', 1);
INSERT INTO Etudiant VALUES (306, 'Bond', 'James', '1990-04-13', 4);
INSERT INTO Etudiant VALUES (307, 'Bourne', 'Jason', '1993-09-13', 3);
INSERT INTO Etudiant VALUES (308, 'Hunt', 'Ethan', '1996-08-18', 1);
INSERT INTO Etudiant VALUES (309, 'Neo', 'Anderson', '1999-03-31', 3);
INSERT INTO Etudiant VALUES (310, 'Trinity', 'Moss', '2000-12-11', 2);
INSERT INTO Etudiant VALUES (311, 'Morpheus', 'Fishburne', '1995-07-30', 4);
INSERT INTO Etudiant VALUES (312, 'Gollum', 'Smeagol', '1980-01-01', 1);
INSERT INTO Etudiant VALUES (313, 'Gamgee', 'Samwise', '2002-04-06', 4);
INSERT INTO Etudiant VALUES (314, 'Leonidas', 'Sparta', '1985-08-08', 3);
INSERT INTO Etudiant VALUES (315, 'Max', 'Mad', '1994-11-12', 1);
INSERT INTO Etudiant VALUES (316, 'Katniss', 'Everdeen', '2004-05-08', 2);
INSERT INTO Etudiant VALUES (317, 'Peeta', 'Mellark', '2004-09-12', 4);
INSERT INTO Etudiant VALUES (318, 'Geller', 'Ross', '1996-10-18', 2);
INSERT INTO Etudiant VALUES (319, 'Green', 'Rachel', '1998-05-05', 4);
INSERT INTO Etudiant VALUES (320, 'Tribbiani', 'Joey', '1997-01-09', 1);


-- ==========================================
-- INSCRIPTIONS
-- ==========================================
-- (Tes inscriptions d'origine n'ont pas bougé !)
INSERT INTO Inscription VALUES (101, 'INTRO_JAVA', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (101, 'ALGO_TRI', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (101, 'ANGLAIS_1', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (101, 'WEB_STATIC', '2022-2023', 4, 'valide');
INSERT INTO Inscription VALUES (101, 'JAVA_AVANCE', '2023-2024', 5, 'en_cours');
INSERT INTO Inscription VALUES (101, 'BDD_SQL', '2023-2024', 5, 'en_cours');
INSERT INTO Inscription VALUES (101, 'COMPTA', '2023-2024', 5, 'en_cours');
INSERT INTO Inscription VALUES (102, 'INTRO_JAVA', '2022-2023', 3, 'echoue');
INSERT INTO Inscription VALUES (102, 'ALGO_TRI', '2022-2023', 3, 'echoue');
INSERT INTO Inscription VALUES (102, 'SPORT', '2022-2023', 4, 'valide');
INSERT INTO Inscription VALUES (102, 'INTRO_JAVA', '2023-2024', 3, 'en_cours');
INSERT INTO Inscription VALUES (102, 'ALGO_TRI', '2023-2024', 3, 'en_cours');
INSERT INTO Inscription VALUES (103, 'INTRO_JAVA', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (103, 'ALGO_TRI', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (103, 'WEB_STATIC', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (103, 'WEB_DYN', '2022-2023', 4, 'valide');
INSERT INTO Inscription VALUES (103, 'JAVA_AVANCE', '2023-2024', 5, 'valide');
INSERT INTO Inscription VALUES (103, 'RHETORIQUE', '2023-2024', 5, 'en_cours');
INSERT INTO Inscription VALUES (104, 'ALGO_TRI', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (104, 'INTRO_JAVA', '2022-2023', 3, 'echoue');
INSERT INTO Inscription VALUES (104, 'INTRO_JAVA', '2023-2024', 3, 'en_cours');
INSERT INTO Inscription VALUES (104, 'WEB_STATIC', '2023-2024', 3, 'en_cours');
INSERT INTO Inscription VALUES (105, 'COMPTA', '2023-2024', 1, 'en_cours');
INSERT INTO Inscription VALUES (105, 'MARKETING', '2023-2024', 1, 'en_cours');
INSERT INTO Inscription VALUES (201, 'ANGLAIS_1', '2023-2024', 5, 'en_cours');
INSERT INTO Inscription VALUES (201, 'STATS_DESC', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (201, 'RHETORIQUE', '2022-2023', 4, 'valide');
INSERT INTO Inscription VALUES (202, 'ANGLAIS_1', '2023-2024', 1, 'en_cours');
INSERT INTO Inscription VALUES (202, 'WEB_STATIC', '2023-2024', 1, 'en_cours');
INSERT INTO Inscription VALUES (202, 'SPORT', '2023-2024', 1, 'en_cours');
INSERT INTO Inscription VALUES (203, 'ANGLAIS_1', '2023-2024', 5, 'en_cours');
INSERT INTO Inscription VALUES (203, 'STATS_DESC', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (203, 'PROBA', '2023-2024', 5, 'en_cours');
INSERT INTO Inscription VALUES (204, 'INTRO_JAVA', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (204, 'RESEAU', '2022-2023', 4, 'valide');
INSERT INTO Inscription VALUES (204, 'JAVA_AVANCE', '2023-2024', 5, 'en_cours');
INSERT INTO Inscription VALUES (205, 'INTRO_JAVA', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (205, 'ALGO_TRI', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (205, 'WEB_DYN', '2023-2024', 5, 'en_cours');
INSERT INTO Inscription VALUES (206, 'COMPTA', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (206, 'MARKETING', '2022-2023', 4, 'valide');
INSERT INTO Inscription VALUES (206, 'STATS_DESC', '2023-2024', 5, 'en_cours');
INSERT INTO Inscription VALUES (207, 'STATS_DESC', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (207, 'ALGO_TRI', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (207, 'BDD_SQL', '2023-2024', 5, 'en_cours');
INSERT INTO Inscription VALUES (208, 'INTRO_JAVA', '2023-2024', 1, 'en_cours');
INSERT INTO Inscription VALUES (208, 'COMPTA', '2023-2024', 1, 'en_cours');
INSERT INTO Inscription VALUES (209, 'COMPTA', '2022-2023', 3, 'echoue');
INSERT INTO Inscription VALUES (209, 'COMPTA', '2023-2024', 3, 'en_cours');
INSERT INTO Inscription VALUES (209, 'MARKETING', '2023-2024', 3, 'en_cours');
INSERT INTO Inscription VALUES (210, 'BDD_SQL', '2022-2023', 3, 'valide');
INSERT INTO Inscription VALUES (210, 'SPORT', '2023-2024', 5, 'en_cours');

-- Inscriptions générées pour quelques nouveaux étudiants (pour qu'ils aient des données)
INSERT INTO Inscription VALUES (301, 'INTRO_JAVA', '2023-2024', 1, 'en_cours');
INSERT INTO Inscription VALUES (301, 'WEB_STATIC', '2023-2024', 1, 'en_cours');
INSERT INTO Inscription VALUES (302, 'MARKETING', '2023-2024', 1, 'en_cours');
INSERT INTO Inscription VALUES (303, 'BDD_SQL', '2023-2024', 3, 'en_cours');
INSERT INTO Inscription VALUES (309, 'ALGO_TRI', '2023-2024', 5, 'en_cours');
INSERT INTO Inscription VALUES (310, 'STATS_DESC', '2023-2024', 3, 'en_cours');