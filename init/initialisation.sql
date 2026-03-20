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
                          semestre INT,
                          id_parcours INT,
                          FOREIGN KEY (id_parcours) REFERENCES Parcours(id_parcours)
);

CREATE TABLE Inscription (
                             num_etu INT,
                             code_ue VARCHAR(20),
                             annee_univ VARCHAR(9),
                             statut_validation VARCHAR(20) DEFAULT 'en_cours',
                             PRIMARY KEY (num_etu, code_ue, annee_univ, semestre),
                             FOREIGN KEY (num_etu) REFERENCES Etudiant(num_etu),
                             FOREIGN KEY (code_ue) REFERENCES UE(code_ue)
);

-- ==========================================
-- 1. INSERTIONS DES MENTIONS
-- ==========================================
INSERT INTO Mention (id_mention, nom_mention) VALUES
                                                  (1, 'MIASHS'),
                                                  (2, 'Informatique'),
                                                  (3, 'Mathématiques'),
                                                  (4, 'Droit');

-- ==========================================
-- 2. INSERTIONS DES PARCOURS
-- ==========================================
INSERT INTO Parcours (id_parcours, nom_parcours, id_mention) VALUES
                                                                 (1, 'MIAGE', 1),
                                                                 (2, 'Ingénierie Opérationnelle', 1),
                                                                 (3, 'Développement Logiciel', 2),
                                                                 (4, 'Data Science', 2),
                                                                 (5, 'Intelligence Artificielle', 2),
                                                                 (6, 'Réseaux et Sécurité', 2),
                                                                 (7, 'Statistiques', 3),
                                                                 (8, 'Algèbre', 3),
                                                                 (9, 'Mathématiques Appliquées', 3),
                                                                 (10, 'Droit Public', 4),
                                                                 (11, 'Droit Privé', 4),
                                                                 (12, 'Droit des Affaires', 4);

