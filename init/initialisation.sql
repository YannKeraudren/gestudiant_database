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
                          date_naissance DATE,
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
                             semestre VARCHAR(10),
                             statut_validation VARCHAR(20) DEFAULT 'en_cours',
                             PRIMARY KEY (num_etu, code_ue, annee_univ, semestre),
                             FOREIGN KEY (num_etu) REFERENCES Etudiant(num_etu),
                             FOREIGN KEY (code_ue) REFERENCES UE(code_ue)
);

-- 3. INSERTION DE DONNEES MASSIVES

-- MENTIONS
INSERT INTO Mention VALUES ('MIASHS', 'Mathématiques et Informatique Appliquées aux SHS');
INSERT INTO Mention VALUES ('INFO', 'Informatique Fondamentale');
INSERT INTO Mention VALUES ('ECO', 'Economie et Gestion');

-- PARCOURS
INSERT INTO Parcours VALUES ('MIAGE', 'Méthodes Informatiques Appliquées à la Gestion', 'MIASHS');
INSERT INTO Parcours VALUES ('BIGDATA', 'Science des Données', 'MIASHS');
INSERT INTO Parcours VALUES ('DEV', 'Développement Logiciel', 'INFO');
INSERT INTO Parcours VALUES ('GESTION', 'Gestion des Entreprises', 'ECO');

-- UE (Mélange de 3 et 6 crédits)
-- Info
INSERT INTO UE VALUES ('INTRO_JAVA', 'Introduction Java', 6);
INSERT INTO UE VALUES ('JAVA_AVANCE', 'Java Avancé', 6);
INSERT INTO UE VALUES ('WEB_STATIC', 'Web HTML/CSS', 3);
INSERT INTO UE VALUES ('WEB_DYN', 'Web Dynamique PHP', 6);
INSERT INTO UE VALUES ('BDD_SQL', 'Bases de Données Relationnelles', 6);
INSERT INTO UE VALUES ('ALGO_TRI', 'Algorithmique et Tris', 6);
INSERT INTO UE VALUES ('RESEAU', 'Réseaux IP', 3);
-- Maths/Gestion
INSERT INTO UE VALUES ('STATS_DESC', 'Statistiques Descriptives', 3);
INSERT INTO UE VALUES ('PROBA', 'Probabilités', 6);
INSERT INTO UE VALUES ('COMPTA', 'Comptabilité Générale', 6);
INSERT INTO UE VALUES ('MARKETING', 'Introduction au Marketing', 3);
-- Langues / Ouverture
INSERT INTO UE VALUES ('ANGLAIS_1', 'Anglais S1', 3);
INSERT INTO UE VALUES ('ANGLAIS_2', 'Anglais S2', 3);
INSERT INTO UE VALUES ('SPORT', 'Sport - Badminton', 3);
INSERT INTO UE VALUES ('RHETORIQUE', 'Art Oratoire', 3);

-- CATALOGUE
INSERT INTO Catalogue_Mention VALUES ('MIASHS', 'INTRO_JAVA'), ('MIASHS', 'JAVA_AVANCE'), ('MIASHS', 'BDD_SQL'), ('MIASHS', 'STATS_DESC'), ('MIASHS', 'COMPTA'), ('MIASHS', 'PROBA');
INSERT INTO Catalogue_Mention VALUES ('INFO', 'INTRO_JAVA'), ('INFO', 'JAVA_AVANCE'), ('INFO', 'ALGO_TRI'), ('INFO', 'WEB_STATIC'), ('INFO', 'WEB_DYN'), ('INFO', 'RESEAU');
INSERT INTO Catalogue_Mention VALUES ('ECO', 'COMPTA'), ('ECO', 'MARKETING'), ('ECO', 'STATS_DESC'), ('ECO', 'PROBA');

