SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ==========================================
-- 1. RESET
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
-- 2. TABLES
-- ==========================================
CREATE TABLE Mention (
                         id_mention INT PRIMARY KEY,
                         nom_mention VARCHAR(100) NOT NULL
);

CREATE TABLE UE (
                    code_ue VARCHAR(20) PRIMARY KEY,
                    nom_ue VARCHAR(100) NOT NULL,
                    nb_credits INT CHECK (nb_credits IN (3, 6))
);

CREATE TABLE Parcours (
                          id_parcours INT PRIMARY KEY,
                          nom_parcours VARCHAR(100) NOT NULL,
                          id_mention INT,
                          FOREIGN KEY (id_mention) REFERENCES Mention(id_mention)
);

CREATE TABLE Catalogue_Mention (
                                   id_mention INT,
                                   code_ue VARCHAR(20),
                                   PRIMARY KEY (id_mention, code_ue),
                                   FOREIGN KEY (id_mention) REFERENCES Mention(id_mention),
                                   FOREIGN KEY (code_ue) REFERENCES UE(code_ue)
);

CREATE TABLE Structure_Parcours (
                                    id_parcours INT,
                                    code_ue VARCHAR(20),
                                    est_obligatoire BOOLEAN DEFAULT TRUE,
                                    semestrePrevu INT,
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

CREATE TABLE Etudiant (
                          num_etu INT PRIMARY KEY,
                          nom VARCHAR(50) NOT NULL,
                          prenom VARCHAR(50) NOT NULL,
                          date_naissance DATE,
                          id_parcours INT,
                          FOREIGN KEY (id_parcours) REFERENCES Parcours(id_parcours)
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
-- 3. INSERTIONS RÉFÉRENTIELS (UE, Mentions, Parcours)
-- ==========================================
INSERT INTO Mention VALUES
                        (1, 'Informatique'), (2, 'Droit'), (3, 'Gestion'), (4, 'Psychologie');

INSERT INTO Parcours VALUES
                         (1, 'MIAGE', 1), (2, 'SDIA', 1), (3, 'Développement Logiciel', 1), (4, 'Systèmes et Réseaux', 1),
                         (5, 'Gestion des Entreprises', 3), (6, 'Finance et Comptabilité', 3), (7, 'Droit Privé', 2),
                         (8, 'Droit Public', 2), (9, 'Psychologie Clinique', 4), (10, 'Psychologie du Travail', 4);

INSERT INTO UE VALUES
                   ('INTRO_JAVA', 'Intro Java', 6), ('STATS_DESC', 'Stats Desc', 3), ('ALGO_BASE', 'Algo', 6),
                   ('WEB_STATIC', 'Web Static', 3), ('ANGLAIS_1', 'Anglais 1', 3), ('BDD_SQL', 'SQL', 6),
                   ('COMPTA', 'Compta', 6), ('PROBA', 'Proba', 3), ('WEB_DYN', 'Web Dynamique', 6),
                   ('ANGLAIS_2', 'Anglais 2', 3), ('JAVA_AVANCE', 'Java Avancé', 6), ('STATS_INF', 'Stats Inf', 6),
                   ('MANAGEMENT', 'Management', 6), ('MATH_DISC', 'Maths Disc', 3), ('ALGEBRE', 'Algèbre', 3),
                   ('MACHINE_L', 'Machine Learning', 6), ('OPTIM', 'Optimisation', 3), ('PROJET_INFO', 'Projet Info', 6),
                   ('ANGLAIS_3', 'Anglais 3', 3), ('RHETORIQUE', 'Rhétorique', 3), ('PROJET_PRO', 'Projet Pro', 6),
                   ('DEEP_L', 'Deep Learning', 6), ('SYST_EXP', 'Systèmes Exploitation', 6), ('MOBILE', 'Dév Mobile', 6),
                   ('CLOUD', 'Cloud Computing', 6), ('SECU_INFO', 'Sécurité', 6), ('RESEAU', 'Réseaux', 6),
                   ('ALGO_AVANCE', 'Algo Avancée', 6), ('MARKETING', 'Marketing', 6), ('MACRO_ECO', 'Macro Éco', 3),
                   ('MICRO_ECO', 'Micro Éco', 3), ('COMPTA_ANA', 'Compta Analytique', 6), ('DROIT_SOC', 'Droit Social', 6),
                   ('MARKETING_2', 'Marketing Strat', 6), ('FINANCE', 'Finance', 6), ('AUDIT', 'Audit', 6),
                   ('FISCALITE', 'Fiscalité', 6), ('DROIT_CONST', 'Droit Const', 6), ('HIST_DROIT', 'Hist Droit', 3),
                   ('DROIT_CIV1', 'Droit Civil 1', 6), ('DROIT_CIV2', 'Droit Civil 2', 6), ('DROIT_PEN', 'Droit Pénal', 6),
                   ('PROCED_CIV', 'Procédure Civile', 6), ('DROIT_TRAV', 'Droit Travail', 6), ('DROIT_EUR', 'Droit Européen', 6),
                   ('PROCED_PEN', 'Procédure Pénale', 6), ('DROIT_ADM', 'Droit Admin', 6), ('PSYCH_GEN', 'Psych Générale', 6),
                   ('PSYCH_DEV', 'Psych Développement', 6), ('METHODO', 'Méthodologie', 3), ('STATS_PSY', 'Stats Psycho', 3),
                   ('PSYCH_SOC', 'Psych Sociale', 6), ('NEURO', 'Neurosciences', 6), ('PSYCH_CLIN', 'Psych Clinique', 6),
                   ('SPORT', 'Sport', 3), ('ENTRETIEN', 'Entretien Clinique', 6), ('PSYCH_TEST', 'Tests Psychologiques', 6),
                   ('PSYCH_TRAV', 'Psych Travail', 6);

-- ==========================================
-- 4. INSERTIONS STRUCTURELLES (Catalogue, Parcours, Prerequis)
-- ==========================================
INSERT INTO Catalogue_Mention (id_mention, code_ue) VALUES
                                                        (1, 'INTRO_JAVA'), (1, 'ALGO_BASE'), (1, 'BDD_SQL'), (1, 'WEB_DYN'), (1, 'JAVA_AVANCE'),
                                                        (2, 'DROIT_CONST'), (2, 'HIST_DROIT'), (2, 'DROIT_CIV1'), (2, 'DROIT_PEN'),
                                                        (3, 'COMPTA'), (3, 'MANAGEMENT'), (3, 'MARKETING'), (3, 'FINANCE'),
                                                        (4, 'PSYCH_GEN'), (4, 'PSYCH_DEV'), (4, 'METHODO'), (4, 'NEURO');

INSERT INTO Structure_Parcours VALUES
                                   (1, 'INTRO_JAVA', 1, 1), (1, 'ALGO_BASE', 1, 1), (1, 'STATS_DESC', 1, 1),
                                   (1, 'BDD_SQL', 1, 2), (1, 'COMPTA', 1, 2), (1, 'WEB_DYN', 1, 2),
                                   (1, 'JAVA_AVANCE', 1, 3), (1, 'STATS_INF', 1, 3),
                                   (7, 'DROIT_CONST', 1, 1), (7, 'HIST_DROIT', 1, 1), (7, 'DROIT_CIV1', 1, 1),
                                   (7, 'DROIT_CIV2', 1, 2), (7, 'DROIT_PEN', 1, 2), (7, 'PROCED_CIV', 1, 2);

INSERT INTO Prerequis VALUES
                          ('JAVA_AVANCE', 'INTRO_JAVA'),
                          ('WEB_DYN', 'WEB_STATIC'),
                          ('STATS_INF', 'STATS_DESC'),
                          ('COMPTA_ANA', 'COMPTA'),
                          ('DEEP_L', 'MACHINE_L');

-- ==========================================
-- 5. INSERTIONS ÉTUDIANTS & INSCRIPTIONS
-- ==========================================
-- L1 (ont validé rien ou en cours S1)
INSERT INTO Etudiant VALUES
                         (11001,'Aubert','Alexis','2004-02-10',1),(11002,'Baudry','Béatrice','2004-05-22',1),
                         (11003,'Carpentier','Cyril','2004-09-14',1),(11004,'Delorme','Diane','2004-01-30',1),
                         (11005,'Espinoza','Ethan','2004-07-18',1),(11006,'Ferreira','Fatima','2004-11-03',1),
                         (11007,'Gosselin','Gabin','2004-03-27',1),(11008,'Henriot','Hana','2004-08-09',1),
                         (11009,'Imbert','Ivan','2004-06-15',1),(11010,'Jacquot','Jade','2004-12-01',1);

INSERT INTO Inscription VALUES
                            (11001,'INTRO_JAVA','2023-2024',1,'en_cours'),(11001,'STATS_DESC','2023-2024',1,'en_cours'),
                            (11001,'ALGO_BASE','2023-2024',1,'en_cours'),(11001,'WEB_STATIC','2023-2024',1,'en_cours'),
                            (11001,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (11002,'INTRO_JAVA','2023-2024',1,'en_cours'),(11002,'STATS_DESC','2023-2024',1,'en_cours'),
                            (11002,'ALGO_BASE','2023-2024',1,'en_cours'),(11002,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (11003,'INTRO_JAVA','2023-2024',1,'en_cours'),(11003,'ALGO_BASE','2023-2024',1,'en_cours'),
                            (11003,'WEB_STATIC','2023-2024',1,'en_cours'),
                            (11004,'INTRO_JAVA','2023-2024',1,'en_cours'),(11004,'STATS_DESC','2023-2024',1,'en_cours'),
                            (11004,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (11005,'INTRO_JAVA','2023-2024',1,'en_cours'),(11005,'ALGO_BASE','2023-2024',1,'en_cours'),
                            (11005,'STATS_DESC','2023-2024',1,'en_cours'),(11005,'WEB_STATIC','2023-2024',1,'en_cours'),
                            (11005,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (11006,'INTRO_JAVA','2023-2024',1,'en_cours'),(11006,'STATS_DESC','2023-2024',1,'en_cours'),
                            (11007,'INTRO_JAVA','2023-2024',1,'en_cours'),(11007,'ALGO_BASE','2023-2024',1,'en_cours'),
                            (11007,'WEB_STATIC','2023-2024',1,'en_cours'),(11007,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (11008,'INTRO_JAVA','2023-2024',1,'en_cours'),(11008,'STATS_DESC','2023-2024',1,'en_cours'),
                            (11008,'ALGO_BASE','2023-2024',1,'en_cours'),
                            (11009,'INTRO_JAVA','2023-2024',1,'en_cours'),(11009,'WEB_STATIC','2023-2024',1,'en_cours'),
                            (11010,'INTRO_JAVA','2023-2024',1,'en_cours'),(11010,'ALGO_BASE','2023-2024',1,'en_cours'),
                            (11010,'STATS_DESC','2023-2024',1,'en_cours'),(11010,'ANGLAIS_1','2023-2024',1,'en_cours');

-- L2 (ont validé S1+S2, en cours S3)
INSERT INTO Etudiant VALUES
                         (12001,'Auger','Amelie','2003-04-12',1),(12002,'Barbe','Boris','2003-07-25',1),
                         (12003,'Caillet','Chloe','2003-02-08',1),(12004,'Delaunay','Denis','2002-11-19',1),
                         (12005,'Evrard','Elodie','2003-06-30',1),(12006,'Faivre','Fabrice','2002-09-04',1),
                         (12007,'Gagnon','Geraldine','2003-01-22',1),(12008,'Hoareau','Henri','2003-10-16',1),
                         (12009,'Isoard','Iris','2002-08-03',1),(12010,'Jamin','Jerome','2003-05-11',1);

INSERT INTO Inscription VALUES
-- S1 validé
(12001,'INTRO_JAVA','2022-2023',1,'valide'),(12001,'STATS_DESC','2022-2023',1,'valide'),
(12001,'ALGO_BASE','2022-2023',1,'valide'),(12001,'WEB_STATIC','2022-2023',1,'valide'),
(12001,'ANGLAIS_1','2022-2023',1,'valide'),
-- S2 validé
(12001,'BDD_SQL','2022-2023',2,'valide'),(12001,'COMPTA','2022-2023',2,'valide'),
(12001,'PROBA','2022-2023',2,'valide'),(12001,'WEB_DYN','2022-2023',2,'valide'),
(12001,'ANGLAIS_2','2022-2023',2,'valide'),
-- S3 en cours
(12001,'JAVA_AVANCE','2023-2024',3,'en_cours'),(12001,'STATS_INF','2023-2024',3,'en_cours'),
(12001,'MANAGEMENT','2023-2024',3,'en_cours'),(12001,'MATH_DISC','2023-2024',3,'en_cours'),

(12002,'INTRO_JAVA','2022-2023',1,'valide'),(12002,'STATS_DESC','2022-2023',1,'valide'),
(12002,'ALGO_BASE','2022-2023',1,'echoue'),(12002,'ANGLAIS_1','2022-2023',1,'valide'),
(12002,'ALGO_BASE','2022-2023',2,'valide'),(12002,'BDD_SQL','2022-2023',2,'valide'),
(12002,'COMPTA','2022-2023',2,'valide'),(12002,'ANGLAIS_2','2022-2023',2,'valide'),
(12002,'JAVA_AVANCE','2023-2024',3,'en_cours'),(12002,'STATS_INF','2023-2024',3,'en_cours'),

(12003,'INTRO_JAVA','2022-2023',1,'valide'),(12003,'STATS_DESC','2022-2023',1,'valide'),
(12003,'ALGO_BASE','2022-2023',1,'valide'),(12003,'WEB_STATIC','2022-2023',1,'valide'),
(12003,'ANGLAIS_1','2022-2023',1,'valide'),(12003,'BDD_SQL','2022-2023',2,'valide'),
(12003,'COMPTA','2022-2023',2,'valide'),(12003,'PROBA','2022-2023',2,'valide'),
(12003,'ANGLAIS_2','2022-2023',2,'valide'),(12003,'JAVA_AVANCE','2023-2024',3,'en_cours'),
(12003,'MANAGEMENT','2023-2024',3,'en_cours'),(12003,'MATH_DISC','2023-2024',3,'en_cours'),

(12004,'INTRO_JAVA','2022-2023',1,'valide'),(12004,'ALGO_BASE','2022-2023',1,'valide'),
(12004,'WEB_STATIC','2022-2023',1,'valide'),(12004,'ANGLAIS_1','2022-2023',1,'valide'),
(12004,'BDD_SQL','2022-2023',2,'valide'),(12004,'COMPTA','2022-2023',2,'valide'),
(12004,'WEB_DYN','2022-2023',2,'valide'),(12004,'ANGLAIS_2','2022-2023',2,'valide'),
(12004,'JAVA_AVANCE','2023-2024',3,'en_cours'),(12004,'STATS_INF','2023-2024',3,'en_cours'),
(12004,'ALGEBRE','2023-2024',3,'en_cours'),

(12005,'INTRO_JAVA','2022-2023',1,'valide'),(12005,'STATS_DESC','2022-2023',1,'valide'),
(12005,'ALGO_BASE','2022-2023',1,'valide'),(12005,'ANGLAIS_1','2022-2023',1,'valide'),
(12005,'BDD_SQL','2022-2023',2,'valide'),(12005,'COMPTA','2022-2023',2,'valide'),
(12005,'PROBA','2022-2023',2,'valide'),(12005,'WEB_DYN','2022-2023',2,'valide'),
(12005,'JAVA_AVANCE','2023-2024',3,'en_cours'),(12005,'STATS_INF','2023-2024',3,'en_cours'),
(12005,'MATH_DISC','2023-2024',3,'en_cours'),(12005,'ALGEBRE','2023-2024',3,'en_cours'),

(12006,'INTRO_JAVA','2022-2023',1,'valide'),(12006,'ALGO_BASE','2022-2023',1,'valide'),
(12006,'WEB_STATIC','2022-2023',1,'valide'),(12006,'ANGLAIS_1','2022-2023',1,'valide'),
(12006,'BDD_SQL','2022-2023',2,'valide'),(12006,'COMPTA','2022-2023',2,'valide'),
(12006,'ANGLAIS_2','2022-2023',2,'valide'),(12006,'JAVA_AVANCE','2023-2024',3,'en_cours'),
(12006,'MANAGEMENT','2023-2024',3,'en_cours'),

(12007,'INTRO_JAVA','2022-2023',1,'valide'),(12007,'STATS_DESC','2022-2023',1,'valide'),
(12007,'ALGO_BASE','2022-2023',1,'valide'),(12007,'WEB_STATIC','2022-2023',1,'valide'),
(12007,'BDD_SQL','2022-2023',2,'valide'),(12007,'COMPTA','2022-2023',2,'valide'),
(12007,'PROBA','2022-2023',2,'valide'),(12007,'WEB_DYN','2022-2023',2,'valide'),
(12007,'JAVA_AVANCE','2023-2024',3,'en_cours'),(12007,'STATS_INF','2023-2024',3,'en_cours'),
(12007,'MATH_DISC','2023-2024',3,'en_cours'),

(12008,'INTRO_JAVA','2022-2023',1,'valide'),(12008,'ALGO_BASE','2022-2023',1,'valide'),
(12008,'ANGLAIS_1','2022-2023',1,'valide'),(12008,'BDD_SQL','2022-2023',2,'valide'),
(12008,'COMPTA','2022-2023',2,'valide'),(12008,'ANGLAIS_2','2022-2023',2,'valide'),
(12008,'JAVA_AVANCE','2023-2024',3,'en_cours'),(12008,'MANAGEMENT','2023-2024',3,'en_cours'),

(12009,'INTRO_JAVA','2022-2023',1,'valide'),(12009,'STATS_DESC','2022-2023',1,'valide'),
(12009,'ALGO_BASE','2022-2023',1,'valide'),(12009,'ANGLAIS_1','2022-2023',1,'valide'),
(12009,'BDD_SQL','2022-2023',2,'valide'),(12009,'PROBA','2022-2023',2,'valide'),
(12009,'WEB_DYN','2022-2023',2,'valide'),(12009,'ANGLAIS_2','2022-2023',2,'valide'),
(12009,'JAVA_AVANCE','2023-2024',3,'en_cours'),(12009,'STATS_INF','2023-2024',3,'en_cours'),
(12009,'ALGEBRE','2023-2024',3,'en_cours'),

(12010,'INTRO_JAVA','2022-2023',1,'valide'),(12010,'STATS_DESC','2022-2023',1,'valide'),
(12010,'WEB_STATIC','2022-2023',1,'valide'),(12010,'ANGLAIS_1','2022-2023',1,'valide'),
(12010,'BDD_SQL','2022-2023',2,'valide'),(12010,'COMPTA','2022-2023',2,'valide'),
(12010,'ANGLAIS_2','2022-2023',2,'valide'),(12010,'JAVA_AVANCE','2023-2024',3,'en_cours'),
(12010,'MATH_DISC','2023-2024',3,'en_cours');

-- L3 (ont validé S1-S4, en cours S5/S6)
INSERT INTO Etudiant VALUES
                         (13001,'Aumont','Adrien','2002-03-15',1),(13002,'Bazin','Brigitte','2001-11-22',1),
                         (13003,'Clement','Cecile','2002-05-08',1),(13004,'Deschamps','Didier','2001-07-19',1),
                         (13005,'Esteve','Elisa','2002-09-30',1),(13006,'Fortier','Florent','2001-01-14',1),
                         (13007,'Guichard','Gwenael','2002-12-03',1),(13008,'Herve','Helene','2001-04-25',1),
                         (13009,'Isambert','Isabelle','2002-08-11',1),(13010,'Joubert','Julien','2001-06-17',1);

INSERT INTO Inscription VALUES
                            (13001,'INTRO_JAVA','2021-2022',1,'valide'),(13001,'STATS_DESC','2021-2022',1,'valide'),
                            (13001,'ALGO_BASE','2021-2022',1,'valide'),(13001,'WEB_STATIC','2021-2022',1,'valide'),
                            (13001,'ANGLAIS_1','2021-2022',1,'valide'),(13001,'BDD_SQL','2021-2022',2,'valide'),
                            (13001,'COMPTA','2021-2022',2,'valide'),(13001,'PROBA','2021-2022',2,'valide'),
                            (13001,'WEB_DYN','2021-2022',2,'valide'),(13001,'ANGLAIS_2','2021-2022',2,'valide'),
                            (13001,'JAVA_AVANCE','2022-2023',3,'valide'),(13001,'STATS_INF','2022-2023',3,'valide'),
                            (13001,'MANAGEMENT','2022-2023',3,'valide'),(13001,'MATH_DISC','2022-2023',3,'valide'),
                            (13001,'ALGEBRE','2022-2023',3,'valide'),(13001,'MACHINE_L','2022-2023',4,'valide'),
                            (13001,'OPTIM','2022-2023',4,'valide'),(13001,'PROJET_INFO','2022-2023',4,'valide'),
                            (13001,'ANGLAIS_3','2022-2023',4,'valide'),(13001,'RHETORIQUE','2023-2024',5,'en_cours'),
                            (13001,'PROJET_PRO','2023-2024',5,'en_cours'),

                            (13002,'INTRO_JAVA','2021-2022',1,'valide'),(13002,'ALGO_BASE','2021-2022',1,'valide'),
                            (13002,'STATS_DESC','2021-2022',1,'valide'),(13002,'ANGLAIS_1','2021-2022',1,'valide'),
                            (13002,'BDD_SQL','2021-2022',2,'valide'),(13002,'COMPTA','2021-2022',2,'valide'),
                            (13002,'PROBA','2021-2022',2,'echoue'),(13002,'ANGLAIS_2','2021-2022',2,'valide'),
                            (13002,'PROBA','2022-2023',3,'valide'),(13002,'JAVA_AVANCE','2022-2023',3,'valide'),
                            (13002,'STATS_INF','2022-2023',3,'valide'),(13002,'MANAGEMENT','2022-2023',3,'valide'),
                            (13002,'MACHINE_L','2022-2023',4,'valide'),(13002,'OPTIM','2022-2023',4,'valide'),
                            (13002,'PROJET_INFO','2022-2023',4,'valide'),(13002,'RHETORIQUE','2023-2024',5,'en_cours'),

                            (13003,'INTRO_JAVA','2021-2022',1,'valide'),(13003,'STATS_DESC','2021-2022',1,'valide'),
                            (13003,'ALGO_BASE','2021-2022',1,'valide'),(13003,'WEB_STATIC','2021-2022',1,'valide'),
                            (13003,'ANGLAIS_1','2021-2022',1,'valide'),(13003,'BDD_SQL','2021-2022',2,'valide'),
                            (13003,'COMPTA','2021-2022',2,'valide'),(13003,'PROBA','2021-2022',2,'valide'),
                            (13003,'WEB_DYN','2021-2022',2,'valide'),(13003,'ANGLAIS_2','2021-2022',2,'valide'),
                            (13003,'JAVA_AVANCE','2022-2023',3,'valide'),(13003,'STATS_INF','2022-2023',3,'valide'),
                            (13003,'MATH_DISC','2022-2023',3,'valide'),(13003,'ALGEBRE','2022-2023',3,'valide'),
                            (13003,'MACHINE_L','2022-2023',4,'valide'),(13003,'OPTIM','2022-2023',4,'valide'),
                            (13003,'PROJET_INFO','2022-2023',4,'valide'),(13003,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (13003,'RHETORIQUE','2023-2024',5,'en_cours'),

                            (13004,'INTRO_JAVA','2021-2022',1,'valide'),(13004,'ALGO_BASE','2021-2022',1,'valide'),
                            (13004,'WEB_STATIC','2021-2022',1,'valide'),(13004,'ANGLAIS_1','2021-2022',1,'valide'),
                            (13004,'BDD_SQL','2021-2022',2,'valide'),(13004,'COMPTA','2021-2022',2,'valide'),
                            (13004,'WEB_DYN','2021-2022',2,'valide'),(13004,'ANGLAIS_2','2021-2022',2,'valide'),
                            (13004,'JAVA_AVANCE','2022-2023',3,'valide'),(13004,'MANAGEMENT','2022-2023',3,'valide'),
                            (13004,'MACHINE_L','2022-2023',4,'echoue'),(13004,'OPTIM','2022-2023',4,'valide'),
                            (13004,'PROJET_INFO','2022-2023',4,'valide'),(13004,'MACHINE_L','2023-2024',5,'en_cours'),
                            (13004,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (13005,'INTRO_JAVA','2021-2022',1,'valide'),(13005,'STATS_DESC','2021-2022',1,'valide'),
                            (13005,'ALGO_BASE','2021-2022',1,'valide'),(13005,'ANGLAIS_1','2021-2022',1,'valide'),
                            (13005,'BDD_SQL','2021-2022',2,'valide'),(13005,'COMPTA','2021-2022',2,'valide'),
                            (13005,'PROBA','2021-2022',2,'valide'),(13005,'ANGLAIS_2','2021-2022',2,'valide'),
                            (13005,'JAVA_AVANCE','2022-2023',3,'valide'),(13005,'STATS_INF','2022-2023',3,'valide'),
                            (13005,'ALGEBRE','2022-2023',3,'valide'),(13005,'MACHINE_L','2022-2023',4,'valide'),
                            (13005,'OPTIM','2022-2023',4,'valide'),(13005,'PROJET_INFO','2022-2023',4,'valide'),
                            (13005,'RHETORIQUE','2023-2024',5,'en_cours'),(13005,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (13006,'INTRO_JAVA','2021-2022',1,'valide'),(13006,'ALGO_BASE','2021-2022',1,'valide'),
                            (13006,'STATS_DESC','2021-2022',1,'valide'),(13006,'ANGLAIS_1','2021-2022',1,'valide'),
                            (13006,'BDD_SQL','2021-2022',2,'valide'),(13006,'PROBA','2021-2022',2,'valide'),
                            (13006,'ANGLAIS_2','2021-2022',2,'valide'),(13006,'JAVA_AVANCE','2022-2023',3,'valide'),
                            (13006,'STATS_INF','2022-2023',3,'valide'),(13006,'MATH_DISC','2022-2023',3,'valide'),
                            (13006,'MACHINE_L','2022-2023',4,'valide'),(13006,'PROJET_INFO','2022-2023',4,'valide'),
                            (13006,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (13007,'INTRO_JAVA','2021-2022',1,'valide'),(13007,'STATS_DESC','2021-2022',1,'valide'),
                            (13007,'ALGO_BASE','2021-2022',1,'valide'),(13007,'WEB_STATIC','2021-2022',1,'valide'),
                            (13007,'ANGLAIS_1','2021-2022',1,'valide'),(13007,'BDD_SQL','2021-2022',2,'valide'),
                            (13007,'COMPTA','2021-2022',2,'valide'),(13007,'WEB_DYN','2021-2022',2,'valide'),
                            (13007,'ANGLAIS_2','2021-2022',2,'valide'),(13007,'JAVA_AVANCE','2022-2023',3,'valide'),
                            (13007,'MANAGEMENT','2022-2023',3,'valide'),(13007,'ALGEBRE','2022-2023',3,'valide'),
                            (13007,'MACHINE_L','2022-2023',4,'valide'),(13007,'OPTIM','2022-2023',4,'valide'),
                            (13007,'PROJET_INFO','2022-2023',4,'valide'),(13007,'RHETORIQUE','2023-2024',5,'en_cours'),

                            (13008,'INTRO_JAVA','2021-2022',1,'valide'),(13008,'ALGO_BASE','2021-2022',1,'valide'),
                            (13008,'ANGLAIS_1','2021-2022',1,'valide'),(13008,'BDD_SQL','2021-2022',2,'valide'),
                            (13008,'COMPTA','2021-2022',2,'valide'),(13008,'ANGLAIS_2','2021-2022',2,'valide'),
                            (13008,'JAVA_AVANCE','2022-2023',3,'valide'),(13008,'STATS_INF','2022-2023',3,'echoue'),
                            (13008,'STATS_INF','2022-2023',4,'valide'),(13008,'MACHINE_L','2022-2023',4,'valide'),
                            (13008,'PROJET_INFO','2022-2023',4,'valide'),(13008,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (13008,'RHETORIQUE','2023-2024',5,'en_cours'),

                            (13009,'INTRO_JAVA','2021-2022',1,'valide'),(13009,'STATS_DESC','2021-2022',1,'valide'),
                            (13009,'ALGO_BASE','2021-2022',1,'valide'),(13009,'ANGLAIS_1','2021-2022',1,'valide'),
                            (13009,'BDD_SQL','2021-2022',2,'valide'),(13009,'COMPTA','2021-2022',2,'valide'),
                            (13009,'PROBA','2021-2022',2,'valide'),(13009,'ANGLAIS_2','2021-2022',2,'valide'),
                            (13009,'JAVA_AVANCE','2022-2023',3,'valide'),(13009,'STATS_INF','2022-2023',3,'valide'),
                            (13009,'MATH_DISC','2022-2023',3,'valide'),(13009,'MACHINE_L','2022-2023',4,'valide'),
                            (13009,'OPTIM','2022-2023',4,'valide'),(13009,'PROJET_INFO','2022-2023',4,'valide'),
                            (13009,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (13010,'INTRO_JAVA','2021-2022',1,'valide'),(13010,'ALGO_BASE','2021-2022',1,'valide'),
                            (13010,'WEB_STATIC','2021-2022',1,'valide'),(13010,'ANGLAIS_1','2021-2022',1,'valide'),
                            (13010,'BDD_SQL','2021-2022',2,'valide'),(13010,'COMPTA','2021-2022',2,'valide'),
                            (13010,'WEB_DYN','2021-2022',2,'valide'),(13010,'ANGLAIS_2','2021-2022',2,'valide'),
                            (13010,'JAVA_AVANCE','2022-2023',3,'valide'),(13010,'MANAGEMENT','2022-2023',3,'valide'),
                            (13010,'MACHINE_L','2022-2023',4,'valide'),(13010,'PROJET_INFO','2022-2023',4,'valide'),
                            (13010,'RHETORIQUE','2023-2024',5,'en_cours');

-- ==========================================
-- PARCOURS 2 : Science des Données et IA
-- S1 : INTRO_JAVA, STATS_DESC, MATH_DISC, ALGEBRE, ANGLAIS_1
-- S2 : ALGO_BASE, PROBA, BDD_SQL, STATS_INF, ANGLAIS_2
-- S3 : MACHINE_L, OPTIM, JAVA_AVANCE, PROJET_INFO
-- S4 : DEEP_L, ANGLAIS_3
-- ==========================================

INSERT INTO Etudiant VALUES
                         (21001,'Kamel','Nadia','2004-01-08',2),(21002,'Lebrun','Olivier','2004-04-20',2),
                         (21003,'Marre','Pauline','2004-08-12',2),(21004,'Noel','Quentin','2004-02-26',2),
                         (21005,'Ober','Ophelie','2004-06-14',2),(21006,'Perrot','Patrick','2004-10-07',2),
                         (21007,'Quentin','Quynh','2004-03-31',2),(21008,'Rosier','Raphael','2004-09-23',2),
                         (21009,'Salmon','Sabrina','2004-07-05',2),(21010,'Tessier','Thibault','2004-12-17',2);

INSERT INTO Inscription VALUES
                            (21001,'INTRO_JAVA','2023-2024',1,'en_cours'),(21001,'STATS_DESC','2023-2024',1,'en_cours'),
                            (21001,'MATH_DISC','2023-2024',1,'en_cours'),(21001,'ALGEBRE','2023-2024',1,'en_cours'),
                            (21001,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (21002,'INTRO_JAVA','2023-2024',1,'en_cours'),(21002,'STATS_DESC','2023-2024',1,'en_cours'),
                            (21002,'MATH_DISC','2023-2024',1,'en_cours'),(21002,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (21003,'INTRO_JAVA','2023-2024',1,'en_cours'),(21003,'ALGEBRE','2023-2024',1,'en_cours'),
                            (21003,'STATS_DESC','2023-2024',1,'en_cours'),
                            (21004,'INTRO_JAVA','2023-2024',1,'en_cours'),(21004,'MATH_DISC','2023-2024',1,'en_cours'),
                            (21004,'ALGEBRE','2023-2024',1,'en_cours'),(21004,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (21005,'INTRO_JAVA','2023-2024',1,'en_cours'),(21005,'STATS_DESC','2023-2024',1,'en_cours'),
                            (21005,'MATH_DISC','2023-2024',1,'en_cours'),
                            (21006,'INTRO_JAVA','2023-2024',1,'en_cours'),(21006,'ALGEBRE','2023-2024',1,'en_cours'),
                            (21006,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (21007,'INTRO_JAVA','2023-2024',1,'en_cours'),(21007,'STATS_DESC','2023-2024',1,'en_cours'),
                            (21007,'MATH_DISC','2023-2024',1,'en_cours'),(21007,'ALGEBRE','2023-2024',1,'en_cours'),
                            (21008,'INTRO_JAVA','2023-2024',1,'en_cours'),(21008,'STATS_DESC','2023-2024',1,'en_cours'),
                            (21008,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (21009,'INTRO_JAVA','2023-2024',1,'en_cours'),(21009,'MATH_DISC','2023-2024',1,'en_cours'),
                            (21009,'STATS_DESC','2023-2024',1,'en_cours'),(21009,'ALGEBRE','2023-2024',1,'en_cours'),
                            (21010,'INTRO_JAVA','2023-2024',1,'en_cours'),(21010,'STATS_DESC','2023-2024',1,'en_cours'),
                            (21010,'ALGEBRE','2023-2024',1,'en_cours');

INSERT INTO Etudiant VALUES
                         (22001,'Uzan','Ursula','2003-02-14',2),(22002,'Vallee','Victor','2003-05-28',2),
                         (22003,'Weil','Wendy','2002-10-09',2),(22004,'Xia','Xavier','2003-08-22',2),
                         (22005,'Yves','Yolande','2002-12-05',2),(22006,'Zola','Zacharie','2003-03-18',2),
                         (22007,'Adam','Axelle','2003-07-01',2),(22008,'Blin','Benoit','2002-11-14',2),
                         (22009,'Cazal','Carole','2003-01-27',2),(22010,'Dron','Damien','2002-09-10',2);

INSERT INTO Inscription VALUES
                            (22001,'INTRO_JAVA','2022-2023',1,'valide'),(22001,'STATS_DESC','2022-2023',1,'valide'),
                            (22001,'MATH_DISC','2022-2023',1,'valide'),(22001,'ALGEBRE','2022-2023',1,'valide'),
                            (22001,'ANGLAIS_1','2022-2023',1,'valide'),(22001,'ALGO_BASE','2022-2023',2,'valide'),
                            (22001,'PROBA','2022-2023',2,'valide'),(22001,'BDD_SQL','2022-2023',2,'valide'),
                            (22001,'STATS_INF','2022-2023',2,'valide'),(22001,'ANGLAIS_2','2022-2023',2,'valide'),
                            (22001,'MACHINE_L','2023-2024',3,'en_cours'),(22001,'OPTIM','2023-2024',3,'en_cours'),
                            (22001,'JAVA_AVANCE','2023-2024',3,'en_cours'),

                            (22002,'INTRO_JAVA','2022-2023',1,'valide'),(22002,'STATS_DESC','2022-2023',1,'valide'),
                            (22002,'ALGEBRE','2022-2023',1,'valide'),(22002,'ANGLAIS_1','2022-2023',1,'valide'),
                            (22002,'ALGO_BASE','2022-2023',2,'valide'),(22002,'PROBA','2022-2023',2,'valide'),
                            (22002,'BDD_SQL','2022-2023',2,'echoue'),(22002,'ANGLAIS_2','2022-2023',2,'valide'),
                            (22002,'BDD_SQL','2023-2024',3,'valide'),(22002,'MACHINE_L','2023-2024',3,'en_cours'),
                            (22002,'OPTIM','2023-2024',3,'en_cours'),

                            (22003,'INTRO_JAVA','2022-2023',1,'valide'),(22003,'MATH_DISC','2022-2023',1,'valide'),
                            (22003,'ALGEBRE','2022-2023',1,'valide'),(22003,'ANGLAIS_1','2022-2023',1,'valide'),
                            (22003,'ALGO_BASE','2022-2023',2,'valide'),(22003,'PROBA','2022-2023',2,'valide'),
                            (22003,'BDD_SQL','2022-2023',2,'valide'),(22003,'STATS_INF','2022-2023',2,'valide'),
                            (22003,'MACHINE_L','2023-2024',3,'en_cours'),(22003,'JAVA_AVANCE','2023-2024',3,'en_cours'),

                            (22004,'INTRO_JAVA','2022-2023',1,'valide'),(22004,'STATS_DESC','2022-2023',1,'valide'),
                            (22004,'MATH_DISC','2022-2023',1,'valide'),(22004,'ANGLAIS_1','2022-2023',1,'valide'),
                            (22004,'ALGO_BASE','2022-2023',2,'valide'),(22004,'PROBA','2022-2023',2,'valide'),
                            (22004,'BDD_SQL','2022-2023',2,'valide'),(22004,'ANGLAIS_2','2022-2023',2,'valide'),
                            (22004,'MACHINE_L','2023-2024',3,'en_cours'),(22004,'OPTIM','2023-2024',3,'en_cours'),

                            (22005,'INTRO_JAVA','2022-2023',1,'valide'),(22005,'ALGEBRE','2022-2023',1,'valide'),
                            (22005,'ANGLAIS_1','2022-2023',1,'valide'),(22005,'ALGO_BASE','2022-2023',2,'valide'),
                            (22005,'PROBA','2022-2023',2,'valide'),(22005,'BDD_SQL','2022-2023',2,'valide'),
                            (22005,'STATS_INF','2022-2023',2,'valide'),(22005,'MACHINE_L','2023-2024',3,'en_cours'),
                            (22005,'JAVA_AVANCE','2023-2024',3,'en_cours'),

                            (22006,'INTRO_JAVA','2022-2023',1,'valide'),(22006,'STATS_DESC','2022-2023',1,'valide'),
                            (22006,'ALGEBRE','2022-2023',1,'valide'),(22006,'ALGO_BASE','2022-2023',2,'valide'),
                            (22006,'PROBA','2022-2023',2,'valide'),(22006,'ANGLAIS_2','2022-2023',2,'valide'),
                            (22006,'MACHINE_L','2023-2024',3,'en_cours'),

                            (22007,'INTRO_JAVA','2022-2023',1,'valide'),(22007,'MATH_DISC','2022-2023',1,'valide'),
                            (22007,'ALGEBRE','2022-2023',1,'valide'),(22007,'ANGLAIS_1','2022-2023',1,'valide'),
                            (22007,'ALGO_BASE','2022-2023',2,'valide'),(22007,'BDD_SQL','2022-2023',2,'valide'),
                            (22007,'STATS_INF','2022-2023',2,'valide'),(22007,'MACHINE_L','2023-2024',3,'en_cours'),
                            (22007,'OPTIM','2023-2024',3,'en_cours'),

                            (22008,'INTRO_JAVA','2022-2023',1,'valide'),(22008,'STATS_DESC','2022-2023',1,'valide'),
                            (22008,'ALGEBRE','2022-2023',1,'valide'),(22008,'ALGO_BASE','2022-2023',2,'valide'),
                            (22008,'PROBA','2022-2023',2,'valide'),(22008,'BDD_SQL','2022-2023',2,'valide'),
                            (22008,'MACHINE_L','2023-2024',3,'en_cours'),

                            (22009,'INTRO_JAVA','2022-2023',1,'valide'),(22009,'MATH_DISC','2022-2023',1,'valide'),
                            (22009,'ALGEBRE','2022-2023',1,'valide'),(22009,'ALGO_BASE','2022-2023',2,'valide'),
                            (22009,'PROBA','2022-2023',2,'valide'),(22009,'ANGLAIS_2','2022-2023',2,'valide'),
                            (22009,'MACHINE_L','2023-2024',3,'en_cours'),(22009,'JAVA_AVANCE','2023-2024',3,'en_cours'),

                            (22010,'INTRO_JAVA','2022-2023',1,'valide'),(22010,'STATS_DESC','2022-2023',1,'valide'),
                            (22010,'ALGEBRE','2022-2023',1,'valide'),(22010,'ANGLAIS_1','2022-2023',1,'valide'),
                            (22010,'ALGO_BASE','2022-2023',2,'valide'),(22010,'BDD_SQL','2022-2023',2,'valide'),
                            (22010,'STATS_INF','2022-2023',2,'valide'),(22010,'MACHINE_L','2023-2024',3,'en_cours');

INSERT INTO Etudiant VALUES
                         (23001,'Elan','Emile','2002-04-06',2),(23002,'Feron','Faustine','2001-08-19',2),
                         (23003,'Gros','Gilles','2002-01-31',2),(23004,'Hamon','Heloise','2001-05-13',2),
                         (23005,'Ide','Igor','2002-09-26',2),(23006,'Jan','Jasmine','2001-03-08',2),
                         (23007,'Kopp','Kilian','2002-07-21',2),(23008,'Lang','Laure','2001-11-04',2),
                         (23009,'Mas','Maxence','2002-02-17',2),(23010,'Nau','Noemie','2001-06-30',2);

INSERT INTO Inscription VALUES
                            (23001,'INTRO_JAVA','2021-2022',1,'valide'),(23001,'STATS_DESC','2021-2022',1,'valide'),
                            (23001,'MATH_DISC','2021-2022',1,'valide'),(23001,'ALGEBRE','2021-2022',1,'valide'),
                            (23001,'ANGLAIS_1','2021-2022',1,'valide'),(23001,'ALGO_BASE','2021-2022',2,'valide'),
                            (23001,'PROBA','2021-2022',2,'valide'),(23001,'BDD_SQL','2021-2022',2,'valide'),
                            (23001,'STATS_INF','2021-2022',2,'valide'),(23001,'ANGLAIS_2','2021-2022',2,'valide'),
                            (23001,'MACHINE_L','2022-2023',3,'valide'),(23001,'OPTIM','2022-2023',3,'valide'),
                            (23001,'JAVA_AVANCE','2022-2023',3,'valide'),(23001,'PROJET_INFO','2022-2023',4,'valide'),
                            (23001,'DEEP_L','2022-2023',4,'valide'),(23001,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (23002,'INTRO_JAVA','2021-2022',1,'valide'),(23002,'ALGEBRE','2021-2022',1,'valide'),
                            (23002,'ANGLAIS_1','2021-2022',1,'valide'),(23002,'ALGO_BASE','2021-2022',2,'valide'),
                            (23002,'PROBA','2021-2022',2,'valide'),(23002,'BDD_SQL','2021-2022',2,'valide'),
                            (23002,'ANGLAIS_2','2021-2022',2,'valide'),(23002,'MACHINE_L','2022-2023',3,'valide'),
                            (23002,'OPTIM','2022-2023',3,'valide'),(23002,'PROJET_INFO','2022-2023',4,'valide'),
                            (23002,'DEEP_L','2022-2023',4,'echoue'),(23002,'DEEP_L','2023-2024',5,'en_cours'),
                            (23002,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (23003,'INTRO_JAVA','2021-2022',1,'valide'),(23003,'STATS_DESC','2021-2022',1,'valide'),
                            (23003,'MATH_DISC','2021-2022',1,'valide'),(23003,'ANGLAIS_1','2021-2022',1,'valide'),
                            (23003,'ALGO_BASE','2021-2022',2,'valide'),(23003,'PROBA','2021-2022',2,'valide'),
                            (23003,'STATS_INF','2021-2022',2,'valide'),(23003,'ANGLAIS_2','2021-2022',2,'valide'),
                            (23003,'MACHINE_L','2022-2023',3,'valide'),(23003,'JAVA_AVANCE','2022-2023',3,'valide'),
                            (23003,'PROJET_INFO','2022-2023',4,'valide'),(23003,'DEEP_L','2022-2023',4,'valide'),
                            (23003,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (23004,'INTRO_JAVA','2021-2022',1,'valide'),(23004,'MATH_DISC','2021-2022',1,'valide'),
                            (23004,'ALGEBRE','2021-2022',1,'valide'),(23004,'ALGO_BASE','2021-2022',2,'valide'),
                            (23004,'PROBA','2021-2022',2,'valide'),(23004,'BDD_SQL','2021-2022',2,'valide'),
                            (23004,'STATS_INF','2021-2022',2,'valide'),(23004,'MACHINE_L','2022-2023',3,'valide'),
                            (23004,'OPTIM','2022-2023',3,'valide'),(23004,'PROJET_INFO','2022-2023',4,'valide'),
                            (23004,'DEEP_L','2022-2023',4,'valide'),(23004,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (23005,'INTRO_JAVA','2021-2022',1,'valide'),(23005,'STATS_DESC','2021-2022',1,'valide'),
                            (23005,'ALGEBRE','2021-2022',1,'valide'),(23005,'ANGLAIS_1','2021-2022',1,'valide'),
                            (23005,'ALGO_BASE','2021-2022',2,'valide'),(23005,'BDD_SQL','2021-2022',2,'valide'),
                            (23005,'ANGLAIS_2','2021-2022',2,'valide'),(23005,'MACHINE_L','2022-2023',3,'valide'),
                            (23005,'JAVA_AVANCE','2022-2023',3,'valide'),(23005,'PROJET_INFO','2022-2023',4,'valide'),
                            (23005,'DEEP_L','2022-2023',4,'valide'),(23005,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (23006,'INTRO_JAVA','2021-2022',1,'valide'),(23006,'MATH_DISC','2021-2022',1,'valide'),
                            (23006,'ALGEBRE','2021-2022',1,'valide'),(23006,'ALGO_BASE','2021-2022',2,'valide'),
                            (23006,'PROBA','2021-2022',2,'valide'),(23006,'BDD_SQL','2021-2022',2,'valide'),
                            (23006,'MACHINE_L','2022-2023',3,'valide'),(23006,'OPTIM','2022-2023',3,'valide'),
                            (23006,'PROJET_INFO','2022-2023',4,'valide'),(23006,'DEEP_L','2022-2023',4,'valide'),
                            (23006,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (23007,'INTRO_JAVA','2021-2022',1,'valide'),(23007,'STATS_DESC','2021-2022',1,'valide'),
                            (23007,'ALGEBRE','2021-2022',1,'valide'),(23007,'ALGO_BASE','2021-2022',2,'valide'),
                            (23007,'PROBA','2021-2022',2,'valide'),(23007,'STATS_INF','2021-2022',2,'valide'),
                            (23007,'MACHINE_L','2022-2023',3,'valide'),(23007,'JAVA_AVANCE','2022-2023',3,'valide'),
                            (23007,'PROJET_INFO','2022-2023',4,'valide'),(23007,'DEEP_L','2022-2023',4,'valide'),
                            (23007,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (23008,'INTRO_JAVA','2021-2022',1,'valide'),(23008,'MATH_DISC','2021-2022',1,'valide'),
                            (23008,'ALGEBRE','2021-2022',1,'valide'),(23008,'ANGLAIS_1','2021-2022',1,'valide'),
                            (23008,'ALGO_BASE','2021-2022',2,'valide'),(23008,'BDD_SQL','2021-2022',2,'valide'),
                            (23008,'ANGLAIS_2','2021-2022',2,'valide'),(23008,'MACHINE_L','2022-2023',3,'valide'),
                            (23008,'OPTIM','2022-2023',3,'valide'),(23008,'PROJET_INFO','2022-2023',4,'valide'),
                            (23008,'DEEP_L','2022-2023',4,'valide'),(23008,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (23009,'INTRO_JAVA','2021-2022',1,'valide'),(23009,'ALGEBRE','2021-2022',1,'valide'),
                            (23009,'ALGO_BASE','2021-2022',2,'valide'),(23009,'PROBA','2021-2022',2,'valide'),
                            (23009,'BDD_SQL','2021-2022',2,'valide'),(23009,'MACHINE_L','2022-2023',3,'valide'),
                            (23009,'PROJET_INFO','2022-2023',4,'valide'),(23009,'DEEP_L','2023-2024',5,'en_cours'),

                            (23010,'INTRO_JAVA','2021-2022',1,'valide'),(23010,'STATS_DESC','2021-2022',1,'valide'),
                            (23010,'MATH_DISC','2021-2022',1,'valide'),(23010,'ALGEBRE','2021-2022',1,'valide'),
                            (23010,'ALGO_BASE','2021-2022',2,'valide'),(23010,'PROBA','2021-2022',2,'valide'),
                            (23010,'STATS_INF','2021-2022',2,'valide'),(23010,'MACHINE_L','2022-2023',3,'valide'),
                            (23010,'OPTIM','2022-2023',3,'valide'),(23010,'PROJET_INFO','2022-2023',4,'valide'),
                            (23010,'DEEP_L','2022-2023',4,'valide'),(23010,'ANGLAIS_3','2023-2024',5,'en_cours');

-- ==========================================
-- PARCOURS 3 : Développement Logiciel
-- S1 : INTRO_JAVA, ALGO_BASE, WEB_STATIC, MATH_DISC, ANGLAIS_1
-- S2 : JAVA_AVANCE, WEB_DYN, BDD_SQL, ALGO_AVANCE, ANGLAIS_2
-- S3 : SYST_EXP, MOBILE, CLOUD, SECU_INFO
-- S4 : PROJET_INFO, ANGLAIS_3, RHETORIQUE
-- ==========================================

INSERT INTO Etudiant VALUES
                         (31001,'Odin','Oceane','2004-01-15',3),(31002,'Pagnol','Paul','2004-04-28',3),
                         (31003,'Quintin','Quentin','2004-08-10',3),(31004,'Ravel','Romain','2004-03-02',3),
                         (31005,'Sabot','Sylvie','2004-07-19',3),(31006,'Tabary','Thomas','2004-11-06',3),
                         (31007,'Uhl','Ugo','2004-02-24',3),(31008,'Verne','Valerie','2004-09-12',3),
                         (31009,'Wagner','William','2004-05-30',3),(31010,'Xavier','Xiao','2004-12-18',3);

INSERT INTO Inscription VALUES
                            (31001,'INTRO_JAVA','2023-2024',1,'en_cours'),(31001,'ALGO_BASE','2023-2024',1,'en_cours'),
                            (31001,'WEB_STATIC','2023-2024',1,'en_cours'),(31001,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (31002,'INTRO_JAVA','2023-2024',1,'en_cours'),(31002,'WEB_STATIC','2023-2024',1,'en_cours'),
                            (31002,'MATH_DISC','2023-2024',1,'en_cours'),
                            (31003,'INTRO_JAVA','2023-2024',1,'en_cours'),(31003,'ALGO_BASE','2023-2024',1,'en_cours'),
                            (31003,'WEB_STATIC','2023-2024',1,'en_cours'),(31003,'MATH_DISC','2023-2024',1,'en_cours'),
                            (31003,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (31004,'INTRO_JAVA','2023-2024',1,'en_cours'),(31004,'ALGO_BASE','2023-2024',1,'en_cours'),
                            (31004,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (31005,'INTRO_JAVA','2023-2024',1,'en_cours'),(31005,'WEB_STATIC','2023-2024',1,'en_cours'),
                            (31006,'INTRO_JAVA','2023-2024',1,'en_cours'),(31006,'ALGO_BASE','2023-2024',1,'en_cours'),
                            (31006,'WEB_STATIC','2023-2024',1,'en_cours'),(31006,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (31007,'INTRO_JAVA','2023-2024',1,'en_cours'),(31007,'ALGO_BASE','2023-2024',1,'en_cours'),
                            (31008,'INTRO_JAVA','2023-2024',1,'en_cours'),(31008,'WEB_STATIC','2023-2024',1,'en_cours'),
                            (31008,'MATH_DISC','2023-2024',1,'en_cours'),
                            (31009,'INTRO_JAVA','2023-2024',1,'en_cours'),(31009,'ALGO_BASE','2023-2024',1,'en_cours'),
                            (31009,'WEB_STATIC','2023-2024',1,'en_cours'),
                            (31010,'INTRO_JAVA','2023-2024',1,'en_cours'),(31010,'ALGO_BASE','2023-2024',1,'en_cours'),
                            (31010,'ANGLAIS_1','2023-2024',1,'en_cours');

INSERT INTO Etudiant VALUES
                         (32001,'Yvan','Yann','2003-03-07',3),(32002,'Zara','Zoe','2003-06-20',3),
                         (32003,'Abel','Adele','2002-10-12',3),(32004,'Bret','Bertrand','2003-01-25',3),
                         (32005,'Cros','Christelle','2002-11-08',3),(32006,'Droz','Delphine','2003-04-14',3),
                         (32007,'Eche','Etienne','2003-08-27',3),(32008,'Fons','Francois','2002-12-10',3),
                         (32009,'Gros','Gilles','2003-02-23',3),(32010,'Hue','Helene','2002-07-06',3);

INSERT INTO Inscription VALUES
                            (32001,'INTRO_JAVA','2022-2023',1,'valide'),(32001,'ALGO_BASE','2022-2023',1,'valide'),
                            (32001,'WEB_STATIC','2022-2023',1,'valide'),(32001,'ANGLAIS_1','2022-2023',1,'valide'),
                            (32001,'JAVA_AVANCE','2022-2023',2,'valide'),(32001,'WEB_DYN','2022-2023',2,'valide'),
                            (32001,'BDD_SQL','2022-2023',2,'valide'),(32001,'ANGLAIS_2','2022-2023',2,'valide'),
                            (32001,'SYST_EXP','2023-2024',3,'en_cours'),(32001,'MOBILE','2023-2024',3,'en_cours'),
                            (32001,'CLOUD','2023-2024',3,'en_cours'),

                            (32002,'INTRO_JAVA','2022-2023',1,'valide'),(32002,'WEB_STATIC','2022-2023',1,'valide'),
                            (32002,'ANGLAIS_1','2022-2023',1,'valide'),(32002,'ALGO_BASE','2022-2023',1,'echoue'),
                            (32002,'ALGO_BASE','2022-2023',2,'valide'),(32002,'WEB_DYN','2022-2023',2,'valide'),
                            (32002,'BDD_SQL','2022-2023',2,'valide'),(32002,'JAVA_AVANCE','2023-2024',3,'en_cours'),
                            (32002,'SYST_EXP','2023-2024',3,'en_cours'),

                            (32003,'INTRO_JAVA','2022-2023',1,'valide'),(32003,'ALGO_BASE','2022-2023',1,'valide'),
                            (32003,'WEB_STATIC','2022-2023',1,'valide'),(32003,'JAVA_AVANCE','2022-2023',2,'valide'),
                            (32003,'WEB_DYN','2022-2023',2,'valide'),(32003,'BDD_SQL','2022-2023',2,'valide'),
                            (32003,'ANGLAIS_2','2022-2023',2,'valide'),(32003,'SYST_EXP','2023-2024',3,'en_cours'),
                            (32003,'MOBILE','2023-2024',3,'en_cours'),

                            (32004,'INTRO_JAVA','2022-2023',1,'valide'),(32004,'ALGO_BASE','2022-2023',1,'valide'),
                            (32004,'ANGLAIS_1','2022-2023',1,'valide'),(32004,'JAVA_AVANCE','2022-2023',2,'valide'),
                            (32004,'WEB_DYN','2022-2023',2,'valide'),(32004,'ANGLAIS_2','2022-2023',2,'valide'),
                            (32004,'BDD_SQL','2023-2024',3,'en_cours'),(32004,'SYST_EXP','2023-2024',3,'en_cours'),

                            (32005,'INTRO_JAVA','2022-2023',1,'valide'),(32005,'WEB_STATIC','2022-2023',1,'valide'),
                            (32005,'ALGO_BASE','2022-2023',1,'valide'),(32005,'JAVA_AVANCE','2022-2023',2,'valide'),
                            (32005,'WEB_DYN','2022-2023',2,'valide'),(32005,'BDD_SQL','2022-2023',2,'valide'),
                            (32005,'SYST_EXP','2023-2024',3,'en_cours'),(32005,'SECU_INFO','2023-2024',3,'en_cours'),

                            (32006,'INTRO_JAVA','2022-2023',1,'valide'),(32006,'ALGO_BASE','2022-2023',1,'valide'),
                            (32006,'WEB_STATIC','2022-2023',1,'valide'),(32006,'JAVA_AVANCE','2022-2023',2,'valide'),
                            (32006,'BDD_SQL','2022-2023',2,'valide'),(32006,'ANGLAIS_2','2022-2023',2,'valide'),
                            (32006,'SYST_EXP','2023-2024',3,'en_cours'),(32006,'MOBILE','2023-2024',3,'en_cours'),

                            (32007,'INTRO_JAVA','2022-2023',1,'valide'),(32007,'ALGO_BASE','2022-2023',1,'valide'),
                            (32007,'ANGLAIS_1','2022-2023',1,'valide'),(32007,'WEB_DYN','2022-2023',2,'valide'),
                            (32007,'JAVA_AVANCE','2022-2023',2,'valide'),(32007,'ANGLAIS_2','2022-2023',2,'valide'),
                            (32007,'SYST_EXP','2023-2024',3,'en_cours'),

                            (32008,'INTRO_JAVA','2022-2023',1,'valide'),(32008,'WEB_STATIC','2022-2023',1,'valide'),
                            (32008,'ALGO_BASE','2022-2023',1,'valide'),(32008,'JAVA_AVANCE','2022-2023',2,'valide'),
                            (32008,'WEB_DYN','2022-2023',2,'valide'),(32008,'BDD_SQL','2022-2023',2,'valide'),
                            (32008,'SYST_EXP','2023-2024',3,'en_cours'),(32008,'CLOUD','2023-2024',3,'en_cours'),

                            (32009,'INTRO_JAVA','2022-2023',1,'valide'),(32009,'ALGO_BASE','2022-2023',1,'valide'),
                            (32009,'WEB_STATIC','2022-2023',1,'valide'),(32009,'JAVA_AVANCE','2022-2023',2,'valide'),
                            (32009,'WEB_DYN','2022-2023',2,'valide'),(32009,'ANGLAIS_2','2022-2023',2,'valide'),
                            (32009,'SYST_EXP','2023-2024',3,'en_cours'),(32009,'MOBILE','2023-2024',3,'en_cours'),

                            (32010,'INTRO_JAVA','2022-2023',1,'valide'),(32010,'ALGO_BASE','2022-2023',1,'valide'),
                            (32010,'ANGLAIS_1','2022-2023',1,'valide'),(32010,'JAVA_AVANCE','2022-2023',2,'valide'),
                            (32010,'BDD_SQL','2022-2023',2,'valide'),(32010,'ANGLAIS_2','2022-2023',2,'valide'),
                            (32010,'SYST_EXP','2023-2024',3,'en_cours'),(32010,'SECU_INFO','2023-2024',3,'en_cours');

INSERT INTO Etudiant VALUES
                         (33001,'Ilic','Irene','2002-05-19',3),(33002,'Jan','Jacques','2001-09-01',3),
                         (33003,'Katz','Kevin','2002-01-14',3),(33004,'Labbe','Leonie','2001-04-27',3),
                         (33005,'Mahe','Maxime','2002-08-10',3),(33006,'Nabet','Nathalie','2001-12-23',3),
                         (33007,'Oger','Olivier','2002-03-06',3),(33008,'Pade','Patricia','2001-07-19',3),
                         (33009,'Rieu','Roland','2002-11-02',3),(33010,'Saby','Serge','2001-06-15',3);

INSERT INTO Inscription VALUES
                            (33001,'INTRO_JAVA','2021-2022',1,'valide'),(33001,'ALGO_BASE','2021-2022',1,'valide'),
                            (33001,'WEB_STATIC','2021-2022',1,'valide'),(33001,'ANGLAIS_1','2021-2022',1,'valide'),
                            (33001,'JAVA_AVANCE','2021-2022',2,'valide'),(33001,'WEB_DYN','2021-2022',2,'valide'),
                            (33001,'BDD_SQL','2021-2022',2,'valide'),(33001,'ANGLAIS_2','2021-2022',2,'valide'),
                            (33001,'SYST_EXP','2022-2023',3,'valide'),(33001,'MOBILE','2022-2023',3,'valide'),
                            (33001,'CLOUD','2022-2023',3,'valide'),(33001,'PROJET_INFO','2022-2023',4,'valide'),
                            (33001,'ANGLAIS_3','2023-2024',5,'en_cours'),(33001,'RHETORIQUE','2023-2024',5,'en_cours'),

                            (33002,'INTRO_JAVA','2021-2022',1,'valide'),(33002,'ALGO_BASE','2021-2022',1,'valide'),
                            (33002,'WEB_STATIC','2021-2022',1,'valide'),(33002,'JAVA_AVANCE','2021-2022',2,'valide'),
                            (33002,'WEB_DYN','2021-2022',2,'valide'),(33002,'BDD_SQL','2021-2022',2,'valide'),
                            (33002,'SYST_EXP','2022-2023',3,'valide'),(33002,'MOBILE','2022-2023',3,'echoue'),
                            (33002,'MOBILE','2022-2023',4,'valide'),(33002,'PROJET_INFO','2022-2023',4,'valide'),
                            (33002,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (33003,'INTRO_JAVA','2021-2022',1,'valide'),(33003,'ALGO_BASE','2021-2022',1,'valide'),
                            (33003,'ANGLAIS_1','2021-2022',1,'valide'),(33003,'JAVA_AVANCE','2021-2022',2,'valide'),
                            (33003,'WEB_DYN','2021-2022',2,'valide'),(33003,'BDD_SQL','2021-2022',2,'valide'),
                            (33003,'ANGLAIS_2','2021-2022',2,'valide'),(33003,'SYST_EXP','2022-2023',3,'valide'),
                            (33003,'CLOUD','2022-2023',3,'valide'),(33003,'PROJET_INFO','2022-2023',4,'valide'),
                            (33003,'RHETORIQUE','2023-2024',5,'en_cours'),

                            (33004,'INTRO_JAVA','2021-2022',1,'valide'),(33004,'WEB_STATIC','2021-2022',1,'valide'),
                            (33004,'ALGO_BASE','2021-2022',1,'valide'),(33004,'JAVA_AVANCE','2021-2022',2,'valide'),
                            (33004,'WEB_DYN','2021-2022',2,'valide'),(33004,'BDD_SQL','2021-2022',2,'valide'),
                            (33004,'SYST_EXP','2022-2023',3,'valide'),(33004,'MOBILE','2022-2023',3,'valide'),
                            (33004,'PROJET_INFO','2022-2023',4,'valide'),(33004,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (33005,'INTRO_JAVA','2021-2022',1,'valide'),(33005,'ALGO_BASE','2021-2022',1,'valide'),
                            (33005,'WEB_STATIC','2021-2022',1,'valide'),(33005,'JAVA_AVANCE','2021-2022',2,'valide'),
                            (33005,'WEB_DYN','2021-2022',2,'valide'),(33005,'ANGLAIS_2','2021-2022',2,'valide'),
                            (33005,'SYST_EXP','2022-2023',3,'valide'),(33005,'SECU_INFO','2022-2023',3,'valide'),
                            (33005,'PROJET_INFO','2022-2023',4,'valide'),(33005,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (33005,'RHETORIQUE','2023-2024',5,'en_cours'),

                            (33006,'INTRO_JAVA','2021-2022',1,'valide'),(33006,'ALGO_BASE','2021-2022',1,'valide'),
                            (33006,'ANGLAIS_1','2021-2022',1,'valide'),(33006,'JAVA_AVANCE','2021-2022',2,'valide'),
                            (33006,'BDD_SQL','2021-2022',2,'valide'),(33006,'ANGLAIS_2','2021-2022',2,'valide'),
                            (33006,'SYST_EXP','2022-2023',3,'valide'),(33006,'MOBILE','2022-2023',3,'valide'),
                            (33006,'CLOUD','2022-2023',3,'valide'),(33006,'PROJET_INFO','2022-2023',4,'valide'),
                            (33006,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (33007,'INTRO_JAVA','2021-2022',1,'valide'),(33007,'WEB_STATIC','2021-2022',1,'valide'),
                            (33007,'ALGO_BASE','2021-2022',1,'valide'),(33007,'JAVA_AVANCE','2021-2022',2,'valide'),
                            (33007,'WEB_DYN','2021-2022',2,'valide'),(33007,'BDD_SQL','2021-2022',2,'valide'),
                            (33007,'SYST_EXP','2022-2023',3,'valide'),(33007,'CLOUD','2022-2023',3,'valide'),
                            (33007,'PROJET_INFO','2022-2023',4,'valide'),(33007,'RHETORIQUE','2023-2024',5,'en_cours'),

                            (33008,'INTRO_JAVA','2021-2022',1,'valide'),(33008,'ALGO_BASE','2021-2022',1,'valide'),
                            (33008,'WEB_STATIC','2021-2022',1,'valide'),(33008,'JAVA_AVANCE','2021-2022',2,'valide'),
                            (33008,'WEB_DYN','2021-2022',2,'valide'),(33008,'ANGLAIS_2','2021-2022',2,'valide'),
                            (33008,'SYST_EXP','2022-2023',3,'valide'),(33008,'MOBILE','2022-2023',3,'valide'),
                            (33008,'PROJET_INFO','2022-2023',4,'valide'),(33008,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (33009,'INTRO_JAVA','2021-2022',1,'valide'),(33009,'ALGO_BASE','2021-2022',1,'valide'),
                            (33009,'ANGLAIS_1','2021-2022',1,'valide'),(33009,'JAVA_AVANCE','2021-2022',2,'valide'),
                            (33009,'WEB_DYN','2021-2022',2,'valide'),(33009,'BDD_SQL','2021-2022',2,'valide'),
                            (33009,'SYST_EXP','2022-2023',3,'valide'),(33009,'SECU_INFO','2022-2023',3,'valide'),
                            (33009,'PROJET_INFO','2022-2023',4,'valide'),(33009,'RHETORIQUE','2023-2024',5,'en_cours'),

                            (33010,'INTRO_JAVA','2021-2022',1,'valide'),(33010,'WEB_STATIC','2021-2022',1,'valide'),
                            (33010,'ALGO_BASE','2021-2022',1,'valide'),(33010,'JAVA_AVANCE','2021-2022',2,'valide'),
                            (33010,'WEB_DYN','2021-2022',2,'valide'),(33010,'BDD_SQL','2021-2022',2,'valide'),
                            (33010,'SYST_EXP','2022-2023',3,'valide'),(33010,'MOBILE','2022-2023',3,'valide'),
                            (33010,'CLOUD','2022-2023',3,'valide'),(33010,'PROJET_INFO','2022-2023',4,'valide'),
                            (33010,'ANGLAIS_3','2023-2024',5,'en_cours');

-- ==========================================
-- PARCOURS 4 : Systèmes et Réseaux
-- S1 : INTRO_JAVA, ALGO_BASE, SYST_EXP, MATH_DISC, ANGLAIS_1
-- S2 : RESEAU, BDD_SQL, SECU_INFO, CLOUD, ANGLAIS_2
-- S3 : ALGO_AVANCE, MOBILE
-- S4 : PROJET_INFO, ANGLAIS_3
-- ==========================================

INSERT INTO Etudiant VALUES
                         (41001,'Toby','Theo','2004-02-11',4),(41002,'Unger','Uriel','2004-05-24',4),
                         (41003,'Vion','Violette','2004-09-06',4),(41004,'Ward','Wendy','2004-01-19',4),
                         (41005,'Xing','Xuan','2004-07-02',4),(41006,'Yen','Yves','2004-10-15',4),
                         (41007,'Ziem','Zofia','2004-03-28',4),(41008,'Alix','Alex','2004-08-11',4),
                         (41009,'Bory','Baptiste','2004-06-24',4),(41010,'Cara','Camille','2004-12-07',4);

INSERT INTO Inscription VALUES
                            (41001,'INTRO_JAVA','2023-2024',1,'en_cours'),(41001,'ALGO_BASE','2023-2024',1,'en_cours'),
                            (41001,'SYST_EXP','2023-2024',1,'en_cours'),(41001,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (41002,'INTRO_JAVA','2023-2024',1,'en_cours'),(41002,'ALGO_BASE','2023-2024',1,'en_cours'),
                            (41002,'MATH_DISC','2023-2024',1,'en_cours'),
                            (41003,'INTRO_JAVA','2023-2024',1,'en_cours'),(41003,'SYST_EXP','2023-2024',1,'en_cours'),
                            (41003,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (41004,'INTRO_JAVA','2023-2024',1,'en_cours'),(41004,'ALGO_BASE','2023-2024',1,'en_cours'),
                            (41004,'SYST_EXP','2023-2024',1,'en_cours'),(41004,'MATH_DISC','2023-2024',1,'en_cours'),
                            (41005,'INTRO_JAVA','2023-2024',1,'en_cours'),(41005,'ALGO_BASE','2023-2024',1,'en_cours'),
                            (41006,'SYST_EXP','2023-2024',1,'en_cours'),(41006,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (41007,'INTRO_JAVA','2023-2024',1,'en_cours'),(41007,'ALGO_BASE','2023-2024',1,'en_cours'),
                            (41007,'SYST_EXP','2023-2024',1,'en_cours'),
                            (41008,'INTRO_JAVA','2023-2024',1,'en_cours'),(41008,'MATH_DISC','2023-2024',1,'en_cours'),
                            (41009,'INTRO_JAVA','2023-2024',1,'en_cours'),(41009,'SYST_EXP','2023-2024',1,'en_cours'),
                            (41009,'ALGO_BASE','2023-2024',1,'en_cours'),(41009,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (41010,'INTRO_JAVA','2023-2024',1,'en_cours'),(41010,'ALGO_BASE','2023-2024',1,'en_cours');

INSERT INTO Etudiant VALUES
                         (42001,'Dais','David','2003-04-13',4),(42002,'Edy','Eloise','2003-07-26',4),
                         (42003,'Fary','Florent','2002-11-08',4),(42004,'Galy','Geraldine','2003-02-21',4),
                         (42005,'Hely','Hugo','2002-10-04',4),(42006,'Illy','Iris','2003-05-17',4),
                         (42007,'Jury','Julien','2003-09-30',4),(42008,'Kery','Karen','2002-08-12',4),
                         (42009,'Lory','Lucas','2003-03-25',4),(42010,'Mary','Manon','2002-12-08',4);

INSERT INTO Inscription VALUES
                            (42001,'INTRO_JAVA','2022-2023',1,'valide'),(42001,'ALGO_BASE','2022-2023',1,'valide'),
                            (42001,'SYST_EXP','2022-2023',1,'valide'),(42001,'ANGLAIS_1','2022-2023',1,'valide'),
                            (42001,'RESEAU','2022-2023',2,'valide'),(42001,'BDD_SQL','2022-2023',2,'valide'),
                            (42001,'SECU_INFO','2022-2023',2,'valide'),(42001,'ANGLAIS_2','2022-2023',2,'valide'),
                            (42001,'ALGO_AVANCE','2023-2024',3,'en_cours'),(42001,'MOBILE','2023-2024',3,'en_cours'),

                            (42002,'INTRO_JAVA','2022-2023',1,'valide'),(42002,'SYST_EXP','2022-2023',1,'valide'),
                            (42002,'ANGLAIS_1','2022-2023',1,'valide'),(42002,'RESEAU','2022-2023',2,'valide'),
                            (42002,'BDD_SQL','2022-2023',2,'valide'),(42002,'ANGLAIS_2','2022-2023',2,'valide'),
                            (42002,'ALGO_AVANCE','2023-2024',3,'en_cours'),

                            (42003,'INTRO_JAVA','2022-2023',1,'valide'),(42003,'ALGO_BASE','2022-2023',1,'valide'),
                            (42003,'SYST_EXP','2022-2023',1,'valide'),(42003,'RESEAU','2022-2023',2,'valide'),
                            (42003,'SECU_INFO','2022-2023',2,'valide'),(42003,'BDD_SQL','2022-2023',2,'valide'),
                            (42003,'ALGO_AVANCE','2023-2024',3,'en_cours'),(42003,'MOBILE','2023-2024',3,'en_cours'),

                            (42004,'INTRO_JAVA','2022-2023',1,'valide'),(42004,'ALGO_BASE','2022-2023',1,'valide'),
                            (42004,'ANGLAIS_1','2022-2023',1,'valide'),(42004,'RESEAU','2022-2023',2,'valide'),
                            (42004,'BDD_SQL','2022-2023',2,'echoue'),(42004,'ANGLAIS_2','2022-2023',2,'valide'),
                            (42004,'BDD_SQL','2023-2024',3,'valide'),(42004,'ALGO_AVANCE','2023-2024',3,'en_cours'),

                            (42005,'INTRO_JAVA','2022-2023',1,'valide'),(42005,'SYST_EXP','2022-2023',1,'valide'),
                            (42005,'ALGO_BASE','2022-2023',1,'valide'),(42005,'RESEAU','2022-2023',2,'valide'),
                            (42005,'SECU_INFO','2022-2023',2,'valide'),(42005,'ANGLAIS_2','2022-2023',2,'valide'),
                            (42005,'ALGO_AVANCE','2023-2024',3,'en_cours'),

                            (42006,'INTRO_JAVA','2022-2023',1,'valide'),(42006,'ALGO_BASE','2022-2023',1,'valide'),
                            (42006,'SYST_EXP','2022-2023',1,'valide'),(42006,'RESEAU','2022-2023',2,'valide'),
                            (42006,'BDD_SQL','2022-2023',2,'valide'),(42006,'CLOUD','2022-2023',2,'valide'),
                            (42006,'ALGO_AVANCE','2023-2024',3,'en_cours'),(42006,'MOBILE','2023-2024',3,'en_cours'),

                            (42007,'INTRO_JAVA','2022-2023',1,'valide'),(42007,'SYST_EXP','2022-2023',1,'valide'),
                            (42007,'ANGLAIS_1','2022-2023',1,'valide'),(42007,'RESEAU','2022-2023',2,'valide'),
                            (42007,'ANGLAIS_2','2022-2023',2,'valide'),(42007,'ALGO_AVANCE','2023-2024',3,'en_cours'),

                            (42008,'INTRO_JAVA','2022-2023',1,'valide'),(42008,'ALGO_BASE','2022-2023',1,'valide'),
                            (42008,'SYST_EXP','2022-2023',1,'valide'),(42008,'RESEAU','2022-2023',2,'valide'),
                            (42008,'BDD_SQL','2022-2023',2,'valide'),(42008,'SECU_INFO','2022-2023',2,'valide'),
                            (42008,'ALGO_AVANCE','2023-2024',3,'en_cours'),

                            (42009,'INTRO_JAVA','2022-2023',1,'valide'),(42009,'SYST_EXP','2022-2023',1,'valide'),
                            (42009,'ALGO_BASE','2022-2023',1,'valide'),(42009,'RESEAU','2022-2023',2,'valide'),
                            (42009,'CLOUD','2022-2023',2,'valide'),(42009,'ANGLAIS_2','2022-2023',2,'valide'),
                            (42009,'ALGO_AVANCE','2023-2024',3,'en_cours'),(42009,'MOBILE','2023-2024',3,'en_cours'),

                            (42010,'INTRO_JAVA','2022-2023',1,'valide'),(42010,'ALGO_BASE','2022-2023',1,'valide'),
                            (42010,'ANGLAIS_1','2022-2023',1,'valide'),(42010,'RESEAU','2022-2023',2,'valide'),
                            (42010,'BDD_SQL','2022-2023',2,'valide'),(42010,'SECU_INFO','2022-2023',2,'valide'),
                            (42010,'ALGO_AVANCE','2023-2024',3,'en_cours');

INSERT INTO Etudiant VALUES
                         (43001,'Nory','Nicolas','2002-06-18',4),(43002,'Ory','Odile','2001-10-01',4),
                         (43003,'Pory','Pierre','2002-02-13',4),(43004,'Qory','Quentin','2001-05-26',4),
                         (43005,'Rory','Renaud','2002-09-09',4),(43006,'Sory','Sophie','2001-01-22',4),
                         (43007,'Tory','Thomas','2002-04-05',4),(43008,'Uory','Ulysse','2001-08-18',4),
                         (43009,'Vory','Valerie','2002-12-01',4),(43010,'Wory','William','2001-03-14',4);

INSERT INTO Inscription VALUES
                            (43001,'INTRO_JAVA','2021-2022',1,'valide'),(43001,'ALGO_BASE','2021-2022',1,'valide'),
                            (43001,'SYST_EXP','2021-2022',1,'valide'),(43001,'ANGLAIS_1','2021-2022',1,'valide'),
                            (43001,'RESEAU','2021-2022',2,'valide'),(43001,'BDD_SQL','2021-2022',2,'valide'),
                            (43001,'SECU_INFO','2021-2022',2,'valide'),(43001,'ANGLAIS_2','2021-2022',2,'valide'),
                            (43001,'ALGO_AVANCE','2022-2023',3,'valide'),(43001,'MOBILE','2022-2023',3,'valide'),
                            (43001,'PROJET_INFO','2022-2023',4,'valide'),(43001,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (43002,'INTRO_JAVA','2021-2022',1,'valide'),(43002,'SYST_EXP','2021-2022',1,'valide'),
                            (43002,'RESEAU','2021-2022',2,'valide'),(43002,'BDD_SQL','2021-2022',2,'valide'),
                            (43002,'ANGLAIS_2','2021-2022',2,'valide'),(43002,'ALGO_AVANCE','2022-2023',3,'valide'),
                            (43002,'PROJET_INFO','2022-2023',4,'valide'),(43002,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (43003,'INTRO_JAVA','2021-2022',1,'valide'),(43003,'ALGO_BASE','2021-2022',1,'valide'),
                            (43003,'SYST_EXP','2021-2022',1,'valide'),(43003,'RESEAU','2021-2022',2,'valide'),
                            (43003,'SECU_INFO','2021-2022',2,'valide'),(43003,'CLOUD','2021-2022',2,'valide'),
                            (43003,'ALGO_AVANCE','2022-2023',3,'valide'),(43003,'MOBILE','2022-2023',3,'valide'),
                            (43003,'PROJET_INFO','2022-2023',4,'valide'),(43003,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (43004,'INTRO_JAVA','2021-2022',1,'valide'),(43004,'ALGO_BASE','2021-2022',1,'valide'),
                            (43004,'ANGLAIS_1','2021-2022',1,'valide'),(43004,'RESEAU','2021-2022',2,'valide'),
                            (43004,'BDD_SQL','2021-2022',2,'valide'),(43004,'ANGLAIS_2','2021-2022',2,'valide'),
                            (43004,'ALGO_AVANCE','2022-2023',3,'echoue'),(43004,'ALGO_AVANCE','2022-2023',4,'valide'),
                            (43004,'PROJET_INFO','2022-2023',4,'valide'),(43004,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (43005,'INTRO_JAVA','2021-2022',1,'valide'),(43005,'SYST_EXP','2021-2022',1,'valide'),
                            (43005,'ALGO_BASE','2021-2022',1,'valide'),(43005,'RESEAU','2021-2022',2,'valide'),
                            (43005,'SECU_INFO','2021-2022',2,'valide'),(43005,'BDD_SQL','2021-2022',2,'valide'),
                            (43005,'ALGO_AVANCE','2022-2023',3,'valide'),(43005,'PROJET_INFO','2022-2023',4,'valide'),
                            (43005,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (43006,'INTRO_JAVA','2021-2022',1,'valide'),(43006,'ALGO_BASE','2021-2022',1,'valide'),
                            (43006,'SYST_EXP','2021-2022',1,'valide'),(43006,'RESEAU','2021-2022',2,'valide'),
                            (43006,'BDD_SQL','2021-2022',2,'valide'),(43006,'CLOUD','2021-2022',2,'valide'),
                            (43006,'ALGO_AVANCE','2022-2023',3,'valide'),(43006,'MOBILE','2022-2023',3,'valide'),
                            (43006,'PROJET_INFO','2022-2023',4,'valide'),(43006,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (43007,'INTRO_JAVA','2021-2022',1,'valide'),(43007,'SYST_EXP','2021-2022',1,'valide'),
                            (43007,'ANGLAIS_1','2021-2022',1,'valide'),(43007,'RESEAU','2021-2022',2,'valide'),
                            (43007,'ANGLAIS_2','2021-2022',2,'valide'),(43007,'ALGO_AVANCE','2022-2023',3,'valide'),
                            (43007,'PROJET_INFO','2022-2023',4,'valide'),(43007,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (43008,'INTRO_JAVA','2021-2022',1,'valide'),(43008,'ALGO_BASE','2021-2022',1,'valide'),
                            (43008,'SYST_EXP','2021-2022',1,'valide'),(43008,'RESEAU','2021-2022',2,'valide'),
                            (43008,'SECU_INFO','2021-2022',2,'valide'),(43008,'BDD_SQL','2021-2022',2,'valide'),
                            (43008,'ALGO_AVANCE','2022-2023',3,'valide'),(43008,'PROJET_INFO','2022-2023',4,'valide'),
                            (43008,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (43009,'INTRO_JAVA','2021-2022',1,'valide'),(43009,'SYST_EXP','2021-2022',1,'valide'),
                            (43009,'ALGO_BASE','2021-2022',1,'valide'),(43009,'RESEAU','2021-2022',2,'valide'),
                            (43009,'CLOUD','2021-2022',2,'valide'),(43009,'ANGLAIS_2','2021-2022',2,'valide'),
                            (43009,'ALGO_AVANCE','2022-2023',3,'valide'),(43009,'MOBILE','2022-2023',3,'valide'),
                            (43009,'PROJET_INFO','2022-2023',4,'valide'),(43009,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (43010,'INTRO_JAVA','2021-2022',1,'valide'),(43010,'ALGO_BASE','2021-2022',1,'valide'),
                            (43010,'ANGLAIS_1','2021-2022',1,'valide'),(43010,'RESEAU','2021-2022',2,'valide'),
                            (43010,'BDD_SQL','2021-2022',2,'valide'),(43010,'SECU_INFO','2021-2022',2,'valide'),
                            (43010,'ALGO_AVANCE','2022-2023',3,'valide'),(43010,'PROJET_INFO','2022-2023',4,'valide'),
                            (43010,'ANGLAIS_3','2023-2024',5,'en_cours');

-- ==========================================
-- PARCOURS 5 : Gestion des Entreprises
-- S1 : COMPTA, MARKETING, MACRO_ECO, MICRO_ECO, ANGLAIS_1
-- S2 : MANAGEMENT, COMPTA_ANA, DROIT_SOC, MARKETING_2, ANGLAIS_2
-- S3 : FINANCE, AUDIT, FISCALITE, STATS_DESC
-- S4 : PROJET_PRO, RHETORIQUE, ANGLAIS_3
-- ==========================================

INSERT INTO Etudiant VALUES
                         (51001,'Abbe','Anne','2004-01-05',5),(51002,'Bere','Bruno','2004-04-18',5),
                         (51003,'Cere','Christine','2004-08-01',5),(51004,'Dere','Dominique','2004-02-14',5),
                         (51005,'Eere','Edouard','2004-06-27',5),(51006,'Fere','Francoise','2004-10-10',5),
                         (51007,'Gere','Gabriel','2004-03-23',5),(51008,'Here','Heloise','2004-09-05',5),
                         (51009,'Iere','Isabelle','2004-07-19',5),(51010,'Jere','Jonathan','2004-12-02',5);

INSERT INTO Inscription VALUES
                            (51001,'COMPTA','2023-2024',1,'en_cours'),(51001,'MARKETING','2023-2024',1,'en_cours'),
                            (51001,'MACRO_ECO','2023-2024',1,'en_cours'),(51001,'MICRO_ECO','2023-2024',1,'en_cours'),
                            (51001,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (51002,'COMPTA','2023-2024',1,'en_cours'),(51002,'MARKETING','2023-2024',1,'en_cours'),
                            (51002,'MACRO_ECO','2023-2024',1,'en_cours'),
                            (51003,'COMPTA','2023-2024',1,'en_cours'),(51003,'MICRO_ECO','2023-2024',1,'en_cours'),
                            (51003,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (51004,'COMPTA','2023-2024',1,'en_cours'),(51004,'MARKETING','2023-2024',1,'en_cours'),
                            (51004,'MACRO_ECO','2023-2024',1,'en_cours'),(51004,'MICRO_ECO','2023-2024',1,'en_cours'),
                            (51005,'COMPTA','2023-2024',1,'en_cours'),(51005,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (51006,'COMPTA','2023-2024',1,'en_cours'),(51006,'MARKETING','2023-2024',1,'en_cours'),
                            (51006,'MICRO_ECO','2023-2024',1,'en_cours'),
                            (51007,'COMPTA','2023-2024',1,'en_cours'),(51007,'MACRO_ECO','2023-2024',1,'en_cours'),
                            (51007,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (51008,'COMPTA','2023-2024',1,'en_cours'),(51008,'MARKETING','2023-2024',1,'en_cours'),
                            (51009,'COMPTA','2023-2024',1,'en_cours'),(51009,'MICRO_ECO','2023-2024',1,'en_cours'),
                            (51009,'MACRO_ECO','2023-2024',1,'en_cours'),
                            (51010,'COMPTA','2023-2024',1,'en_cours'),(51010,'ANGLAIS_1','2023-2024',1,'en_cours');

INSERT INTO Etudiant VALUES
                         (52001,'Kere','Karine','2003-03-15',5),(52002,'Lere','Laurent','2003-06-28',5),
                         (52003,'Mere','Marine','2002-10-11',5),(52004,'Nere','Nicolas','2003-01-24',5),
                         (52005,'Oere','Odile','2002-11-06',5),(52006,'Pere','Patricia','2003-04-20',5),
                         (52007,'Qere','Quentin','2003-08-03',5),(52008,'Rere','Renaud','2002-12-16',5),
                         (52009,'Sere','Sophie','2003-02-27',5),(52010,'Tere','Thomas','2002-07-10',5);

INSERT INTO Inscription VALUES
                            (52001,'COMPTA','2022-2023',1,'valide'),(52001,'MARKETING','2022-2023',1,'valide'),
                            (52001,'MACRO_ECO','2022-2023',1,'valide'),(52001,'MICRO_ECO','2022-2023',1,'valide'),
                            (52001,'ANGLAIS_1','2022-2023',1,'valide'),(52001,'MANAGEMENT','2022-2023',2,'valide'),
                            (52001,'COMPTA_ANA','2022-2023',2,'valide'),(52001,'MARKETING_2','2022-2023',2,'valide'),
                            (52001,'ANGLAIS_2','2022-2023',2,'valide'),(52001,'FINANCE','2023-2024',3,'en_cours'),
                            (52001,'AUDIT','2023-2024',3,'en_cours'),(52001,'STATS_DESC','2023-2024',3,'en_cours'),

                            (52002,'COMPTA','2022-2023',1,'valide'),(52002,'MACRO_ECO','2022-2023',1,'valide'),
                            (52002,'ANGLAIS_1','2022-2023',1,'valide'),(52002,'MANAGEMENT','2022-2023',2,'valide'),
                            (52002,'COMPTA_ANA','2022-2023',2,'valide'),(52002,'ANGLAIS_2','2022-2023',2,'valide'),
                            (52002,'FINANCE','2023-2024',3,'en_cours'),(52002,'AUDIT','2023-2024',3,'en_cours'),

                            (52003,'COMPTA','2022-2023',1,'valide'),(52003,'MARKETING','2022-2023',1,'valide'),
                            (52003,'MICRO_ECO','2022-2023',1,'valide'),(52003,'MANAGEMENT','2022-2023',2,'valide'),
                            (52003,'COMPTA_ANA','2022-2023',2,'valide'),(52003,'DROIT_SOC','2022-2023',2,'valide'),
                            (52003,'FINANCE','2023-2024',3,'en_cours'),(52003,'FISCALITE','2023-2024',3,'en_cours'),

                            (52004,'COMPTA','2022-2023',1,'valide'),(52004,'MACRO_ECO','2022-2023',1,'valide'),
                            (52004,'MICRO_ECO','2022-2023',1,'valide'),(52004,'MANAGEMENT','2022-2023',2,'valide'),
                            (52004,'COMPTA_ANA','2022-2023',2,'echoue'),(52004,'ANGLAIS_2','2022-2023',2,'valide'),
                            (52004,'COMPTA_ANA','2023-2024',3,'valide'),(52004,'FINANCE','2023-2024',3,'en_cours'),

                            (52005,'COMPTA','2022-2023',1,'valide'),(52005,'MARKETING','2022-2023',1,'valide'),
                            (52005,'ANGLAIS_1','2022-2023',1,'valide'),(52005,'MANAGEMENT','2022-2023',2,'valide'),
                            (52005,'COMPTA_ANA','2022-2023',2,'valide'),(52005,'MARKETING_2','2022-2023',2,'valide'),
                            (52005,'FINANCE','2023-2024',3,'en_cours'),(52005,'AUDIT','2023-2024',3,'en_cours'),
                            (52005,'STATS_DESC','2023-2024',3,'en_cours'),

                            (52006,'COMPTA','2022-2023',1,'valide'),(52006,'MACRO_ECO','2022-2023',1,'valide'),
                            (52006,'MICRO_ECO','2022-2023',1,'valide'),(52006,'MANAGEMENT','2022-2023',2,'valide'),
                            (52006,'COMPTA_ANA','2022-2023',2,'valide'),(52006,'ANGLAIS_2','2022-2023',2,'valide'),
                            (52006,'FINANCE','2023-2024',3,'en_cours'),

                            (52007,'COMPTA','2022-2023',1,'valide'),(52007,'MARKETING','2022-2023',1,'valide'),
                            (52007,'MACRO_ECO','2022-2023',1,'valide'),(52007,'MANAGEMENT','2022-2023',2,'valide'),
                            (52007,'COMPTA_ANA','2022-2023',2,'valide'),(52007,'DROIT_SOC','2022-2023',2,'valide'),
                            (52007,'FINANCE','2023-2024',3,'en_cours'),(52007,'AUDIT','2023-2024',3,'en_cours'),

                            (52008,'COMPTA','2022-2023',1,'valide'),(52008,'MICRO_ECO','2022-2023',1,'valide'),
                            (52008,'ANGLAIS_1','2022-2023',1,'valide'),(52008,'MANAGEMENT','2022-2023',2,'valide'),
                            (52008,'COMPTA_ANA','2022-2023',2,'valide'),(52008,'ANGLAIS_2','2022-2023',2,'valide'),
                            (52008,'FINANCE','2023-2024',3,'en_cours'),(52008,'FISCALITE','2023-2024',3,'en_cours'),

                            (52009,'COMPTA','2022-2023',1,'valide'),(52009,'MARKETING','2022-2023',1,'valide'),
                            (52009,'MACRO_ECO','2022-2023',1,'valide'),(52009,'MANAGEMENT','2022-2023',2,'valide'),
                            (52009,'COMPTA_ANA','2022-2023',2,'valide'),(52009,'MARKETING_2','2022-2023',2,'valide'),
                            (52009,'FINANCE','2023-2024',3,'en_cours'),(52009,'STATS_DESC','2023-2024',3,'en_cours'),

                            (52010,'COMPTA','2022-2023',1,'valide'),(52010,'MACRO_ECO','2022-2023',1,'valide'),
                            (52010,'MICRO_ECO','2022-2023',1,'valide'),(52010,'MANAGEMENT','2022-2023',2,'valide'),
                            (52010,'COMPTA_ANA','2022-2023',2,'valide'),(52010,'ANGLAIS_2','2022-2023',2,'valide'),
                            (52010,'FINANCE','2023-2024',3,'en_cours'),(52010,'AUDIT','2023-2024',3,'en_cours');

INSERT INTO Etudiant VALUES
                         (53001,'Uere','Ursula','2002-05-23',5),(53002,'Vere','Vincent','2001-09-05',5),
                         (53003,'Were','Wilfried','2002-01-18',5),(53004,'Xere','Xavier','2001-04-02',5),
                         (53005,'Yere','Yolande','2002-08-15',5),(53006,'Zere','Zacharie','2001-12-28',5),
                         (53007,'Afer','Amelie','2002-03-11',5),(53008,'Bfer','Baptiste','2001-07-24',5),
                         (53009,'Cfer','Caroline','2002-11-07',5),(53010,'Dfer','Damien','2001-06-20',5);

INSERT INTO Inscription VALUES
                            (53001,'COMPTA','2021-2022',1,'valide'),(53001,'MARKETING','2021-2022',1,'valide'),
                            (53001,'MACRO_ECO','2021-2022',1,'valide'),(53001,'MICRO_ECO','2021-2022',1,'valide'),
                            (53001,'ANGLAIS_1','2021-2022',1,'valide'),(53001,'MANAGEMENT','2021-2022',2,'valide'),
                            (53001,'COMPTA_ANA','2021-2022',2,'valide'),(53001,'MARKETING_2','2021-2022',2,'valide'),
                            (53001,'ANGLAIS_2','2021-2022',2,'valide'),(53001,'FINANCE','2022-2023',3,'valide'),
                            (53001,'AUDIT','2022-2023',3,'valide'),(53001,'STATS_DESC','2022-2023',3,'valide'),
                            (53001,'PROJET_PRO','2022-2023',4,'valide'),(53001,'RHETORIQUE','2023-2024',5,'en_cours'),
                            (53001,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (53002,'COMPTA','2021-2022',1,'valide'),(53002,'MACRO_ECO','2021-2022',1,'valide'),
                            (53002,'ANGLAIS_1','2021-2022',1,'valide'),(53002,'MANAGEMENT','2021-2022',2,'valide'),
                            (53002,'COMPTA_ANA','2021-2022',2,'valide'),(53002,'ANGLAIS_2','2021-2022',2,'valide'),
                            (53002,'FINANCE','2022-2023',3,'valide'),(53002,'AUDIT','2022-2023',3,'valide'),
                            (53002,'PROJET_PRO','2022-2023',4,'valide'),(53002,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (53003,'COMPTA','2021-2022',1,'valide'),(53003,'MARKETING','2021-2022',1,'valide'),
                            (53003,'MICRO_ECO','2021-2022',1,'valide'),(53003,'MANAGEMENT','2021-2022',2,'valide'),
                            (53003,'COMPTA_ANA','2021-2022',2,'valide'),(53003,'DROIT_SOC','2021-2022',2,'valide'),
                            (53003,'FINANCE','2022-2023',3,'valide'),(53003,'FISCALITE','2022-2023',3,'valide'),
                            (53003,'PROJET_PRO','2022-2023',4,'valide'),(53003,'RHETORIQUE','2023-2024',5,'en_cours'),

                            (53004,'COMPTA','2021-2022',1,'valide'),(53004,'MACRO_ECO','2021-2022',1,'valide'),
                            (53004,'MICRO_ECO','2021-2022',1,'valide'),(53004,'MANAGEMENT','2021-2022',2,'valide'),
                            (53004,'COMPTA_ANA','2021-2022',2,'valide'),(53004,'ANGLAIS_2','2021-2022',2,'valide'),
                            (53004,'FINANCE','2022-2023',3,'valide'),(53004,'AUDIT','2022-2023',3,'valide'),
                            (53004,'PROJET_PRO','2022-2023',4,'valide'),(53004,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (53005,'COMPTA','2021-2022',1,'valide'),(53005,'MARKETING','2021-2022',1,'valide'),
                            (53005,'ANGLAIS_1','2021-2022',1,'valide'),(53005,'MANAGEMENT','2021-2022',2,'valide'),
                            (53005,'COMPTA_ANA','2021-2022',2,'valide'),(53005,'MARKETING_2','2021-2022',2,'valide'),
                            (53005,'FINANCE','2022-2023',3,'valide'),(53005,'STATS_DESC','2022-2023',3,'valide'),
                            (53005,'PROJET_PRO','2022-2023',4,'valide'),(53005,'RHETORIQUE','2023-2024',5,'en_cours'),
                            (53005,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (53006,'COMPTA','2021-2022',1,'valide'),(53006,'MACRO_ECO','2021-2022',1,'valide'),
                            (53006,'MICRO_ECO','2021-2022',1,'valide'),(53006,'MANAGEMENT','2021-2022',2,'valide'),
                            (53006,'COMPTA_ANA','2021-2022',2,'valide'),(53006,'ANGLAIS_2','2021-2022',2,'valide'),
                            (53006,'FINANCE','2022-2023',3,'valide'),(53006,'AUDIT','2022-2023',3,'valide'),
                            (53006,'PROJET_PRO','2022-2023',4,'valide'),(53006,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (53007,'COMPTA','2021-2022',1,'valide'),(53007,'MARKETING','2021-2022',1,'valide'),
                            (53007,'MACRO_ECO','2021-2022',1,'valide'),(53007,'MANAGEMENT','2021-2022',2,'valide'),
                            (53007,'COMPTA_ANA','2021-2022',2,'valide'),(53007,'DROIT_SOC','2021-2022',2,'valide'),
                            (53007,'FINANCE','2022-2023',3,'valide'),(53007,'AUDIT','2022-2023',3,'echoue'),
                            (53007,'AUDIT','2022-2023',4,'valide'),(53007,'PROJET_PRO','2022-2023',4,'valide'),
                            (53007,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (53008,'COMPTA','2021-2022',1,'valide'),(53008,'MICRO_ECO','2021-2022',1,'valide'),
                            (53008,'ANGLAIS_1','2021-2022',1,'valide'),(53008,'MANAGEMENT','2021-2022',2,'valide'),
                            (53008,'COMPTA_ANA','2021-2022',2,'valide'),(53008,'ANGLAIS_2','2021-2022',2,'valide'),
                            (53008,'FINANCE','2022-2023',3,'valide'),(53008,'FISCALITE','2022-2023',3,'valide'),
                            (53008,'PROJET_PRO','2022-2023',4,'valide'),(53008,'RHETORIQUE','2023-2024',5,'en_cours'),

                            (53009,'COMPTA','2021-2022',1,'valide'),(53009,'MARKETING','2021-2022',1,'valide'),
                            (53009,'MACRO_ECO','2021-2022',1,'valide'),(53009,'MANAGEMENT','2021-2022',2,'valide'),
                            (53009,'COMPTA_ANA','2021-2022',2,'valide'),(53009,'MARKETING_2','2021-2022',2,'valide'),
                            (53009,'FINANCE','2022-2023',3,'valide'),(53009,'STATS_DESC','2022-2023',3,'valide'),
                            (53009,'PROJET_PRO','2022-2023',4,'valide'),(53009,'ANGLAIS_3','2023-2024',5,'en_cours'),

                            (53010,'COMPTA','2021-2022',1,'valide'),(53010,'MACRO_ECO','2021-2022',1,'valide'),
                            (53010,'MICRO_ECO','2021-2022',1,'valide'),(53010,'MANAGEMENT','2021-2022',2,'valide'),
                            (53010,'COMPTA_ANA','2021-2022',2,'valide'),(53010,'ANGLAIS_2','2021-2022',2,'valide'),
                            (53010,'FINANCE','2022-2023',3,'valide'),(53010,'AUDIT','2022-2023',3,'valide'),
                            (53010,'PROJET_PRO','2022-2023',4,'valide'),(53010,'RHETORIQUE','2023-2024',5,'en_cours');

-- ==========================================
-- PARCOURS 6-10 : Même pattern condensé
-- Pour Finance(6), Droit Privé(7), Droit Public(8), Psy Clinique(9), Psy Travail(10)
-- ==========================================

-- ---- PARCOURS 6 : Finance et Comptabilité ----
-- S1 : COMPTA, MICRO_ECO, MACRO_ECO, STATS_DESC, ANGLAIS_1
-- S2 : COMPTA_ANA, FINANCE, DROIT_SOC, FISCALITE, ANGLAIS_2
-- S3 : AUDIT, MANAGEMENT, MARKETING_2
-- S4 : PROJET_PRO, ANGLAIS_3

INSERT INTO Etudiant VALUES
                         (61001,'Efer','Edith','2004-02-08',6),(61002,'Ffer','Felix','2004-05-21',6),
                         (61003,'Gfer','Genevieve','2004-09-03',6),(61004,'Hfer','Hubert','2004-01-16',6),
                         (61005,'Ifer','Ingrid','2004-07-29',6),(61006,'Jfer','Joel','2004-11-11',6),
                         (61007,'Kfer','Karine','2004-04-24',6),(61008,'Lfer','Louis','2004-08-07',6),
                         (61009,'Mfer','Martine','2004-06-20',6),(61010,'Nfer','Noel','2004-12-03',6);

INSERT INTO Inscription VALUES
                            (61001,'COMPTA','2023-2024',1,'en_cours'),(61001,'MICRO_ECO','2023-2024',1,'en_cours'),
                            (61001,'MACRO_ECO','2023-2024',1,'en_cours'),(61001,'STATS_DESC','2023-2024',1,'en_cours'),
                            (61002,'COMPTA','2023-2024',1,'en_cours'),(61002,'MICRO_ECO','2023-2024',1,'en_cours'),
                            (61002,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (61003,'COMPTA','2023-2024',1,'en_cours'),(61003,'MACRO_ECO','2023-2024',1,'en_cours'),
                            (61003,'STATS_DESC','2023-2024',1,'en_cours'),(61003,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (61004,'COMPTA','2023-2024',1,'en_cours'),(61004,'MICRO_ECO','2023-2024',1,'en_cours'),
                            (61004,'MACRO_ECO','2023-2024',1,'en_cours'),
                            (61005,'COMPTA','2023-2024',1,'en_cours'),(61005,'STATS_DESC','2023-2024',1,'en_cours'),
                            (61006,'COMPTA','2023-2024',1,'en_cours'),(61006,'MICRO_ECO','2023-2024',1,'en_cours'),
                            (61006,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (61007,'COMPTA','2023-2024',1,'en_cours'),(61007,'MACRO_ECO','2023-2024',1,'en_cours'),
                            (61008,'COMPTA','2023-2024',1,'en_cours'),(61008,'STATS_DESC','2023-2024',1,'en_cours'),
                            (61008,'MICRO_ECO','2023-2024',1,'en_cours'),
                            (61009,'COMPTA','2023-2024',1,'en_cours'),(61009,'MACRO_ECO','2023-2024',1,'en_cours'),
                            (61009,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (61010,'COMPTA','2023-2024',1,'en_cours'),(61010,'MICRO_ECO','2023-2024',1,'en_cours');

INSERT INTO Etudiant VALUES
                         (62001,'Ofer','Olivier','2003-03-14',6),(62002,'Pfer','Pascale','2003-06-27',6),
                         (62003,'Qfer','Quentin','2002-10-10',6),(62004,'Rfer','Renaud','2003-01-23',6),
                         (62005,'Sfer','Sandrine','2002-11-05',6),(62006,'Tfer','Thierry','2003-04-19',6),
                         (62007,'Ufer','Ursula','2003-08-02',6),(62008,'Vfer','Valerie','2002-12-15',6),
                         (62009,'Wfer','William','2003-02-28',6),(62010,'Xfer','Xavier','2002-07-11',6);

INSERT INTO Inscription VALUES
                            (62001,'COMPTA','2022-2023',1,'valide'),(62001,'MICRO_ECO','2022-2023',1,'valide'),
                            (62001,'MACRO_ECO','2022-2023',1,'valide'),(62001,'STATS_DESC','2022-2023',1,'valide'),
                            (62001,'ANGLAIS_1','2022-2023',1,'valide'),(62001,'COMPTA_ANA','2022-2023',2,'valide'),
                            (62001,'FINANCE','2022-2023',2,'valide'),(62001,'DROIT_SOC','2022-2023',2,'valide'),
                            (62001,'ANGLAIS_2','2022-2023',2,'valide'),(62001,'AUDIT','2023-2024',3,'en_cours'),
                            (62001,'MANAGEMENT','2023-2024',3,'en_cours'),
                            (62002,'COMPTA','2022-2023',1,'valide'),(62002,'MICRO_ECO','2022-2023',1,'valide'),
                            (62002,'ANGLAIS_1','2022-2023',1,'valide'),(62002,'COMPTA_ANA','2022-2023',2,'valide'),
                            (62002,'FINANCE','2022-2023',2,'valide'),(62002,'ANGLAIS_2','2022-2023',2,'valide'),
                            (62002,'AUDIT','2023-2024',3,'en_cours'),
                            (62003,'COMPTA','2022-2023',1,'valide'),(62003,'MACRO_ECO','2022-2023',1,'valide'),
                            (62003,'STATS_DESC','2022-2023',1,'valide'),(62003,'COMPTA_ANA','2022-2023',2,'valide'),
                            (62003,'FINANCE','2022-2023',2,'valide'),(62003,'FISCALITE','2022-2023',2,'valide'),
                            (62003,'AUDIT','2023-2024',3,'en_cours'),(62003,'MANAGEMENT','2023-2024',3,'en_cours'),
                            (62004,'COMPTA','2022-2023',1,'valide'),(62004,'MICRO_ECO','2022-2023',1,'valide'),
                            (62004,'MACRO_ECO','2022-2023',1,'valide'),(62004,'COMPTA_ANA','2022-2023',2,'valide'),
                            (62004,'FINANCE','2022-2023',2,'echoue'),(62004,'ANGLAIS_2','2022-2023',2,'valide'),
                            (62004,'FINANCE','2023-2024',3,'valide'),(62004,'AUDIT','2023-2024',3,'en_cours'),
                            (62005,'COMPTA','2022-2023',1,'valide'),(62005,'STATS_DESC','2022-2023',1,'valide'),
                            (62005,'ANGLAIS_1','2022-2023',1,'valide'),(62005,'COMPTA_ANA','2022-2023',2,'valide'),
                            (62005,'FINANCE','2022-2023',2,'valide'),(62005,'DROIT_SOC','2022-2023',2,'valide'),
                            (62005,'AUDIT','2023-2024',3,'en_cours'),(62005,'MARKETING_2','2023-2024',3,'en_cours'),
                            (62006,'COMPTA','2022-2023',1,'valide'),(62006,'MACRO_ECO','2022-2023',1,'valide'),
                            (62006,'MICRO_ECO','2022-2023',1,'valide'),(62006,'COMPTA_ANA','2022-2023',2,'valide'),
                            (62006,'FINANCE','2022-2023',2,'valide'),(62006,'ANGLAIS_2','2022-2023',2,'valide'),
                            (62006,'AUDIT','2023-2024',3,'en_cours'),
                            (62007,'COMPTA','2022-2023',1,'valide'),(62007,'MICRO_ECO','2022-2023',1,'valide'),
                            (62007,'ANGLAIS_1','2022-2023',1,'valide'),(62007,'COMPTA_ANA','2022-2023',2,'valide'),
                            (62007,'FINANCE','2022-2023',2,'valide'),(62007,'FISCALITE','2022-2023',2,'valide'),
                            (62007,'AUDIT','2023-2024',3,'en_cours'),(62007,'MANAGEMENT','2023-2024',3,'en_cours'),
                            (62008,'COMPTA','2022-2023',1,'valide'),(62008,'STATS_DESC','2022-2023',1,'valide'),
                            (62008,'MACRO_ECO','2022-2023',1,'valide'),(62008,'COMPTA_ANA','2022-2023',2,'valide'),
                            (62008,'FINANCE','2022-2023',2,'valide'),(62008,'DROIT_SOC','2022-2023',2,'valide'),
                            (62008,'AUDIT','2023-2024',3,'en_cours'),
                            (62009,'COMPTA','2022-2023',1,'valide'),(62009,'MICRO_ECO','2022-2023',1,'valide'),
                            (62009,'MACRO_ECO','2022-2023',1,'valide'),(62009,'COMPTA_ANA','2022-2023',2,'valide'),
                            (62009,'FINANCE','2022-2023',2,'valide'),(62009,'ANGLAIS_2','2022-2023',2,'valide'),
                            (62009,'AUDIT','2023-2024',3,'en_cours'),(62009,'MANAGEMENT','2023-2024',3,'en_cours'),
                            (62010,'COMPTA','2022-2023',1,'valide'),(62010,'STATS_DESC','2022-2023',1,'valide'),
                            (62010,'ANGLAIS_1','2022-2023',1,'valide'),(62010,'COMPTA_ANA','2022-2023',2,'valide'),
                            (62010,'FINANCE','2022-2023',2,'valide'),(62010,'FISCALITE','2022-2023',2,'valide'),
                            (62010,'AUDIT','2023-2024',3,'en_cours');

INSERT INTO Etudiant VALUES
                         (63001,'Yfer','Yann','2002-05-17',6),(63002,'Zfer','Zoe','2001-08-30',6),
                         (63003,'Ager','Agnes','2002-01-12',6),(63004,'Bger','Bernard','2001-04-25',6),
                         (63005,'Cger','Cecile','2002-09-08',6),(63006,'Dger','Denis','2001-12-21',6),
                         (63007,'Eger','Emilie','2002-03-04',6),(63008,'Fger','Francois','2001-07-17',6),
                         (63009,'Gger','Genevieve','2002-11-01',6),(63010,'Hger','Henri','2001-02-13',6);

INSERT INTO Inscription VALUES
                            (63001,'COMPTA','2021-2022',1,'valide'),(63001,'MICRO_ECO','2021-2022',1,'valide'),
                            (63001,'MACRO_ECO','2021-2022',1,'valide'),(63001,'STATS_DESC','2021-2022',1,'valide'),
                            (63001,'ANGLAIS_1','2021-2022',1,'valide'),(63001,'COMPTA_ANA','2021-2022',2,'valide'),
                            (63001,'FINANCE','2021-2022',2,'valide'),(63001,'DROIT_SOC','2021-2022',2,'valide'),
                            (63001,'ANGLAIS_2','2021-2022',2,'valide'),(63001,'AUDIT','2022-2023',3,'valide'),
                            (63001,'MANAGEMENT','2022-2023',3,'valide'),(63001,'PROJET_PRO','2022-2023',4,'valide'),
                            (63001,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (63002,'COMPTA','2021-2022',1,'valide'),(63002,'MICRO_ECO','2021-2022',1,'valide'),
                            (63002,'ANGLAIS_1','2021-2022',1,'valide'),(63002,'COMPTA_ANA','2021-2022',2,'valide'),
                            (63002,'FINANCE','2021-2022',2,'valide'),(63002,'ANGLAIS_2','2021-2022',2,'valide'),
                            (63002,'AUDIT','2022-2023',3,'valide'),(63002,'PROJET_PRO','2022-2023',4,'valide'),
                            (63002,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (63003,'COMPTA','2021-2022',1,'valide'),(63003,'MACRO_ECO','2021-2022',1,'valide'),
                            (63003,'STATS_DESC','2021-2022',1,'valide'),(63003,'COMPTA_ANA','2021-2022',2,'valide'),
                            (63003,'FINANCE','2021-2022',2,'valide'),(63003,'FISCALITE','2021-2022',2,'valide'),
                            (63003,'AUDIT','2022-2023',3,'valide'),(63003,'MANAGEMENT','2022-2023',3,'valide'),
                            (63003,'PROJET_PRO','2022-2023',4,'valide'),(63003,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (63004,'COMPTA','2021-2022',1,'valide'),(63004,'MICRO_ECO','2021-2022',1,'valide'),
                            (63004,'MACRO_ECO','2021-2022',1,'valide'),(63004,'COMPTA_ANA','2021-2022',2,'valide'),
                            (63004,'FINANCE','2021-2022',2,'valide'),(63004,'ANGLAIS_2','2021-2022',2,'valide'),
                            (63004,'AUDIT','2022-2023',3,'valide'),(63004,'PROJET_PRO','2022-2023',4,'valide'),
                            (63004,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (63005,'COMPTA','2021-2022',1,'valide'),(63005,'STATS_DESC','2021-2022',1,'valide'),
                            (63005,'ANGLAIS_1','2021-2022',1,'valide'),(63005,'COMPTA_ANA','2021-2022',2,'valide'),
                            (63005,'FINANCE','2021-2022',2,'valide'),(63005,'DROIT_SOC','2021-2022',2,'valide'),
                            (63005,'AUDIT','2022-2023',3,'valide'),(63005,'MARKETING_2','2022-2023',3,'valide'),
                            (63005,'PROJET_PRO','2022-2023',4,'valide'),(63005,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (63006,'COMPTA','2021-2022',1,'valide'),(63006,'MACRO_ECO','2021-2022',1,'valide'),
                            (63006,'MICRO_ECO','2021-2022',1,'valide'),(63006,'COMPTA_ANA','2021-2022',2,'valide'),
                            (63006,'FINANCE','2021-2022',2,'valide'),(63006,'ANGLAIS_2','2021-2022',2,'valide'),
                            (63006,'AUDIT','2022-2023',3,'valide'),(63006,'PROJET_PRO','2022-2023',4,'valide'),
                            (63006,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (63007,'COMPTA','2021-2022',1,'valide'),(63007,'MICRO_ECO','2021-2022',1,'valide'),
                            (63007,'ANGLAIS_1','2021-2022',1,'valide'),(63007,'COMPTA_ANA','2021-2022',2,'valide'),
                            (63007,'FINANCE','2021-2022',2,'echoue'),(63007,'FISCALITE','2021-2022',2,'valide'),
                            (63007,'FINANCE','2022-2023',3,'valide'),(63007,'AUDIT','2022-2023',3,'valide'),
                            (63007,'PROJET_PRO','2022-2023',4,'valide'),(63007,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (63008,'COMPTA','2021-2022',1,'valide'),(63008,'STATS_DESC','2021-2022',1,'valide'),
                            (63008,'MACRO_ECO','2021-2022',1,'valide'),(63008,'COMPTA_ANA','2021-2022',2,'valide'),
                            (63008,'FINANCE','2021-2022',2,'valide'),(63008,'DROIT_SOC','2021-2022',2,'valide'),
                            (63008,'AUDIT','2022-2023',3,'valide'),(63008,'PROJET_PRO','2022-2023',4,'valide'),
                            (63008,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (63009,'COMPTA','2021-2022',1,'valide'),(63009,'MICRO_ECO','2021-2022',1,'valide'),
                            (63009,'MACRO_ECO','2021-2022',1,'valide'),(63009,'COMPTA_ANA','2021-2022',2,'valide'),
                            (63009,'FINANCE','2021-2022',2,'valide'),(63009,'ANGLAIS_2','2021-2022',2,'valide'),
                            (63009,'AUDIT','2022-2023',3,'valide'),(63009,'MANAGEMENT','2022-2023',3,'valide'),
                            (63009,'PROJET_PRO','2022-2023',4,'valide'),(63009,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (63010,'COMPTA','2021-2022',1,'valide'),(63010,'STATS_DESC','2021-2022',1,'valide'),
                            (63010,'ANGLAIS_1','2021-2022',1,'valide'),(63010,'COMPTA_ANA','2021-2022',2,'valide'),
                            (63010,'FINANCE','2021-2022',2,'valide'),(63010,'FISCALITE','2021-2022',2,'valide'),
                            (63010,'AUDIT','2022-2023',3,'valide'),(63010,'PROJET_PRO','2022-2023',4,'valide'),
                            (63010,'ANGLAIS_3','2023-2024',5,'en_cours');

-- ---- PARCOURS 7 : Droit Privé ----
-- S1: DROIT_CONST, HIST_DROIT, DROIT_CIV1, ANGLAIS_1, RHETORIQUE
-- S2: DROIT_CIV2, DROIT_PEN, PROCED_CIV, DROIT_SOC, ANGLAIS_2
-- S3: DROIT_TRAV, DROIT_EUR, PROCED_PEN
-- S4: PROJET_PRO, ANGLAIS_3

INSERT INTO Etudiant VALUES
                         (71001,'Iger','Igore','2004-01-04',7),(71002,'Jger','Joelle','2004-04-17',7),
                         (71003,'Kger','Kevin','2004-08-30',7),(71004,'Lger','Leonie','2004-02-12',7),
                         (71005,'Mger','Marc','2004-06-25',7),(71006,'Nger','Nathalie','2004-10-08',7),
                         (71007,'Oger','Octave','2004-03-21',7),(71008,'Pger','Patricia','2004-09-04',7),
                         (71009,'Qger','Quentin','2004-07-18',7),(71010,'Rger','Renee','2004-11-30',7);

INSERT INTO Inscription VALUES
                            (71001,'DROIT_CONST','2023-2024',1,'en_cours'),(71001,'HIST_DROIT','2023-2024',1,'en_cours'),
                            (71001,'DROIT_CIV1','2023-2024',1,'en_cours'),(71001,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (71002,'DROIT_CONST','2023-2024',1,'en_cours'),(71002,'DROIT_CIV1','2023-2024',1,'en_cours'),
                            (71002,'RHETORIQUE','2023-2024',1,'en_cours'),
                            (71003,'DROIT_CONST','2023-2024',1,'en_cours'),(71003,'HIST_DROIT','2023-2024',1,'en_cours'),
                            (71003,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (71004,'DROIT_CONST','2023-2024',1,'en_cours'),(71004,'DROIT_CIV1','2023-2024',1,'en_cours'),
                            (71004,'HIST_DROIT','2023-2024',1,'en_cours'),(71004,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (71005,'DROIT_CONST','2023-2024',1,'en_cours'),(71005,'RHETORIQUE','2023-2024',1,'en_cours'),
                            (71006,'DROIT_CONST','2023-2024',1,'en_cours'),(71006,'HIST_DROIT','2023-2024',1,'en_cours'),
                            (71007,'DROIT_CONST','2023-2024',1,'en_cours'),(71007,'DROIT_CIV1','2023-2024',1,'en_cours'),
                            (71007,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (71008,'DROIT_CONST','2023-2024',1,'en_cours'),(71008,'HIST_DROIT','2023-2024',1,'en_cours'),
                            (71008,'RHETORIQUE','2023-2024',1,'en_cours'),
                            (71009,'DROIT_CONST','2023-2024',1,'en_cours'),(71009,'DROIT_CIV1','2023-2024',1,'en_cours'),
                            (71010,'DROIT_CONST','2023-2024',1,'en_cours'),(71010,'ANGLAIS_1','2023-2024',1,'en_cours');

INSERT INTO Etudiant VALUES
                         (72001,'Sger','Serge','2003-02-13',7),(72002,'Tger','Therese','2003-05-26',7),
                         (72003,'Uger','Ugo','2002-09-08',7),(72004,'Vger','Valerie','2003-01-21',7),
                         (72005,'Wger','William','2002-10-04',7),(72006,'Xger','Xavier','2003-04-17',7),
                         (72007,'Yger','Yves','2003-08-30',7),(72008,'Zger','Zoe','2002-12-13',7),
                         (72009,'Aher','Andre','2003-03-27',7),(72010,'Bher','Beatrice','2002-08-09',7);

INSERT INTO Inscription VALUES
                            (72001,'DROIT_CONST','2022-2023',1,'valide'),(72001,'HIST_DROIT','2022-2023',1,'valide'),
                            (72001,'DROIT_CIV1','2022-2023',1,'valide'),(72001,'ANGLAIS_1','2022-2023',1,'valide'),
                            (72001,'DROIT_CIV2','2022-2023',2,'valide'),(72001,'DROIT_PEN','2022-2023',2,'valide'),
                            (72001,'PROCED_CIV','2022-2023',2,'valide'),(72001,'ANGLAIS_2','2022-2023',2,'valide'),
                            (72001,'DROIT_TRAV','2023-2024',3,'en_cours'),(72001,'PROCED_PEN','2023-2024',3,'en_cours'),
                            (72002,'DROIT_CONST','2022-2023',1,'valide'),(72002,'DROIT_CIV1','2022-2023',1,'valide'),
                            (72002,'ANGLAIS_1','2022-2023',1,'valide'),(72002,'DROIT_CIV2','2022-2023',2,'valide'),
                            (72002,'DROIT_PEN','2022-2023',2,'valide'),(72002,'ANGLAIS_2','2022-2023',2,'valide'),
                            (72002,'DROIT_TRAV','2023-2024',3,'en_cours'),
                            (72003,'DROIT_CONST','2022-2023',1,'valide'),(72003,'HIST_DROIT','2022-2023',1,'valide'),
                            (72003,'DROIT_CIV1','2022-2023',1,'valide'),(72003,'DROIT_CIV2','2022-2023',2,'valide'),
                            (72003,'DROIT_PEN','2022-2023',2,'valide'),(72003,'DROIT_SOC','2022-2023',2,'valide'),
                            (72003,'DROIT_TRAV','2023-2024',3,'en_cours'),(72003,'DROIT_EUR','2023-2024',3,'en_cours'),
                            (72004,'DROIT_CONST','2022-2023',1,'valide'),(72004,'DROIT_CIV1','2022-2023',1,'valide'),
                            (72004,'RHETORIQUE','2022-2023',1,'valide'),(72004,'DROIT_CIV2','2022-2023',2,'valide'),
                            (72004,'DROIT_PEN','2022-2023',2,'echoue'),(72004,'ANGLAIS_2','2022-2023',2,'valide'),
                            (72004,'DROIT_PEN','2023-2024',3,'valide'),(72004,'DROIT_TRAV','2023-2024',3,'en_cours'),
                            (72005,'DROIT_CONST','2022-2023',1,'valide'),(72005,'HIST_DROIT','2022-2023',1,'valide'),
                            (72005,'ANGLAIS_1','2022-2023',1,'valide'),(72005,'DROIT_CIV2','2022-2023',2,'valide'),
                            (72005,'PROCED_CIV','2022-2023',2,'valide'),(72005,'ANGLAIS_2','2022-2023',2,'valide'),
                            (72005,'DROIT_TRAV','2023-2024',3,'en_cours'),
                            (72006,'DROIT_CONST','2022-2023',1,'valide'),(72006,'DROIT_CIV1','2022-2023',1,'valide'),
                            (72006,'ANGLAIS_1','2022-2023',1,'valide'),(72006,'DROIT_CIV2','2022-2023',2,'valide'),
                            (72006,'DROIT_PEN','2022-2023',2,'valide'),(72006,'ANGLAIS_2','2022-2023',2,'valide'),
                            (72006,'DROIT_TRAV','2023-2024',3,'en_cours'),(72006,'PROCED_PEN','2023-2024',3,'en_cours'),
                            (72007,'DROIT_CONST','2022-2023',1,'valide'),(72007,'HIST_DROIT','2022-2023',1,'valide'),
                            (72007,'DROIT_CIV1','2022-2023',1,'valide'),(72007,'DROIT_CIV2','2022-2023',2,'valide'),
                            (72007,'DROIT_SOC','2022-2023',2,'valide'),(72007,'ANGLAIS_2','2022-2023',2,'valide'),
                            (72007,'DROIT_TRAV','2023-2024',3,'en_cours'),(72007,'DROIT_EUR','2023-2024',3,'en_cours'),
                            (72008,'DROIT_CONST','2022-2023',1,'valide'),(72008,'DROIT_CIV1','2022-2023',1,'valide'),
                            (72008,'RHETORIQUE','2022-2023',1,'valide'),(72008,'DROIT_CIV2','2022-2023',2,'valide'),
                            (72008,'DROIT_PEN','2022-2023',2,'valide'),(72008,'PROCED_CIV','2022-2023',2,'valide'),
                            (72008,'DROIT_TRAV','2023-2024',3,'en_cours'),
                            (72009,'DROIT_CONST','2022-2023',1,'valide'),(72009,'HIST_DROIT','2022-2023',1,'valide'),
                            (72009,'ANGLAIS_1','2022-2023',1,'valide'),(72009,'DROIT_CIV2','2022-2023',2,'valide'),
                            (72009,'DROIT_PEN','2022-2023',2,'valide'),(72009,'ANGLAIS_2','2022-2023',2,'valide'),
                            (72009,'DROIT_TRAV','2023-2024',3,'en_cours'),(72009,'PROCED_PEN','2023-2024',3,'en_cours'),
                            (72010,'DROIT_CONST','2022-2023',1,'valide'),(72010,'DROIT_CIV1','2022-2023',1,'valide'),
                            (72010,'ANGLAIS_1','2022-2023',1,'valide'),(72010,'DROIT_PEN','2022-2023',2,'valide'),
                            (72010,'PROCED_CIV','2022-2023',2,'valide'),(72010,'ANGLAIS_2','2022-2023',2,'valide'),
                            (72010,'DROIT_TRAV','2023-2024',3,'en_cours');

INSERT INTO Etudiant VALUES
                         (73001,'Cher','Charles','2002-04-16',7),(73002,'Dher','Diane','2001-07-29',7),
                         (73003,'Eher','Emile','2002-01-11',7),(73004,'Fher','Fabienne','2001-05-24',7),
                         (73005,'Gher','Gaston','2002-09-07',7),(73006,'Hher','Helene','2001-12-20',7),
                         (73007,'Iher','Irene','2002-02-02',7),(73008,'Jher','Jacques','2001-06-15',7),
                         (73009,'Kher','Karine','2002-10-28',7),(73010,'Lher','Laurent','2001-03-13',7);

INSERT INTO Inscription VALUES
                            (73001,'DROIT_CONST','2021-2022',1,'valide'),(73001,'HIST_DROIT','2021-2022',1,'valide'),
                            (73001,'DROIT_CIV1','2021-2022',1,'valide'),(73001,'ANGLAIS_1','2021-2022',1,'valide'),
                            (73001,'DROIT_CIV2','2021-2022',2,'valide'),(73001,'DROIT_PEN','2021-2022',2,'valide'),
                            (73001,'PROCED_CIV','2021-2022',2,'valide'),(73001,'ANGLAIS_2','2021-2022',2,'valide'),
                            (73001,'DROIT_TRAV','2022-2023',3,'valide'),(73001,'PROCED_PEN','2022-2023',3,'valide'),
                            (73001,'DROIT_EUR','2022-2023',3,'valide'),(73001,'PROJET_PRO','2022-2023',4,'valide'),
                            (73001,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (73002,'DROIT_CONST','2021-2022',1,'valide'),(73002,'DROIT_CIV1','2021-2022',1,'valide'),
                            (73002,'ANGLAIS_1','2021-2022',1,'valide'),(73002,'DROIT_CIV2','2021-2022',2,'valide'),
                            (73002,'DROIT_PEN','2021-2022',2,'valide'),(73002,'ANGLAIS_2','2021-2022',2,'valide'),
                            (73002,'DROIT_TRAV','2022-2023',3,'valide'),(73002,'PROJET_PRO','2022-2023',4,'valide'),
                            (73002,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (73003,'DROIT_CONST','2021-2022',1,'valide'),(73003,'HIST_DROIT','2021-2022',1,'valide'),
                            (73003,'DROIT_CIV1','2021-2022',1,'valide'),(73003,'DROIT_CIV2','2021-2022',2,'valide'),
                            (73003,'DROIT_SOC','2021-2022',2,'valide'),(73003,'ANGLAIS_2','2021-2022',2,'valide'),
                            (73003,'DROIT_TRAV','2022-2023',3,'valide'),(73003,'DROIT_EUR','2022-2023',3,'valide'),
                            (73003,'PROJET_PRO','2022-2023',4,'valide'),(73003,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (73004,'DROIT_CONST','2021-2022',1,'valide'),(73004,'DROIT_CIV1','2021-2022',1,'valide'),
                            (73004,'RHETORIQUE','2021-2022',1,'valide'),(73004,'DROIT_CIV2','2021-2022',2,'valide'),
                            (73004,'DROIT_PEN','2021-2022',2,'valide'),(73004,'PROCED_CIV','2021-2022',2,'valide'),
                            (73004,'DROIT_TRAV','2022-2023',3,'valide'),(73004,'PROCED_PEN','2022-2023',3,'valide'),
                            (73004,'PROJET_PRO','2022-2023',4,'valide'),(73004,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (73005,'DROIT_CONST','2021-2022',1,'valide'),(73005,'HIST_DROIT','2021-2022',1,'valide'),
                            (73005,'ANGLAIS_1','2021-2022',1,'valide'),(73005,'DROIT_CIV2','2021-2022',2,'valide'),
                            (73005,'DROIT_PEN','2021-2022',2,'valide'),(73005,'ANGLAIS_2','2021-2022',2,'valide'),
                            (73005,'DROIT_TRAV','2022-2023',3,'valide'),(73005,'PROJET_PRO','2022-2023',4,'valide'),
                            (73005,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (73006,'DROIT_CONST','2021-2022',1,'valide'),(73006,'DROIT_CIV1','2021-2022',1,'valide'),
                            (73006,'ANGLAIS_1','2021-2022',1,'valide'),(73006,'DROIT_CIV2','2021-2022',2,'valide'),
                            (73006,'DROIT_PEN','2021-2022',2,'echoue'),(73006,'ANGLAIS_2','2021-2022',2,'valide'),
                            (73006,'DROIT_PEN','2022-2023',3,'valide'),(73006,'DROIT_TRAV','2022-2023',3,'valide'),
                            (73006,'PROJET_PRO','2022-2023',4,'valide'),(73006,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (73007,'DROIT_CONST','2021-2022',1,'valide'),(73007,'HIST_DROIT','2021-2022',1,'valide'),
                            (73007,'DROIT_CIV1','2021-2022',1,'valide'),(73007,'DROIT_CIV2','2021-2022',2,'valide'),
                            (73007,'DROIT_SOC','2021-2022',2,'valide'),(73007,'PROCED_CIV','2021-2022',2,'valide'),
                            (73007,'DROIT_TRAV','2022-2023',3,'valide'),(73007,'DROIT_EUR','2022-2023',3,'valide'),
                            (73007,'PROCED_PEN','2022-2023',3,'valide'),(73007,'PROJET_PRO','2022-2023',4,'valide'),
                            (73007,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (73008,'DROIT_CONST','2021-2022',1,'valide'),(73008,'DROIT_CIV1','2021-2022',1,'valide'),
                            (73008,'ANGLAIS_1','2021-2022',1,'valide'),(73008,'DROIT_CIV2','2021-2022',2,'valide'),
                            (73008,'DROIT_PEN','2021-2022',2,'valide'),(73008,'ANGLAIS_2','2021-2022',2,'valide'),
                            (73008,'DROIT_TRAV','2022-2023',3,'valide'),(73008,'PROCED_PEN','2022-2023',3,'valide'),
                            (73008,'PROJET_PRO','2022-2023',4,'valide'),(73008,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (73009,'DROIT_CONST','2021-2022',1,'valide'),(73009,'HIST_DROIT','2021-2022',1,'valide'),
                            (73009,'RHETORIQUE','2021-2022',1,'valide'),(73009,'DROIT_CIV2','2021-2022',2,'valide'),
                            (73009,'DROIT_PEN','2021-2022',2,'valide'),(73009,'PROCED_CIV','2021-2022',2,'valide'),
                            (73009,'DROIT_TRAV','2022-2023',3,'valide'),(73009,'DROIT_EUR','2022-2023',3,'valide'),
                            (73009,'PROJET_PRO','2022-2023',4,'valide'),(73009,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (73010,'DROIT_CONST','2021-2022',1,'valide'),(73010,'DROIT_CIV1','2021-2022',1,'valide'),
                            (73010,'ANGLAIS_1','2021-2022',1,'valide'),(73010,'DROIT_PEN','2021-2022',2,'valide'),
                            (73010,'PROCED_CIV','2021-2022',2,'valide'),(73010,'ANGLAIS_2','2021-2022',2,'valide'),
                            (73010,'DROIT_TRAV','2022-2023',3,'valide'),(73010,'PROCED_PEN','2022-2023',3,'valide'),
                            (73010,'PROJET_PRO','2022-2023',4,'valide'),(73010,'ANGLAIS_3','2023-2024',5,'en_cours');

-- ---- PARCOURS 8 : Droit Public ----
-- S1: DROIT_CONST, HIST_DROIT, DROIT_ADM, ANGLAIS_1, RHETORIQUE
-- S2: DROIT_EUR, DROIT_CIV1, PROCED_CIV, ANGLAIS_2, DROIT_PEN
-- S3: DROIT_TRAV, PROCED_PEN
-- S4: PROJET_PRO, ANGLAIS_3

INSERT INTO Etudiant VALUES
                         (81001,'Mher','Marcel','2004-01-01',8),(81002,'Nher','Nicole','2004-04-14',8),
                         (81003,'Oher','Odile','2004-07-27',8),(81004,'Pher','Philippe','2004-02-09',8),
                         (81005,'Qher','Quentin','2004-06-22',8),(81006,'Rher','Renee','2004-10-05',8),
                         (81007,'Sher','Sophie','2004-03-18',8),(81008,'Ther','Thomas','2004-09-01',8),
                         (81009,'Uher','Ulysse','2004-07-15',8),(81010,'Vher','Valerie','2004-11-28',8);

INSERT INTO Inscription VALUES
                            (81001,'DROIT_CONST','2023-2024',1,'en_cours'),(81001,'HIST_DROIT','2023-2024',1,'en_cours'),
                            (81001,'DROIT_ADM','2023-2024',1,'en_cours'),(81001,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (81002,'DROIT_CONST','2023-2024',1,'en_cours'),(81002,'DROIT_ADM','2023-2024',1,'en_cours'),
                            (81002,'RHETORIQUE','2023-2024',1,'en_cours'),
                            (81003,'DROIT_CONST','2023-2024',1,'en_cours'),(81003,'HIST_DROIT','2023-2024',1,'en_cours'),
                            (81003,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (81004,'DROIT_CONST','2023-2024',1,'en_cours'),(81004,'DROIT_ADM','2023-2024',1,'en_cours'),
                            (81004,'HIST_DROIT','2023-2024',1,'en_cours'),
                            (81005,'DROIT_CONST','2023-2024',1,'en_cours'),(81005,'RHETORIQUE','2023-2024',1,'en_cours'),
                            (81006,'DROIT_CONST','2023-2024',1,'en_cours'),(81006,'HIST_DROIT','2023-2024',1,'en_cours'),
                            (81006,'DROIT_ADM','2023-2024',1,'en_cours'),
                            (81007,'DROIT_CONST','2023-2024',1,'en_cours'),(81007,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (81008,'DROIT_CONST','2023-2024',1,'en_cours'),(81008,'DROIT_ADM','2023-2024',1,'en_cours'),
                            (81008,'HIST_DROIT','2023-2024',1,'en_cours'),
                            (81009,'DROIT_CONST','2023-2024',1,'en_cours'),(81009,'RHETORIQUE','2023-2024',1,'en_cours'),
                            (81010,'DROIT_CONST','2023-2024',1,'en_cours'),(81010,'ANGLAIS_1','2023-2024',1,'en_cours');

INSERT INTO Etudiant VALUES
                         (82001,'Wher','Wilfrid','2003-02-10',8),(82002,'Xher','Xenia','2003-05-23',8),
                         (82003,'Yher','Yann','2002-09-06',8),(82004,'Zher','Zoe','2003-01-19',8),
                         (82005,'Aier','Andre','2002-10-01',8),(82006,'Bier','Brigitte','2003-04-15',8),
                         (82007,'Cier','Charles','2003-07-28',8),(82008,'Dier','Denise','2002-12-11',8),
                         (82009,'Eier','Edouard','2003-03-24',8),(82010,'Fier','Francoise','2002-08-06',8);

INSERT INTO Inscription VALUES
                            (82001,'DROIT_CONST','2022-2023',1,'valide'),(82001,'HIST_DROIT','2022-2023',1,'valide'),
                            (82001,'DROIT_ADM','2022-2023',1,'valide'),(82001,'ANGLAIS_1','2022-2023',1,'valide'),
                            (82001,'DROIT_EUR','2022-2023',2,'valide'),(82001,'DROIT_CIV1','2022-2023',2,'valide'),
                            (82001,'ANGLAIS_2','2022-2023',2,'valide'),(82001,'DROIT_TRAV','2023-2024',3,'en_cours'),
                            (82001,'PROCED_PEN','2023-2024',3,'en_cours'),
                            (82002,'DROIT_CONST','2022-2023',1,'valide'),(82002,'DROIT_ADM','2022-2023',1,'valide'),
                            (82002,'RHETORIQUE','2022-2023',1,'valide'),(82002,'DROIT_EUR','2022-2023',2,'valide'),
                            (82002,'ANGLAIS_2','2022-2023',2,'valide'),(82002,'DROIT_TRAV','2023-2024',3,'en_cours'),
                            (82003,'DROIT_CONST','2022-2023',1,'valide'),(82003,'HIST_DROIT','2022-2023',1,'valide'),
                            (82003,'ANGLAIS_1','2022-2023',1,'valide'),(82003,'DROIT_EUR','2022-2023',2,'valide'),
                            (82003,'DROIT_CIV1','2022-2023',2,'valide'),(82003,'PROCED_CIV','2022-2023',2,'valide'),
                            (82003,'DROIT_TRAV','2023-2024',3,'en_cours'),(82003,'PROCED_PEN','2023-2024',3,'en_cours'),
                            (82004,'DROIT_CONST','2022-2023',1,'valide'),(82004,'DROIT_ADM','2022-2023',1,'valide'),
                            (82004,'ANGLAIS_1','2022-2023',1,'valide'),(82004,'DROIT_EUR','2022-2023',2,'valide'),
                            (82004,'DROIT_PEN','2022-2023',2,'valide'),(82004,'ANGLAIS_2','2022-2023',2,'valide'),
                            (82004,'DROIT_TRAV','2023-2024',3,'en_cours'),
                            (82005,'DROIT_CONST','2022-2023',1,'valide'),(82005,'HIST_DROIT','2022-2023',1,'valide'),
                            (82005,'DROIT_ADM','2022-2023',1,'valide'),(82005,'DROIT_EUR','2022-2023',2,'valide'),
                            (82005,'DROIT_CIV1','2022-2023',2,'echoue'),(82005,'ANGLAIS_2','2022-2023',2,'valide'),
                            (82005,'DROIT_CIV1','2023-2024',3,'valide'),(82005,'DROIT_TRAV','2023-2024',3,'en_cours'),
                            (82006,'DROIT_CONST','2022-2023',1,'valide'),(82006,'DROIT_ADM','2022-2023',1,'valide'),
                            (82006,'ANGLAIS_1','2022-2023',1,'valide'),(82006,'DROIT_EUR','2022-2023',2,'valide'),
                            (82006,'PROCED_CIV','2022-2023',2,'valide'),(82006,'ANGLAIS_2','2022-2023',2,'valide'),
                            (82006,'DROIT_TRAV','2023-2024',3,'en_cours'),(82006,'PROCED_PEN','2023-2024',3,'en_cours'),
                            (82007,'DROIT_CONST','2022-2023',1,'valide'),(82007,'HIST_DROIT','2022-2023',1,'valide'),
                            (82007,'DROIT_ADM','2022-2023',1,'valide'),(82007,'DROIT_EUR','2022-2023',2,'valide'),
                            (82007,'DROIT_CIV1','2022-2023',2,'valide'),(82007,'DROIT_PEN','2022-2023',2,'valide'),
                            (82007,'DROIT_TRAV','2023-2024',3,'en_cours'),
                            (82008,'DROIT_CONST','2022-2023',1,'valide'),(82008,'DROIT_ADM','2022-2023',1,'valide'),
                            (82008,'RHETORIQUE','2022-2023',1,'valide'),(82008,'DROIT_EUR','2022-2023',2,'valide'),
                            (82008,'ANGLAIS_2','2022-2023',2,'valide'),(82008,'DROIT_TRAV','2023-2024',3,'en_cours'),
                            (82009,'DROIT_CONST','2022-2023',1,'valide'),(82009,'HIST_DROIT','2022-2023',1,'valide'),
                            (82009,'ANGLAIS_1','2022-2023',1,'valide'),(82009,'DROIT_EUR','2022-2023',2,'valide'),
                            (82009,'PROCED_CIV','2022-2023',2,'valide'),(82009,'ANGLAIS_2','2022-2023',2,'valide'),
                            (82009,'DROIT_TRAV','2023-2024',3,'en_cours'),
                            (82010,'DROIT_CONST','2022-2023',1,'valide'),(82010,'DROIT_ADM','2022-2023',1,'valide'),
                            (82010,'ANGLAIS_1','2022-2023',1,'valide'),(82010,'DROIT_EUR','2022-2023',2,'valide'),
                            (82010,'DROIT_PEN','2022-2023',2,'valide'),(82010,'ANGLAIS_2','2022-2023',2,'valide'),
                            (82010,'DROIT_TRAV','2023-2024',3,'en_cours'),(82010,'PROCED_PEN','2023-2024',3,'en_cours');

INSERT INTO Etudiant VALUES
                         (83001,'Gier','Gaelle','2002-04-11',8),(83002,'Hier','Herve','2001-07-24',8),
                         (83003,'Iier','Isabelle','2002-01-06',8),(83004,'Jier','Jerome','2001-04-19',8),
                         (83005,'Kier','Karine','2002-08-02',8),(83006,'Lier','Laurent','2001-11-15',8),
                         (83007,'Mier','Marine','2002-02-28',8),(83008,'Nier','Nicolas','2001-06-13',8),
                         (83009,'Oier','Odette','2002-10-26',8),(83010,'Pier','Pierre','2001-03-10',8);

INSERT INTO Inscription VALUES
                            (83001,'DROIT_CONST','2021-2022',1,'valide'),(83001,'HIST_DROIT','2021-2022',1,'valide'),
                            (83001,'DROIT_ADM','2021-2022',1,'valide'),(83001,'ANGLAIS_1','2021-2022',1,'valide'),
                            (83001,'DROIT_EUR','2021-2022',2,'valide'),(83001,'DROIT_CIV1','2021-2022',2,'valide'),
                            (83001,'ANGLAIS_2','2021-2022',2,'valide'),(83001,'DROIT_TRAV','2022-2023',3,'valide'),
                            (83001,'PROCED_PEN','2022-2023',3,'valide'),(83001,'PROJET_PRO','2022-2023',4,'valide'),
                            (83001,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (83002,'DROIT_CONST','2021-2022',1,'valide'),(83002,'DROIT_ADM','2021-2022',1,'valide'),
                            (83002,'ANGLAIS_1','2021-2022',1,'valide'),(83002,'DROIT_EUR','2021-2022',2,'valide'),
                            (83002,'ANGLAIS_2','2021-2022',2,'valide'),(83002,'DROIT_TRAV','2022-2023',3,'valide'),
                            (83002,'PROJET_PRO','2022-2023',4,'valide'),(83002,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (83003,'DROIT_CONST','2021-2022',1,'valide'),(83003,'HIST_DROIT','2021-2022',1,'valide'),
                            (83003,'DROIT_ADM','2021-2022',1,'valide'),(83003,'DROIT_EUR','2021-2022',2,'valide'),
                            (83003,'DROIT_CIV1','2021-2022',2,'valide'),(83003,'PROCED_CIV','2021-2022',2,'valide'),
                            (83003,'DROIT_TRAV','2022-2023',3,'valide'),(83003,'PROCED_PEN','2022-2023',3,'valide'),
                            (83003,'PROJET_PRO','2022-2023',4,'valide'),(83003,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (83004,'DROIT_CONST','2021-2022',1,'valide'),(83004,'DROIT_ADM','2021-2022',1,'valide'),
                            (83004,'RHETORIQUE','2021-2022',1,'valide'),(83004,'DROIT_EUR','2021-2022',2,'valide'),
                            (83004,'DROIT_PEN','2021-2022',2,'valide'),(83004,'ANGLAIS_2','2021-2022',2,'valide'),
                            (83004,'DROIT_TRAV','2022-2023',3,'valide'),(83004,'PROJET_PRO','2022-2023',4,'valide'),
                            (83004,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (83005,'DROIT_CONST','2021-2022',1,'valide'),(83005,'HIST_DROIT','2021-2022',1,'valide'),
                            (83005,'ANGLAIS_1','2021-2022',1,'valide'),(83005,'DROIT_EUR','2021-2022',2,'valide'),
                            (83005,'DROIT_CIV1','2021-2022',2,'valide'),(83005,'ANGLAIS_2','2021-2022',2,'valide'),
                            (83005,'DROIT_TRAV','2022-2023',3,'valide'),(83005,'PROJET_PRO','2022-2023',4,'valide'),
                            (83005,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (83006,'DROIT_CONST','2021-2022',1,'valide'),(83006,'DROIT_ADM','2021-2022',1,'valide'),
                            (83006,'ANGLAIS_1','2021-2022',1,'valide'),(83006,'DROIT_EUR','2021-2022',2,'valide'),
                            (83006,'PROCED_CIV','2021-2022',2,'valide'),(83006,'DROIT_PEN','2021-2022',2,'valide'),
                            (83006,'DROIT_TRAV','2022-2023',3,'valide'),(83006,'PROCED_PEN','2022-2023',3,'valide'),
                            (83006,'PROJET_PRO','2022-2023',4,'valide'),(83006,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (83007,'DROIT_CONST','2021-2022',1,'valide'),(83007,'HIST_DROIT','2021-2022',1,'valide'),
                            (83007,'DROIT_ADM','2021-2022',1,'valide'),(83007,'DROIT_EUR','2021-2022',2,'valide'),
                            (83007,'DROIT_CIV1','2021-2022',2,'echoue'),(83007,'ANGLAIS_2','2021-2022',2,'valide'),
                            (83007,'DROIT_CIV1','2022-2023',3,'valide'),(83007,'DROIT_TRAV','2022-2023',3,'valide'),
                            (83007,'PROJET_PRO','2022-2023',4,'valide'),(83007,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (83008,'DROIT_CONST','2021-2022',1,'valide'),(83008,'DROIT_ADM','2021-2022',1,'valide'),
                            (83008,'ANGLAIS_1','2021-2022',1,'valide'),(83008,'DROIT_EUR','2021-2022',2,'valide'),
                            (83008,'ANGLAIS_2','2021-2022',2,'valide'),(83008,'DROIT_TRAV','2022-2023',3,'valide'),
                            (83008,'PROCED_PEN','2022-2023',3,'valide'),(83008,'PROJET_PRO','2022-2023',4,'valide'),
                            (83008,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (83009,'DROIT_CONST','2021-2022',1,'valide'),(83009,'HIST_DROIT','2021-2022',1,'valide'),
                            (83009,'DROIT_ADM','2021-2022',1,'valide'),(83009,'DROIT_EUR','2021-2022',2,'valide'),
                            (83009,'DROIT_PEN','2021-2022',2,'valide'),(83009,'ANGLAIS_2','2021-2022',2,'valide'),
                            (83009,'DROIT_TRAV','2022-2023',3,'valide'),(83009,'PROJET_PRO','2022-2023',4,'valide'),
                            (83009,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (83010,'DROIT_CONST','2021-2022',1,'valide'),(83010,'DROIT_ADM','2021-2022',1,'valide'),
                            (83010,'RHETORIQUE','2021-2022',1,'valide'),(83010,'DROIT_EUR','2021-2022',2,'valide'),
                            (83010,'PROCED_CIV','2021-2022',2,'valide'),(83010,'ANGLAIS_2','2021-2022',2,'valide'),
                            (83010,'DROIT_TRAV','2022-2023',3,'valide'),(83010,'PROCED_PEN','2022-2023',3,'valide'),
                            (83010,'PROJET_PRO','2022-2023',4,'valide'),(83010,'ANGLAIS_3','2023-2024',5,'en_cours');

-- ---- PARCOURS 9 : Psychologie Clinique ----
-- S1: PSYCH_GEN, PSYCH_DEV, METHODO, STATS_PSY, ANGLAIS_1
-- S2: PSYCH_SOC, NEURO, PSYCH_CLIN, ANGLAIS_2, SPORT
-- S3: ENTRETIEN, PSYCH_TEST, PSYCH_TRAV
-- S4: PROJET_PRO, ANGLAIS_3

INSERT INTO Etudiant VALUES
                         (91001,'Qier','Quentin','2004-01-02',9),(91002,'Rier','Renee','2004-04-15',9),
                         (91003,'Sier','Sabine','2004-07-28',9),(91004,'Tier','Therese','2004-02-10',9),
                         (91005,'Uier','Ulysse','2004-06-23',9),(91006,'Vier','Viviane','2004-10-06',9),
                         (91007,'Wier','Wilfrid','2004-03-19',9),(91008,'Xier','Xenia','2004-09-02',9),
                         (91009,'Yier','Yolande','2004-07-16',9),(91010,'Zier','Zacharie','2004-11-29',9);

INSERT INTO Inscription VALUES
                            (91001,'PSYCH_GEN','2023-2024',1,'en_cours'),(91001,'PSYCH_DEV','2023-2024',1,'en_cours'),
                            (91001,'METHODO','2023-2024',1,'en_cours'),(91001,'STATS_PSY','2023-2024',1,'en_cours'),
                            (91002,'PSYCH_GEN','2023-2024',1,'en_cours'),(91002,'METHODO','2023-2024',1,'en_cours'),
                            (91002,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (91003,'PSYCH_GEN','2023-2024',1,'en_cours'),(91003,'PSYCH_DEV','2023-2024',1,'en_cours'),
                            (91003,'STATS_PSY','2023-2024',1,'en_cours'),
                            (91004,'PSYCH_GEN','2023-2024',1,'en_cours'),(91004,'METHODO','2023-2024',1,'en_cours'),
                            (91004,'PSYCH_DEV','2023-2024',1,'en_cours'),(91004,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (91005,'PSYCH_GEN','2023-2024',1,'en_cours'),(91005,'STATS_PSY','2023-2024',1,'en_cours'),
                            (91006,'PSYCH_GEN','2023-2024',1,'en_cours'),(91006,'PSYCH_DEV','2023-2024',1,'en_cours'),
                            (91006,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (91007,'PSYCH_GEN','2023-2024',1,'en_cours'),(91007,'METHODO','2023-2024',1,'en_cours'),
                            (91008,'PSYCH_GEN','2023-2024',1,'en_cours'),(91008,'PSYCH_DEV','2023-2024',1,'en_cours'),
                            (91008,'STATS_PSY','2023-2024',1,'en_cours'),
                            (91009,'PSYCH_GEN','2023-2024',1,'en_cours'),(91009,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (91010,'PSYCH_GEN','2023-2024',1,'en_cours'),(91010,'PSYCH_DEV','2023-2024',1,'en_cours'),
                            (91010,'METHODO','2023-2024',1,'en_cours');

INSERT INTO Etudiant VALUES
                         (92001,'Ajer','Amelie','2003-02-12',9),(92002,'Bjer','Boris','2003-05-25',9),
                         (92003,'Cjer','Claire','2002-09-08',9),(92004,'Djer','Denis','2003-01-21',9),
                         (92005,'Ejer','Edith','2002-10-03',9),(92006,'Fjer','Fabrice','2003-04-17',9),
                         (92007,'Gjer','Geraldine','2003-08-30',9),(92008,'Hjer','Henri','2002-12-13',9),
                         (92009,'Ijer','Isabelle','2003-03-26',9),(92010,'Jjer','Jacques','2002-08-08',9);

INSERT INTO Inscription VALUES
                            (92001,'PSYCH_GEN','2022-2023',1,'valide'),(92001,'PSYCH_DEV','2022-2023',1,'valide'),
                            (92001,'METHODO','2022-2023',1,'valide'),(92001,'STATS_PSY','2022-2023',1,'valide'),
                            (92001,'ANGLAIS_1','2022-2023',1,'valide'),(92001,'PSYCH_SOC','2022-2023',2,'valide'),
                            (92001,'NEURO','2022-2023',2,'valide'),(92001,'PSYCH_CLIN','2022-2023',2,'valide'),
                            (92001,'ANGLAIS_2','2022-2023',2,'valide'),(92001,'ENTRETIEN','2023-2024',3,'en_cours'),
                            (92001,'PSYCH_TEST','2023-2024',3,'en_cours'),
                            (92002,'PSYCH_GEN','2022-2023',1,'valide'),(92002,'METHODO','2022-2023',1,'valide'),
                            (92002,'ANGLAIS_1','2022-2023',1,'valide'),(92002,'PSYCH_SOC','2022-2023',2,'valide'),
                            (92002,'PSYCH_CLIN','2022-2023',2,'valide'),(92002,'ANGLAIS_2','2022-2023',2,'valide'),
                            (92002,'PSYCH_TEST','2023-2024',3,'en_cours'),
                            (92003,'PSYCH_GEN','2022-2023',1,'valide'),(92003,'PSYCH_DEV','2022-2023',1,'valide'),
                            (92003,'STATS_PSY','2022-2023',1,'valide'),(92003,'PSYCH_SOC','2022-2023',2,'valide'),
                            (92003,'NEURO','2022-2023',2,'valide'),(92003,'PSYCH_CLIN','2022-2023',2,'valide'),
                            (92003,'ENTRETIEN','2023-2024',3,'en_cours'),(92003,'PSYCH_TEST','2023-2024',3,'en_cours'),
                            (92004,'PSYCH_GEN','2022-2023',1,'valide'),(92004,'METHODO','2022-2023',1,'valide'),
                            (92004,'ANGLAIS_1','2022-2023',1,'valide'),(92004,'PSYCH_CLIN','2022-2023',2,'valide'),
                            (92004,'NEURO','2022-2023',2,'echoue'),(92004,'ANGLAIS_2','2022-2023',2,'valide'),
                            (92004,'NEURO','2023-2024',3,'valide'),(92004,'ENTRETIEN','2023-2024',3,'en_cours'),
                            (92005,'PSYCH_GEN','2022-2023',1,'valide'),(92005,'PSYCH_DEV','2022-2023',1,'valide'),
                            (92005,'METHODO','2022-2023',1,'valide'),(92005,'PSYCH_SOC','2022-2023',2,'valide'),
                            (92005,'PSYCH_CLIN','2022-2023',2,'valide'),(92005,'ANGLAIS_2','2022-2023',2,'valide'),
                            (92005,'ENTRETIEN','2023-2024',3,'en_cours'),(92005,'PSYCH_TEST','2023-2024',3,'en_cours'),
                            (92006,'PSYCH_GEN','2022-2023',1,'valide'),(92006,'STATS_PSY','2022-2023',1,'valide'),
                            (92006,'ANGLAIS_1','2022-2023',1,'valide'),(92006,'PSYCH_SOC','2022-2023',2,'valide'),
                            (92006,'NEURO','2022-2023',2,'valide'),(92006,'PSYCH_CLIN','2022-2023',2,'valide'),
                            (92006,'PSYCH_TEST','2023-2024',3,'en_cours'),
                            (92007,'PSYCH_GEN','2022-2023',1,'valide'),(92007,'PSYCH_DEV','2022-2023',1,'valide'),
                            (92007,'METHODO','2022-2023',1,'valide'),(92007,'PSYCH_CLIN','2022-2023',2,'valide'),
                            (92007,'ANGLAIS_2','2022-2023',2,'valide'),(92007,'ENTRETIEN','2023-2024',3,'en_cours'),
                            (92007,'PSYCH_TEST','2023-2024',3,'en_cours'),
                            (92008,'PSYCH_GEN','2022-2023',1,'valide'),(92008,'STATS_PSY','2022-2023',1,'valide'),
                            (92008,'ANGLAIS_1','2022-2023',1,'valide'),(92008,'PSYCH_SOC','2022-2023',2,'valide'),
                            (92008,'PSYCH_CLIN','2022-2023',2,'valide'),(92008,'NEURO','2022-2023',2,'valide'),
                            (92008,'PSYCH_TEST','2023-2024',3,'en_cours'),
                            (92009,'PSYCH_GEN','2022-2023',1,'valide'),(92009,'PSYCH_DEV','2022-2023',1,'valide'),
                            (92009,'ANGLAIS_1','2022-2023',1,'valide'),(92009,'PSYCH_CLIN','2022-2023',2,'valide'),
                            (92009,'NEURO','2022-2023',2,'valide'),(92009,'ANGLAIS_2','2022-2023',2,'valide'),
                            (92009,'ENTRETIEN','2023-2024',3,'en_cours'),
                            (92010,'PSYCH_GEN','2022-2023',1,'valide'),(92010,'METHODO','2022-2023',1,'valide'),
                            (92010,'STATS_PSY','2022-2023',1,'valide'),(92010,'PSYCH_SOC','2022-2023',2,'valide'),
                            (92010,'PSYCH_CLIN','2022-2023',2,'valide'),(92010,'ANGLAIS_2','2022-2023',2,'valide'),
                            (92010,'PSYCH_TEST','2023-2024',3,'en_cours');

INSERT INTO Etudiant VALUES
                         (93001,'Kjer','Karine','2002-04-14',9),(93002,'Ljer','Laurent','2001-07-27',9),
                         (93003,'Mjer','Marine','2002-01-09',9),(93004,'Njer','Nicolas','2001-04-22',9),
                         (93005,'Ojer','Odile','2002-08-05',9),(93006,'Pjer','Patricia','2001-11-18',9),
                         (93007,'Qjer','Quentin','2002-02-01',9),(93008,'Rjer','Renee','2001-05-14',9),
                         (93009,'Sjer','Serge','2002-09-27',9),(93010,'Tjer','Therese','2001-01-10',9);

INSERT INTO Inscription VALUES
                            (93001,'PSYCH_GEN','2021-2022',1,'valide'),(93001,'PSYCH_DEV','2021-2022',1,'valide'),
                            (93001,'METHODO','2021-2022',1,'valide'),(93001,'STATS_PSY','2021-2022',1,'valide'),
                            (93001,'ANGLAIS_1','2021-2022',1,'valide'),(93001,'PSYCH_SOC','2021-2022',2,'valide'),
                            (93001,'NEURO','2021-2022',2,'valide'),(93001,'PSYCH_CLIN','2021-2022',2,'valide'),
                            (93001,'ANGLAIS_2','2021-2022',2,'valide'),(93001,'ENTRETIEN','2022-2023',3,'valide'),
                            (93001,'PSYCH_TEST','2022-2023',3,'valide'),(93001,'PROJET_PRO','2022-2023',4,'valide'),
                            (93001,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (93002,'PSYCH_GEN','2021-2022',1,'valide'),(93002,'METHODO','2021-2022',1,'valide'),
                            (93002,'ANGLAIS_1','2021-2022',1,'valide'),(93002,'PSYCH_CLIN','2021-2022',2,'valide'),
                            (93002,'ANGLAIS_2','2021-2022',2,'valide'),(93002,'ENTRETIEN','2022-2023',3,'valide'),
                            (93002,'PSYCH_TEST','2022-2023',3,'valide'),(93002,'PROJET_PRO','2022-2023',4,'valide'),
                            (93002,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (93003,'PSYCH_GEN','2021-2022',1,'valide'),(93003,'PSYCH_DEV','2021-2022',1,'valide'),
                            (93003,'STATS_PSY','2021-2022',1,'valide'),(93003,'PSYCH_SOC','2021-2022',2,'valide'),
                            (93003,'NEURO','2021-2022',2,'valide'),(93003,'PSYCH_CLIN','2021-2022',2,'valide'),
                            (93003,'ENTRETIEN','2022-2023',3,'valide'),(93003,'PSYCH_TEST','2022-2023',3,'valide'),
                            (93003,'PROJET_PRO','2022-2023',4,'valide'),(93003,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (93004,'PSYCH_GEN','2021-2022',1,'valide'),(93004,'METHODO','2021-2022',1,'valide'),
                            (93004,'ANGLAIS_1','2021-2022',1,'valide'),(93004,'PSYCH_CLIN','2021-2022',2,'valide'),
                            (93004,'NEURO','2021-2022',2,'valide'),(93004,'ANGLAIS_2','2021-2022',2,'valide'),
                            (93004,'PSYCH_TEST','2022-2023',3,'valide'),(93004,'ENTRETIEN','2022-2023',3,'valide'),
                            (93004,'PROJET_PRO','2022-2023',4,'valide'),(93004,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (93005,'PSYCH_GEN','2021-2022',1,'valide'),(93005,'PSYCH_DEV','2021-2022',1,'valide'),
                            (93005,'METHODO','2021-2022',1,'valide'),(93005,'PSYCH_SOC','2021-2022',2,'valide'),
                            (93005,'PSYCH_CLIN','2021-2022',2,'echoue'),(93005,'ANGLAIS_2','2021-2022',2,'valide'),
                            (93005,'PSYCH_CLIN','2022-2023',3,'valide'),(93005,'ENTRETIEN','2022-2023',3,'valide'),
                            (93005,'PSYCH_TEST','2022-2023',3,'valide'),(93005,'PROJET_PRO','2022-2023',4,'valide'),
                            (93005,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (93006,'PSYCH_GEN','2021-2022',1,'valide'),(93006,'STATS_PSY','2021-2022',1,'valide'),
                            (93006,'ANGLAIS_1','2021-2022',1,'valide'),(93006,'PSYCH_CLIN','2021-2022',2,'valide'),
                            (93006,'NEURO','2021-2022',2,'valide'),(93006,'ANGLAIS_2','2021-2022',2,'valide'),
                            (93006,'ENTRETIEN','2022-2023',3,'valide'),(93006,'PSYCH_TEST','2022-2023',3,'valide'),
                            (93006,'PROJET_PRO','2022-2023',4,'valide'),(93006,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (93007,'PSYCH_GEN','2021-2022',1,'valide'),(93007,'PSYCH_DEV','2021-2022',1,'valide'),
                            (93007,'METHODO','2021-2022',1,'valide'),(93007,'PSYCH_SOC','2021-2022',2,'valide'),
                            (93007,'PSYCH_CLIN','2021-2022',2,'valide'),(93007,'NEURO','2021-2022',2,'valide'),
                            (93007,'ENTRETIEN','2022-2023',3,'valide'),(93007,'PSYCH_TEST','2022-2023',3,'valide'),
                            (93007,'PROJET_PRO','2022-2023',4,'valide'),(93007,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (93008,'PSYCH_GEN','2021-2022',1,'valide'),(93008,'STATS_PSY','2021-2022',1,'valide'),
                            (93008,'ANGLAIS_1','2021-2022',1,'valide'),(93008,'PSYCH_CLIN','2021-2022',2,'valide'),
                            (93008,'ANGLAIS_2','2021-2022',2,'valide'),(93008,'PSYCH_TEST','2022-2023',3,'valide'),
                            (93008,'ENTRETIEN','2022-2023',3,'valide'),(93008,'PROJET_PRO','2022-2023',4,'valide'),
                            (93008,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (93009,'PSYCH_GEN','2021-2022',1,'valide'),(93009,'PSYCH_DEV','2021-2022',1,'valide'),
                            (93009,'ANGLAIS_1','2021-2022',1,'valide'),(93009,'PSYCH_CLIN','2021-2022',2,'valide'),
                            (93009,'NEURO','2021-2022',2,'valide'),(93009,'ANGLAIS_2','2021-2022',2,'valide'),
                            (93009,'ENTRETIEN','2022-2023',3,'valide'),(93009,'PSYCH_TEST','2022-2023',3,'valide'),
                            (93009,'PROJET_PRO','2022-2023',4,'valide'),(93009,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (93010,'PSYCH_GEN','2021-2022',1,'valide'),(93010,'METHODO','2021-2022',1,'valide'),
                            (93010,'STATS_PSY','2021-2022',1,'valide'),(93010,'PSYCH_SOC','2021-2022',2,'valide'),
                            (93010,'PSYCH_CLIN','2021-2022',2,'valide'),(93010,'ANGLAIS_2','2021-2022',2,'valide'),
                            (93010,'PSYCH_TEST','2022-2023',3,'valide'),(93010,'ENTRETIEN','2022-2023',3,'valide'),
                            (93010,'PROJET_PRO','2022-2023',4,'valide'),(93010,'ANGLAIS_3','2023-2024',5,'en_cours');

-- ---- PARCOURS 10 : Psychologie du Travail ----
-- S1: PSYCH_GEN, PSYCH_DEV, METHODO, STATS_PSY, ANGLAIS_1
-- S2: PSYCH_SOC, PSYCH_TRAV, NEURO, ANGLAIS_2, SPORT
-- S3: ENTRETIEN, PSYCH_TEST, PSYCH_CLIN
-- S4: PROJET_PRO, ANGLAIS_3

INSERT INTO Etudiant VALUES
                         (101001,'Ujer','Ursula','2004-01-03',10),(101002,'Vjer','Valerie','2004-04-16',10),
                         (101003,'Wjer','Wilfrid','2004-07-29',10),(101004,'Xjer','Xenia','2004-02-11',10),
                         (101005,'Yjer','Yann','2004-06-24',10),(101006,'Zjer','Zoe','2004-10-07',10),
                         (101007,'Aker','Andre','2004-03-20',10),(101008,'Bker','Brigitte','2004-09-03',10),
                         (101009,'Cker','Charles','2004-07-17',10),(101010,'Dker','Denise','2004-11-30',10);

INSERT INTO Inscription VALUES
                            (101001,'PSYCH_GEN','2023-2024',1,'en_cours'),(101001,'PSYCH_DEV','2023-2024',1,'en_cours'),
                            (101001,'METHODO','2023-2024',1,'en_cours'),(101001,'STATS_PSY','2023-2024',1,'en_cours'),
                            (101002,'PSYCH_GEN','2023-2024',1,'en_cours'),(101002,'METHODO','2023-2024',1,'en_cours'),
                            (101002,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (101003,'PSYCH_GEN','2023-2024',1,'en_cours'),(101003,'PSYCH_DEV','2023-2024',1,'en_cours'),
                            (101003,'STATS_PSY','2023-2024',1,'en_cours'),
                            (101004,'PSYCH_GEN','2023-2024',1,'en_cours'),(101004,'METHODO','2023-2024',1,'en_cours'),
                            (101004,'PSYCH_DEV','2023-2024',1,'en_cours'),
                            (101005,'PSYCH_GEN','2023-2024',1,'en_cours'),(101005,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (101006,'PSYCH_GEN','2023-2024',1,'en_cours'),(101006,'PSYCH_DEV','2023-2024',1,'en_cours'),
                            (101006,'METHODO','2023-2024',1,'en_cours'),
                            (101007,'PSYCH_GEN','2023-2024',1,'en_cours'),(101007,'STATS_PSY','2023-2024',1,'en_cours'),
                            (101008,'PSYCH_GEN','2023-2024',1,'en_cours'),(101008,'PSYCH_DEV','2023-2024',1,'en_cours'),
                            (101008,'ANGLAIS_1','2023-2024',1,'en_cours'),
                            (101009,'PSYCH_GEN','2023-2024',1,'en_cours'),(101009,'METHODO','2023-2024',1,'en_cours'),
                            (101010,'PSYCH_GEN','2023-2024',1,'en_cours'),(101010,'PSYCH_DEV','2023-2024',1,'en_cours'),
                            (101010,'STATS_PSY','2023-2024',1,'en_cours');

INSERT INTO Etudiant VALUES
                         (102001,'Eker','Edith','2003-02-13',10),(102002,'Fker','Fabrice','2003-05-26',10),
                         (102003,'Gker','Geraldine','2002-09-09',10),(102004,'Hker','Henri','2003-01-22',10),
                         (102005,'Iker','Isabelle','2002-10-04',10),(102006,'Jker','Jacques','2003-04-18',10),
                         (102007,'Kker','Karine','2003-08-01',10),(102008,'Lker','Laurent','2002-12-14',10),
                         (102009,'Mker','Marine','2003-03-27',10),(102010,'Nker','Nicolas','2002-07-09',10);

INSERT INTO Inscription VALUES
                            (102001,'PSYCH_GEN','2022-2023',1,'valide'),(102001,'PSYCH_DEV','2022-2023',1,'valide'),
                            (102001,'METHODO','2022-2023',1,'valide'),(102001,'STATS_PSY','2022-2023',1,'valide'),
                            (102001,'ANGLAIS_1','2022-2023',1,'valide'),(102001,'PSYCH_SOC','2022-2023',2,'valide'),
                            (102001,'PSYCH_TRAV','2022-2023',2,'valide'),(102001,'ANGLAIS_2','2022-2023',2,'valide'),
                            (102001,'PSYCH_TEST','2023-2024',3,'en_cours'),(102001,'PSYCH_CLIN','2023-2024',3,'en_cours'),
                            (102002,'PSYCH_GEN','2022-2023',1,'valide'),(102002,'METHODO','2022-2023',1,'valide'),
                            (102002,'ANGLAIS_1','2022-2023',1,'valide'),(102002,'PSYCH_TRAV','2022-2023',2,'valide'),
                            (102002,'ANGLAIS_2','2022-2023',2,'valide'),(102002,'PSYCH_TEST','2023-2024',3,'en_cours'),
                            (102003,'PSYCH_GEN','2022-2023',1,'valide'),(102003,'PSYCH_DEV','2022-2023',1,'valide'),
                            (102003,'STATS_PSY','2022-2023',1,'valide'),(102003,'PSYCH_SOC','2022-2023',2,'valide'),
                            (102003,'PSYCH_TRAV','2022-2023',2,'valide'),(102003,'NEURO','2022-2023',2,'valide'),
                            (102003,'PSYCH_TEST','2023-2024',3,'en_cours'),(102003,'PSYCH_CLIN','2023-2024',3,'en_cours'),
                            (102004,'PSYCH_GEN','2022-2023',1,'valide'),(102004,'METHODO','2022-2023',1,'valide'),
                            (102004,'ANGLAIS_1','2022-2023',1,'valide'),(102004,'PSYCH_TRAV','2022-2023',2,'valide'),
                            (102004,'NEURO','2022-2023',2,'echoue'),(102004,'ANGLAIS_2','2022-2023',2,'valide'),
                            (102004,'NEURO','2023-2024',3,'valide'),(102004,'PSYCH_TEST','2023-2024',3,'en_cours'),
                            (102005,'PSYCH_GEN','2022-2023',1,'valide'),(102005,'PSYCH_DEV','2022-2023',1,'valide'),
                            (102005,'METHODO','2022-2023',1,'valide'),(102005,'PSYCH_SOC','2022-2023',2,'valide'),
                            (102005,'PSYCH_TRAV','2022-2023',2,'valide'),(102005,'ANGLAIS_2','2022-2023',2,'valide'),
                            (102005,'PSYCH_TEST','2023-2024',3,'en_cours'),(102005,'PSYCH_CLIN','2023-2024',3,'en_cours'),
                            (102006,'PSYCH_GEN','2022-2023',1,'valide'),(102006,'STATS_PSY','2022-2023',1,'valide'),
                            (102006,'ANGLAIS_1','2022-2023',1,'valide'),(102006,'PSYCH_SOC','2022-2023',2,'valide'),
                            (102006,'PSYCH_TRAV','2022-2023',2,'valide'),(102006,'NEURO','2022-2023',2,'valide'),
                            (102006,'PSYCH_TEST','2023-2024',3,'en_cours'),
                            (102007,'PSYCH_GEN','2022-2023',1,'valide'),(102007,'PSYCH_DEV','2022-2023',1,'valide'),
                            (102007,'METHODO','2022-2023',1,'valide'),(102007,'PSYCH_TRAV','2022-2023',2,'valide'),
                            (102007,'ANGLAIS_2','2022-2023',2,'valide'),(102007,'PSYCH_TEST','2023-2024',3,'en_cours'),
                            (102007,'PSYCH_CLIN','2023-2024',3,'en_cours'),
                            (102008,'PSYCH_GEN','2022-2023',1,'valide'),(102008,'STATS_PSY','2022-2023',1,'valide'),
                            (102008,'ANGLAIS_1','2022-2023',1,'valide'),(102008,'PSYCH_SOC','2022-2023',2,'valide'),
                            (102008,'PSYCH_TRAV','2022-2023',2,'valide'),(102008,'NEURO','2022-2023',2,'valide'),
                            (102008,'PSYCH_TEST','2023-2024',3,'en_cours'),
                            (102009,'PSYCH_GEN','2022-2023',1,'valide'),(102009,'PSYCH_DEV','2022-2023',1,'valide'),
                            (102009,'ANGLAIS_1','2022-2023',1,'valide'),(102009,'PSYCH_TRAV','2022-2023',2,'valide'),
                            (102009,'NEURO','2022-2023',2,'valide'),(102009,'ANGLAIS_2','2022-2023',2,'valide'),
                            (102009,'PSYCH_TEST','2023-2024',3,'en_cours'),
                            (102010,'PSYCH_GEN','2022-2023',1,'valide'),(102010,'METHODO','2022-2023',1,'valide'),
                            (102010,'STATS_PSY','2022-2023',1,'valide'),(102010,'PSYCH_SOC','2022-2023',2,'valide'),
                            (102010,'PSYCH_TRAV','2022-2023',2,'valide'),(102010,'ANGLAIS_2','2022-2023',2,'valide'),
                            (102010,'PSYCH_TEST','2023-2024',3,'en_cours');

INSERT INTO Etudiant VALUES
                         (103001,'Oker','Odile','2002-04-12',10),(103002,'Pker','Pierre','2001-07-25',10),
                         (103003,'Qker','Quentin','2002-01-07',10),(103004,'Rker','Renee','2001-04-20',10),
                         (103005,'Sker','Serge','2002-08-03',10),(103006,'Tker','Therese','2001-11-16',10),
                         (103007,'Uker','Ulysse','2002-02-28',10),(103008,'Vker','Valerie','2001-06-12',10),
                         (103009,'Wker','Wilfrid','2002-10-25',10),(103010,'Xker','Xavier','2001-02-08',10);

INSERT INTO Inscription VALUES
                            (103001,'PSYCH_GEN','2021-2022',1,'valide'),(103001,'PSYCH_DEV','2021-2022',1,'valide'),
                            (103001,'METHODO','2021-2022',1,'valide'),(103001,'STATS_PSY','2021-2022',1,'valide'),
                            (103001,'ANGLAIS_1','2021-2022',1,'valide'),(103001,'PSYCH_SOC','2021-2022',2,'valide'),
                            (103001,'PSYCH_TRAV','2021-2022',2,'valide'),(103001,'NEURO','2021-2022',2,'valide'),
                            (103001,'ANGLAIS_2','2021-2022',2,'valide'),(103001,'PSYCH_TEST','2022-2023',3,'valide'),
                            (103001,'PSYCH_CLIN','2022-2023',3,'valide'),(103001,'PROJET_PRO','2022-2023',4,'valide'),
                            (103001,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (103002,'PSYCH_GEN','2021-2022',1,'valide'),(103002,'METHODO','2021-2022',1,'valide'),
                            (103002,'ANGLAIS_1','2021-2022',1,'valide'),(103002,'PSYCH_TRAV','2021-2022',2,'valide'),
                            (103002,'ANGLAIS_2','2021-2022',2,'valide'),(103002,'PSYCH_TEST','2022-2023',3,'valide'),
                            (103002,'PROJET_PRO','2022-2023',4,'valide'),(103002,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (103003,'PSYCH_GEN','2021-2022',1,'valide'),(103003,'PSYCH_DEV','2021-2022',1,'valide'),
                            (103003,'STATS_PSY','2021-2022',1,'valide'),(103003,'PSYCH_SOC','2021-2022',2,'valide'),
                            (103003,'PSYCH_TRAV','2021-2022',2,'valide'),(103003,'NEURO','2021-2022',2,'valide'),
                            (103003,'PSYCH_TEST','2022-2023',3,'valide'),(103003,'PSYCH_CLIN','2022-2023',3,'valide'),
                            (103003,'PROJET_PRO','2022-2023',4,'valide'),(103003,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (103004,'PSYCH_GEN','2021-2022',1,'valide'),(103004,'METHODO','2021-2022',1,'valide'),
                            (103004,'ANGLAIS_1','2021-2022',1,'valide'),(103004,'PSYCH_TRAV','2021-2022',2,'valide'),
                            (103004,'NEURO','2021-2022',2,'valide'),(103004,'ANGLAIS_2','2021-2022',2,'valide'),
                            (103004,'PSYCH_TEST','2022-2023',3,'valide'),(103004,'ENTRETIEN','2022-2023',3,'valide'),
                            (103004,'PROJET_PRO','2022-2023',4,'valide'),(103004,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (103005,'PSYCH_GEN','2021-2022',1,'valide'),(103005,'PSYCH_DEV','2021-2022',1,'valide'),
                            (103005,'METHODO','2021-2022',1,'valide'),(103005,'PSYCH_SOC','2021-2022',2,'valide'),
                            (103005,'PSYCH_TRAV','2021-2022',2,'echoue'),(103005,'ANGLAIS_2','2021-2022',2,'valide'),
                            (103005,'PSYCH_TRAV','2022-2023',3,'valide'),(103005,'PSYCH_TEST','2022-2023',3,'valide'),
                            (103005,'PROJET_PRO','2022-2023',4,'valide'),(103005,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (103006,'PSYCH_GEN','2021-2022',1,'valide'),(103006,'STATS_PSY','2021-2022',1,'valide'),
                            (103006,'ANGLAIS_1','2021-2022',1,'valide'),(103006,'PSYCH_TRAV','2021-2022',2,'valide'),
                            (103006,'NEURO','2021-2022',2,'valide'),(103006,'ANGLAIS_2','2021-2022',2,'valide'),
                            (103006,'PSYCH_TEST','2022-2023',3,'valide'),(103006,'PSYCH_CLIN','2022-2023',3,'valide'),
                            (103006,'PROJET_PRO','2022-2023',4,'valide'),(103006,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (103007,'PSYCH_GEN','2021-2022',1,'valide'),(103007,'PSYCH_DEV','2021-2022',1,'valide'),
                            (103007,'METHODO','2021-2022',1,'valide'),(103007,'PSYCH_SOC','2021-2022',2,'valide'),
                            (103007,'PSYCH_TRAV','2021-2022',2,'valide'),(103007,'NEURO','2021-2022',2,'valide'),
                            (103007,'PSYCH_TEST','2022-2023',3,'valide'),(103007,'PROJET_PRO','2022-2023',4,'valide'),
                            (103007,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (103008,'PSYCH_GEN','2021-2022',1,'valide'),(103008,'STATS_PSY','2021-2022',1,'valide'),
                            (103008,'ANGLAIS_1','2021-2022',1,'valide'),(103008,'PSYCH_TRAV','2021-2022',2,'valide'),
                            (103008,'ANGLAIS_2','2021-2022',2,'valide'),(103008,'PSYCH_TEST','2022-2023',3,'valide'),
                            (103008,'PSYCH_CLIN','2022-2023',3,'valide'),(103008,'PROJET_PRO','2022-2023',4,'valide'),
                            (103008,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (103009,'PSYCH_GEN','2021-2022',1,'valide'),(103009,'PSYCH_DEV','2021-2022',1,'valide'),
                            (103009,'ANGLAIS_1','2021-2022',1,'valide'),(103009,'PSYCH_TRAV','2021-2022',2,'valide'),
                            (103009,'NEURO','2021-2022',2,'valide'),(103009,'ANGLAIS_2','2021-2022',2,'valide'),
                            (103009,'PSYCH_TEST','2022-2023',3,'valide'),(103009,'ENTRETIEN','2022-2023',3,'valide'),
                            (103009,'PROJET_PRO','2022-2023',4,'valide'),(103009,'ANGLAIS_3','2023-2024',5,'en_cours'),
                            (103010,'PSYCH_GEN','2021-2022',1,'valide'),(103010,'METHODO','2021-2022',1,'valide'),
                            (103010,'STATS_PSY','2021-2022',1,'valide'),(103010,'PSYCH_SOC','2021-2022',2,'valide'),
                            (103010,'PSYCH_TRAV','2021-2022',2,'valide'),(103010,'ANGLAIS_2','2021-2022',2,'valide'),
                            (103010,'PSYCH_TEST','2022-2023',3,'valide'),(103010,'PSYCH_CLIN','2022-2023',3,'valide'),
                            (103010,'PROJET_PRO','2022-2023',4,'valide'),(103010,'ANGLAIS_3','2023-2024',5,'en_cours');