-- ==========================================
-- 3. INSERTIONS DES UEs (Déclinées S1 à S6)
-- ==========================================
INSERT INTO UE (code_ue, nom_ue, nb_credits) VALUES
-- TRANSVERSALES (Communes à toute l'université)
('ANG_S1', 'Anglais S1', 3), ('ANG_S2', 'Anglais S2', 3), ('ANG_S3', 'Anglais S3', 3), ('ANG_S4', 'Anglais S4', 3), ('ANG_S5', 'Anglais S5', 3), ('ANG_S6', 'Anglais S6', 3),
('COMPRO_S1', 'Com Professionnelle S1', 3), ('COMPRO_S2', 'Com Professionnelle S2', 3), ('COMPRO_S3', 'Com Professionnelle S3', 3), ('COMPRO_S4', 'Com Professionnelle S4', 3), ('COMPRO_S5', 'Com Professionnelle S5', 3), ('COMPRO_S6', 'Com Professionnelle S6', 3),

-- TRONC COMMUN SCIENCES (MIASHS, Info, Maths)
('ALGO_S1', 'Algorithmique S1', 6), ('ALGO_S2', 'Algorithmique S2', 6), ('ALGO_S3', 'Algorithmique S3', 6), ('ALGO_S4', 'Algorithmique S4', 6), ('ALGO_S5', 'Algorithmique S5', 6), ('ALGO_S6', 'Algorithmique S6', 6),
('MDISC_S1', 'Maths Discrètes S1', 3), ('MDISC_S2', 'Maths Discrètes S2', 3), ('MDISC_S3', 'Maths Discrètes S3', 3), ('MDISC_S4', 'Maths Discrètes S4', 3), ('MDISC_S5', 'Maths Discrètes S5', 3), ('MDISC_S6', 'Maths Discrètes S6', 3),

-- TRONC COMMUN DROIT
('DCONST_S1', 'Droit Constitutionnel S1', 6), ('DCONST_S2', 'Droit Constitutionnel S2', 6), ('DCONST_S3', 'Droit Constitutionnel S3', 6), ('DCONST_S4', 'Droit Constitutionnel S4', 6), ('DCONST_S5', 'Droit Constitutionnel S5', 6), ('DCONST_S6', 'Droit Constitutionnel S6', 6),
('HDROIT_S1', 'Histoire du Droit S1', 3), ('HDROIT_S2', 'Histoire du Droit S2', 3), ('HDROIT_S3', 'Histoire du Droit S3', 3), ('HDROIT_S4', 'Histoire du Droit S4', 3), ('HDROIT_S5', 'Histoire du Droit S5', 3), ('HDROIT_S6', 'Histoire du Droit S6', 3),

-- SPÉCIALITÉS MIASHS
('ECOG_S1', 'Économie et Gestion S1', 6), ('ECOG_S2', 'Économie et Gestion S2', 6), ('ECOG_S3', 'Économie et Gestion S3', 6), ('ECOG_S4', 'Économie et Gestion S4', 6), ('ECOG_S5', 'Économie et Gestion S5', 6), ('ECOG_S6', 'Économie et Gestion S6', 6),
('COMP_S1', 'Comptabilité S1', 3), ('COMP_S2', 'Comptabilité S2', 3), ('COMP_S3', 'Comptabilité S3', 3), ('COMP_S4', 'Comptabilité S4', 3), ('COMP_S5', 'Comptabilité S5', 3), ('COMP_S6', 'Comptabilité S6', 3),
('SINF_S1', 'Systèmes Info S1', 3), ('SINF_S2', 'Systèmes Info S2', 3), ('SINF_S3', 'Systèmes Info S3', 3), ('SINF_S4', 'Systèmes Info S4', 3), ('SINF_S5', 'Systèmes Info S5', 3), ('SINF_S6', 'Systèmes Info S6', 3),
('RECHOP_S1', 'Recherche Opé S1', 3), ('RECHOP_S2', 'Recherche Opé S2', 3), ('RECHOP_S3', 'Recherche Opé S3', 3), ('RECHOP_S4', 'Recherche Opé S4', 3), ('RECHOP_S5', 'Recherche Opé S5', 3), ('RECHOP_S6', 'Recherche Opé S6', 3),
('MODEL_S1', 'Modélisation S1', 3), ('MODEL_S2', 'Modélisation S2', 3), ('MODEL_S3', 'Modélisation S3', 3), ('MODEL_S4', 'Modélisation S4', 3), ('MODEL_S5', 'Modélisation S5', 3), ('MODEL_S6', 'Modélisation S6', 3),
('STATAPP_S1', 'Stats Appliquées S1', 3), ('STATAPP_S2', 'Stats Appliquées S2', 3), ('STATAPP_S3', 'Stats Appliquées S3', 3), ('STATAPP_S4', 'Stats Appliquées S4', 3), ('STATAPP_S5', 'Stats Appliquées S5', 3), ('STATAPP_S6', 'Stats Appliquées S6', 3),

-- SPÉCIALITÉS INFORMATIQUE
('JAVAPOO_S1', 'Java Avancé S1', 6), ('JAVAPOO_S2', 'Java Avancé S2', 6), ('JAVAPOO_S3', 'Java Avancé S3', 6), ('JAVAPOO_S4', 'Java Avancé S4', 6), ('JAVAPOO_S5', 'Java Avancé S5', 6), ('JAVAPOO_S6', 'Java Avancé S6', 6),
('DWEB_S1', 'Dév Web S1', 3), ('DWEB_S2', 'Dév Web S2', 3), ('DWEB_S3', 'Dév Web S3', 3), ('DWEB_S4', 'Dév Web S4', 3), ('DWEB_S5', 'Dév Web S5', 3), ('DWEB_S6', 'Dév Web S6', 3),
('BDDSQL_S1', 'Base de Données S1', 3), ('BDDSQL_S2', 'Base de Données S2', 3), ('BDDSQL_S3', 'Base de Données S3', 3), ('BDDSQL_S4', 'Base de Données S4', 3), ('BDDSQL_S5', 'Base de Données S5', 3), ('BDDSQL_S6', 'Base de Données S6', 3),
('GLOG_S1', 'Génie Logiciel S1', 3), ('GLOG_S2', 'Génie Logiciel S2', 3), ('GLOG_S3', 'Génie Logiciel S3', 3), ('GLOG_S4', 'Génie Logiciel S4', 3), ('GLOG_S5', 'Génie Logiciel S5', 3), ('GLOG_S6', 'Génie Logiciel S6', 3),
('BDDADV_S1', 'BDD Avancées S1', 6), ('BDDADV_S2', 'BDD Avancées S2', 6), ('BDDADV_S3', 'BDD Avancées S3', 6), ('BDDADV_S4', 'BDD Avancées S4', 6), ('BDDADV_S5', 'BDD Avancées S5', 6), ('BDDADV_S6', 'BDD Avancées S6', 6),
('BIGDAT_S1', 'Big Data S1', 3), ('BIGDAT_S2', 'Big Data S2', 3), ('BIGDAT_S3', 'Big Data S3', 3), ('BIGDAT_S4', 'Big Data S4', 3), ('BIGDAT_S5', 'Big Data S5', 3), ('BIGDAT_S6', 'Big Data S6', 3),
('PYTH_S1', 'Python S1', 3), ('PYTH_S2', 'Python S2', 3), ('PYTH_S3', 'Python S3', 3), ('PYTH_S4', 'Python S4', 3), ('PYTH_S5', 'Python S5', 3), ('PYTH_S6', 'Python S6', 3),
('STATDAT_S1', 'Stats pour Data S1', 3), ('STATDAT_S2', 'Stats pour Data S2', 3), ('STATDAT_S3', 'Stats pour Data S3', 3), ('STATDAT_S4', 'Stats pour Data S4', 3), ('STATDAT_S5', 'Stats pour Data S5', 3), ('STATDAT_S6', 'Stats pour Data S6', 3),
('MACHL_S1', 'Machine Learning S1', 6), ('MACHL_S2', 'Machine Learning S2', 6), ('MACHL_S3', 'Machine Learning S3', 6), ('MACHL_S4', 'Machine Learning S4', 6), ('MACHL_S5', 'Machine Learning S5', 6), ('MACHL_S6', 'Machine Learning S6', 6),
('DEEPL_S1', 'Deep Learning S1', 3), ('DEEPL_S2', 'Deep Learning S2', 3), ('DEEPL_S3', 'Deep Learning S3', 3), ('DEEPL_S4', 'Deep Learning S4', 3), ('DEEPL_S5', 'Deep Learning S5', 3), ('DEEPL_S6', 'Deep Learning S6', 3),
('IAETH_S1', 'IA et Éthique S1', 3), ('IAETH_S2', 'IA et Éthique S2', 3), ('IAETH_S3', 'IA et Éthique S3', 3), ('IAETH_S4', 'IA et Éthique S4', 3), ('IAETH_S5', 'IA et Éthique S5', 3), ('IAETH_S6', 'IA et Éthique S6', 3),
('RESLOC_S1', 'Réseaux Locaux S1', 6), ('RESLOC_S2', 'Réseaux Locaux S2', 6), ('RESLOC_S3', 'Réseaux Locaux S3', 6), ('RESLOC_S4', 'Réseaux Locaux S4', 6), ('RESLOC_S5', 'Réseaux Locaux S5', 6), ('RESLOC_S6', 'Réseaux Locaux S6', 6),
('SECINFO_S1', 'Sécurité Info S1', 3), ('SECINFO_S2', 'Sécurité Info S2', 3), ('SECINFO_S3', 'Sécurité Info S3', 3), ('SECINFO_S4', 'Sécurité Info S4', 3), ('SECINFO_S5', 'Sécurité Info S5', 3), ('SECINFO_S6', 'Sécurité Info S6', 3),
('ADMSYS_S1', 'Admin Système S1', 3), ('ADMSYS_S2', 'Admin Système S2', 3), ('ADMSYS_S3', 'Admin Système S3', 3), ('ADMSYS_S4', 'Admin Système S4', 3), ('ADMSYS_S5', 'Admin Système S5', 3), ('ADMSYS_S6', 'Admin Système S6', 3),
('CLOUD_S1', 'Cloud Computing S1', 3), ('CLOUD_S2', 'Cloud Computing S2', 3), ('CLOUD_S3', 'Cloud Computing S3', 3), ('CLOUD_S4', 'Cloud Computing S4', 3), ('CLOUD_S5', 'Cloud Computing S5', 3), ('CLOUD_S6', 'Cloud Computing S6', 3),

-- SPÉCIALITÉS MATHÉMATIQUES
('PROBA_S1', 'Probabilités S1', 6), ('PROBA_S2', 'Probabilités S2', 6), ('PROBA_S3', 'Probabilités S3', 6), ('PROBA_S4', 'Probabilités S4', 6), ('PROBA_S5', 'Probabilités S5', 6), ('PROBA_S6', 'Probabilités S6', 6),
('STATINF_S1', 'Stats Inférentielles S1', 3), ('STATINF_S2', 'Stats Inférentielles S2', 3), ('STATINF_S3', 'Stats Inférentielles S3', 3), ('STATINF_S4', 'Stats Inférentielles S4', 3), ('STATINF_S5', 'Stats Inférentielles S5', 3), ('STATINF_S6', 'Stats Inférentielles S6', 3),
('LOGR_S1', 'Logiciel R S1', 3), ('LOGR_S2', 'Logiciel R S2', 3), ('LOGR_S3', 'Logiciel R S3', 3), ('LOGR_S4', 'Logiciel R S4', 3), ('LOGR_S5', 'Logiciel R S5', 3), ('LOGR_S6', 'Logiciel R S6', 3),
('SONDAG_S1', 'Théorie Sondages S1', 3), ('SONDAG_S2', 'Théorie Sondages S2', 3), ('SONDAG_S3', 'Théorie Sondages S3', 3), ('SONDAG_S4', 'Théorie Sondages S4', 3), ('SONDAG_S5', 'Théorie Sondages S5', 3), ('SONDAG_S6', 'Théorie Sondages S6', 3),
('ALGLIN_S1', 'Algèbre Linéaire S1', 6), ('ALGLIN_S2', 'Algèbre Linéaire S2', 6), ('ALGLIN_S3', 'Algèbre Linéaire S3', 6), ('ALGLIN_S4', 'Algèbre Linéaire S4', 6), ('ALGLIN_S5', 'Algèbre Linéaire S5', 6), ('ALGLIN_S6', 'Algèbre Linéaire S6', 6),
('ARITH_S1', 'Arithmétique S1', 3), ('ARITH_S2', 'Arithmétique S2', 3), ('ARITH_S3', 'Arithmétique S3', 3), ('ARITH_S4', 'Arithmétique S4', 3), ('ARITH_S5', 'Arithmétique S5', 3), ('ARITH_S6', 'Arithmétique S6', 3),
('GEOM_S1', 'Géométrie S1', 3), ('GEOM_S2', 'Géométrie S2', 3), ('GEOM_S3', 'Géométrie S3', 3), ('GEOM_S4', 'Géométrie S4', 3), ('GEOM_S5', 'Géométrie S5', 3), ('GEOM_S6', 'Géométrie S6', 3),
('TOPO_S1', 'Topologie S1', 3), ('TOPO_S2', 'Topologie S2', 3), ('TOPO_S3', 'Topologie S3', 3), ('TOPO_S4', 'Topologie S4', 3), ('TOPO_S5', 'Topologie S5', 3), ('TOPO_S6', 'Topologie S6', 3),
('EQDIF_S1', 'Équations Diff S1', 6), ('EQDIF_S2', 'Équations Diff S2', 6), ('EQDIF_S3', 'Équations Diff S3', 6), ('EQDIF_S4', 'Équations Diff S4', 6), ('EQDIF_S5', 'Équations Diff S5', 6), ('EQDIF_S6', 'Équations Diff S6', 6),
('ANANUM_S1', 'Analyse Numérique S1', 3), ('ANANUM_S2', 'Analyse Numérique S2', 3), ('ANANUM_S3', 'Analyse Numérique S3', 3), ('ANANUM_S4', 'Analyse Numérique S4', 3), ('ANANUM_S5', 'Analyse Numérique S5', 3), ('ANANUM_S6', 'Analyse Numérique S6', 3),
('OPTI_S1', 'Optimisation S1', 3), ('OPTI_S2', 'Optimisation S2', 3), ('OPTI_S3', 'Optimisation S3', 3), ('OPTI_S4', 'Optimisation S4', 3), ('OPTI_S5', 'Optimisation S5', 3), ('OPTI_S6', 'Optimisation S6', 3),

-- SPÉCIALITÉS DROIT
('DADM_S1', 'Droit Administratif S1', 6), ('DADM_S2', 'Droit Administratif S2', 6), ('DADM_S3', 'Droit Administratif S3', 6), ('DADM_S4', 'Droit Administratif S4', 6), ('DADM_S5', 'Droit Administratif S5', 6), ('DADM_S6', 'Droit Administratif S6', 6),
('LIBPUB_S1', 'Libertés Publiques S1', 3), ('LIBPUB_S2', 'Libertés Publiques S2', 3), ('LIBPUB_S3', 'Libertés Publiques S3', 3), ('LIBPUB_S4', 'Libertés Publiques S4', 3), ('LIBPUB_S5', 'Libertés Publiques S5', 3), ('LIBPUB_S6', 'Libertés Publiques S6', 3),
('DINT_S1', 'Droit International S1', 3), ('DINT_S2', 'Droit International S2', 3), ('DINT_S3', 'Droit International S3', 3), ('DINT_S4', 'Droit International S4', 3), ('DINT_S5', 'Droit International S5', 3), ('DINT_S6', 'Droit International S6', 3),
('DFISC_S1', 'Droit Fiscal S1', 3), ('DFISC_S2', 'Droit Fiscal S2', 3), ('DFISC_S3', 'Droit Fiscal S3', 3), ('DFISC_S4', 'Droit Fiscal S4', 3), ('DFISC_S5', 'Droit Fiscal S5', 3), ('DFISC_S6', 'Droit Fiscal S6', 3),
('DCIVIL_S1', 'Droit Civil S1', 6), ('DCIVIL_S2', 'Droit Civil S2', 6), ('DCIVIL_S3', 'Droit Civil S3', 6), ('DCIVIL_S4', 'Droit Civil S4', 6), ('DCIVIL_S5', 'Droit Civil S5', 6), ('DCIVIL_S6', 'Droit Civil S6', 6),
('DPENAL_S1', 'Droit Pénal S1', 3), ('DPENAL_S2', 'Droit Pénal S2', 3), ('DPENAL_S3', 'Droit Pénal S3', 3), ('DPENAL_S4', 'Droit Pénal S4', 3), ('DPENAL_S5', 'Droit Pénal S5', 3), ('DPENAL_S6', 'Droit Pénal S6', 3),
('PROCIV_S1', 'Procédure Civile S1', 3), ('PROCIV_S2', 'Procédure Civile S2', 3), ('PROCIV_S3', 'Procédure Civile S3', 3), ('PROCIV_S4', 'Procédure Civile S4', 3), ('PROCIV_S5', 'Procédure Civile S5', 3), ('PROCIV_S6', 'Procédure Civile S6', 3),
('DFAM_S1', 'Droit de la Famille S1', 3), ('DFAM_S2', 'Droit de la Famille S2', 3), ('DFAM_S3', 'Droit de la Famille S3', 3), ('DFAM_S4', 'Droit de la Famille S4', 3), ('DFAM_S5', 'Droit de la Famille S5', 3), ('DFAM_S6', 'Droit de la Famille S6', 3),
('DCOM_S1', 'Droit Commercial S1', 6), ('DCOM_S2', 'Droit Commercial S2', 6), ('DCOM_S3', 'Droit Commercial S3', 6), ('DCOM_S4', 'Droit Commercial S4', 6), ('DCOM_S5', 'Droit Commercial S5', 6), ('DCOM_S6', 'Droit Commercial S6', 6),
('DSOC_S1', 'Droit Social S1', 3), ('DSOC_S2', 'Droit Social S2', 3), ('DSOC_S3', 'Droit Social S3', 3), ('DSOC_S4', 'Droit Social S4', 3), ('DSOC_S5', 'Droit Social S5', 3), ('DSOC_S6', 'Droit Social S6', 3),
('FISCEN_S1', 'Fiscalité Entreprise S1', 3), ('FISCEN_S2', 'Fiscalité Entreprise S2', 3), ('FISCEN_S3', 'Fiscalité Entreprise S3', 3), ('FISCEN_S4', 'Fiscalité Entreprise S4', 3), ('FISCEN_S5', 'Fiscalité Entreprise S5', 3), ('FISCEN_S6', 'Fiscalité Entreprise S6', 3),
('DBANQ_S1', 'Droit Bancaire S1', 3), ('DBANQ_S2', 'Droit Bancaire S2', 3), ('DBANQ_S3', 'Droit Bancaire S3', 3), ('DBANQ_S4', 'Droit Bancaire S4', 3), ('DBANQ_S5', 'Droit Bancaire S5', 3), ('DBANQ_S6', 'Droit Bancaire S6', 3);

-- ==========================================
-- 4. INSERTIONS DE STRUCTURE_PARCOURS
-- ==========================================
INSERT INTO Structure_Parcours (id_parcours, code_ue, est_obligatoire, semestrePrevu) VALUES
-- 1. PARCOURS MIAGE (S1 à S6)
(1, 'ANG_S1', TRUE, 1), (1, 'COMPRO_S1', TRUE, 1), (1, 'ALGO_S1', TRUE, 1), (1, 'MDISC_S1', TRUE, 1), (1, 'ECOG_S1', TRUE, 1), (1, 'COMP_S1', TRUE, 1), (1, 'SINF_S1', TRUE, 1), (1, 'DWEB_S1', TRUE, 1),
(1, 'ANG_S2', TRUE, 2), (1, 'COMPRO_S2', TRUE, 2), (1, 'ALGO_S2', TRUE, 2), (1, 'MDISC_S2', TRUE, 2), (1, 'ECOG_S2', TRUE, 2), (1, 'COMP_S2', TRUE, 2), (1, 'SINF_S2', TRUE, 2), (1, 'DWEB_S2', TRUE, 2),
(1, 'ANG_S3', TRUE, 3), (1, 'COMPRO_S3', TRUE, 3), (1, 'ALGO_S3', TRUE, 3), (1, 'MDISC_S3', TRUE, 3), (1, 'ECOG_S3', TRUE, 3), (1, 'COMP_S3', TRUE, 3), (1, 'SINF_S3', TRUE, 3), (1, 'DWEB_S3', TRUE, 3),
(1, 'ANG_S4', TRUE, 4), (1, 'COMPRO_S4', TRUE, 4), (1, 'ALGO_S4', TRUE, 4), (1, 'MDISC_S4', TRUE, 4), (1, 'ECOG_S4', TRUE, 4), (1, 'COMP_S4', TRUE, 4), (1, 'SINF_S4', TRUE, 4), (1, 'DWEB_S4', TRUE, 4),
(1, 'ANG_S5', TRUE, 5), (1, 'COMPRO_S5', TRUE, 5), (1, 'ALGO_S5', TRUE, 5), (1, 'MDISC_S5', TRUE, 5), (1, 'ECOG_S5', TRUE, 5), (1, 'COMP_S5', TRUE, 5), (1, 'SINF_S5', TRUE, 5), (1, 'DWEB_S5', TRUE, 5),
(1, 'ANG_S6', TRUE, 6), (1, 'COMPRO_S6', TRUE, 6), (1, 'ALGO_S6', TRUE, 6), (1, 'MDISC_S6', TRUE, 6), (1, 'ECOG_S6', TRUE, 6), (1, 'COMP_S6', TRUE, 6), (1, 'SINF_S6', TRUE, 6), (1, 'DWEB_S6', TRUE, 6),

-- 2. PARCOURS INGÉNIERIE OPÉRATIONNELLE
(2, 'ANG_S1', TRUE, 1), (2, 'COMPRO_S1', TRUE, 1), (2, 'ALGO_S1', TRUE, 1), (2, 'MDISC_S1', TRUE, 1), (2, 'ECOG_S1', TRUE, 1), (2, 'RECHOP_S1', TRUE, 1), (2, 'MODEL_S1', TRUE, 1), (2, 'STATAPP_S1', TRUE, 1),
(2, 'ANG_S2', TRUE, 2), (2, 'COMPRO_S2', TRUE, 2), (2, 'ALGO_S2', TRUE, 2), (2, 'MDISC_S2', TRUE, 2), (2, 'ECOG_S2', TRUE, 2), (2, 'RECHOP_S2', TRUE, 2), (2, 'MODEL_S2', TRUE, 2), (2, 'STATAPP_S2', TRUE, 2),
(2, 'ANG_S3', TRUE, 3), (2, 'COMPRO_S3', TRUE, 3), (2, 'ALGO_S3', TRUE, 3), (2, 'MDISC_S3', TRUE, 3), (2, 'ECOG_S3', TRUE, 3), (2, 'RECHOP_S3', TRUE, 3), (2, 'MODEL_S3', TRUE, 3), (2, 'STATAPP_S3', TRUE, 3),
(2, 'ANG_S4', TRUE, 4), (2, 'COMPRO_S4', TRUE, 4), (2, 'ALGO_S4', TRUE, 4), (2, 'MDISC_S4', TRUE, 4), (2, 'ECOG_S4', TRUE, 4), (2, 'RECHOP_S4', TRUE, 4), (2, 'MODEL_S4', TRUE, 4), (2, 'STATAPP_S4', TRUE, 4),
(2, 'ANG_S5', TRUE, 5), (2, 'COMPRO_S5', TRUE, 5), (2, 'ALGO_S5', TRUE, 5), (2, 'MDISC_S5', TRUE, 5), (2, 'ECOG_S5', TRUE, 5), (2, 'RECHOP_S5', TRUE, 5), (2, 'MODEL_S5', TRUE, 5), (2, 'STATAPP_S5', TRUE, 5),
(2, 'ANG_S6', TRUE, 6), (2, 'COMPRO_S6', TRUE, 6), (2, 'ALGO_S6', TRUE, 6), (2, 'MDISC_S6', TRUE, 6), (2, 'ECOG_S6', TRUE, 6), (2, 'RECHOP_S6', TRUE, 6), (2, 'MODEL_S6', TRUE, 6), (2, 'STATAPP_S6', TRUE, 6),

-- 3. PARCOURS DÉVELOPPEMENT LOGICIEL
(3, 'ANG_S1', TRUE, 1), (3, 'COMPRO_S1', TRUE, 1), (3, 'ALGO_S1', TRUE, 1), (3, 'MDISC_S1', TRUE, 1), (3, 'JAVAPOO_S1', TRUE, 1), (3, 'DWEB_S1', TRUE, 1), (3, 'BDDSQL_S1', TRUE, 1), (3, 'GLOG_S1', TRUE, 1),
(3, 'ANG_S2', TRUE, 2), (3, 'COMPRO_S2', TRUE, 2), (3, 'ALGO_S2', TRUE, 2), (3, 'MDISC_S2', TRUE, 2), (3, 'JAVAPOO_S2', TRUE, 2), (3, 'DWEB_S2', TRUE, 2), (3, 'BDDSQL_S2', TRUE, 2), (3, 'GLOG_S2', TRUE, 2),
(3, 'ANG_S3', TRUE, 3), (3, 'COMPRO_S3', TRUE, 3), (3, 'ALGO_S3', TRUE, 3), (3, 'MDISC_S3', TRUE, 3), (3, 'JAVAPOO_S3', TRUE, 3), (3, 'DWEB_S3', TRUE, 3), (3, 'BDDSQL_S3', TRUE, 3), (3, 'GLOG_S3', TRUE, 3),
(3, 'ANG_S4', TRUE, 4), (3, 'COMPRO_S4', TRUE, 4), (3, 'ALGO_S4', TRUE, 4), (3, 'MDISC_S4', TRUE, 4), (3, 'JAVAPOO_S4', TRUE, 4), (3, 'DWEB_S4', TRUE, 4), (3, 'BDDSQL_S4', TRUE, 4), (3, 'GLOG_S4', TRUE, 4),
(3, 'ANG_S5', TRUE, 5), (3, 'COMPRO_S5', TRUE, 5), (3, 'ALGO_S5', TRUE, 5), (3, 'MDISC_S5', TRUE, 5), (3, 'JAVAPOO_S5', TRUE, 5), (3, 'DWEB_S5', TRUE, 5), (3, 'BDDSQL_S5', TRUE, 5), (3, 'GLOG_S5', TRUE, 5),
(3, 'ANG_S6', TRUE, 6), (3, 'COMPRO_S6', TRUE, 6), (3, 'ALGO_S6', TRUE, 6), (3, 'MDISC_S6', TRUE, 6), (3, 'JAVAPOO_S6', TRUE, 6), (3, 'DWEB_S6', TRUE, 6), (3, 'BDDSQL_S6', TRUE, 6), (3, 'GLOG_S6', TRUE, 6),

-- 4. PARCOURS DATA SCIENCE
(4, 'ANG_S1', TRUE, 1), (4, 'COMPRO_S1', TRUE, 1), (4, 'ALGO_S1', TRUE, 1), (4, 'MDISC_S1', TRUE, 1), (4, 'BDDADV_S1', TRUE, 1), (4, 'BIGDAT_S1', TRUE, 1), (4, 'PYTH_S1', TRUE, 1), (4, 'STATDAT_S1', TRUE, 1),
(4, 'ANG_S2', TRUE, 2), (4, 'COMPRO_S2', TRUE, 2), (4, 'ALGO_S2', TRUE, 2), (4, 'MDISC_S2', TRUE, 2), (4, 'BDDADV_S2', TRUE, 2), (4, 'BIGDAT_S2', TRUE, 2), (4, 'PYTH_S2', TRUE, 2), (4, 'STATDAT_S2', TRUE, 2),
(4, 'ANG_S3', TRUE, 3), (4, 'COMPRO_S3', TRUE, 3), (4, 'ALGO_S3', TRUE, 3), (4, 'MDISC_S3', TRUE, 3), (4, 'BDDADV_S3', TRUE, 3), (4, 'BIGDAT_S3', TRUE, 3), (4, 'PYTH_S3', TRUE, 3), (4, 'STATDAT_S3', TRUE, 3),
(4, 'ANG_S4', TRUE, 4), (4, 'COMPRO_S4', TRUE, 4), (4, 'ALGO_S4', TRUE, 4), (4, 'MDISC_S4', TRUE, 4), (4, 'BDDADV_S4', TRUE, 4), (4, 'BIGDAT_S4', TRUE, 4), (4, 'PYTH_S4', TRUE, 4), (4, 'STATDAT_S4', TRUE, 4),
(4, 'ANG_S5', TRUE, 5), (4, 'COMPRO_S5', TRUE, 5), (4, 'ALGO_S5', TRUE, 5), (4, 'MDISC_S5', TRUE, 5), (4, 'BDDADV_S5', TRUE, 5), (4, 'BIGDAT_S5', TRUE, 5), (4, 'PYTH_S5', TRUE, 5), (4, 'STATDAT_S5', TRUE, 5),
(4, 'ANG_S6', TRUE, 6), (4, 'COMPRO_S6', TRUE, 6), (4, 'ALGO_S6', TRUE, 6), (4, 'MDISC_S6', TRUE, 6), (4, 'BDDADV_S6', TRUE, 6), (4, 'BIGDAT_S6', TRUE, 6), (4, 'PYTH_S6', TRUE, 6), (4, 'STATDAT_S6', TRUE, 6),

-- 5. PARCOURS INTELLIGENCE ARTIFICIELLE
(5, 'ANG_S1', TRUE, 1), (5, 'COMPRO_S1', TRUE, 1), (5, 'ALGO_S1', TRUE, 1), (5, 'MDISC_S1', TRUE, 1), (5, 'MACHL_S1', TRUE, 1), (5, 'PYTH_S1', TRUE, 1), (5, 'DEEPL_S1', TRUE, 1), (5, 'IAETH_S1', TRUE, 1),
(5, 'ANG_S2', TRUE, 2), (5, 'COMPRO_S2', TRUE, 2), (5, 'ALGO_S2', TRUE, 2), (5, 'MDISC_S2', TRUE, 2), (5, 'MACHL_S2', TRUE, 2), (5, 'PYTH_S2', TRUE, 2), (5, 'DEEPL_S2', TRUE, 2), (5, 'IAETH_S2', TRUE, 2),
(5, 'ANG_S3', TRUE, 3), (5, 'COMPRO_S3', TRUE, 3), (5, 'ALGO_S3', TRUE, 3), (5, 'MDISC_S3', TRUE, 3), (5, 'MACHL_S3', TRUE, 3), (5, 'PYTH_S3', TRUE, 3), (5, 'DEEPL_S3', TRUE, 3), (5, 'IAETH_S3', TRUE, 3),
(5, 'ANG_S4', TRUE, 4), (5, 'COMPRO_S4', TRUE, 4), (5, 'ALGO_S4', TRUE, 4), (5, 'MDISC_S4', TRUE, 4), (5, 'MACHL_S4', TRUE, 4), (5, 'PYTH_S4', TRUE, 4), (5, 'DEEPL_S4', TRUE, 4), (5, 'IAETH_S4', TRUE, 4),
(5, 'ANG_S5', TRUE, 5), (5, 'COMPRO_S5', TRUE, 5), (5, 'ALGO_S5', TRUE, 5), (5, 'MDISC_S5', TRUE, 5), (5, 'MACHL_S5', TRUE, 5), (5, 'PYTH_S5', TRUE, 5), (5, 'DEEPL_S5', TRUE, 5), (5, 'IAETH_S5', TRUE, 5),
(5, 'ANG_S6', TRUE, 6), (5, 'COMPRO_S6', TRUE, 6), (5, 'ALGO_S6', TRUE, 6), (5, 'MDISC_S6', TRUE, 6), (5, 'MACHL_S6', TRUE, 6), (5, 'PYTH_S6', TRUE, 6), (5, 'DEEPL_S6', TRUE, 6), (5, 'IAETH_S6', TRUE, 6),

-- 6. PARCOURS RÉSEAUX ET SÉCURITÉ
(6, 'ANG_S1', TRUE, 1), (6, 'COMPRO_S1', TRUE, 1), (6, 'ALGO_S1', TRUE, 1), (6, 'MDISC_S1', TRUE, 1), (6, 'RESLOC_S1', TRUE, 1), (6, 'SECINFO_S1', TRUE, 1), (6, 'ADMSYS_S1', TRUE, 1), (6, 'CLOUD_S1', TRUE, 1),
(6, 'ANG_S2', TRUE, 2), (6, 'COMPRO_S2', TRUE, 2), (6, 'ALGO_S2', TRUE, 2), (6, 'MDISC_S2', TRUE, 2), (6, 'RESLOC_S2', TRUE, 2), (6, 'SECINFO_S2', TRUE, 2), (6, 'ADMSYS_S2', TRUE, 2), (6, 'CLOUD_S2', TRUE, 2),
(6, 'ANG_S3', TRUE, 3), (6, 'COMPRO_S3', TRUE, 3), (6, 'ALGO_S3', TRUE, 3), (6, 'MDISC_S3', TRUE, 3), (6, 'RESLOC_S3', TRUE, 3), (6, 'SECINFO_S3', TRUE, 3), (6, 'ADMSYS_S3', TRUE, 3), (6, 'CLOUD_S3', TRUE, 3),
(6, 'ANG_S4', TRUE, 4), (6, 'COMPRO_S4', TRUE, 4), (6, 'ALGO_S4', TRUE, 4), (6, 'MDISC_S4', TRUE, 4), (6, 'RESLOC_S4', TRUE, 4), (6, 'SECINFO_S4', TRUE, 4), (6, 'ADMSYS_S4', TRUE, 4), (6, 'CLOUD_S4', TRUE, 4),
(6, 'ANG_S5', TRUE, 5), (6, 'COMPRO_S5', TRUE, 5), (6, 'ALGO_S5', TRUE, 5), (6, 'MDISC_S5', TRUE, 5), (6, 'RESLOC_S5', TRUE, 5), (6, 'SECINFO_S5', TRUE, 5), (6, 'ADMSYS_S5', TRUE, 5), (6, 'CLOUD_S5', TRUE, 5),
(6, 'ANG_S6', TRUE, 6), (6, 'COMPRO_S6', TRUE, 6), (6, 'ALGO_S6', TRUE, 6), (6, 'MDISC_S6', TRUE, 6), (6, 'RESLOC_S6', TRUE, 6), (6, 'SECINFO_S6', TRUE, 6), (6, 'ADMSYS_S6', TRUE, 6), (6, 'CLOUD_S6', TRUE, 6),

-- 7. PARCOURS STATISTIQUES
(7, 'ANG_S1', TRUE, 1), (7, 'COMPRO_S1', TRUE, 1), (7, 'ALGO_S1', TRUE, 1), (7, 'MDISC_S1', TRUE, 1), (7, 'PROBA_S1', TRUE, 1), (7, 'STATINF_S1', TRUE, 1), (7, 'LOGR_S1', TRUE, 1), (7, 'SONDAG_S1', TRUE, 1),
(7, 'ANG_S2', TRUE, 2), (7, 'COMPRO_S2', TRUE, 2), (7, 'ALGO_S2', TRUE, 2), (7, 'MDISC_S2', TRUE, 2), (7, 'PROBA_S2', TRUE, 2), (7, 'STATINF_S2', TRUE, 2), (7, 'LOGR_S2', TRUE, 2), (7, 'SONDAG_S2', TRUE, 2),
(7, 'ANG_S3', TRUE, 3), (7, 'COMPRO_S3', TRUE, 3), (7, 'ALGO_S3', TRUE, 3), (7, 'MDISC_S3', TRUE, 3), (7, 'PROBA_S3', TRUE, 3), (7, 'STATINF_S3', TRUE, 3), (7, 'LOGR_S3', TRUE, 3), (7, 'SONDAG_S3', TRUE, 3),
(7, 'ANG_S4', TRUE, 4), (7, 'COMPRO_S4', TRUE, 4), (7, 'ALGO_S4', TRUE, 4), (7, 'MDISC_S4', TRUE, 4), (7, 'PROBA_S4', TRUE, 4), (7, 'STATINF_S4', TRUE, 4), (7, 'LOGR_S4', TRUE, 4), (7, 'SONDAG_S4', TRUE, 4),
(7, 'ANG_S5', TRUE, 5), (7, 'COMPRO_S5', TRUE, 5), (7, 'ALGO_S5', TRUE, 5), (7, 'MDISC_S5', TRUE, 5), (7, 'PROBA_S5', TRUE, 5), (7, 'STATINF_S5', TRUE, 5), (7, 'LOGR_S5', TRUE, 5), (7, 'SONDAG_S5', TRUE, 5),
(7, 'ANG_S6', TRUE, 6), (7, 'COMPRO_S6', TRUE, 6), (7, 'ALGO_S6', TRUE, 6), (7, 'MDISC_S6', TRUE, 6), (7, 'PROBA_S6', TRUE, 6), (7, 'STATINF_S6', TRUE, 6), (7, 'LOGR_S6', TRUE, 6), (7, 'SONDAG_S6', TRUE, 6),

-- 8. PARCOURS ALGÈBRE
(8, 'ANG_S1', TRUE, 1), (8, 'COMPRO_S1', TRUE, 1), (8, 'ALGO_S1', TRUE, 1), (8, 'MDISC_S1', TRUE, 1), (8, 'ALGLIN_S1', TRUE, 1), (8, 'ARITH_S1', TRUE, 1), (8, 'GEOM_S1', TRUE, 1), (8, 'TOPO_S1', TRUE, 1),
(8, 'ANG_S2', TRUE, 2), (8, 'COMPRO_S2', TRUE, 2), (8, 'ALGO_S2', TRUE, 2), (8, 'MDISC_S2', TRUE, 2), (8, 'ALGLIN_S2', TRUE, 2), (8, 'ARITH_S2', TRUE, 2), (8, 'GEOM_S2', TRUE, 2), (8, 'TOPO_S2', TRUE, 2),
(8, 'ANG_S3', TRUE, 3), (8, 'COMPRO_S3', TRUE, 3), (8, 'ALGO_S3', TRUE, 3), (8, 'MDISC_S3', TRUE, 3), (8, 'ALGLIN_S3', TRUE, 3), (8, 'ARITH_S3', TRUE, 3), (8, 'GEOM_S3', TRUE, 3), (8, 'TOPO_S3', TRUE, 3),
(8, 'ANG_S4', TRUE, 4), (8, 'COMPRO_S4', TRUE, 4), (8, 'ALGO_S4', TRUE, 4), (8, 'MDISC_S4', TRUE, 4), (8, 'ALGLIN_S4', TRUE, 4), (8, 'ARITH_S4', TRUE, 4), (8, 'GEOM_S4', TRUE, 4), (8, 'TOPO_S4', TRUE, 4),
(8, 'ANG_S5', TRUE, 5), (8, 'COMPRO_S5', TRUE, 5), (8, 'ALGO_S5', TRUE, 5), (8, 'MDISC_S5', TRUE, 5), (8, 'ALGLIN_S5', TRUE, 5), (8, 'ARITH_S5', TRUE, 5), (8, 'GEOM_S5', TRUE, 5), (8, 'TOPO_S5', TRUE, 5),
(8, 'ANG_S6', TRUE, 6), (8, 'COMPRO_S6', TRUE, 6), (8, 'ALGO_S6', TRUE, 6), (8, 'MDISC_S6', TRUE, 6), (8, 'ALGLIN_S6', TRUE, 6), (8, 'ARITH_S6', TRUE, 6), (8, 'GEOM_S6', TRUE, 6), (8, 'TOPO_S6', TRUE, 6),

-- 9. PARCOURS MATHÉMATIQUES APPLIQUÉES
(9, 'ANG_S1', TRUE, 1), (9, 'COMPRO_S1', TRUE, 1), (9, 'ALGO_S1', TRUE, 1), (9, 'MDISC_S1', TRUE, 1), (9, 'EQDIF_S1', TRUE, 1), (9, 'ANANUM_S1', TRUE, 1), (9, 'OPTI_S1', TRUE, 1), (9, 'MODEL_S1', TRUE, 1),
(9, 'ANG_S2', TRUE, 2), (9, 'COMPRO_S2', TRUE, 2), (9, 'ALGO_S2', TRUE, 2), (9, 'MDISC_S2', TRUE, 2), (9, 'EQDIF_S2', TRUE, 2), (9, 'ANANUM_S2', TRUE, 2), (9, 'OPTI_S2', TRUE, 2), (9, 'MODEL_S2', TRUE, 2),
(9, 'ANG_S3', TRUE, 3), (9, 'COMPRO_S3', TRUE, 3), (9, 'ALGO_S3', TRUE, 3), (9, 'MDISC_S3', TRUE, 3), (9, 'EQDIF_S3', TRUE, 3), (9, 'ANANUM_S3', TRUE, 3), (9, 'OPTI_S3', TRUE, 3), (9, 'MODEL_S3', TRUE, 3),
(9, 'ANG_S4', TRUE, 4), (9, 'COMPRO_S4', TRUE, 4), (9, 'ALGO_S4', TRUE, 4), (9, 'MDISC_S4', TRUE, 4), (9, 'EQDIF_S4', TRUE, 4), (9, 'ANANUM_S4', TRUE, 4), (9, 'OPTI_S4', TRUE, 4), (9, 'MODEL_S4', TRUE, 4),
(9, 'ANG_S5', TRUE, 5), (9, 'COMPRO_S5', TRUE, 5), (9, 'ALGO_S5', TRUE, 5), (9, 'MDISC_S5', TRUE, 5), (9, 'EQDIF_S5', TRUE, 5), (9, 'ANANUM_S5', TRUE, 5), (9, 'OPTI_S5', TRUE, 5), (9, 'MODEL_S5', TRUE, 5),
(9, 'ANG_S6', TRUE, 6), (9, 'COMPRO_S6', TRUE, 6), (9, 'ALGO_S6', TRUE, 6), (9, 'MDISC_S6', TRUE, 6), (9, 'EQDIF_S6', TRUE, 6), (9, 'ANANUM_S6', TRUE, 6), (9, 'OPTI_S6', TRUE, 6), (9, 'MODEL_S6', TRUE, 6),

-- 10. PARCOURS DROIT PUBLIC
(10, 'ANG_S1', TRUE, 1), (10, 'COMPRO_S1', TRUE, 1), (10, 'DCONST_S1', TRUE, 1), (10, 'HDROIT_S1', TRUE, 1), (10, 'DADM_S1', TRUE, 1), (10, 'LIBPUB_S1', TRUE, 1), (10, 'DINT_S1', TRUE, 1), (10, 'DFISC_S1', TRUE, 1),
(10, 'ANG_S2', TRUE, 2), (10, 'COMPRO_S2', TRUE, 2), (10, 'DCONST_S2', TRUE, 2), (10, 'HDROIT_S2', TRUE, 2), (10, 'DADM_S2', TRUE, 2), (10, 'LIBPUB_S2', TRUE, 2), (10, 'DINT_S2', TRUE, 2), (10, 'DFISC_S2', TRUE, 2),
(10, 'ANG_S3', TRUE, 3), (10, 'COMPRO_S3', TRUE, 3), (10, 'DCONST_S3', TRUE, 3), (10, 'HDROIT_S3', TRUE, 3), (10, 'DADM_S3', TRUE, 3), (10, 'LIBPUB_S3', TRUE, 3), (10, 'DINT_S3', TRUE, 3), (10, 'DFISC_S3', TRUE, 3),
(10, 'ANG_S4', TRUE, 4), (10, 'COMPRO_S4', TRUE, 4), (10, 'DCONST_S4', TRUE, 4), (10, 'HDROIT_S4', TRUE, 4), (10, 'DADM_S4', TRUE, 4), (10, 'LIBPUB_S4', TRUE, 4), (10, 'DINT_S4', TRUE, 4), (10, 'DFISC_S4', TRUE, 4),
(10, 'ANG_S5', TRUE, 5), (10, 'COMPRO_S5', TRUE, 5), (10, 'DCONST_S5', TRUE, 5), (10, 'HDROIT_S5', TRUE, 5), (10, 'DADM_S5', TRUE, 5), (10, 'LIBPUB_S5', TRUE, 5), (10, 'DINT_S5', TRUE, 5), (10, 'DFISC_S5', TRUE, 5),
(10, 'ANG_S6', TRUE, 6), (10, 'COMPRO_S6', TRUE, 6), (10, 'DCONST_S6', TRUE, 6), (10, 'HDROIT_S6', TRUE, 6), (10, 'DADM_S6', TRUE, 6), (10, 'LIBPUB_S6', TRUE, 6), (10, 'DINT_S6', TRUE, 6), (10, 'DFISC_S6', TRUE, 6),

-- 11. PARCOURS DROIT PRIVÉ
(11, 'ANG_S1', TRUE, 1), (11, 'COMPRO_S1', TRUE, 1), (11, 'DCONST_S1', TRUE, 1), (11, 'HDROIT_S1', TRUE, 1), (11, 'DCIVIL_S1', TRUE, 1), (11, 'DPENAL_S1', TRUE, 1), (11, 'PROCIV_S1', TRUE, 1), (11, 'DFAM_S1', TRUE, 1),
(11, 'ANG_S2', TRUE, 2), (11, 'COMPRO_S2', TRUE, 2), (11, 'DCONST_S2', TRUE, 2), (11, 'HDROIT_S2', TRUE, 2), (11, 'DCIVIL_S2', TRUE, 2), (11, 'DPENAL_S2', TRUE, 2), (11, 'PROCIV_S2', TRUE, 2), (11, 'DFAM_S2', TRUE, 2),
(11, 'ANG_S3', TRUE, 3), (11, 'COMPRO_S3', TRUE, 3), (11, 'DCONST_S3', TRUE, 3), (11, 'HDROIT_S3', TRUE, 3), (11, 'DCIVIL_S3', TRUE, 3), (11, 'DPENAL_S3', TRUE, 3), (11, 'PROCIV_S3', TRUE, 3), (11, 'DFAM_S3', TRUE, 3),
(11, 'ANG_S4', TRUE, 4), (11, 'COMPRO_S4', TRUE, 4), (11, 'DCONST_S4', TRUE, 4), (11, 'HDROIT_S4', TRUE, 4), (11, 'DCIVIL_S4', TRUE, 4), (11, 'DPENAL_S4', TRUE, 4), (11, 'PROCIV_S4', TRUE, 4), (11, 'DFAM_S4', TRUE, 4),
(11, 'ANG_S5', TRUE, 5), (11, 'COMPRO_S5', TRUE, 5), (11, 'DCONST_S5', TRUE, 5), (11, 'HDROIT_S5', TRUE, 5), (11, 'DCIVIL_S5', TRUE, 5), (11, 'DPENAL_S5', TRUE, 5), (11, 'PROCIV_S5', TRUE, 5), (11, 'DFAM_S5', TRUE, 5),
(11, 'ANG_S6', TRUE, 6), (11, 'COMPRO_S6', TRUE, 6), (11, 'DCONST_S6', TRUE, 6), (11, 'HDROIT_S6', TRUE, 6), (11, 'DCIVIL_S6', TRUE, 6), (11, 'DPENAL_S6', TRUE, 6), (11, 'PROCIV_S6', TRUE, 6), (11, 'DFAM_S6', TRUE, 6),

-- 12. PARCOURS DROIT DES AFFAIRES
(12, 'ANG_S1', TRUE, 1), (12, 'COMPRO_S1', TRUE, 1), (12, 'DCONST_S1', TRUE, 1), (12, 'HDROIT_S1', TRUE, 1), (12, 'DCOM_S1', TRUE, 1), (12, 'DSOC_S1', TRUE, 1), (12, 'FISCEN_S1', TRUE, 1), (12, 'DBANQ_S1', TRUE, 1),
(12, 'ANG_S2', TRUE, 2), (12, 'COMPRO_S2', TRUE, 2), (12, 'DCONST_S2', TRUE, 2), (12, 'HDROIT_S2', TRUE, 2), (12, 'DCOM_S2', TRUE, 2), (12, 'DSOC_S2', TRUE, 2), (12, 'FISCEN_S2', TRUE, 2), (12, 'DBANQ_S2', TRUE, 2),
(12, 'ANG_S3', TRUE, 3), (12, 'COMPRO_S3', TRUE, 3), (12, 'DCONST_S3', TRUE, 3), (12, 'HDROIT_S3', TRUE, 3), (12, 'DCOM_S3', TRUE, 3), (12, 'DSOC_S3', TRUE, 3), (12, 'FISCEN_S3', TRUE, 3), (12, 'DBANQ_S3', TRUE, 3),
(12, 'ANG_S4', TRUE, 4), (12, 'COMPRO_S4', TRUE, 4), (12, 'DCONST_S4', TRUE, 4), (12, 'HDROIT_S4', TRUE, 4), (12, 'DCOM_S4', TRUE, 4), (12, 'DSOC_S4', TRUE, 4), (12, 'FISCEN_S4', TRUE, 4), (12, 'DBANQ_S4', TRUE, 4),
(12, 'ANG_S5', TRUE, 5), (12, 'COMPRO_S5', TRUE, 5), (12, 'DCONST_S5', TRUE, 5), (12, 'HDROIT_S5', TRUE, 5), (12, 'DCOM_S5', TRUE, 5), (12, 'DSOC_S5', TRUE, 5), (12, 'FISCEN_S5', TRUE, 5), (12, 'DBANQ_S5', TRUE, 5),
(12, 'ANG_S6', TRUE, 6), (12, 'COMPRO_S6', TRUE, 6), (12, 'DCONST_S6', TRUE, 6), (12, 'HDROIT_S6', TRUE, 6), (12, 'DCOM_S6', TRUE, 6), (12, 'DSOC_S6', TRUE, 6), (12, 'FISCEN_S6', TRUE, 6), (12, 'DBANQ_S6', TRUE, 6);

-- ==========================================
-- 5. ÉTUDIANTS & INSCRIPTIONS : PARCOURS 1 (MIAGE)
-- ==========================================

-- ------------------------------------------
-- 1070 inserts Etudiant
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10101, 'Fontaine', 'Maël', '2005-03-01', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10102, 'Perrin', 'Diane', '2005-03-12', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10103, 'Mallet', 'Camille', '2005-03-23', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10104, 'Perrotin', 'Célia', '2005-04-03', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10105, 'Cassignol', 'Philippine', '2005-04-14', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10106, 'Moreau', 'Maxime', '2005-04-25', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10107, 'Vincent', 'Nolann', '2005-05-06', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10108, 'Clément', 'Lucas', '2005-05-17', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10109, 'Brunel', 'Nina', '2005-05-28', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10110, 'Courtois', 'Zélie', '2005-06-08', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10111, 'Lacombe', 'Sarah', '2005-06-19', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10112, 'Simon', 'Benjamin', '2005-06-30', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10113, 'Lefèvre', 'Loane', '2005-07-11', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10114, 'Henry', 'Paul', '2005-07-22', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10115, 'Savarin', 'Judith', '2005-08-02', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10116, 'Clémentin', 'Brune', '2005-08-13', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10117, 'Ardouin', 'Lucie', '2005-08-24', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10118, 'Lefebvre', 'Ugo', '2005-09-04', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10119, 'André', 'Chloé', '2005-09-15', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10120, 'Mathieu', 'Samuel', '2005-09-26', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10121, 'Valentin', 'Gaëtan', '2005-10-07', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10122, 'Bourdin', 'Tom', '2005-10-18', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10123, 'Joubert', 'Flavie', '2005-10-29', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10124, 'Roux', 'Titouan', '2005-11-09', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10125, 'Blanc', 'Marine', '2005-11-20', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10126, 'Masson', 'Quitterie', '2005-12-01', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10127, 'Charlier', 'Jade', '2005-12-12', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10128, 'Vautrin', 'Julien', '2005-12-23', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10129, 'Vernadet', 'Cassian', '2005-01-03', 1, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20101, 'Bertrand', 'Adam', '2004-03-17', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20102, 'Boyer', 'Basile', '2004-03-28', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20103, 'Vasseur', 'Octave', '2004-04-08', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20104, 'Fauvel', 'Juliette', '2004-04-19', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20105, 'Marquet', 'Maëlys', '2004-04-30', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20106, 'Bernard', 'Maureen', '2004-05-11', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20107, 'Fournier', 'Romain', '2004-05-22', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20108, 'Chevalier', 'Yanis', '2004-06-02', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20109, 'Ponsard', 'Gabriel', '2004-06-13', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20110, 'Cazals', 'Jeanne', '2004-06-24', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20111, 'Fresson', 'Jules', '2004-07-05', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20112, 'Petit', 'Clara', '2004-07-16', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20113, 'Bonnet', 'Ilan', '2004-07-27', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20114, 'Legrand', 'Apolline', '2004-08-07', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20115, 'Borie', 'Alexandre', '2004-08-18', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20116, 'Rochas', 'Théophile', '2004-08-29', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20117, 'Auriol', 'Nathan', '2004-09-09', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20118, 'Richard', 'Zoé', '2004-09-20', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20119, 'Lambert', 'Faustine', '2004-10-01', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20120, 'Garcia', 'Léa', '2004-10-12', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20121, 'Giroux', 'Elina', '2004-10-23', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20122, 'Ménard', 'Sixtine', '2004-11-03', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20123, 'Bellanger', 'Baptiste', '2004-11-14', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20124, 'Dubois', 'Priam', '2004-11-25', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20125, 'Rousseau', 'Hugo', '2004-12-06', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20126, 'Robin', 'Alice', '2004-12-17', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20127, 'Tissier', 'Bérénice', '2004-12-28', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20128, 'Aubanel', 'Inès', '2004-01-09', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20129, 'Mazière', 'Amaury', '2004-01-20', 3, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30101, 'Laurent', 'Ninon', '2003-04-04', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30102, 'Muller', 'Mathis', '2003-04-15', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30103, 'Morin', 'Lison', '2003-04-26', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30104, 'Noiret', 'Éléonore', '2003-05-07', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30105, 'Guichard', 'Élise', '2003-05-18', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30106, 'Prévost', 'Wassim', '2003-05-29', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30107, 'Michel', 'Manon', '2003-06-09', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30108, 'Faure', 'Thomas', '2003-06-20', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30109, 'Roussel', 'Ismaël', '2003-07-01', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30110, 'Ducros', 'Théo', '2003-07-12', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30111, 'Renaudin', 'Héloïse', '2003-07-23', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30112, 'Boissel', 'Yse', '2003-08-03', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30113, 'Leroy', 'Charlotte', '2003-08-14', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30114, 'Mercier', 'Salomé', '2003-08-25', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30115, 'Gautier', 'Lina', '2003-09-05', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30116, 'Rivière', 'Valentin', '2003-09-16', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30117, 'Dumontel', 'Eliott', '2003-09-27', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30118, 'Saunier', 'Noah', '2003-10-08', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30119, 'David', 'Dorian', '2003-10-19', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30120, 'Guérin', 'Raphaël', '2003-10-30', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30121, 'Marchand', 'Anaïs', '2003-11-10', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30122, 'Monnier', 'Oriane', '2003-11-21', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30123, 'Briand', 'Emma', '2003-12-02', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30124, 'Martin', 'Victor', '2003-12-13', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30125, 'Morel', 'Anouk', '2003-12-24', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30126, 'Garnier', 'Arthur', '2003-01-04', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30127, 'Delorme', 'Pauline', '2003-01-15', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30128, 'Bessière', 'Malo', '2003-01-26', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30129, 'Roussin', 'Lola', '2003-02-06', 5, 1);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10201, 'Thomas', 'Kylian', '2005-04-01', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10202, 'Girard', 'Colin', '2005-04-12', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10203, 'François', 'Antoine', '2005-04-23', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10204, 'Vidalin', 'Violette', '2005-05-04', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10205, 'Delaunay', 'Léo', '2005-05-15', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10206, 'Chabrol', 'Margot', '2005-05-26', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10207, 'Robert', 'Hortense', '2005-06-06', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10208, 'Dupont', 'Eva', '2005-06-17', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10209, 'Gauthier', 'Gaspard', '2005-06-28', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10210, 'Launay', 'Victoire', '2005-07-09', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10211, 'Lavergne', 'Ethan', '2005-07-20', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10212, 'Pelletier', 'Ruben', '2005-07-31', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10213, 'Durand', 'Louis', '2005-08-11', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10214, 'Fontaine', 'Benjamin', '2005-08-22', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10215, 'Perrin', 'Loane', '2005-09-02', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10216, 'Mallet', 'Paul', '2005-09-13', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10217, 'Perrotin', 'Judith', '2005-09-24', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10218, 'Cassignol', 'Brune', '2005-10-05', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10219, 'Moreau', 'Lucie', '2005-10-16', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10220, 'Vincent', 'Ugo', '2005-10-27', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10221, 'Clément', 'Chloé', '2005-11-07', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10222, 'Brunel', 'Samuel', '2005-11-18', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10223, 'Courtois', 'Gaëtan', '2005-11-29', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10224, 'Lacombe', 'Tom', '2005-12-10', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10225, 'Simon', 'Flavie', '2005-12-21', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10226, 'Lefèvre', 'Titouan', '2005-01-01', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10227, 'Henry', 'Marine', '2005-01-12', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10228, 'Savarin', 'Quitterie', '2005-01-23', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10229, 'Clémentin', 'Jade', '2005-02-03', 1, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20201, 'Ardouin', 'Julien', '2004-04-17', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20202, 'Lefebvre', 'Cassian', '2004-04-28', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20203, 'André', 'Adam', '2004-05-09', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20204, 'Mathieu', 'Basile', '2004-05-20', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20205, 'Valentin', 'Octave', '2004-05-31', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20206, 'Bourdin', 'Juliette', '2004-06-11', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20207, 'Joubert', 'Maëlys', '2004-06-22', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20208, 'Roux', 'Maureen', '2004-07-03', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20209, 'Blanc', 'Romain', '2004-07-14', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20210, 'Masson', 'Yanis', '2004-07-25', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20211, 'Charlier', 'Gabriel', '2004-08-05', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20212, 'Vautrin', 'Jeanne', '2004-08-16', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20213, 'Vernadet', 'Jules', '2004-08-27', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20214, 'Bertrand', 'Clara', '2004-09-07', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20215, 'Boyer', 'Ilan', '2004-09-18', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20216, 'Vasseur', 'Apolline', '2004-09-29', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20217, 'Fauvel', 'Alexandre', '2004-10-10', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20218, 'Marquet', 'Théophile', '2004-10-21', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20219, 'Bernard', 'Nathan', '2004-11-01', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20220, 'Fournier', 'Zoé', '2004-11-12', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20221, 'Chevalier', 'Faustine', '2004-11-23', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20222, 'Ponsard', 'Léa', '2004-12-04', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20223, 'Cazals', 'Elina', '2004-12-15', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20224, 'Fresson', 'Sixtine', '2004-12-26', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20225, 'Petit', 'Baptiste', '2004-01-07', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20226, 'Bonnet', 'Priam', '2004-01-18', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20227, 'Legrand', 'Hugo', '2004-01-29', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20228, 'Borie', 'Alice', '2004-02-09', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20229, 'Rochas', 'Bérénice', '2004-02-20', 3, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30201, 'Auriol', 'Inès', '2003-05-05', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30202, 'Richard', 'Amaury', '2003-05-16', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30203, 'Lambert', 'Ninon', '2003-05-27', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30204, 'Garcia', 'Mathis', '2003-06-07', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30205, 'Giroux', 'Lison', '2003-06-18', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30206, 'Ménard', 'Éléonore', '2003-06-29', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30207, 'Bellanger', 'Élise', '2003-07-10', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30208, 'Dubois', 'Wassim', '2003-07-21', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30209, 'Rousseau', 'Manon', '2003-08-01', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30210, 'Robin', 'Thomas', '2003-08-12', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30211, 'Tissier', 'Ismaël', '2003-08-23', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30212, 'Aubanel', 'Théo', '2003-09-03', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30213, 'Mazière', 'Héloïse', '2003-09-14', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30214, 'Laurent', 'Yse', '2003-09-25', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30215, 'Muller', 'Charlotte', '2003-10-06', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30216, 'Morin', 'Salomé', '2003-10-17', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30217, 'Noiret', 'Lina', '2003-10-28', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30218, 'Guichard', 'Valentin', '2003-11-08', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30219, 'Prévost', 'Eliott', '2003-11-19', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30220, 'Michel', 'Noah', '2003-11-30', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30221, 'Faure', 'Dorian', '2003-12-11', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30222, 'Roussel', 'Raphaël', '2003-12-22', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30223, 'Ducros', 'Anaïs', '2003-01-02', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30224, 'Renaudin', 'Oriane', '2003-01-13', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30225, 'Boissel', 'Emma', '2003-01-24', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30226, 'Leroy', 'Victor', '2003-02-04', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30227, 'Mercier', 'Anouk', '2003-02-15', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30228, 'Gautier', 'Arthur', '2003-02-26', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30229, 'Rivière', 'Pauline', '2003-03-09', 5, 2);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10301, 'Dumontel', 'Malo', '2005-05-02', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10302, 'Saunier', 'Lola', '2005-05-13', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10303, 'David', 'Kylian', '2005-05-24', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10304, 'Guérin', 'Colin', '2005-06-04', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10305, 'Marchand', 'Antoine', '2005-06-15', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10306, 'Monnier', 'Violette', '2005-06-26', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10307, 'Briand', 'Léo', '2005-07-07', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10308, 'Martin', 'Margot', '2005-07-18', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10309, 'Morel', 'Hortense', '2005-07-29', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10310, 'Garnier', 'Eva', '2005-08-09', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10311, 'Delorme', 'Gaspard', '2005-08-20', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10312, 'Bessière', 'Victoire', '2005-08-31', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10313, 'Roussin', 'Ethan', '2005-09-11', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10314, 'Thomas', 'Ruben', '2005-09-22', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10315, 'Girard', 'Louis', '2005-10-03', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10316, 'François', 'Maël', '2005-10-14', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10317, 'Vidalin', 'Diane', '2005-10-25', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10318, 'Delaunay', 'Camille', '2005-11-05', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10319, 'Chabrol', 'Célia', '2005-11-16', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10320, 'Robert', 'Philippine', '2005-11-27', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10321, 'Dupont', 'Maxime', '2005-12-08', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10322, 'Gauthier', 'Nolann', '2005-12-19', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10323, 'Launay', 'Lucas', '2005-12-30', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10324, 'Lavergne', 'Nina', '2005-01-10', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10325, 'Pelletier', 'Zélie', '2005-01-21', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10326, 'Durand', 'Sarah', '2005-02-01', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10327, 'Fontaine', 'Flavie', '2005-02-12', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10328, 'Perrin', 'Titouan', '2005-02-23', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10329, 'Mallet', 'Marine', '2005-03-06', 1, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20301, 'Perrotin', 'Quitterie', '2004-05-18', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20302, 'Cassignol', 'Jade', '2004-05-29', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20303, 'Moreau', 'Julien', '2004-06-09', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20304, 'Vincent', 'Cassian', '2004-06-20', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20305, 'Clément', 'Adam', '2004-07-01', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20306, 'Brunel', 'Basile', '2004-07-12', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20307, 'Courtois', 'Octave', '2004-07-23', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20308, 'Lacombe', 'Juliette', '2004-08-03', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20309, 'Simon', 'Maëlys', '2004-08-14', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20310, 'Lefèvre', 'Maureen', '2004-08-25', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20311, 'Henry', 'Romain', '2004-09-05', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20312, 'Savarin', 'Yanis', '2004-09-16', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20313, 'Clémentin', 'Gabriel', '2004-09-27', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20314, 'Ardouin', 'Jeanne', '2004-10-08', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20315, 'Lefebvre', 'Jules', '2004-10-19', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20316, 'André', 'Clara', '2004-10-30', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20317, 'Mathieu', 'Ilan', '2004-11-10', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20318, 'Valentin', 'Apolline', '2004-11-21', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20319, 'Bourdin', 'Alexandre', '2004-12-02', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20320, 'Joubert', 'Théophile', '2004-12-13', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20321, 'Roux', 'Nathan', '2004-12-24', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20322, 'Blanc', 'Zoé', '2004-01-05', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20323, 'Masson', 'Faustine', '2004-01-16', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20324, 'Charlier', 'Léa', '2004-01-27', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20325, 'Vautrin', 'Elina', '2004-02-07', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20326, 'Vernadet', 'Sixtine', '2004-02-18', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20327, 'Bertrand', 'Baptiste', '2004-02-29', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20328, 'Boyer', 'Priam', '2004-03-11', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20329, 'Vasseur', 'Hugo', '2004-03-22', 3, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30301, 'Fauvel', 'Alice', '2003-06-05', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30302, 'Marquet', 'Bérénice', '2003-06-16', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30303, 'Bernard', 'Inès', '2003-06-27', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30304, 'Fournier', 'Amaury', '2003-07-08', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30305, 'Chevalier', 'Ninon', '2003-07-19', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30306, 'Ponsard', 'Mathis', '2003-07-30', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30307, 'Cazals', 'Lison', '2003-08-10', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30308, 'Fresson', 'Éléonore', '2003-08-21', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30309, 'Petit', 'Élise', '2003-09-01', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30310, 'Bonnet', 'Wassim', '2003-09-12', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30311, 'Legrand', 'Manon', '2003-09-23', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30312, 'Borie', 'Thomas', '2003-10-04', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30313, 'Rochas', 'Ismaël', '2003-10-15', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30314, 'Auriol', 'Théo', '2003-10-26', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30315, 'Richard', 'Héloïse', '2003-11-06', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30316, 'Lambert', 'Yse', '2003-11-17', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30317, 'Garcia', 'Charlotte', '2003-11-28', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30318, 'Giroux', 'Salomé', '2003-12-09', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30319, 'Ménard', 'Lina', '2003-12-20', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30320, 'Bellanger', 'Valentin', '2003-12-31', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30321, 'Dubois', 'Eliott', '2003-01-11', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30322, 'Rousseau', 'Noah', '2003-01-22', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30323, 'Robin', 'Dorian', '2003-02-02', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30324, 'Tissier', 'Raphaël', '2003-02-13', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30325, 'Aubanel', 'Anaïs', '2003-02-24', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30326, 'Mazière', 'Oriane', '2003-03-07', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30327, 'Laurent', 'Emma', '2003-03-18', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30328, 'Muller', 'Victor', '2003-03-29', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30329, 'Morin', 'Anouk', '2003-04-09', 5, 3);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10401, 'Noiret', 'Arthur', '2005-06-02', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10402, 'Guichard', 'Pauline', '2005-06-13', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10403, 'Prévost', 'Malo', '2005-06-24', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10404, 'Michel', 'Lola', '2005-07-05', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10405, 'Faure', 'Kylian', '2005-07-16', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10406, 'Roussel', 'Colin', '2005-07-27', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10407, 'Ducros', 'Antoine', '2005-08-07', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10408, 'Renaudin', 'Violette', '2005-08-18', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10409, 'Boissel', 'Léo', '2005-08-29', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10410, 'Leroy', 'Margot', '2005-09-09', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10411, 'Mercier', 'Hortense', '2005-09-20', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10412, 'Gautier', 'Eva', '2005-10-01', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10413, 'Rivière', 'Gaspard', '2005-10-12', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10414, 'Dumontel', 'Victoire', '2005-10-23', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10415, 'Saunier', 'Ethan', '2005-11-03', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10416, 'David', 'Ruben', '2005-11-14', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10417, 'Guérin', 'Louis', '2005-11-25', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10418, 'Marchand', 'Maël', '2005-12-06', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10419, 'Monnier', 'Diane', '2005-12-17', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10420, 'Briand', 'Camille', '2005-12-28', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10421, 'Martin', 'Célia', '2005-01-08', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10422, 'Morel', 'Philippine', '2005-01-19', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10423, 'Garnier', 'Maxime', '2005-01-30', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10424, 'Delorme', 'Nolann', '2005-02-10', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10425, 'Bessière', 'Lucas', '2005-02-21', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10426, 'Roussin', 'Nina', '2005-03-04', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10427, 'Thomas', 'Zélie', '2005-03-15', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10428, 'Girard', 'Sarah', '2005-03-26', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10429, 'François', 'Benjamin', '2005-04-06', 1, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20401, 'Vidalin', 'Loane', '2004-06-18', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20402, 'Delaunay', 'Paul', '2004-06-29', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20403, 'Chabrol', 'Judith', '2004-07-10', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20404, 'Robert', 'Brune', '2004-07-21', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20405, 'Dupont', 'Lucie', '2004-08-01', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20406, 'Gauthier', 'Ugo', '2004-08-12', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20407, 'Launay', 'Chloé', '2004-08-23', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20408, 'Lavergne', 'Samuel', '2004-09-03', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20409, 'Pelletier', 'Gaëtan', '2004-09-14', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20410, 'Durand', 'Tom', '2004-09-25', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20411, 'Fontaine', 'Maëlys', '2004-10-06', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20412, 'Perrin', 'Maureen', '2004-10-17', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20413, 'Mallet', 'Romain', '2004-10-28', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20414, 'Perrotin', 'Yanis', '2004-11-08', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20415, 'Cassignol', 'Gabriel', '2004-11-19', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20416, 'Moreau', 'Jeanne', '2004-11-30', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20417, 'Vincent', 'Jules', '2004-12-11', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20418, 'Clément', 'Clara', '2004-12-22', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20419, 'Brunel', 'Ilan', '2004-01-03', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20420, 'Courtois', 'Apolline', '2004-01-14', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20421, 'Lacombe', 'Alexandre', '2004-01-25', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20422, 'Simon', 'Théophile', '2004-02-05', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20423, 'Lefèvre', 'Nathan', '2004-02-16', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20424, 'Henry', 'Zoé', '2004-02-27', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20425, 'Savarin', 'Faustine', '2004-03-09', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20426, 'Clémentin', 'Léa', '2004-03-20', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20427, 'Ardouin', 'Elina', '2004-03-31', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20428, 'Lefebvre', 'Sixtine', '2004-04-11', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20429, 'André', 'Baptiste', '2004-04-22', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20430, 'Mathieu', 'Priam', '2004-05-03', 3, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30401, 'Valentin', 'Hugo', '2003-07-06', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30402, 'Bourdin', 'Alice', '2003-07-17', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30403, 'Joubert', 'Bérénice', '2003-07-28', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30404, 'Roux', 'Inès', '2003-08-08', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30405, 'Blanc', 'Amaury', '2003-08-19', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30406, 'Masson', 'Ninon', '2003-08-30', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30407, 'Charlier', 'Mathis', '2003-09-10', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30408, 'Vautrin', 'Lison', '2003-09-21', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30409, 'Vernadet', 'Éléonore', '2003-10-02', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30410, 'Bertrand', 'Élise', '2003-10-13', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30411, 'Boyer', 'Wassim', '2003-10-24', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30412, 'Vasseur', 'Manon', '2003-11-04', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30413, 'Fauvel', 'Thomas', '2003-11-15', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30414, 'Marquet', 'Ismaël', '2003-11-26', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30415, 'Bernard', 'Théo', '2003-12-07', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30416, 'Fournier', 'Héloïse', '2003-12-18', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30417, 'Chevalier', 'Yse', '2003-12-29', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30418, 'Ponsard', 'Charlotte', '2003-01-09', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30419, 'Cazals', 'Salomé', '2003-01-20', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30420, 'Fresson', 'Lina', '2003-01-31', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30421, 'Petit', 'Valentin', '2003-02-11', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30422, 'Bonnet', 'Eliott', '2003-02-22', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30423, 'Legrand', 'Noah', '2003-03-05', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30424, 'Borie', 'Dorian', '2003-03-16', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30425, 'Rochas', 'Raphaël', '2003-03-27', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30426, 'Auriol', 'Anaïs', '2003-04-07', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30427, 'Richard', 'Oriane', '2003-04-18', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30428, 'Lambert', 'Emma', '2003-04-29', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30429, 'Garcia', 'Victor', '2003-05-10', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30430, 'Giroux', 'Anouk', '2003-05-21', 5, 4);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10501, 'Ménard', 'Arthur', '2005-07-03', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10502, 'Bellanger', 'Pauline', '2005-07-14', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10503, 'Dubois', 'Malo', '2005-07-25', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10504, 'Rousseau', 'Lola', '2005-08-05', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10505, 'Robin', 'Kylian', '2005-08-16', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10506, 'Tissier', 'Colin', '2005-08-27', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10507, 'Aubanel', 'Antoine', '2005-09-07', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10508, 'Mazière', 'Violette', '2005-09-18', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10509, 'Laurent', 'Léo', '2005-09-29', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10510, 'Muller', 'Margot', '2005-10-10', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10511, 'Morin', 'Hortense', '2005-10-21', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10512, 'Noiret', 'Eva', '2005-11-01', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10513, 'Guichard', 'Gaspard', '2005-11-12', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10514, 'Prévost', 'Victoire', '2005-11-23', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10515, 'Michel', 'Ethan', '2005-12-04', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10516, 'Faure', 'Ruben', '2005-12-15', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10517, 'Roussel', 'Louis', '2005-12-26', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10518, 'Ducros', 'Maël', '2005-01-06', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10519, 'Renaudin', 'Diane', '2005-01-17', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10520, 'Boissel', 'Camille', '2005-01-28', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10521, 'Leroy', 'Célia', '2005-02-08', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10522, 'Mercier', 'Philippine', '2005-02-19', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10523, 'Gautier', 'Maxime', '2005-03-02', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10524, 'Rivière', 'Nolann', '2005-03-13', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10525, 'Dumontel', 'Lucas', '2005-03-24', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10526, 'Saunier', 'Nina', '2005-04-04', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10527, 'David', 'Zélie', '2005-04-15', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10528, 'Guérin', 'Sarah', '2005-04-26', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10529, 'Marchand', 'Benjamin', '2005-05-07', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10530, 'Monnier', 'Loane', '2005-05-18', 1, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20501, 'Briand', 'Paul', '2004-07-19', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20502, 'Martin', 'Judith', '2004-07-30', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20503, 'Morel', 'Brune', '2004-08-10', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20504, 'Garnier', 'Lucie', '2004-08-21', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20505, 'Delorme', 'Ugo', '2004-09-01', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20506, 'Bessière', 'Chloé', '2004-09-12', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20507, 'Roussin', 'Samuel', '2004-09-23', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20508, 'Thomas', 'Gaëtan', '2004-10-04', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20509, 'Girard', 'Tom', '2004-10-15', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20510, 'François', 'Flavie', '2004-10-26', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20511, 'Vidalin', 'Titouan', '2004-11-06', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20512, 'Delaunay', 'Marine', '2004-11-17', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20513, 'Chabrol', 'Quitterie', '2004-11-28', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20514, 'Robert', 'Jade', '2004-12-09', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20515, 'Dupont', 'Julien', '2004-12-20', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20516, 'Gauthier', 'Cassian', '2004-01-01', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20517, 'Launay', 'Adam', '2004-01-12', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20518, 'Lavergne', 'Basile', '2004-01-23', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20519, 'Pelletier', 'Octave', '2004-02-03', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20520, 'Durand', 'Juliette', '2004-02-14', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20521, 'Fontaine', 'Théophile', '2004-02-25', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20522, 'Perrin', 'Nathan', '2004-03-07', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20523, 'Mallet', 'Zoé', '2004-03-18', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20524, 'Perrotin', 'Faustine', '2004-03-29', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20525, 'Cassignol', 'Léa', '2004-04-09', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20526, 'Moreau', 'Elina', '2004-04-20', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20527, 'Vincent', 'Sixtine', '2004-05-01', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20528, 'Clément', 'Baptiste', '2004-05-12', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20529, 'Brunel', 'Priam', '2004-05-23', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20530, 'Courtois', 'Hugo', '2004-06-03', 3, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30501, 'Lacombe', 'Alice', '2003-08-06', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30502, 'Simon', 'Bérénice', '2003-08-17', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30503, 'Lefèvre', 'Inès', '2003-08-28', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30504, 'Henry', 'Amaury', '2003-09-08', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30505, 'Savarin', 'Ninon', '2003-09-19', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30506, 'Clémentin', 'Mathis', '2003-09-30', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30507, 'Ardouin', 'Lison', '2003-10-11', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30508, 'Lefebvre', 'Éléonore', '2003-10-22', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30509, 'André', 'Élise', '2003-11-02', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30510, 'Mathieu', 'Wassim', '2003-11-13', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30511, 'Valentin', 'Manon', '2003-11-24', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30512, 'Bourdin', 'Thomas', '2003-12-05', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30513, 'Joubert', 'Ismaël', '2003-12-16', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30514, 'Roux', 'Théo', '2003-12-27', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30515, 'Blanc', 'Héloïse', '2003-01-07', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30516, 'Masson', 'Yse', '2003-01-18', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30517, 'Charlier', 'Charlotte', '2003-01-29', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30518, 'Vautrin', 'Salomé', '2003-02-09', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30519, 'Vernadet', 'Lina', '2003-02-20', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30520, 'Bertrand', 'Valentin', '2003-03-03', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30521, 'Boyer', 'Eliott', '2003-03-14', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30522, 'Vasseur', 'Noah', '2003-03-25', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30523, 'Fauvel', 'Dorian', '2003-04-05', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30524, 'Marquet', 'Raphaël', '2003-04-16', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30525, 'Bernard', 'Anaïs', '2003-04-27', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30526, 'Fournier', 'Oriane', '2003-05-08', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30527, 'Chevalier', 'Emma', '2003-05-19', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30528, 'Ponsard', 'Victor', '2003-05-30', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30529, 'Cazals', 'Anouk', '2003-06-10', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30530, 'Fresson', 'Arthur', '2003-06-21', 5, 5);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10601, 'Petit', 'Pauline', '2005-08-03', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10602, 'Bonnet', 'Malo', '2005-08-14', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10603, 'Legrand', 'Lola', '2005-08-25', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10604, 'Borie', 'Kylian', '2005-09-05', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10605, 'Rochas', 'Colin', '2005-09-16', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10606, 'Auriol', 'Antoine', '2005-09-27', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10607, 'Richard', 'Violette', '2005-10-08', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10608, 'Lambert', 'Léo', '2005-10-19', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10609, 'Garcia', 'Margot', '2005-10-30', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10610, 'Giroux', 'Hortense', '2005-11-10', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10611, 'Ménard', 'Eva', '2005-11-21', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10612, 'Bellanger', 'Gaspard', '2005-12-02', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10613, 'Dubois', 'Victoire', '2005-12-13', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10614, 'Rousseau', 'Ethan', '2005-12-24', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10615, 'Robin', 'Ruben', '2005-01-04', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10616, 'Tissier', 'Louis', '2005-01-15', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10617, 'Aubanel', 'Maël', '2005-01-26', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10618, 'Mazière', 'Diane', '2005-02-06', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10619, 'Laurent', 'Camille', '2005-02-17', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10620, 'Muller', 'Célia', '2005-02-28', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10621, 'Morin', 'Philippine', '2005-03-11', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10622, 'Noiret', 'Maxime', '2005-03-22', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10623, 'Guichard', 'Nolann', '2005-04-02', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10624, 'Prévost', 'Lucas', '2005-04-13', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10625, 'Michel', 'Nina', '2005-04-24', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10626, 'Faure', 'Zélie', '2005-05-05', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10627, 'Roussel', 'Sarah', '2005-05-16', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10628, 'Ducros', 'Benjamin', '2005-05-27', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10629, 'Renaudin', 'Loane', '2005-06-07', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10630, 'Boissel', 'Paul', '2005-06-18', 1, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20601, 'Leroy', 'Judith', '2004-08-19', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20602, 'Mercier', 'Brune', '2004-08-30', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20603, 'Gautier', 'Lucie', '2004-09-10', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20604, 'Rivière', 'Ugo', '2004-09-21', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20605, 'Dumontel', 'Chloé', '2004-10-02', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20606, 'Saunier', 'Samuel', '2004-10-13', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20607, 'David', 'Gaëtan', '2004-10-24', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20608, 'Guérin', 'Tom', '2004-11-04', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20609, 'Marchand', 'Flavie', '2004-11-15', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20610, 'Monnier', 'Titouan', '2004-11-26', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20611, 'Briand', 'Marine', '2004-12-07', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20612, 'Martin', 'Quitterie', '2004-12-18', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20613, 'Morel', 'Jade', '2004-12-29', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20614, 'Garnier', 'Julien', '2004-01-10', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20615, 'Delorme', 'Cassian', '2004-01-21', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20616, 'Bessière', 'Adam', '2004-02-01', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20617, 'Roussin', 'Basile', '2004-02-12', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20618, 'Thomas', 'Octave', '2004-02-23', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20619, 'Girard', 'Juliette', '2004-03-05', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20620, 'François', 'Maëlys', '2004-03-16', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20621, 'Vidalin', 'Maureen', '2004-03-27', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20622, 'Delaunay', 'Romain', '2004-04-07', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20623, 'Chabrol', 'Yanis', '2004-04-18', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20624, 'Robert', 'Gabriel', '2004-04-29', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20625, 'Dupont', 'Jeanne', '2004-05-10', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20626, 'Gauthier', 'Jules', '2004-05-21', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20627, 'Launay', 'Clara', '2004-06-01', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20628, 'Lavergne', 'Ilan', '2004-06-12', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20629, 'Pelletier', 'Apolline', '2004-06-23', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20630, 'Durand', 'Alexandre', '2004-07-04', 3, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30601, 'Fontaine', 'Bérénice', '2003-09-06', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30602, 'Perrin', 'Inès', '2003-09-17', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30603, 'Mallet', 'Amaury', '2003-09-28', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30604, 'Perrotin', 'Ninon', '2003-10-09', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30605, 'Cassignol', 'Mathis', '2003-10-20', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30606, 'Moreau', 'Lison', '2003-10-31', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30607, 'Vincent', 'Éléonore', '2003-11-11', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30608, 'Clément', 'Élise', '2003-11-22', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30609, 'Brunel', 'Wassim', '2003-12-03', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30610, 'Courtois', 'Manon', '2003-12-14', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30611, 'Lacombe', 'Thomas', '2003-12-25', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30612, 'Simon', 'Ismaël', '2003-01-05', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30613, 'Lefèvre', 'Théo', '2003-01-16', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30614, 'Henry', 'Héloïse', '2003-01-27', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30615, 'Savarin', 'Yse', '2003-02-07', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30616, 'Clémentin', 'Charlotte', '2003-02-18', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30617, 'Ardouin', 'Salomé', '2003-03-01', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30618, 'Lefebvre', 'Lina', '2003-03-12', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30619, 'André', 'Valentin', '2003-03-23', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30620, 'Mathieu', 'Eliott', '2003-04-03', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30621, 'Valentin', 'Noah', '2003-04-14', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30622, 'Bourdin', 'Dorian', '2003-04-25', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30623, 'Joubert', 'Raphaël', '2003-05-06', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30624, 'Roux', 'Anaïs', '2003-05-17', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30625, 'Blanc', 'Oriane', '2003-05-28', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30626, 'Masson', 'Emma', '2003-06-08', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30627, 'Charlier', 'Victor', '2003-06-19', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30628, 'Vautrin', 'Anouk', '2003-06-30', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30629, 'Vernadet', 'Arthur', '2003-07-11', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30630, 'Bertrand', 'Pauline', '2003-07-22', 5, 6);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10701, 'Boyer', 'Malo', '2005-09-03', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10702, 'Vasseur', 'Lola', '2005-09-14', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10703, 'Fauvel', 'Kylian', '2005-09-25', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10704, 'Marquet', 'Colin', '2005-10-06', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10705, 'Bernard', 'Antoine', '2005-10-17', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10706, 'Fournier', 'Violette', '2005-10-28', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10707, 'Chevalier', 'Léo', '2005-11-08', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10708, 'Ponsard', 'Margot', '2005-11-19', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10709, 'Cazals', 'Hortense', '2005-11-30', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10710, 'Fresson', 'Eva', '2005-12-11', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10711, 'Petit', 'Gaspard', '2005-12-22', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10712, 'Bonnet', 'Victoire', '2005-01-02', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10713, 'Legrand', 'Ethan', '2005-01-13', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10714, 'Borie', 'Ruben', '2005-01-24', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10715, 'Rochas', 'Louis', '2005-02-04', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10716, 'Auriol', 'Maël', '2005-02-15', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10717, 'Richard', 'Diane', '2005-02-26', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10718, 'Lambert', 'Camille', '2005-03-09', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10719, 'Garcia', 'Célia', '2005-03-20', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10720, 'Giroux', 'Philippine', '2005-03-31', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10721, 'Ménard', 'Maxime', '2005-04-11', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10722, 'Bellanger', 'Nolann', '2005-04-22', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10723, 'Dubois', 'Lucas', '2005-05-03', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10724, 'Rousseau', 'Nina', '2005-05-14', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10725, 'Robin', 'Zélie', '2005-05-25', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10726, 'Tissier', 'Sarah', '2005-06-05', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10727, 'Aubanel', 'Benjamin', '2005-06-16', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10728, 'Mazière', 'Loane', '2005-06-27', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10729, 'Laurent', 'Paul', '2005-07-08', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10730, 'Muller', 'Judith', '2005-07-19', 1, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20701, 'Morin', 'Brune', '2004-09-19', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20702, 'Noiret', 'Lucie', '2004-09-30', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20703, 'Guichard', 'Ugo', '2004-10-11', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20704, 'Prévost', 'Chloé', '2004-10-22', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20705, 'Michel', 'Samuel', '2004-11-02', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20706, 'Faure', 'Gaëtan', '2004-11-13', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20707, 'Roussel', 'Tom', '2004-11-24', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20708, 'Ducros', 'Flavie', '2004-12-05', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20709, 'Renaudin', 'Titouan', '2004-12-16', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20710, 'Boissel', 'Marine', '2004-12-27', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20711, 'Leroy', 'Quitterie', '2004-01-08', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20712, 'Mercier', 'Jade', '2004-01-19', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20713, 'Gautier', 'Julien', '2004-01-30', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20714, 'Rivière', 'Cassian', '2004-02-10', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20715, 'Dumontel', 'Adam', '2004-02-21', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20716, 'Saunier', 'Basile', '2004-03-03', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20717, 'David', 'Octave', '2004-03-14', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20718, 'Guérin', 'Juliette', '2004-03-25', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20719, 'Marchand', 'Maëlys', '2004-04-05', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20720, 'Monnier', 'Maureen', '2004-04-16', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20721, 'Briand', 'Romain', '2004-04-27', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20722, 'Martin', 'Yanis', '2004-05-08', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20723, 'Morel', 'Gabriel', '2004-05-19', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20724, 'Garnier', 'Jeanne', '2004-05-30', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20725, 'Delorme', 'Jules', '2004-06-10', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20726, 'Bessière', 'Clara', '2004-06-21', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20727, 'Roussin', 'Ilan', '2004-07-02', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20728, 'Thomas', 'Apolline', '2004-07-13', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20729, 'Girard', 'Alexandre', '2004-07-24', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20730, 'François', 'Théophile', '2004-08-04', 3, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30701, 'Vidalin', 'Nathan', '2003-10-07', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30702, 'Delaunay', 'Zoé', '2003-10-18', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30703, 'Chabrol', 'Faustine', '2003-10-29', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30704, 'Robert', 'Léa', '2003-11-09', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30705, 'Dupont', 'Elina', '2003-11-20', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30706, 'Gauthier', 'Sixtine', '2003-12-01', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30707, 'Launay', 'Baptiste', '2003-12-12', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30708, 'Lavergne', 'Priam', '2003-12-23', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30709, 'Pelletier', 'Hugo', '2003-01-03', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30710, 'Durand', 'Alice', '2003-01-14', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30711, 'Fontaine', 'Ismaël', '2003-01-25', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30712, 'Perrin', 'Théo', '2003-02-05', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30713, 'Mallet', 'Héloïse', '2003-02-16', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30714, 'Perrotin', 'Yse', '2003-02-27', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30715, 'Cassignol', 'Charlotte', '2003-03-10', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30716, 'Moreau', 'Salomé', '2003-03-21', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30717, 'Vincent', 'Lina', '2003-04-01', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30718, 'Clément', 'Valentin', '2003-04-12', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30719, 'Brunel', 'Eliott', '2003-04-23', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30720, 'Courtois', 'Noah', '2003-05-04', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30721, 'Lacombe', 'Dorian', '2003-05-15', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30722, 'Simon', 'Raphaël', '2003-05-26', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30723, 'Lefèvre', 'Anaïs', '2003-06-06', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30724, 'Henry', 'Oriane', '2003-06-17', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30725, 'Savarin', 'Emma', '2003-06-28', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30726, 'Clémentin', 'Victor', '2003-07-09', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30727, 'Ardouin', 'Anouk', '2003-07-20', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30728, 'Lefebvre', 'Arthur', '2003-07-31', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30729, 'André', 'Pauline', '2003-08-11', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30730, 'Mathieu', 'Malo', '2003-08-22', 5, 7);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10801, 'Valentin', 'Lola', '2005-10-04', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10802, 'Bourdin', 'Kylian', '2005-10-15', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10803, 'Joubert', 'Colin', '2005-10-26', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10804, 'Roux', 'Antoine', '2005-11-06', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10805, 'Blanc', 'Violette', '2005-11-17', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10806, 'Masson', 'Léo', '2005-11-28', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10807, 'Charlier', 'Margot', '2005-12-09', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10808, 'Vautrin', 'Hortense', '2005-12-20', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10809, 'Vernadet', 'Eva', '2005-12-31', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10810, 'Bertrand', 'Gaspard', '2005-01-11', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10811, 'Boyer', 'Victoire', '2005-01-22', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10812, 'Vasseur', 'Ethan', '2005-02-02', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10813, 'Fauvel', 'Ruben', '2005-02-13', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10814, 'Marquet', 'Louis', '2005-02-24', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10815, 'Bernard', 'Maël', '2005-03-07', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10816, 'Fournier', 'Diane', '2005-03-18', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10817, 'Chevalier', 'Camille', '2005-03-29', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10818, 'Ponsard', 'Célia', '2005-04-09', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10819, 'Cazals', 'Philippine', '2005-04-20', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10820, 'Fresson', 'Maxime', '2005-05-01', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10821, 'Petit', 'Nolann', '2005-05-12', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10822, 'Bonnet', 'Lucas', '2005-05-23', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10823, 'Legrand', 'Nina', '2005-06-03', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10824, 'Borie', 'Zélie', '2005-06-14', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10825, 'Rochas', 'Sarah', '2005-06-25', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10826, 'Auriol', 'Benjamin', '2005-07-06', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10827, 'Richard', 'Loane', '2005-07-17', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10828, 'Lambert', 'Paul', '2005-07-28', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10829, 'Garcia', 'Judith', '2005-08-08', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10830, 'Giroux', 'Brune', '2005-08-19', 1, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20801, 'Ménard', 'Lucie', '2004-10-20', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20802, 'Bellanger', 'Ugo', '2004-10-31', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20803, 'Dubois', 'Chloé', '2004-11-11', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20804, 'Rousseau', 'Samuel', '2004-11-22', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20805, 'Robin', 'Gaëtan', '2004-12-03', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20806, 'Tissier', 'Tom', '2004-12-14', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20807, 'Aubanel', 'Flavie', '2004-12-25', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20808, 'Mazière', 'Titouan', '2004-01-06', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20809, 'Laurent', 'Marine', '2004-01-17', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20810, 'Muller', 'Quitterie', '2004-01-28', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20811, 'Morin', 'Jade', '2004-02-08', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20812, 'Noiret', 'Julien', '2004-02-19', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20813, 'Guichard', 'Cassian', '2004-03-01', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20814, 'Prévost', 'Adam', '2004-03-12', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20815, 'Michel', 'Basile', '2004-03-23', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20816, 'Faure', 'Octave', '2004-04-03', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20817, 'Roussel', 'Juliette', '2004-04-14', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20818, 'Ducros', 'Maëlys', '2004-04-25', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20819, 'Renaudin', 'Maureen', '2004-05-06', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20820, 'Boissel', 'Romain', '2004-05-17', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20821, 'Leroy', 'Yanis', '2004-05-28', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20822, 'Mercier', 'Gabriel', '2004-06-08', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20823, 'Gautier', 'Jeanne', '2004-06-19', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20824, 'Rivière', 'Jules', '2004-06-30', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20825, 'Dumontel', 'Clara', '2004-07-11', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20826, 'Saunier', 'Ilan', '2004-07-22', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20827, 'David', 'Apolline', '2004-08-02', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20828, 'Guérin', 'Alexandre', '2004-08-13', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20829, 'Marchand', 'Théophile', '2004-08-24', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20830, 'Monnier', 'Nathan', '2004-09-04', 3, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30801, 'Briand', 'Zoé', '2003-11-07', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30802, 'Martin', 'Faustine', '2003-11-18', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30803, 'Morel', 'Léa', '2003-11-29', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30804, 'Garnier', 'Elina', '2003-12-10', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30805, 'Delorme', 'Sixtine', '2003-12-21', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30806, 'Bessière', 'Baptiste', '2003-01-01', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30807, 'Roussin', 'Priam', '2003-01-12', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30808, 'Thomas', 'Hugo', '2003-01-23', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30809, 'Girard', 'Alice', '2003-02-03', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30810, 'François', 'Bérénice', '2003-02-14', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30811, 'Vidalin', 'Inès', '2003-02-25', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30812, 'Delaunay', 'Amaury', '2003-03-08', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30813, 'Chabrol', 'Ninon', '2003-03-19', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30814, 'Robert', 'Mathis', '2003-03-30', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30815, 'Dupont', 'Lison', '2003-04-10', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30816, 'Gauthier', 'Éléonore', '2003-04-21', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30817, 'Launay', 'Élise', '2003-05-02', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30818, 'Lavergne', 'Wassim', '2003-05-13', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30819, 'Pelletier', 'Manon', '2003-05-24', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30820, 'Durand', 'Thomas', '2003-06-04', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30821, 'Fontaine', 'Raphaël', '2003-06-15', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30822, 'Perrin', 'Anaïs', '2003-06-26', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30823, 'Mallet', 'Oriane', '2003-07-07', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30824, 'Perrotin', 'Emma', '2003-07-18', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30825, 'Cassignol', 'Victor', '2003-07-29', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30826, 'Moreau', 'Anouk', '2003-08-09', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30827, 'Vincent', 'Arthur', '2003-08-20', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30828, 'Clément', 'Pauline', '2003-08-31', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30829, 'Brunel', 'Malo', '2003-09-11', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30830, 'Courtois', 'Lola', '2003-09-22', 5, 8);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10901, 'Lacombe', 'Kylian', '2005-11-04', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10902, 'Simon', 'Colin', '2005-11-15', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10903, 'Lefèvre', 'Antoine', '2005-11-26', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10904, 'Henry', 'Violette', '2005-12-07', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10905, 'Savarin', 'Léo', '2005-12-18', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10906, 'Clémentin', 'Margot', '2005-12-29', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10907, 'Ardouin', 'Hortense', '2005-01-09', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10908, 'Lefebvre', 'Eva', '2005-01-20', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10909, 'André', 'Gaspard', '2005-01-31', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10910, 'Mathieu', 'Victoire', '2005-02-11', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10911, 'Valentin', 'Ethan', '2005-02-22', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10912, 'Bourdin', 'Ruben', '2005-03-05', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10913, 'Joubert', 'Louis', '2005-03-16', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10914, 'Roux', 'Maël', '2005-03-27', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10915, 'Blanc', 'Diane', '2005-04-07', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10916, 'Masson', 'Camille', '2005-04-18', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10917, 'Charlier', 'Célia', '2005-04-29', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10918, 'Vautrin', 'Philippine', '2005-05-10', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10919, 'Vernadet', 'Maxime', '2005-05-21', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10920, 'Bertrand', 'Nolann', '2005-06-01', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10921, 'Boyer', 'Lucas', '2005-06-12', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10922, 'Vasseur', 'Nina', '2005-06-23', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10923, 'Fauvel', 'Zélie', '2005-07-04', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10924, 'Marquet', 'Sarah', '2005-07-15', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10925, 'Bernard', 'Benjamin', '2005-07-26', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10926, 'Fournier', 'Loane', '2005-08-06', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10927, 'Chevalier', 'Paul', '2005-08-17', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10928, 'Ponsard', 'Judith', '2005-08-28', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10929, 'Cazals', 'Brune', '2005-09-08', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (10930, 'Fresson', 'Lucie', '2005-09-19', 1, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20901, 'Petit', 'Ugo', '2004-11-20', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20902, 'Bonnet', 'Chloé', '2004-12-01', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20903, 'Legrand', 'Samuel', '2004-12-12', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20904, 'Borie', 'Gaëtan', '2004-12-23', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20905, 'Rochas', 'Tom', '2004-01-04', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20906, 'Auriol', 'Flavie', '2004-01-15', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20907, 'Richard', 'Titouan', '2004-01-26', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20908, 'Lambert', 'Marine', '2004-02-06', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20909, 'Garcia', 'Quitterie', '2004-02-17', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20910, 'Giroux', 'Jade', '2004-02-28', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20911, 'Ménard', 'Julien', '2004-03-10', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20912, 'Bellanger', 'Cassian', '2004-03-21', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20913, 'Dubois', 'Adam', '2004-04-01', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20914, 'Rousseau', 'Basile', '2004-04-12', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20915, 'Robin', 'Octave', '2004-04-23', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20916, 'Tissier', 'Juliette', '2004-05-04', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20917, 'Aubanel', 'Maëlys', '2004-05-15', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20918, 'Mazière', 'Maureen', '2004-05-26', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20919, 'Laurent', 'Romain', '2004-06-06', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20920, 'Muller', 'Yanis', '2004-06-17', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20921, 'Morin', 'Gabriel', '2004-06-28', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20922, 'Noiret', 'Jeanne', '2004-07-09', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20923, 'Guichard', 'Jules', '2004-07-20', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20924, 'Prévost', 'Clara', '2004-07-31', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20925, 'Michel', 'Ilan', '2004-08-11', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20926, 'Faure', 'Apolline', '2004-08-22', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20927, 'Roussel', 'Alexandre', '2004-09-02', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20928, 'Ducros', 'Théophile', '2004-09-13', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20929, 'Renaudin', 'Nathan', '2004-09-24', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (20930, 'Boissel', 'Zoé', '2004-10-05', 3, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30901, 'Leroy', 'Faustine', '2003-12-08', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30902, 'Mercier', 'Léa', '2003-12-19', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30903, 'Gautier', 'Elina', '2003-12-30', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30904, 'Rivière', 'Sixtine', '2003-01-10', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30905, 'Dumontel', 'Baptiste', '2003-01-21', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30906, 'Saunier', 'Priam', '2003-02-01', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30907, 'David', 'Hugo', '2003-02-12', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30908, 'Guérin', 'Alice', '2003-02-23', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30909, 'Marchand', 'Bérénice', '2003-03-06', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30910, 'Monnier', 'Inès', '2003-03-17', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30911, 'Briand', 'Amaury', '2003-03-28', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30912, 'Martin', 'Ninon', '2003-04-08', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30913, 'Morel', 'Mathis', '2003-04-19', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30914, 'Garnier', 'Lison', '2003-04-30', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30915, 'Delorme', 'Éléonore', '2003-05-11', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30916, 'Bessière', 'Élise', '2003-05-22', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30917, 'Roussin', 'Wassim', '2003-06-02', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30918, 'Thomas', 'Manon', '2003-06-13', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30919, 'Girard', 'Thomas', '2003-06-24', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30920, 'François', 'Ismaël', '2003-07-05', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30921, 'Vidalin', 'Théo', '2003-07-16', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30922, 'Delaunay', 'Héloïse', '2003-07-27', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30923, 'Chabrol', 'Yse', '2003-08-07', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30924, 'Robert', 'Charlotte', '2003-08-18', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30925, 'Dupont', 'Salomé', '2003-08-29', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30926, 'Gauthier', 'Lina', '2003-09-09', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30927, 'Launay', 'Valentin', '2003-09-20', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30928, 'Lavergne', 'Eliott', '2003-10-01', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30929, 'Pelletier', 'Noah', '2003-10-12', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (30930, 'Durand', 'Dorian', '2003-10-23', 5, 9);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11001, 'Fontaine', 'Colin', '2005-12-05', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11002, 'Perrin', 'Antoine', '2005-12-16', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11003, 'Mallet', 'Violette', '2005-12-27', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11004, 'Perrotin', 'Léo', '2005-01-07', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11005, 'Cassignol', 'Margot', '2005-01-18', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11006, 'Moreau', 'Hortense', '2005-01-29', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11007, 'Vincent', 'Eva', '2005-02-09', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11008, 'Clément', 'Gaspard', '2005-02-20', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11009, 'Brunel', 'Victoire', '2005-03-03', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11010, 'Courtois', 'Ethan', '2005-03-14', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11011, 'Lacombe', 'Ruben', '2005-03-25', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11012, 'Simon', 'Louis', '2005-04-05', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11013, 'Lefèvre', 'Maël', '2005-04-16', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11014, 'Henry', 'Diane', '2005-04-27', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11015, 'Savarin', 'Camille', '2005-05-08', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11016, 'Clémentin', 'Célia', '2005-05-19', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11017, 'Ardouin', 'Philippine', '2005-05-30', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11018, 'Lefebvre', 'Maxime', '2005-06-10', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11019, 'André', 'Nolann', '2005-06-21', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11020, 'Mathieu', 'Lucas', '2005-07-02', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11021, 'Valentin', 'Nina', '2005-07-13', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11022, 'Bourdin', 'Zélie', '2005-07-24', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11023, 'Joubert', 'Sarah', '2005-08-04', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11024, 'Roux', 'Benjamin', '2005-08-15', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11025, 'Blanc', 'Loane', '2005-08-26', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11026, 'Masson', 'Paul', '2005-09-06', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11027, 'Charlier', 'Judith', '2005-09-17', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11028, 'Vautrin', 'Brune', '2005-09-28', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11029, 'Vernadet', 'Lucie', '2005-10-09', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11030, 'Bertrand', 'Ugo', '2005-10-20', 1, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21001, 'Boyer', 'Chloé', '2004-12-21', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21002, 'Vasseur', 'Samuel', '2004-01-02', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21003, 'Fauvel', 'Gaëtan', '2004-01-13', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21004, 'Marquet', 'Tom', '2004-01-24', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21005, 'Bernard', 'Flavie', '2004-02-04', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21006, 'Fournier', 'Titouan', '2004-02-15', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21007, 'Chevalier', 'Marine', '2004-02-26', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21008, 'Ponsard', 'Quitterie', '2004-03-08', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21009, 'Cazals', 'Jade', '2004-03-19', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21010, 'Fresson', 'Julien', '2004-03-30', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21011, 'Petit', 'Cassian', '2004-04-10', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21012, 'Bonnet', 'Adam', '2004-04-21', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21013, 'Legrand', 'Basile', '2004-05-02', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21014, 'Borie', 'Octave', '2004-05-13', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21015, 'Rochas', 'Juliette', '2004-05-24', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21016, 'Auriol', 'Maëlys', '2004-06-04', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21017, 'Richard', 'Maureen', '2004-06-15', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21018, 'Lambert', 'Romain', '2004-06-26', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21019, 'Garcia', 'Yanis', '2004-07-07', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21020, 'Giroux', 'Gabriel', '2004-07-18', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21021, 'Ménard', 'Jeanne', '2004-07-29', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21022, 'Bellanger', 'Jules', '2004-08-09', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21023, 'Dubois', 'Clara', '2004-08-20', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21024, 'Rousseau', 'Ilan', '2004-08-31', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21025, 'Robin', 'Apolline', '2004-09-11', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21026, 'Tissier', 'Alexandre', '2004-09-22', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21027, 'Aubanel', 'Théophile', '2004-10-03', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21028, 'Mazière', 'Nathan', '2004-10-14', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21029, 'Laurent', 'Zoé', '2004-10-25', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21030, 'Muller', 'Faustine', '2004-11-05', 3, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31001, 'Morin', 'Léa', '2003-01-08', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31002, 'Noiret', 'Elina', '2003-01-19', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31003, 'Guichard', 'Sixtine', '2003-01-30', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31004, 'Prévost', 'Baptiste', '2003-02-10', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31005, 'Michel', 'Priam', '2003-02-21', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31006, 'Faure', 'Hugo', '2003-03-04', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31007, 'Roussel', 'Alice', '2003-03-15', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31008, 'Ducros', 'Bérénice', '2003-03-26', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31009, 'Renaudin', 'Inès', '2003-04-06', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31010, 'Boissel', 'Amaury', '2003-04-17', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31011, 'Leroy', 'Ninon', '2003-04-28', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31012, 'Mercier', 'Mathis', '2003-05-09', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31013, 'Gautier', 'Lison', '2003-05-20', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31014, 'Rivière', 'Éléonore', '2003-05-31', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31015, 'Dumontel', 'Élise', '2003-06-11', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31016, 'Saunier', 'Wassim', '2003-06-22', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31017, 'David', 'Manon', '2003-07-03', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31018, 'Guérin', 'Thomas', '2003-07-14', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31019, 'Marchand', 'Ismaël', '2003-07-25', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31020, 'Monnier', 'Théo', '2003-08-05', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31021, 'Briand', 'Héloïse', '2003-08-16', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31022, 'Martin', 'Yse', '2003-08-27', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31023, 'Morel', 'Charlotte', '2003-09-07', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31024, 'Garnier', 'Salomé', '2003-09-18', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31025, 'Delorme', 'Lina', '2003-09-29', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31026, 'Bessière', 'Valentin', '2003-10-10', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31027, 'Roussin', 'Eliott', '2003-10-21', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31028, 'Thomas', 'Noah', '2003-11-01', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31029, 'Girard', 'Dorian', '2003-11-12', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31030, 'François', 'Raphaël', '2003-11-23', 5, 10);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11101, 'Vidalin', 'Anaïs', '2005-01-05', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11102, 'Delaunay', 'Oriane', '2005-01-16', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11103, 'Chabrol', 'Emma', '2005-01-27', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11104, 'Robert', 'Victor', '2005-02-07', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11105, 'Dupont', 'Anouk', '2005-02-18', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11106, 'Gauthier', 'Arthur', '2005-03-01', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11107, 'Launay', 'Pauline', '2005-03-12', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11108, 'Lavergne', 'Malo', '2005-03-23', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11109, 'Pelletier', 'Lola', '2005-04-03', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11110, 'Durand', 'Kylian', '2005-04-14', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11111, 'Fontaine', 'Louis', '2005-04-25', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11112, 'Perrin', 'Maël', '2005-05-06', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11113, 'Mallet', 'Diane', '2005-05-17', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11114, 'Perrotin', 'Camille', '2005-05-28', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11115, 'Cassignol', 'Célia', '2005-06-08', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11116, 'Moreau', 'Philippine', '2005-06-19', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11117, 'Vincent', 'Maxime', '2005-06-30', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11118, 'Clément', 'Nolann', '2005-07-11', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11119, 'Brunel', 'Lucas', '2005-07-22', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11120, 'Courtois', 'Nina', '2005-08-02', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11121, 'Lacombe', 'Zélie', '2005-08-13', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11122, 'Simon', 'Sarah', '2005-08-24', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11123, 'Lefèvre', 'Benjamin', '2005-09-04', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11124, 'Henry', 'Loane', '2005-09-15', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11125, 'Savarin', 'Paul', '2005-09-26', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11126, 'Clémentin', 'Judith', '2005-10-07', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11127, 'Ardouin', 'Brune', '2005-10-18', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11128, 'Lefebvre', 'Lucie', '2005-10-29', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11129, 'André', 'Ugo', '2005-11-09', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11130, 'Mathieu', 'Chloé', '2005-11-20', 1, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21101, 'Valentin', 'Samuel', '2004-01-22', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21102, 'Bourdin', 'Gaëtan', '2004-02-02', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21103, 'Joubert', 'Tom', '2004-02-13', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21104, 'Roux', 'Flavie', '2004-02-24', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21105, 'Blanc', 'Titouan', '2004-03-06', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21106, 'Masson', 'Marine', '2004-03-17', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21107, 'Charlier', 'Quitterie', '2004-03-28', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21108, 'Vautrin', 'Jade', '2004-04-08', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21109, 'Vernadet', 'Julien', '2004-04-19', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21110, 'Bertrand', 'Cassian', '2004-04-30', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21111, 'Boyer', 'Adam', '2004-05-11', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21112, 'Vasseur', 'Basile', '2004-05-22', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21113, 'Fauvel', 'Octave', '2004-06-02', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21114, 'Marquet', 'Juliette', '2004-06-13', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21115, 'Bernard', 'Maëlys', '2004-06-24', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21116, 'Fournier', 'Maureen', '2004-07-05', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21117, 'Chevalier', 'Romain', '2004-07-16', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21118, 'Ponsard', 'Yanis', '2004-07-27', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21119, 'Cazals', 'Gabriel', '2004-08-07', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21120, 'Fresson', 'Jeanne', '2004-08-18', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21121, 'Petit', 'Jules', '2004-08-29', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21122, 'Bonnet', 'Clara', '2004-09-09', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21123, 'Legrand', 'Ilan', '2004-09-20', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21124, 'Borie', 'Apolline', '2004-10-01', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21125, 'Rochas', 'Alexandre', '2004-10-12', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21126, 'Auriol', 'Théophile', '2004-10-23', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21127, 'Richard', 'Nathan', '2004-11-03', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21128, 'Lambert', 'Zoé', '2004-11-14', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21129, 'Garcia', 'Faustine', '2004-11-25', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21130, 'Giroux', 'Léa', '2004-12-06', 3, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31101, 'Ménard', 'Elina', '2003-02-08', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31102, 'Bellanger', 'Sixtine', '2003-02-19', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31103, 'Dubois', 'Baptiste', '2003-03-02', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31104, 'Rousseau', 'Priam', '2003-03-13', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31105, 'Robin', 'Hugo', '2003-03-24', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31106, 'Tissier', 'Alice', '2003-04-04', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31107, 'Aubanel', 'Bérénice', '2003-04-15', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31108, 'Mazière', 'Inès', '2003-04-26', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31109, 'Laurent', 'Amaury', '2003-05-07', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31110, 'Muller', 'Ninon', '2003-05-18', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31111, 'Morin', 'Mathis', '2003-05-29', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31112, 'Noiret', 'Lison', '2003-06-09', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31113, 'Guichard', 'Éléonore', '2003-06-20', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31114, 'Prévost', 'Élise', '2003-07-01', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31115, 'Michel', 'Wassim', '2003-07-12', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31116, 'Faure', 'Manon', '2003-07-23', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31117, 'Roussel', 'Thomas', '2003-08-03', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31118, 'Ducros', 'Ismaël', '2003-08-14', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31119, 'Renaudin', 'Théo', '2003-08-25', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31120, 'Boissel', 'Héloïse', '2003-09-05', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31121, 'Leroy', 'Yse', '2003-09-16', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31122, 'Mercier', 'Charlotte', '2003-09-27', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31123, 'Gautier', 'Salomé', '2003-10-08', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31124, 'Rivière', 'Lina', '2003-10-19', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31125, 'Dumontel', 'Valentin', '2003-10-30', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31126, 'Saunier', 'Eliott', '2003-11-10', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31127, 'David', 'Noah', '2003-11-21', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31128, 'Guérin', 'Dorian', '2003-12-02', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31129, 'Marchand', 'Raphaël', '2003-12-13', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31130, 'Monnier', 'Anaïs', '2003-12-24', 5, 11);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11201, 'Briand', 'Oriane', '2005-02-05', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11202, 'Martin', 'Emma', '2005-02-16', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11203, 'Morel', 'Victor', '2005-02-27', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11204, 'Garnier', 'Anouk', '2005-03-10', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11205, 'Delorme', 'Arthur', '2005-03-21', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11206, 'Bessière', 'Pauline', '2005-04-01', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11207, 'Roussin', 'Malo', '2005-04-12', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11208, 'Thomas', 'Lola', '2005-04-23', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11209, 'Girard', 'Kylian', '2005-05-04', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11210, 'François', 'Colin', '2005-05-15', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11211, 'Vidalin', 'Antoine', '2005-05-26', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11212, 'Delaunay', 'Violette', '2005-06-06', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11213, 'Chabrol', 'Léo', '2005-06-17', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11214, 'Robert', 'Margot', '2005-06-28', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11215, 'Dupont', 'Hortense', '2005-07-09', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11216, 'Gauthier', 'Eva', '2005-07-20', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11217, 'Launay', 'Gaspard', '2005-07-31', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11218, 'Lavergne', 'Victoire', '2005-08-11', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11219, 'Pelletier', 'Ethan', '2005-08-22', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11220, 'Durand', 'Ruben', '2005-09-02', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11221, 'Fontaine', 'Sarah', '2005-09-13', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11222, 'Perrin', 'Benjamin', '2005-09-24', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11223, 'Mallet', 'Loane', '2005-10-05', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11224, 'Perrotin', 'Paul', '2005-10-16', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11225, 'Cassignol', 'Judith', '2005-10-27', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11226, 'Moreau', 'Brune', '2005-11-07', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11227, 'Vincent', 'Lucie', '2005-11-18', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11228, 'Clément', 'Ugo', '2005-11-29', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11229, 'Brunel', 'Chloé', '2005-12-10', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (11230, 'Courtois', 'Samuel', '2005-12-21', 1, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21201, 'Lacombe', 'Gaëtan', '2004-02-22', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21202, 'Simon', 'Tom', '2004-03-04', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21203, 'Lefèvre', 'Flavie', '2004-03-15', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21204, 'Henry', 'Titouan', '2004-03-26', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21205, 'Savarin', 'Marine', '2004-04-06', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21206, 'Clémentin', 'Quitterie', '2004-04-17', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21207, 'Ardouin', 'Jade', '2004-04-28', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21208, 'Lefebvre', 'Julien', '2004-05-09', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21209, 'André', 'Cassian', '2004-05-20', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21210, 'Mathieu', 'Adam', '2004-05-31', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21211, 'Valentin', 'Basile', '2004-06-11', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21212, 'Bourdin', 'Octave', '2004-06-22', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21213, 'Joubert', 'Juliette', '2004-07-03', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21214, 'Roux', 'Maëlys', '2004-07-14', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21215, 'Blanc', 'Maureen', '2004-07-25', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21216, 'Masson', 'Romain', '2004-08-05', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21217, 'Charlier', 'Yanis', '2004-08-16', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21218, 'Vautrin', 'Gabriel', '2004-08-27', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21219, 'Vernadet', 'Jeanne', '2004-09-07', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21220, 'Bertrand', 'Jules', '2004-09-18', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21221, 'Boyer', 'Clara', '2004-09-29', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21222, 'Vasseur', 'Ilan', '2004-10-10', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21223, 'Fauvel', 'Apolline', '2004-10-21', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21224, 'Marquet', 'Alexandre', '2004-11-01', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21225, 'Bernard', 'Théophile', '2004-11-12', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21226, 'Fournier', 'Nathan', '2004-11-23', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21227, 'Chevalier', 'Zoé', '2004-12-04', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21228, 'Ponsard', 'Faustine', '2004-12-15', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21229, 'Cazals', 'Léa', '2004-12-26', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (21230, 'Fresson', 'Elina', '2004-01-07', 3, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31201, 'Petit', 'Sixtine', '2003-03-11', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31202, 'Bonnet', 'Baptiste', '2003-03-22', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31203, 'Legrand', 'Priam', '2003-04-02', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31204, 'Borie', 'Hugo', '2003-04-13', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31205, 'Rochas', 'Alice', '2003-04-24', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31206, 'Auriol', 'Bérénice', '2003-05-05', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31207, 'Richard', 'Inès', '2003-05-16', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31208, 'Lambert', 'Amaury', '2003-05-27', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31209, 'Garcia', 'Ninon', '2003-06-07', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31210, 'Giroux', 'Mathis', '2003-06-18', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31211, 'Ménard', 'Lison', '2003-06-29', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31212, 'Bellanger', 'Éléonore', '2003-07-10', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31213, 'Dubois', 'Élise', '2003-07-21', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31214, 'Rousseau', 'Wassim', '2003-08-01', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31215, 'Robin', 'Manon', '2003-08-12', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31216, 'Tissier', 'Thomas', '2003-08-23', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31217, 'Aubanel', 'Ismaël', '2003-09-03', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31218, 'Mazière', 'Théo', '2003-09-14', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31219, 'Laurent', 'Héloïse', '2003-09-25', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31220, 'Muller', 'Yse', '2003-10-06', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31221, 'Morin', 'Charlotte', '2003-10-17', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31222, 'Noiret', 'Salomé', '2003-10-28', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31223, 'Guichard', 'Lina', '2003-11-08', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31224, 'Prévost', 'Valentin', '2003-11-19', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31225, 'Michel', 'Eliott', '2003-11-30', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31226, 'Faure', 'Noah', '2003-12-11', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31227, 'Roussel', 'Dorian', '2003-12-22', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31228, 'Ducros', 'Raphaël', '2003-01-02', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31229, 'Renaudin', 'Anaïs', '2003-01-13', 5, 12);
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, semestre, id_parcours) VALUES (31230, 'Boissel', 'Oriane', '2003-01-24', 5, 12);