-- STRUCTURE PARCOURS (Obligatoires)
INSERT INTO Structure_Parcours VALUES ('MIAGE', 'INTRO_JAVA', TRUE), ('MIAGE', 'BDD_SQL', TRUE), ('MIAGE', 'COMPTA', TRUE), ('MIAGE', 'WEB_STATIC', FALSE);
INSERT INTO Structure_Parcours VALUES ('DEV', 'ALGO_TRI', TRUE), ('DEV', 'INTRO_JAVA', TRUE), ('DEV', 'WEB_DYN', TRUE);
INSERT INTO Structure_Parcours VALUES ('BIGDATA', 'STATS_DESC', TRUE), ('BIGDATA', 'PROBA', TRUE), ('BIGDATA', 'BDD_SQL', TRUE), ('BIGDATA', 'ALGO_TRI', FALSE);
INSERT INTO Structure_Parcours VALUES ('GESTION', 'COMPTA', TRUE), ('GESTION', 'MARKETING', TRUE), ('GESTION', 'STATS_DESC', TRUE);

-- PREREQUIS
INSERT INTO Prerequis VALUES ('JAVA_AVANCE', 'INTRO_JAVA');
INSERT INTO Prerequis VALUES ('WEB_DYN', 'WEB_STATIC');
INSERT INTO Prerequis VALUES ('WEB_DYN', 'INTRO_JAVA');
INSERT INTO Prerequis VALUES ('BDD_SQL', 'ALGO_TRI');
INSERT INTO Prerequis VALUES ('ANGLAIS_2', 'ANGLAIS_1');
INSERT INTO Prerequis VALUES ('PROBA', 'STATS_DESC');

-- ==========================================
-- NOUVEAUX ETUDIANTS (20 au total)
-- ==========================================
-- Les originaux
INSERT INTO Etudiant VALUES (101, 'Snow', 'Jon', '2002-12-05', 'MIAGE');
INSERT INTO Etudiant VALUES (102, 'Simpson', 'Homer', '1985-05-12', 'MIAGE');
INSERT INTO Etudiant VALUES (103, 'Granger', 'Hermione', '2003-09-19', 'DEV');
INSERT INTO Etudiant VALUES (104, 'Potter', 'Harry', '2003-07-31', 'DEV');
INSERT INTO Etudiant VALUES (105, 'Nook', 'Tom', '1995-10-18', 'GESTION');
-- Les petits nouveaux (Pop Culture)
INSERT INTO Etudiant VALUES (106, 'Skywalker', 'Luke', '2001-09-25', 'DEV');
INSERT INTO Etudiant VALUES (107, 'Stark', 'Tony', '1990-05-29', 'DEV');
INSERT INTO Etudiant VALUES (108, 'Wayne', 'Bruce', '1995-02-19', 'GESTION');
INSERT INTO Etudiant VALUES (109, 'Croft', 'Lara', '1998-02-14', 'BIGDATA');
INSERT INTO Etudiant VALUES (110, 'Danvers', 'Carol', '1997-10-10', 'MIAGE');
INSERT INTO Etudiant VALUES (111, 'Baggins', 'Frodo', '2002-09-22', 'GESTION');
INSERT INTO Etudiant VALUES (112, 'Ripley', 'Ellen', '1996-01-08', 'BIGDATA');
INSERT INTO Etudiant VALUES (113, 'Wick', 'John', '1992-09-12', 'MIAGE');
INSERT INTO Etudiant VALUES (114, 'Ketchum', 'Ash', '2005-05-22', 'BIGDATA');
INSERT INTO Etudiant VALUES (115, 'Uzumaki', 'Naruto', '2004-10-10', 'DEV');
INSERT INTO Etudiant VALUES (116, 'Squarepants', 'SpongeBob', '2000-07-14', 'MIAGE');
INSERT INTO Etudiant VALUES (117, 'Connor', 'Sarah', '1998-08-29', 'GESTION');
INSERT INTO Etudiant VALUES (118, 'MacGyver', 'Angus', '1990-03-23', 'DEV');
INSERT INTO Etudiant VALUES (119, 'Holmes', 'Sherlock', '1995-01-06', 'BIGDATA');
INSERT INTO Etudiant VALUES (120, 'Poppins', 'Mary', '1992-04-15', 'GESTION');