-- ======================================================
-- INSCRIPTIONS AUX UE
-- ======================================================

-- L1 : semestres 1 et 2 en cours
INSERT INTO Inscription (num_etu, code_ue, annee_univ, statut_validation)
SELECT
    e.num_etu,
    sp.code_ue,
    '2023-2024',
    'en_cours'
FROM Etudiant e
         JOIN Structure_Parcours sp
              ON sp.id_parcours = e.id_parcours
WHERE FLOOR(e.num_etu / 10000) = 1
  AND sp.semestre_prevu IN (1,2);

-- L2 : S1/S2 validés, S3/S4 en cours
INSERT INTO Inscription (num_etu, code_ue, annee_univ, statut_validation)
SELECT
    e.num_etu,
    sp.code_ue,
    CASE
        WHEN sp.semestre_prevu IN (1,2) THEN '2022-2023'
        ELSE '2023-2024'
        END,
    CASE
        WHEN sp.semestre_prevu IN (1,2) THEN 'valide'
        ELSE 'en_cours'
        END
FROM Etudiant e
         JOIN Structure_Parcours sp
              ON sp.id_parcours = e.id_parcours
WHERE FLOOR(e.num_etu / 10000) = 2
  AND sp.semestre_prevu IN (1,2,3,4);

-- L3 : S1/S2/S3/S4 validés, S5/S6 en cours
INSERT INTO Inscription (num_etu, code_ue, annee_univ, statut_validation)
SELECT
    e.num_etu,
    sp.code_ue,
    CASE
        WHEN sp.semestre_prevu IN (1,2) THEN '2021-2022'
        WHEN sp.semestre_prevu IN (3,4) THEN '2022-2023'
        ELSE '2023-2024'
        END,
    CASE
        WHEN sp.semestre_prevu IN (1,2,3,4) THEN 'valide'
        ELSE 'en_cours'
        END
FROM Etudiant e
         JOIN Structure_Parcours sp
              ON sp.id_parcours = e.id_parcours
WHERE FLOOR(e.num_etu / 10000) = 3
  AND sp.semestre_prevu IN (1,2,3,4,5,6);