-- ==========================================
-- INSCRIPTIONS (HISTORIQUE ET ACTUEL)
-- ==========================================

-- Jon Snow (101) - MIAGE
INSERT INTO Inscription VALUES (101, 'INTRO_JAVA', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (101, 'ALGO_TRI', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (101, 'ANGLAIS_1', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (101, 'WEB_STATIC', '2022-2023', 'pair', 'valide');
INSERT INTO Inscription VALUES (101, 'JAVA_AVANCE', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (101, 'BDD_SQL', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (101, 'COMPTA', '2023-2024', 'impair', 'en_cours');

-- Homer Simpson (102) - MIAGE (Redoublant)
INSERT INTO Inscription VALUES (102, 'INTRO_JAVA', '2022-2023', 'impair', 'echoue');
INSERT INTO Inscription VALUES (102, 'ALGO_TRI', '2022-2023', 'impair', 'echoue');
INSERT INTO Inscription VALUES (102, 'SPORT', '2022-2023', 'pair', 'valide');
INSERT INTO Inscription VALUES (102, 'INTRO_JAVA', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (102, 'ALGO_TRI', '2023-2024', 'impair', 'en_cours');

-- Hermione Granger (103) - DEV (Première de la classe)
INSERT INTO Inscription VALUES (103, 'INTRO_JAVA', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (103, 'ALGO_TRI', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (103, 'WEB_STATIC', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (103, 'WEB_DYN', '2022-2023', 'pair', 'valide');
INSERT INTO Inscription VALUES (103, 'JAVA_AVANCE', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (103, 'RHETORIQUE', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (103, 'RESEAU', '2023-2024', 'impair', 'en_cours');

-- Harry Potter (104) - DEV
INSERT INTO Inscription VALUES (104, 'ALGO_TRI', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (104, 'INTRO_JAVA', '2022-2023', 'impair', 'echoue');
INSERT INTO Inscription VALUES (104, 'INTRO_JAVA', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (104, 'WEB_STATIC', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (104, 'SPORT', '2023-2024', 'impair', 'en_cours');

-- Tom Nook (105) - GESTION
INSERT INTO Inscription VALUES (105, 'COMPTA', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (105, 'MARKETING', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (105, 'STATS_DESC', '2023-2024', 'impair', 'en_cours');

-- Luke Skywalker (106) - DEV (Bon élève, s'oriente vers les réseaux)
INSERT INTO Inscription VALUES (106, 'INTRO_JAVA', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (106, 'RESEAU', '2022-2023', 'pair', 'valide');
INSERT INTO Inscription VALUES (106, 'JAVA_AVANCE', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (106, 'ALGO_TRI', '2023-2024', 'impair', 'en_cours');

-- Tony Stark (107) - DEV (A tout validé haut la main, s'ennuie)
INSERT INTO Inscription VALUES (107, 'INTRO_JAVA', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (107, 'ALGO_TRI', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (107, 'WEB_STATIC', '2022-2023', 'pair', 'valide');
INSERT INTO Inscription VALUES (107, 'JAVA_AVANCE', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (107, 'WEB_DYN', '2023-2024', 'impair', 'en_cours');

-- Bruce Wayne (108) - GESTION (Héritier de l'entreprise)
INSERT INTO Inscription VALUES (108, 'COMPTA', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (108, 'MARKETING', '2022-2023', 'pair', 'valide');
INSERT INTO Inscription VALUES (108, 'STATS_DESC', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (108, 'RHETORIQUE', '2023-2024', 'impair', 'en_cours');

-- Lara Croft (109) - BIGDATA (Exploratrice de données)
INSERT INTO Inscription VALUES (109, 'STATS_DESC', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (109, 'ALGO_TRI', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (109, 'PROBA', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (109, 'BDD_SQL', '2023-2024', 'impair', 'en_cours');

-- Carol Danvers (110) - MIAGE
INSERT INTO Inscription VALUES (110, 'INTRO_JAVA', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (110, 'COMPTA', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (110, 'ANGLAIS_1', '2023-2024', 'impair', 'en_cours');

-- Frodo Baggins (111) - GESTION (A du mal loin de chez lui)
INSERT INTO Inscription VALUES (111, 'COMPTA', '2022-2023', 'impair', 'echoue');
INSERT INTO Inscription VALUES (111, 'MARKETING', '2022-2023', 'pair', 'valide');
INSERT INTO Inscription VALUES (111, 'COMPTA', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (111, 'SPORT', '2023-2024', 'impair', 'en_cours');

-- Ellen Ripley (112) - BIGDATA
INSERT INTO Inscription VALUES (112, 'STATS_DESC', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (112, 'PROBA', '2022-2023', 'pair', 'valide');
INSERT INTO Inscription VALUES (112, 'BDD_SQL', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (112, 'ANGLAIS_1', '2023-2024', 'impair', 'en_cours');

-- John Wick (113) - MIAGE (Très précis, peu bavard)
INSERT INTO Inscription VALUES (113, 'BDD_SQL', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (113, 'ALGO_TRI', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (113, 'SPORT', '2023-2024', 'impair', 'en_cours');

-- Ash Ketchum (114) - BIGDATA (Veut toutes les attraper... les datas)
INSERT INTO Inscription VALUES (114, 'STATS_DESC', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (114, 'ALGO_TRI', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (114, 'SPORT', '2023-2024', 'impair', 'en_cours');

-- Naruto Uzumaki (115) - DEV (A beaucoup raté mais s'accroche)
INSERT INTO Inscription VALUES (115, 'INTRO_JAVA', '2022-2023', 'impair', 'echoue');
INSERT INTO Inscription VALUES (115, 'ALGO_TRI', '2022-2023', 'impair', 'echoue');
INSERT INTO Inscription VALUES (115, 'INTRO_JAVA', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (115, 'ALGO_TRI', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (115, 'SPORT', '2023-2024', 'impair', 'en_cours');

-- SpongeBob Squarepants (116) - MIAGE
INSERT INTO Inscription VALUES (116, 'COMPTA', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (116, 'WEB_STATIC', '2023-2024', 'impair', 'en_cours');

-- Sarah Connor (117) - GESTION (Se prépare à tout)
INSERT INTO Inscription VALUES (117, 'COMPTA', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (117, 'STATS_DESC', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (117, 'PROBA', '2023-2024', 'impair', 'en_cours');

-- Angus MacGyver (118) - DEV (Bidouilleur)
INSERT INTO Inscription VALUES (118, 'ALGO_TRI', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (118, 'WEB_STATIC', '2022-2023', 'pair', 'valide');
INSERT INTO Inscription VALUES (118, 'WEB_DYN', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (118, 'RESEAU', '2023-2024', 'impair', 'en_cours');

-- Sherlock Holmes (119) - BIGDATA (Déduction et statistiques)
INSERT INTO Inscription VALUES (119, 'STATS_DESC', '2022-2023', 'impair', 'valide');
INSERT INTO Inscription VALUES (119, 'PROBA', '2022-2023', 'pair', 'valide');
INSERT INTO Inscription VALUES (119, 'BDD_SQL', '2023-2024', 'impair', 'en_cours');

-- Mary Poppins (120) - GESTION
INSERT INTO Inscription VALUES (120, 'COMPTA', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (120, 'MARKETING', '2023-2024', 'impair', 'en_cours');
INSERT INTO Inscription VALUES (120, 'RHETORIQUE', '2023-2024', 'impair', 'en_cours');