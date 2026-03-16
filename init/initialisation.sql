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
-- PROMO L1 (5 Étudiants) - Inscrits en S1 et S2 (en_cours)
-- ------------------------------------------
INSERT INTO Etudiant VALUES (10101, 'Nom_1_1', 'Prenom_1', '2005-11-28', 1);
INSERT INTO Etudiant VALUES (10102, 'Nom_1_2', 'Prenom_2', '2005-09-09', 1);
INSERT INTO Etudiant VALUES (10103, 'Nom_1_3', 'Prenom_3', '2005-01-23', 1);
INSERT INTO Etudiant VALUES (10104, 'Nom_1_4', 'Prenom_4', '2005-07-02', 1);
INSERT INTO Etudiant VALUES (10105, 'Nom_1_5', 'Prenom_5', '2005-08-02', 1);
INSERT INTO Etudiant VALUES (10106, 'Nom_1_6', 'Prenom_6', '2005-02-16', 1);
INSERT INTO Etudiant VALUES (10107, 'Nom_1_7', 'Prenom_7', '2005-01-04', 1);
INSERT INTO Etudiant VALUES (10108, 'Nom_1_8', 'Prenom_8', '2005-08-15', 1);
INSERT INTO Etudiant VALUES (10109, 'Nom_1_9', 'Prenom_9', '2005-09-20', 1);
INSERT INTO Etudiant VALUES (10110, 'Nom_1_10', 'Prenom_10', '2005-11-11', 1);
INSERT INTO Etudiant VALUES (10111, 'Nom_1_11', 'Prenom_11', '2005-09-28', 1);
INSERT INTO Etudiant VALUES (10112, 'Nom_1_12', 'Prenom_12', '2005-04-22', 1);
INSERT INTO Etudiant VALUES (10113, 'Nom_1_13', 'Prenom_13', '2005-01-07', 1);
INSERT INTO Etudiant VALUES (10114, 'Nom_1_14', 'Prenom_14', '2005-12-06', 1);
INSERT INTO Etudiant VALUES (10115, 'Nom_1_15', 'Prenom_15', '2005-02-07', 1);
INSERT INTO Etudiant VALUES (10116, 'Nom_1_16', 'Prenom_16', '2005-04-15', 1);
INSERT INTO Etudiant VALUES (10117, 'Nom_1_17', 'Prenom_17', '2005-08-04', 1);
INSERT INTO Etudiant VALUES (10118, 'Nom_1_18', 'Prenom_18', '2005-12-08', 1);
INSERT INTO Etudiant VALUES (10119, 'Nom_1_19', 'Prenom_19', '2005-11-08', 1);
INSERT INTO Etudiant VALUES (10120, 'Nom_1_20', 'Prenom_20', '2005-01-12', 1);
INSERT INTO Etudiant VALUES (10121, 'Nom_1_21', 'Prenom_21', '2005-01-14', 1);
INSERT INTO Etudiant VALUES (10122, 'Nom_1_22', 'Prenom_22', '2005-03-23', 1);
INSERT INTO Etudiant VALUES (10123, 'Nom_1_23', 'Prenom_23', '2005-01-07', 1);
INSERT INTO Etudiant VALUES (10124, 'Nom_1_24', 'Prenom_24', '2005-02-22', 1);
INSERT INTO Etudiant VALUES (10125, 'Nom_1_25', 'Prenom_25', '2005-05-12', 1);
INSERT INTO Etudiant VALUES (10126, 'Nom_1_26', 'Prenom_26', '2005-12-30', 1);
INSERT INTO Etudiant VALUES (10127, 'Nom_1_27', 'Prenom_27', '2005-09-14', 1);
INSERT INTO Etudiant VALUES (10128, 'Nom_1_28', 'Prenom_28', '2005-07-12', 1);
INSERT INTO Etudiant VALUES (10129, 'Nom_1_29', 'Prenom_29', '2005-07-28', 1);
INSERT INTO Etudiant VALUES (10130, 'Nom_1_30', 'Prenom_30', '2005-01-31', 1);
INSERT INTO Etudiant VALUES (20101, 'Nom_1_1', 'Prenom_1', '2004-01-24', 1);
INSERT INTO Etudiant VALUES (20102, 'Nom_1_2', 'Prenom_2', '2004-08-31', 1);
INSERT INTO Etudiant VALUES (20103, 'Nom_1_3', 'Prenom_3', '2004-12-02', 1);
INSERT INTO Etudiant VALUES (20104, 'Nom_1_4', 'Prenom_4', '2004-04-09', 1);
INSERT INTO Etudiant VALUES (20105, 'Nom_1_5', 'Prenom_5', '2004-08-07', 1);
INSERT INTO Etudiant VALUES (20106, 'Nom_1_6', 'Prenom_6', '2004-07-07', 1);
INSERT INTO Etudiant VALUES (20107, 'Nom_1_7', 'Prenom_7', '2004-01-18', 1);
INSERT INTO Etudiant VALUES (20108, 'Nom_1_8', 'Prenom_8', '2004-01-24', 1);
INSERT INTO Etudiant VALUES (20109, 'Nom_1_9', 'Prenom_9', '2004-12-23', 1);
INSERT INTO Etudiant VALUES (20110, 'Nom_1_10', 'Prenom_10', '2004-10-19', 1);
INSERT INTO Etudiant VALUES (20111, 'Nom_1_11', 'Prenom_11', '2004-11-15', 1);
INSERT INTO Etudiant VALUES (20112, 'Nom_1_12', 'Prenom_12', '2004-03-16', 1);
INSERT INTO Etudiant VALUES (20113, 'Nom_1_13', 'Prenom_13', '2004-06-20', 1);
INSERT INTO Etudiant VALUES (20114, 'Nom_1_14', 'Prenom_14', '2004-07-30', 1);
INSERT INTO Etudiant VALUES (20115, 'Nom_1_15', 'Prenom_15', '2004-09-30', 1);
INSERT INTO Etudiant VALUES (20116, 'Nom_1_16', 'Prenom_16', '2004-12-15', 1);
INSERT INTO Etudiant VALUES (20117, 'Nom_1_17', 'Prenom_17', '2004-12-27', 1);
INSERT INTO Etudiant VALUES (20118, 'Nom_1_18', 'Prenom_18', '2004-08-07', 1);
INSERT INTO Etudiant VALUES (20119, 'Nom_1_19', 'Prenom_19', '2004-07-11', 1);
INSERT INTO Etudiant VALUES (20120, 'Nom_1_20', 'Prenom_20', '2004-02-11', 1);
INSERT INTO Etudiant VALUES (20121, 'Nom_1_21', 'Prenom_21', '2004-07-22', 1);
INSERT INTO Etudiant VALUES (20122, 'Nom_1_22', 'Prenom_22', '2004-04-15', 1);
INSERT INTO Etudiant VALUES (20123, 'Nom_1_23', 'Prenom_23', '2004-02-05', 1);
INSERT INTO Etudiant VALUES (20124, 'Nom_1_24', 'Prenom_24', '2004-08-10', 1);
INSERT INTO Etudiant VALUES (20125, 'Nom_1_25', 'Prenom_25', '2004-12-27', 1);
INSERT INTO Etudiant VALUES (20126, 'Nom_1_26', 'Prenom_26', '2004-03-10', 1);
INSERT INTO Etudiant VALUES (20127, 'Nom_1_27', 'Prenom_27', '2004-12-21', 1);
INSERT INTO Etudiant VALUES (20128, 'Nom_1_28', 'Prenom_28', '2004-09-03', 1);
INSERT INTO Etudiant VALUES (20129, 'Nom_1_29', 'Prenom_29', '2004-06-04', 1);
INSERT INTO Etudiant VALUES (20130, 'Nom_1_30', 'Prenom_30', '2004-10-19', 1);
INSERT INTO Etudiant VALUES (20131, 'Nom_1_31', 'Prenom_31', '2004-10-09', 1);
INSERT INTO Etudiant VALUES (30101, 'Nom_1_1', 'Prenom_1', '2003-01-01', 1);
INSERT INTO Etudiant VALUES (30102, 'Nom_1_2', 'Prenom_2', '2003-09-04', 1);
INSERT INTO Etudiant VALUES (30103, 'Nom_1_3', 'Prenom_3', '2003-07-28', 1);
INSERT INTO Etudiant VALUES (30104, 'Nom_1_4', 'Prenom_4', '2003-11-23', 1);
INSERT INTO Etudiant VALUES (30105, 'Nom_1_5', 'Prenom_5', '2003-09-23', 1);
INSERT INTO Etudiant VALUES (30106, 'Nom_1_6', 'Prenom_6', '2003-10-12', 1);
INSERT INTO Etudiant VALUES (30107, 'Nom_1_7', 'Prenom_7', '2003-10-10', 1);
INSERT INTO Etudiant VALUES (30108, 'Nom_1_8', 'Prenom_8', '2003-05-02', 1);
INSERT INTO Etudiant VALUES (30109, 'Nom_1_9', 'Prenom_9', '2003-09-18', 1);
INSERT INTO Etudiant VALUES (30110, 'Nom_1_10', 'Prenom_10', '2003-03-04', 1);
INSERT INTO Etudiant VALUES (30111, 'Nom_1_11', 'Prenom_11', '2003-06-23', 1);
INSERT INTO Etudiant VALUES (30112, 'Nom_1_12', 'Prenom_12', '2003-09-27', 1);
INSERT INTO Etudiant VALUES (30113, 'Nom_1_13', 'Prenom_13', '2003-01-13', 1);
INSERT INTO Etudiant VALUES (30114, 'Nom_1_14', 'Prenom_14', '2003-11-07', 1);
INSERT INTO Etudiant VALUES (30115, 'Nom_1_15', 'Prenom_15', '2003-06-21', 1);
INSERT INTO Etudiant VALUES (30116, 'Nom_1_16', 'Prenom_16', '2003-06-12', 1);
INSERT INTO Etudiant VALUES (30117, 'Nom_1_17', 'Prenom_17', '2003-01-17', 1);
INSERT INTO Etudiant VALUES (30118, 'Nom_1_18', 'Prenom_18', '2003-12-08', 1);
INSERT INTO Etudiant VALUES (30119, 'Nom_1_19', 'Prenom_19', '2003-01-06', 1);
INSERT INTO Etudiant VALUES (30120, 'Nom_1_20', 'Prenom_20', '2003-08-24', 1);
INSERT INTO Etudiant VALUES (30121, 'Nom_1_21', 'Prenom_21', '2003-09-29', 1);
INSERT INTO Etudiant VALUES (30122, 'Nom_1_22', 'Prenom_22', '2003-06-18', 1);
INSERT INTO Etudiant VALUES (30123, 'Nom_1_23', 'Prenom_23', '2003-06-21', 1);
INSERT INTO Etudiant VALUES (30124, 'Nom_1_24', 'Prenom_24', '2003-04-14', 1);
INSERT INTO Etudiant VALUES (30125, 'Nom_1_25', 'Prenom_25', '2003-02-21', 1);
INSERT INTO Etudiant VALUES (30126, 'Nom_1_26', 'Prenom_26', '2003-02-14', 1);
INSERT INTO Etudiant VALUES (30127, 'Nom_1_27', 'Prenom_27', '2003-02-12', 1);
INSERT INTO Etudiant VALUES (30128, 'Nom_1_28', 'Prenom_28', '2003-10-06', 1);
INSERT INTO Etudiant VALUES (30129, 'Nom_1_29', 'Prenom_29', '2003-06-14', 1);
INSERT INTO Etudiant VALUES (30130, 'Nom_1_30', 'Prenom_30', '2003-01-01', 1);
INSERT INTO Etudiant VALUES (30131, 'Nom_1_31', 'Prenom_31', '2003-06-05', 1);
INSERT INTO Etudiant VALUES (10201, 'Nom_2_1', 'Prenom_1', '2005-02-22', 2);
INSERT INTO Etudiant VALUES (10202, 'Nom_2_2', 'Prenom_2', '2005-03-02', 2);
INSERT INTO Etudiant VALUES (10203, 'Nom_2_3', 'Prenom_3', '2005-01-21', 2);
INSERT INTO Etudiant VALUES (10204, 'Nom_2_4', 'Prenom_4', '2005-02-05', 2);
INSERT INTO Etudiant VALUES (10205, 'Nom_2_5', 'Prenom_5', '2005-03-21', 2);
INSERT INTO Etudiant VALUES (10206, 'Nom_2_6', 'Prenom_6', '2005-06-09', 2);
INSERT INTO Etudiant VALUES (10207, 'Nom_2_7', 'Prenom_7', '2005-02-20', 2);
INSERT INTO Etudiant VALUES (10208, 'Nom_2_8', 'Prenom_8', '2005-11-13', 2);
INSERT INTO Etudiant VALUES (10209, 'Nom_2_9', 'Prenom_9', '2005-01-29', 2);
INSERT INTO Etudiant VALUES (10210, 'Nom_2_10', 'Prenom_10', '2005-07-08', 2);
INSERT INTO Etudiant VALUES (10211, 'Nom_2_11', 'Prenom_11', '2005-09-07', 2);
INSERT INTO Etudiant VALUES (10212, 'Nom_2_12', 'Prenom_12', '2005-04-03', 2);
INSERT INTO Etudiant VALUES (10213, 'Nom_2_13', 'Prenom_13', '2005-06-10', 2);
INSERT INTO Etudiant VALUES (10214, 'Nom_2_14', 'Prenom_14', '2005-03-28', 2);
INSERT INTO Etudiant VALUES (10215, 'Nom_2_15', 'Prenom_15', '2005-04-17', 2);
INSERT INTO Etudiant VALUES (10216, 'Nom_2_16', 'Prenom_16', '2005-08-28', 2);
INSERT INTO Etudiant VALUES (10217, 'Nom_2_17', 'Prenom_17', '2005-06-27', 2);
INSERT INTO Etudiant VALUES (10218, 'Nom_2_18', 'Prenom_18', '2005-12-26', 2);
INSERT INTO Etudiant VALUES (10219, 'Nom_2_19', 'Prenom_19', '2005-04-04', 2);
INSERT INTO Etudiant VALUES (10220, 'Nom_2_20', 'Prenom_20', '2005-03-31', 2);
INSERT INTO Etudiant VALUES (10221, 'Nom_2_21', 'Prenom_21', '2005-10-05', 2);
INSERT INTO Etudiant VALUES (10222, 'Nom_2_22', 'Prenom_22', '2005-07-15', 2);
INSERT INTO Etudiant VALUES (10223, 'Nom_2_23', 'Prenom_23', '2005-05-20', 2);
INSERT INTO Etudiant VALUES (10224, 'Nom_2_24', 'Prenom_24', '2005-02-11', 2);
INSERT INTO Etudiant VALUES (10225, 'Nom_2_25', 'Prenom_25', '2005-03-31', 2);
INSERT INTO Etudiant VALUES (10226, 'Nom_2_26', 'Prenom_26', '2005-09-29', 2);
INSERT INTO Etudiant VALUES (10227, 'Nom_2_27', 'Prenom_27', '2005-10-02', 2);
INSERT INTO Etudiant VALUES (10228, 'Nom_2_28', 'Prenom_28', '2005-06-13', 2);
INSERT INTO Etudiant VALUES (10229, 'Nom_2_29', 'Prenom_29', '2005-02-01', 2);
INSERT INTO Etudiant VALUES (10230, 'Nom_2_30', 'Prenom_30', '2005-12-10', 2);
INSERT INTO Etudiant VALUES (10231, 'Nom_2_31', 'Prenom_31', '2005-06-25', 2);
INSERT INTO Etudiant VALUES (20201, 'Nom_2_1', 'Prenom_1', '2004-11-19', 2);
INSERT INTO Etudiant VALUES (20202, 'Nom_2_2', 'Prenom_2', '2004-07-10', 2);
INSERT INTO Etudiant VALUES (20203, 'Nom_2_3', 'Prenom_3', '2004-11-30', 2);
INSERT INTO Etudiant VALUES (20204, 'Nom_2_4', 'Prenom_4', '2004-03-05', 2);
INSERT INTO Etudiant VALUES (20205, 'Nom_2_5', 'Prenom_5', '2004-05-29', 2);
INSERT INTO Etudiant VALUES (20206, 'Nom_2_6', 'Prenom_6', '2004-08-31', 2);
INSERT INTO Etudiant VALUES (20207, 'Nom_2_7', 'Prenom_7', '2004-07-08', 2);
INSERT INTO Etudiant VALUES (20208, 'Nom_2_8', 'Prenom_8', '2004-11-09', 2);
INSERT INTO Etudiant VALUES (20209, 'Nom_2_9', 'Prenom_9', '2004-08-13', 2);
INSERT INTO Etudiant VALUES (20210, 'Nom_2_10', 'Prenom_10', '2004-01-01', 2);
INSERT INTO Etudiant VALUES (20211, 'Nom_2_11', 'Prenom_11', '2004-07-11', 2);
INSERT INTO Etudiant VALUES (20212, 'Nom_2_12', 'Prenom_12', '2004-04-25', 2);
INSERT INTO Etudiant VALUES (20213, 'Nom_2_13', 'Prenom_13', '2004-09-26', 2);
INSERT INTO Etudiant VALUES (20214, 'Nom_2_14', 'Prenom_14', '2004-03-18', 2);
INSERT INTO Etudiant VALUES (20215, 'Nom_2_15', 'Prenom_15', '2004-09-23', 2);
INSERT INTO Etudiant VALUES (20216, 'Nom_2_16', 'Prenom_16', '2004-11-27', 2);
INSERT INTO Etudiant VALUES (20217, 'Nom_2_17', 'Prenom_17', '2004-07-12', 2);
INSERT INTO Etudiant VALUES (20218, 'Nom_2_18', 'Prenom_18', '2004-11-22', 2);
INSERT INTO Etudiant VALUES (20219, 'Nom_2_19', 'Prenom_19', '2004-09-26', 2);
INSERT INTO Etudiant VALUES (20220, 'Nom_2_20', 'Prenom_20', '2004-12-25', 2);
INSERT INTO Etudiant VALUES (20221, 'Nom_2_21', 'Prenom_21', '2004-06-28', 2);
INSERT INTO Etudiant VALUES (20222, 'Nom_2_22', 'Prenom_22', '2004-05-10', 2);
INSERT INTO Etudiant VALUES (20223, 'Nom_2_23', 'Prenom_23', '2004-01-09', 2);
INSERT INTO Etudiant VALUES (20224, 'Nom_2_24', 'Prenom_24', '2004-10-06', 2);
INSERT INTO Etudiant VALUES (20225, 'Nom_2_25', 'Prenom_25', '2004-08-23', 2);
INSERT INTO Etudiant VALUES (20226, 'Nom_2_26', 'Prenom_26', '2004-10-27', 2);
INSERT INTO Etudiant VALUES (20227, 'Nom_2_27', 'Prenom_27', '2004-10-01', 2);
INSERT INTO Etudiant VALUES (20228, 'Nom_2_28', 'Prenom_28', '2004-10-07', 2);
INSERT INTO Etudiant VALUES (20229, 'Nom_2_29', 'Prenom_29', '2004-04-08', 2);
INSERT INTO Etudiant VALUES (20230, 'Nom_2_30', 'Prenom_30', '2004-09-11', 2);
INSERT INTO Etudiant VALUES (30201, 'Nom_2_1', 'Prenom_1', '2003-07-16', 2);
INSERT INTO Etudiant VALUES (30202, 'Nom_2_2', 'Prenom_2', '2003-05-26', 2);
INSERT INTO Etudiant VALUES (30203, 'Nom_2_3', 'Prenom_3', '2003-10-16', 2);
INSERT INTO Etudiant VALUES (30204, 'Nom_2_4', 'Prenom_4', '2003-11-25', 2);
INSERT INTO Etudiant VALUES (30205, 'Nom_2_5', 'Prenom_5', '2003-07-19', 2);
INSERT INTO Etudiant VALUES (30206, 'Nom_2_6', 'Prenom_6', '2003-07-29', 2);
INSERT INTO Etudiant VALUES (30207, 'Nom_2_7', 'Prenom_7', '2003-09-19', 2);
INSERT INTO Etudiant VALUES (30208, 'Nom_2_8', 'Prenom_8', '2003-11-19', 2);
INSERT INTO Etudiant VALUES (30209, 'Nom_2_9', 'Prenom_9', '2003-03-02', 2);
INSERT INTO Etudiant VALUES (30210, 'Nom_2_10', 'Prenom_10', '2003-06-08', 2);
INSERT INTO Etudiant VALUES (30211, 'Nom_2_11', 'Prenom_11', '2003-08-21', 2);
INSERT INTO Etudiant VALUES (30212, 'Nom_2_12', 'Prenom_12', '2003-05-01', 2);
INSERT INTO Etudiant VALUES (30213, 'Nom_2_13', 'Prenom_13', '2003-06-08', 2);
INSERT INTO Etudiant VALUES (30214, 'Nom_2_14', 'Prenom_14', '2003-10-20', 2);
INSERT INTO Etudiant VALUES (30215, 'Nom_2_15', 'Prenom_15', '2003-09-24', 2);
INSERT INTO Etudiant VALUES (30216, 'Nom_2_16', 'Prenom_16', '2003-12-27', 2);
INSERT INTO Etudiant VALUES (30217, 'Nom_2_17', 'Prenom_17', '2003-08-12', 2);
INSERT INTO Etudiant VALUES (30218, 'Nom_2_18', 'Prenom_18', '2003-04-22', 2);
INSERT INTO Etudiant VALUES (30219, 'Nom_2_19', 'Prenom_19', '2003-11-06', 2);
INSERT INTO Etudiant VALUES (30220, 'Nom_2_20', 'Prenom_20', '2003-11-02', 2);
INSERT INTO Etudiant VALUES (30221, 'Nom_2_21', 'Prenom_21', '2003-12-08', 2);
INSERT INTO Etudiant VALUES (30222, 'Nom_2_22', 'Prenom_22', '2003-09-30', 2);
INSERT INTO Etudiant VALUES (30223, 'Nom_2_23', 'Prenom_23', '2003-01-11', 2);
INSERT INTO Etudiant VALUES (30224, 'Nom_2_24', 'Prenom_24', '2003-02-11', 2);
INSERT INTO Etudiant VALUES (30225, 'Nom_2_25', 'Prenom_25', '2003-10-27', 2);
INSERT INTO Etudiant VALUES (30226, 'Nom_2_26', 'Prenom_26', '2003-11-26', 2);
INSERT INTO Etudiant VALUES (30227, 'Nom_2_27', 'Prenom_27', '2003-07-04', 2);
INSERT INTO Etudiant VALUES (30228, 'Nom_2_28', 'Prenom_28', '2003-02-01', 2);
INSERT INTO Etudiant VALUES (10301, 'Nom_3_1', 'Prenom_1', '2005-09-05', 3);
INSERT INTO Etudiant VALUES (10302, 'Nom_3_2', 'Prenom_2', '2005-10-30', 3);
INSERT INTO Etudiant VALUES (10303, 'Nom_3_3', 'Prenom_3', '2005-02-08', 3);
INSERT INTO Etudiant VALUES (10304, 'Nom_3_4', 'Prenom_4', '2005-06-27', 3);
INSERT INTO Etudiant VALUES (10305, 'Nom_3_5', 'Prenom_5', '2005-08-20', 3);
INSERT INTO Etudiant VALUES (10306, 'Nom_3_6', 'Prenom_6', '2005-06-17', 3);
INSERT INTO Etudiant VALUES (10307, 'Nom_3_7', 'Prenom_7', '2005-07-05', 3);
INSERT INTO Etudiant VALUES (10308, 'Nom_3_8', 'Prenom_8', '2005-05-13', 3);
INSERT INTO Etudiant VALUES (10309, 'Nom_3_9', 'Prenom_9', '2005-12-07', 3);
INSERT INTO Etudiant VALUES (10310, 'Nom_3_10', 'Prenom_10', '2005-08-05', 3);
INSERT INTO Etudiant VALUES (10311, 'Nom_3_11', 'Prenom_11', '2005-09-09', 3);
INSERT INTO Etudiant VALUES (10312, 'Nom_3_12', 'Prenom_12', '2005-08-03', 3);
INSERT INTO Etudiant VALUES (10313, 'Nom_3_13', 'Prenom_13', '2005-02-07', 3);
INSERT INTO Etudiant VALUES (10314, 'Nom_3_14', 'Prenom_14', '2005-03-04', 3);
INSERT INTO Etudiant VALUES (10315, 'Nom_3_15', 'Prenom_15', '2005-09-18', 3);
INSERT INTO Etudiant VALUES (10316, 'Nom_3_16', 'Prenom_16', '2005-09-15', 3);
INSERT INTO Etudiant VALUES (10317, 'Nom_3_17', 'Prenom_17', '2005-03-06', 3);
INSERT INTO Etudiant VALUES (10318, 'Nom_3_18', 'Prenom_18', '2005-11-01', 3);
INSERT INTO Etudiant VALUES (10319, 'Nom_3_19', 'Prenom_19', '2005-11-16', 3);
INSERT INTO Etudiant VALUES (10320, 'Nom_3_20', 'Prenom_20', '2005-12-13', 3);
INSERT INTO Etudiant VALUES (10321, 'Nom_3_21', 'Prenom_21', '2005-05-10', 3);
INSERT INTO Etudiant VALUES (10322, 'Nom_3_22', 'Prenom_22', '2005-04-22', 3);
INSERT INTO Etudiant VALUES (10323, 'Nom_3_23', 'Prenom_23', '2005-06-11', 3);
INSERT INTO Etudiant VALUES (10324, 'Nom_3_24', 'Prenom_24', '2005-03-31', 3);
INSERT INTO Etudiant VALUES (10325, 'Nom_3_25', 'Prenom_25', '2005-06-20', 3);
INSERT INTO Etudiant VALUES (10326, 'Nom_3_26', 'Prenom_26', '2005-04-09', 3);
INSERT INTO Etudiant VALUES (10327, 'Nom_3_27', 'Prenom_27', '2005-01-18', 3);
INSERT INTO Etudiant VALUES (10328, 'Nom_3_28', 'Prenom_28', '2005-07-13', 3);
INSERT INTO Etudiant VALUES (10329, 'Nom_3_29', 'Prenom_29', '2005-10-19', 3);
INSERT INTO Etudiant VALUES (10330, 'Nom_3_30', 'Prenom_30', '2005-08-17', 3);
INSERT INTO Etudiant VALUES (20301, 'Nom_3_1', 'Prenom_1', '2004-06-03', 3);
INSERT INTO Etudiant VALUES (20302, 'Nom_3_2', 'Prenom_2', '2004-07-17', 3);
INSERT INTO Etudiant VALUES (20303, 'Nom_3_3', 'Prenom_3', '2004-02-29', 3);
INSERT INTO Etudiant VALUES (20304, 'Nom_3_4', 'Prenom_4', '2004-02-14', 3);
INSERT INTO Etudiant VALUES (20305, 'Nom_3_5', 'Prenom_5', '2004-07-05', 3);
INSERT INTO Etudiant VALUES (20306, 'Nom_3_6', 'Prenom_6', '2004-12-17', 3);
INSERT INTO Etudiant VALUES (20307, 'Nom_3_7', 'Prenom_7', '2004-08-13', 3);
INSERT INTO Etudiant VALUES (20308, 'Nom_3_8', 'Prenom_8', '2004-06-18', 3);
INSERT INTO Etudiant VALUES (20309, 'Nom_3_9', 'Prenom_9', '2004-07-12', 3);
INSERT INTO Etudiant VALUES (20310, 'Nom_3_10', 'Prenom_10', '2004-02-15', 3);
INSERT INTO Etudiant VALUES (20311, 'Nom_3_11', 'Prenom_11', '2004-11-12', 3);
INSERT INTO Etudiant VALUES (20312, 'Nom_3_12', 'Prenom_12', '2004-09-25', 3);
INSERT INTO Etudiant VALUES (20313, 'Nom_3_13', 'Prenom_13', '2004-05-17', 3);
INSERT INTO Etudiant VALUES (20314, 'Nom_3_14', 'Prenom_14', '2004-12-09', 3);
INSERT INTO Etudiant VALUES (20315, 'Nom_3_15', 'Prenom_15', '2004-07-01', 3);
INSERT INTO Etudiant VALUES (20316, 'Nom_3_16', 'Prenom_16', '2004-10-01', 3);
INSERT INTO Etudiant VALUES (20317, 'Nom_3_17', 'Prenom_17', '2004-07-30', 3);
INSERT INTO Etudiant VALUES (20318, 'Nom_3_18', 'Prenom_18', '2004-09-21', 3);
INSERT INTO Etudiant VALUES (20319, 'Nom_3_19', 'Prenom_19', '2004-05-02', 3);
INSERT INTO Etudiant VALUES (20320, 'Nom_3_20', 'Prenom_20', '2004-01-23', 3);
INSERT INTO Etudiant VALUES (20321, 'Nom_3_21', 'Prenom_21', '2004-01-01', 3);
INSERT INTO Etudiant VALUES (20322, 'Nom_3_22', 'Prenom_22', '2004-02-13', 3);
INSERT INTO Etudiant VALUES (20323, 'Nom_3_23', 'Prenom_23', '2004-04-05', 3);
INSERT INTO Etudiant VALUES (20324, 'Nom_3_24', 'Prenom_24', '2004-07-09', 3);
INSERT INTO Etudiant VALUES (20325, 'Nom_3_25', 'Prenom_25', '2004-01-30', 3);
INSERT INTO Etudiant VALUES (20326, 'Nom_3_26', 'Prenom_26', '2004-12-02', 3);
INSERT INTO Etudiant VALUES (20327, 'Nom_3_27', 'Prenom_27', '2004-08-18', 3);
INSERT INTO Etudiant VALUES (20328, 'Nom_3_28', 'Prenom_28', '2004-10-08', 3);
INSERT INTO Etudiant VALUES (20329, 'Nom_3_29', 'Prenom_29', '2004-08-05', 3);
INSERT INTO Etudiant VALUES (20330, 'Nom_3_30', 'Prenom_30', '2004-06-23', 3);
INSERT INTO Etudiant VALUES (20331, 'Nom_3_31', 'Prenom_31', '2004-01-08', 3);
INSERT INTO Etudiant VALUES (30301, 'Nom_3_1', 'Prenom_1', '2003-11-23', 3);
INSERT INTO Etudiant VALUES (30302, 'Nom_3_2', 'Prenom_2', '2003-03-01', 3);
INSERT INTO Etudiant VALUES (30303, 'Nom_3_3', 'Prenom_3', '2003-07-02', 3);
INSERT INTO Etudiant VALUES (30304, 'Nom_3_4', 'Prenom_4', '2003-02-14', 3);
INSERT INTO Etudiant VALUES (30305, 'Nom_3_5', 'Prenom_5', '2003-08-11', 3);
INSERT INTO Etudiant VALUES (30306, 'Nom_3_6', 'Prenom_6', '2003-07-19', 3);
INSERT INTO Etudiant VALUES (30307, 'Nom_3_7', 'Prenom_7', '2003-06-16', 3);
INSERT INTO Etudiant VALUES (30308, 'Nom_3_8', 'Prenom_8', '2003-11-16', 3);
INSERT INTO Etudiant VALUES (30309, 'Nom_3_9', 'Prenom_9', '2003-01-18', 3);
INSERT INTO Etudiant VALUES (30310, 'Nom_3_10', 'Prenom_10', '2003-12-09', 3);
INSERT INTO Etudiant VALUES (30311, 'Nom_3_11', 'Prenom_11', '2003-07-07', 3);
INSERT INTO Etudiant VALUES (30312, 'Nom_3_12', 'Prenom_12', '2003-12-21', 3);
INSERT INTO Etudiant VALUES (30313, 'Nom_3_13', 'Prenom_13', '2003-05-10', 3);
INSERT INTO Etudiant VALUES (30314, 'Nom_3_14', 'Prenom_14', '2003-12-06', 3);
INSERT INTO Etudiant VALUES (30315, 'Nom_3_15', 'Prenom_15', '2003-05-01', 3);
INSERT INTO Etudiant VALUES (30316, 'Nom_3_16', 'Prenom_16', '2003-12-15', 3);
INSERT INTO Etudiant VALUES (30317, 'Nom_3_17', 'Prenom_17', '2003-02-15', 3);
INSERT INTO Etudiant VALUES (30318, 'Nom_3_18', 'Prenom_18', '2003-06-24', 3);
INSERT INTO Etudiant VALUES (30319, 'Nom_3_19', 'Prenom_19', '2003-06-05', 3);
INSERT INTO Etudiant VALUES (30320, 'Nom_3_20', 'Prenom_20', '2003-10-15', 3);
INSERT INTO Etudiant VALUES (30321, 'Nom_3_21', 'Prenom_21', '2003-07-12', 3);
INSERT INTO Etudiant VALUES (30322, 'Nom_3_22', 'Prenom_22', '2003-08-15', 3);
INSERT INTO Etudiant VALUES (30323, 'Nom_3_23', 'Prenom_23', '2003-03-07', 3);
INSERT INTO Etudiant VALUES (30324, 'Nom_3_24', 'Prenom_24', '2003-06-02', 3);
INSERT INTO Etudiant VALUES (30325, 'Nom_3_25', 'Prenom_25', '2003-12-09', 3);
INSERT INTO Etudiant VALUES (30326, 'Nom_3_26', 'Prenom_26', '2003-07-14', 3);
INSERT INTO Etudiant VALUES (30327, 'Nom_3_27', 'Prenom_27', '2003-09-03', 3);
INSERT INTO Etudiant VALUES (30328, 'Nom_3_28', 'Prenom_28', '2003-07-05', 3);
INSERT INTO Etudiant VALUES (30329, 'Nom_3_29', 'Prenom_29', '2003-12-07', 3);
INSERT INTO Etudiant VALUES (10401, 'Nom_4_1', 'Prenom_1', '2005-09-04', 4);
INSERT INTO Etudiant VALUES (10402, 'Nom_4_2', 'Prenom_2', '2005-06-13', 4);
INSERT INTO Etudiant VALUES (10403, 'Nom_4_3', 'Prenom_3', '2005-11-08', 4);
INSERT INTO Etudiant VALUES (10404, 'Nom_4_4', 'Prenom_4', '2005-12-17', 4);
INSERT INTO Etudiant VALUES (10405, 'Nom_4_5', 'Prenom_5', '2005-05-02', 4);
INSERT INTO Etudiant VALUES (10406, 'Nom_4_6', 'Prenom_6', '2005-07-12', 4);
INSERT INTO Etudiant VALUES (10407, 'Nom_4_7', 'Prenom_7', '2005-06-22', 4);
INSERT INTO Etudiant VALUES (10408, 'Nom_4_8', 'Prenom_8', '2005-05-05', 4);
INSERT INTO Etudiant VALUES (10409, 'Nom_4_9', 'Prenom_9', '2005-04-26', 4);
INSERT INTO Etudiant VALUES (10410, 'Nom_4_10', 'Prenom_10', '2005-11-16', 4);
INSERT INTO Etudiant VALUES (10411, 'Nom_4_11', 'Prenom_11', '2005-04-01', 4);
INSERT INTO Etudiant VALUES (10412, 'Nom_4_12', 'Prenom_12', '2005-05-15', 4);
INSERT INTO Etudiant VALUES (10413, 'Nom_4_13', 'Prenom_13', '2005-01-21', 4);
INSERT INTO Etudiant VALUES (10414, 'Nom_4_14', 'Prenom_14', '2005-09-25', 4);
INSERT INTO Etudiant VALUES (10415, 'Nom_4_15', 'Prenom_15', '2005-01-06', 4);
INSERT INTO Etudiant VALUES (10416, 'Nom_4_16', 'Prenom_16', '2005-12-17', 4);
INSERT INTO Etudiant VALUES (10417, 'Nom_4_17', 'Prenom_17', '2005-11-16', 4);
INSERT INTO Etudiant VALUES (10418, 'Nom_4_18', 'Prenom_18', '2005-02-11', 4);
INSERT INTO Etudiant VALUES (10419, 'Nom_4_19', 'Prenom_19', '2005-08-11', 4);
INSERT INTO Etudiant VALUES (10420, 'Nom_4_20', 'Prenom_20', '2005-12-29', 4);
INSERT INTO Etudiant VALUES (10421, 'Nom_4_21', 'Prenom_21', '2005-02-26', 4);
INSERT INTO Etudiant VALUES (10422, 'Nom_4_22', 'Prenom_22', '2005-11-02', 4);
INSERT INTO Etudiant VALUES (10423, 'Nom_4_23', 'Prenom_23', '2005-08-05', 4);
INSERT INTO Etudiant VALUES (10424, 'Nom_4_24', 'Prenom_24', '2005-12-31', 4);
INSERT INTO Etudiant VALUES (10425, 'Nom_4_25', 'Prenom_25', '2005-03-09', 4);
INSERT INTO Etudiant VALUES (10426, 'Nom_4_26', 'Prenom_26', '2005-03-28', 4);
INSERT INTO Etudiant VALUES (10427, 'Nom_4_27', 'Prenom_27', '2005-05-28', 4);
INSERT INTO Etudiant VALUES (10428, 'Nom_4_28', 'Prenom_28', '2005-10-08', 4);
INSERT INTO Etudiant VALUES (10429, 'Nom_4_29', 'Prenom_29', '2005-11-03', 4);
INSERT INTO Etudiant VALUES (20401, 'Nom_4_1', 'Prenom_1', '2004-12-05', 4);
INSERT INTO Etudiant VALUES (20402, 'Nom_4_2', 'Prenom_2', '2004-03-15', 4);
INSERT INTO Etudiant VALUES (20403, 'Nom_4_3', 'Prenom_3', '2004-02-27', 4);
INSERT INTO Etudiant VALUES (20404, 'Nom_4_4', 'Prenom_4', '2004-09-11', 4);
INSERT INTO Etudiant VALUES (20405, 'Nom_4_5', 'Prenom_5', '2004-06-01', 4);
INSERT INTO Etudiant VALUES (20406, 'Nom_4_6', 'Prenom_6', '2004-03-30', 4);
INSERT INTO Etudiant VALUES (20407, 'Nom_4_7', 'Prenom_7', '2004-04-06', 4);
INSERT INTO Etudiant VALUES (20408, 'Nom_4_8', 'Prenom_8', '2004-12-31', 4);
INSERT INTO Etudiant VALUES (20409, 'Nom_4_9', 'Prenom_9', '2004-12-10', 4);
INSERT INTO Etudiant VALUES (20410, 'Nom_4_10', 'Prenom_10', '2004-09-25', 4);
INSERT INTO Etudiant VALUES (20411, 'Nom_4_11', 'Prenom_11', '2004-01-15', 4);
INSERT INTO Etudiant VALUES (20412, 'Nom_4_12', 'Prenom_12', '2004-12-27', 4);
INSERT INTO Etudiant VALUES (20413, 'Nom_4_13', 'Prenom_13', '2004-03-28', 4);
INSERT INTO Etudiant VALUES (20414, 'Nom_4_14', 'Prenom_14', '2004-11-27', 4);
INSERT INTO Etudiant VALUES (20415, 'Nom_4_15', 'Prenom_15', '2004-12-24', 4);
INSERT INTO Etudiant VALUES (20416, 'Nom_4_16', 'Prenom_16', '2004-03-11', 4);
INSERT INTO Etudiant VALUES (20417, 'Nom_4_17', 'Prenom_17', '2004-07-31', 4);
INSERT INTO Etudiant VALUES (20418, 'Nom_4_18', 'Prenom_18', '2004-08-24', 4);
INSERT INTO Etudiant VALUES (20419, 'Nom_4_19', 'Prenom_19', '2004-02-25', 4);
INSERT INTO Etudiant VALUES (20420, 'Nom_4_20', 'Prenom_20', '2004-12-13', 4);
INSERT INTO Etudiant VALUES (20421, 'Nom_4_21', 'Prenom_21', '2004-06-16', 4);
INSERT INTO Etudiant VALUES (20422, 'Nom_4_22', 'Prenom_22', '2004-01-09', 4);
INSERT INTO Etudiant VALUES (20423, 'Nom_4_23', 'Prenom_23', '2004-03-21', 4);
INSERT INTO Etudiant VALUES (20424, 'Nom_4_24', 'Prenom_24', '2004-05-24', 4);
INSERT INTO Etudiant VALUES (20425, 'Nom_4_25', 'Prenom_25', '2004-04-19', 4);
INSERT INTO Etudiant VALUES (20426, 'Nom_4_26', 'Prenom_26', '2004-06-26', 4);
INSERT INTO Etudiant VALUES (20427, 'Nom_4_27', 'Prenom_27', '2004-12-15', 4);
INSERT INTO Etudiant VALUES (20428, 'Nom_4_28', 'Prenom_28', '2004-09-29', 4);
INSERT INTO Etudiant VALUES (20429, 'Nom_4_29', 'Prenom_29', '2004-06-24', 4);
INSERT INTO Etudiant VALUES (20430, 'Nom_4_30', 'Prenom_30', '2004-08-22', 4);
INSERT INTO Etudiant VALUES (20431, 'Nom_4_31', 'Prenom_31', '2004-06-29', 4);
INSERT INTO Etudiant VALUES (20432, 'Nom_4_32', 'Prenom_32', '2004-04-18', 4);
INSERT INTO Etudiant VALUES (30401, 'Nom_4_1', 'Prenom_1', '2003-07-15', 4);
INSERT INTO Etudiant VALUES (30402, 'Nom_4_2', 'Prenom_2', '2003-09-19', 4);
INSERT INTO Etudiant VALUES (30403, 'Nom_4_3', 'Prenom_3', '2003-11-08', 4);
INSERT INTO Etudiant VALUES (30404, 'Nom_4_4', 'Prenom_4', '2003-02-15', 4);
INSERT INTO Etudiant VALUES (30405, 'Nom_4_5', 'Prenom_5', '2003-04-02', 4);
INSERT INTO Etudiant VALUES (30406, 'Nom_4_6', 'Prenom_6', '2003-08-31', 4);
INSERT INTO Etudiant VALUES (30407, 'Nom_4_7', 'Prenom_7', '2003-11-06', 4);
INSERT INTO Etudiant VALUES (30408, 'Nom_4_8', 'Prenom_8', '2003-08-27', 4);
INSERT INTO Etudiant VALUES (30409, 'Nom_4_9', 'Prenom_9', '2003-02-22', 4);
INSERT INTO Etudiant VALUES (30410, 'Nom_4_10', 'Prenom_10', '2003-11-02', 4);
INSERT INTO Etudiant VALUES (30411, 'Nom_4_11', 'Prenom_11', '2003-12-11', 4);
INSERT INTO Etudiant VALUES (30412, 'Nom_4_12', 'Prenom_12', '2003-04-11', 4);
INSERT INTO Etudiant VALUES (30413, 'Nom_4_13', 'Prenom_13', '2003-07-01', 4);
INSERT INTO Etudiant VALUES (30414, 'Nom_4_14', 'Prenom_14', '2003-11-30', 4);
INSERT INTO Etudiant VALUES (30415, 'Nom_4_15', 'Prenom_15', '2003-03-25', 4);
INSERT INTO Etudiant VALUES (30416, 'Nom_4_16', 'Prenom_16', '2003-10-28', 4);
INSERT INTO Etudiant VALUES (30417, 'Nom_4_17', 'Prenom_17', '2003-06-03', 4);
INSERT INTO Etudiant VALUES (30418, 'Nom_4_18', 'Prenom_18', '2003-01-10', 4);
INSERT INTO Etudiant VALUES (30419, 'Nom_4_19', 'Prenom_19', '2003-10-23', 4);
INSERT INTO Etudiant VALUES (30420, 'Nom_4_20', 'Prenom_20', '2003-01-20', 4);
INSERT INTO Etudiant VALUES (30421, 'Nom_4_21', 'Prenom_21', '2003-01-30', 4);
INSERT INTO Etudiant VALUES (30422, 'Nom_4_22', 'Prenom_22', '2003-07-11', 4);
INSERT INTO Etudiant VALUES (30423, 'Nom_4_23', 'Prenom_23', '2003-02-06', 4);
INSERT INTO Etudiant VALUES (30424, 'Nom_4_24', 'Prenom_24', '2003-07-19', 4);
INSERT INTO Etudiant VALUES (30425, 'Nom_4_25', 'Prenom_25', '2003-06-19', 4);
INSERT INTO Etudiant VALUES (30426, 'Nom_4_26', 'Prenom_26', '2003-10-25', 4);
INSERT INTO Etudiant VALUES (30427, 'Nom_4_27', 'Prenom_27', '2003-12-21', 4);
INSERT INTO Etudiant VALUES (30428, 'Nom_4_28', 'Prenom_28', '2003-08-16', 4);
INSERT INTO Etudiant VALUES (30429, 'Nom_4_29', 'Prenom_29', '2003-11-13', 4);
INSERT INTO Etudiant VALUES (10501, 'Nom_5_1', 'Prenom_1', '2005-11-11', 5);
INSERT INTO Etudiant VALUES (10502, 'Nom_5_2', 'Prenom_2', '2005-03-02', 5);
INSERT INTO Etudiant VALUES (10503, 'Nom_5_3', 'Prenom_3', '2005-09-01', 5);
INSERT INTO Etudiant VALUES (10504, 'Nom_5_4', 'Prenom_4', '2005-05-06', 5);
INSERT INTO Etudiant VALUES (10505, 'Nom_5_5', 'Prenom_5', '2005-03-22', 5);
INSERT INTO Etudiant VALUES (10506, 'Nom_5_6', 'Prenom_6', '2005-06-05', 5);
INSERT INTO Etudiant VALUES (10507, 'Nom_5_7', 'Prenom_7', '2005-02-19', 5);
INSERT INTO Etudiant VALUES (10508, 'Nom_5_8', 'Prenom_8', '2005-08-05', 5);
INSERT INTO Etudiant VALUES (10509, 'Nom_5_9', 'Prenom_9', '2005-04-15', 5);
INSERT INTO Etudiant VALUES (10510, 'Nom_5_10', 'Prenom_10', '2005-06-14', 5);
INSERT INTO Etudiant VALUES (10511, 'Nom_5_11', 'Prenom_11', '2005-06-06', 5);
INSERT INTO Etudiant VALUES (10512, 'Nom_5_12', 'Prenom_12', '2005-01-08', 5);
INSERT INTO Etudiant VALUES (10513, 'Nom_5_13', 'Prenom_13', '2005-07-02', 5);
INSERT INTO Etudiant VALUES (10514, 'Nom_5_14', 'Prenom_14', '2005-01-03', 5);
INSERT INTO Etudiant VALUES (10515, 'Nom_5_15', 'Prenom_15', '2005-12-09', 5);
INSERT INTO Etudiant VALUES (10516, 'Nom_5_16', 'Prenom_16', '2005-02-27', 5);
INSERT INTO Etudiant VALUES (10517, 'Nom_5_17', 'Prenom_17', '2005-07-08', 5);
INSERT INTO Etudiant VALUES (10518, 'Nom_5_18', 'Prenom_18', '2005-08-22', 5);
INSERT INTO Etudiant VALUES (10519, 'Nom_5_19', 'Prenom_19', '2005-11-14', 5);
INSERT INTO Etudiant VALUES (10520, 'Nom_5_20', 'Prenom_20', '2005-06-12', 5);
INSERT INTO Etudiant VALUES (10521, 'Nom_5_21', 'Prenom_21', '2005-08-22', 5);
INSERT INTO Etudiant VALUES (10522, 'Nom_5_22', 'Prenom_22', '2005-03-23', 5);
INSERT INTO Etudiant VALUES (10523, 'Nom_5_23', 'Prenom_23', '2005-04-30', 5);
INSERT INTO Etudiant VALUES (10524, 'Nom_5_24', 'Prenom_24', '2005-07-27', 5);
INSERT INTO Etudiant VALUES (10525, 'Nom_5_25', 'Prenom_25', '2005-10-05', 5);
INSERT INTO Etudiant VALUES (10526, 'Nom_5_26', 'Prenom_26', '2005-09-22', 5);
INSERT INTO Etudiant VALUES (10527, 'Nom_5_27', 'Prenom_27', '2005-09-12', 5);
INSERT INTO Etudiant VALUES (10528, 'Nom_5_28', 'Prenom_28', '2005-05-13', 5);
INSERT INTO Etudiant VALUES (10529, 'Nom_5_29', 'Prenom_29', '2005-04-27', 5);
INSERT INTO Etudiant VALUES (10530, 'Nom_5_30', 'Prenom_30', '2005-04-10', 5);
INSERT INTO Etudiant VALUES (10531, 'Nom_5_31', 'Prenom_31', '2005-09-30', 5);
INSERT INTO Etudiant VALUES (10532, 'Nom_5_32', 'Prenom_32', '2005-04-25', 5);
INSERT INTO Etudiant VALUES (20501, 'Nom_5_1', 'Prenom_1', '2004-05-27', 5);
INSERT INTO Etudiant VALUES (20502, 'Nom_5_2', 'Prenom_2', '2004-10-08', 5);
INSERT INTO Etudiant VALUES (20503, 'Nom_5_3', 'Prenom_3', '2004-12-21', 5);
INSERT INTO Etudiant VALUES (20504, 'Nom_5_4', 'Prenom_4', '2004-08-01', 5);
INSERT INTO Etudiant VALUES (20505, 'Nom_5_5', 'Prenom_5', '2004-01-16', 5);
INSERT INTO Etudiant VALUES (20506, 'Nom_5_6', 'Prenom_6', '2004-06-13', 5);
INSERT INTO Etudiant VALUES (20507, 'Nom_5_7', 'Prenom_7', '2004-07-03', 5);
INSERT INTO Etudiant VALUES (20508, 'Nom_5_8', 'Prenom_8', '2004-11-01', 5);
INSERT INTO Etudiant VALUES (20509, 'Nom_5_9', 'Prenom_9', '2004-05-15', 5);
INSERT INTO Etudiant VALUES (20510, 'Nom_5_10', 'Prenom_10', '2004-12-09', 5);
INSERT INTO Etudiant VALUES (20511, 'Nom_5_11', 'Prenom_11', '2004-09-29', 5);
INSERT INTO Etudiant VALUES (20512, 'Nom_5_12', 'Prenom_12', '2004-03-24', 5);
INSERT INTO Etudiant VALUES (20513, 'Nom_5_13', 'Prenom_13', '2004-09-03', 5);
INSERT INTO Etudiant VALUES (20514, 'Nom_5_14', 'Prenom_14', '2004-12-17', 5);
INSERT INTO Etudiant VALUES (20515, 'Nom_5_15', 'Prenom_15', '2004-07-31', 5);
INSERT INTO Etudiant VALUES (20516, 'Nom_5_16', 'Prenom_16', '2004-06-30', 5);
INSERT INTO Etudiant VALUES (20517, 'Nom_5_17', 'Prenom_17', '2004-06-11', 5);
INSERT INTO Etudiant VALUES (20518, 'Nom_5_18', 'Prenom_18', '2004-12-01', 5);
INSERT INTO Etudiant VALUES (20519, 'Nom_5_19', 'Prenom_19', '2004-05-27', 5);
INSERT INTO Etudiant VALUES (20520, 'Nom_5_20', 'Prenom_20', '2004-12-11', 5);
INSERT INTO Etudiant VALUES (20521, 'Nom_5_21', 'Prenom_21', '2004-09-28', 5);
INSERT INTO Etudiant VALUES (20522, 'Nom_5_22', 'Prenom_22', '2004-01-27', 5);
INSERT INTO Etudiant VALUES (20523, 'Nom_5_23', 'Prenom_23', '2004-06-12', 5);
INSERT INTO Etudiant VALUES (20524, 'Nom_5_24', 'Prenom_24', '2004-08-14', 5);
INSERT INTO Etudiant VALUES (20525, 'Nom_5_25', 'Prenom_25', '2004-05-18', 5);
INSERT INTO Etudiant VALUES (20526, 'Nom_5_26', 'Prenom_26', '2004-05-25', 5);
INSERT INTO Etudiant VALUES (20527, 'Nom_5_27', 'Prenom_27', '2004-11-15', 5);
INSERT INTO Etudiant VALUES (20528, 'Nom_5_28', 'Prenom_28', '2004-05-29', 5);
INSERT INTO Etudiant VALUES (30501, 'Nom_5_1', 'Prenom_1', '2003-04-19', 5);
INSERT INTO Etudiant VALUES (30502, 'Nom_5_2', 'Prenom_2', '2003-07-04', 5);
INSERT INTO Etudiant VALUES (30503, 'Nom_5_3', 'Prenom_3', '2003-02-06', 5);
INSERT INTO Etudiant VALUES (30504, 'Nom_5_4', 'Prenom_4', '2003-09-28', 5);
INSERT INTO Etudiant VALUES (30505, 'Nom_5_5', 'Prenom_5', '2003-12-30', 5);
INSERT INTO Etudiant VALUES (30506, 'Nom_5_6', 'Prenom_6', '2003-12-06', 5);
INSERT INTO Etudiant VALUES (30507, 'Nom_5_7', 'Prenom_7', '2003-09-08', 5);
INSERT INTO Etudiant VALUES (30508, 'Nom_5_8', 'Prenom_8', '2003-12-04', 5);
INSERT INTO Etudiant VALUES (30509, 'Nom_5_9', 'Prenom_9', '2003-10-16', 5);
INSERT INTO Etudiant VALUES (30510, 'Nom_5_10', 'Prenom_10', '2003-06-12', 5);
INSERT INTO Etudiant VALUES (30511, 'Nom_5_11', 'Prenom_11', '2003-01-29', 5);
INSERT INTO Etudiant VALUES (30512, 'Nom_5_12', 'Prenom_12', '2003-08-19', 5);
INSERT INTO Etudiant VALUES (30513, 'Nom_5_13', 'Prenom_13', '2003-06-12', 5);
INSERT INTO Etudiant VALUES (30514, 'Nom_5_14', 'Prenom_14', '2003-09-29', 5);
INSERT INTO Etudiant VALUES (30515, 'Nom_5_15', 'Prenom_15', '2003-11-05', 5);
INSERT INTO Etudiant VALUES (30516, 'Nom_5_16', 'Prenom_16', '2003-11-17', 5);
INSERT INTO Etudiant VALUES (30517, 'Nom_5_17', 'Prenom_17', '2003-07-07', 5);
INSERT INTO Etudiant VALUES (30518, 'Nom_5_18', 'Prenom_18', '2003-06-02', 5);
INSERT INTO Etudiant VALUES (30519, 'Nom_5_19', 'Prenom_19', '2003-05-04', 5);
INSERT INTO Etudiant VALUES (30520, 'Nom_5_20', 'Prenom_20', '2003-05-29', 5);
INSERT INTO Etudiant VALUES (30521, 'Nom_5_21', 'Prenom_21', '2003-01-14', 5);
INSERT INTO Etudiant VALUES (30522, 'Nom_5_22', 'Prenom_22', '2003-02-28', 5);
INSERT INTO Etudiant VALUES (30523, 'Nom_5_23', 'Prenom_23', '2003-03-11', 5);
INSERT INTO Etudiant VALUES (30524, 'Nom_5_24', 'Prenom_24', '2003-05-24', 5);
INSERT INTO Etudiant VALUES (30525, 'Nom_5_25', 'Prenom_25', '2003-12-31', 5);
INSERT INTO Etudiant VALUES (30526, 'Nom_5_26', 'Prenom_26', '2003-08-01', 5);
INSERT INTO Etudiant VALUES (30527, 'Nom_5_27', 'Prenom_27', '2003-07-06', 5);
INSERT INTO Etudiant VALUES (30528, 'Nom_5_28', 'Prenom_28', '2003-03-07', 5);
INSERT INTO Etudiant VALUES (30529, 'Nom_5_29', 'Prenom_29', '2003-09-30', 5);
INSERT INTO Etudiant VALUES (30530, 'Nom_5_30', 'Prenom_30', '2003-01-19', 5);
INSERT INTO Etudiant VALUES (30531, 'Nom_5_31', 'Prenom_31', '2003-12-24', 5);
INSERT INTO Etudiant VALUES (30532, 'Nom_5_32', 'Prenom_32', '2003-03-21', 5);
INSERT INTO Etudiant VALUES (10601, 'Nom_6_1', 'Prenom_1', '2005-02-11', 6);
INSERT INTO Etudiant VALUES (10602, 'Nom_6_2', 'Prenom_2', '2005-08-05', 6);
INSERT INTO Etudiant VALUES (10603, 'Nom_6_3', 'Prenom_3', '2005-05-19', 6);
INSERT INTO Etudiant VALUES (10604, 'Nom_6_4', 'Prenom_4', '2005-12-21', 6);
INSERT INTO Etudiant VALUES (10605, 'Nom_6_5', 'Prenom_5', '2005-02-23', 6);
INSERT INTO Etudiant VALUES (10606, 'Nom_6_6', 'Prenom_6', '2005-11-24', 6);
INSERT INTO Etudiant VALUES (10607, 'Nom_6_7', 'Prenom_7', '2005-04-24', 6);
INSERT INTO Etudiant VALUES (10608, 'Nom_6_8', 'Prenom_8', '2005-05-24', 6);
INSERT INTO Etudiant VALUES (10609, 'Nom_6_9', 'Prenom_9', '2005-04-10', 6);
INSERT INTO Etudiant VALUES (10610, 'Nom_6_10', 'Prenom_10', '2005-09-11', 6);
INSERT INTO Etudiant VALUES (10611, 'Nom_6_11', 'Prenom_11', '2005-08-14', 6);
INSERT INTO Etudiant VALUES (10612, 'Nom_6_12', 'Prenom_12', '2005-10-23', 6);
INSERT INTO Etudiant VALUES (10613, 'Nom_6_13', 'Prenom_13', '2005-09-20', 6);
INSERT INTO Etudiant VALUES (10614, 'Nom_6_14', 'Prenom_14', '2005-12-16', 6);
INSERT INTO Etudiant VALUES (10615, 'Nom_6_15', 'Prenom_15', '2005-04-29', 6);
INSERT INTO Etudiant VALUES (10616, 'Nom_6_16', 'Prenom_16', '2005-08-09', 6);
INSERT INTO Etudiant VALUES (10617, 'Nom_6_17', 'Prenom_17', '2005-02-21', 6);
INSERT INTO Etudiant VALUES (10618, 'Nom_6_18', 'Prenom_18', '2005-09-16', 6);
INSERT INTO Etudiant VALUES (10619, 'Nom_6_19', 'Prenom_19', '2005-07-08', 6);
INSERT INTO Etudiant VALUES (10620, 'Nom_6_20', 'Prenom_20', '2005-03-03', 6);
INSERT INTO Etudiant VALUES (10621, 'Nom_6_21', 'Prenom_21', '2005-04-03', 6);
INSERT INTO Etudiant VALUES (10622, 'Nom_6_22', 'Prenom_22', '2005-01-15', 6);
INSERT INTO Etudiant VALUES (10623, 'Nom_6_23', 'Prenom_23', '2005-10-04', 6);
INSERT INTO Etudiant VALUES (10624, 'Nom_6_24', 'Prenom_24', '2005-02-23', 6);
INSERT INTO Etudiant VALUES (10625, 'Nom_6_25', 'Prenom_25', '2005-05-19', 6);
INSERT INTO Etudiant VALUES (10626, 'Nom_6_26', 'Prenom_26', '2005-08-29', 6);
INSERT INTO Etudiant VALUES (10627, 'Nom_6_27', 'Prenom_27', '2005-06-01', 6);
INSERT INTO Etudiant VALUES (10628, 'Nom_6_28', 'Prenom_28', '2005-06-22', 6);
INSERT INTO Etudiant VALUES (10629, 'Nom_6_29', 'Prenom_29', '2005-09-09', 6);
INSERT INTO Etudiant VALUES (10630, 'Nom_6_30', 'Prenom_30', '2005-04-09', 6);
INSERT INTO Etudiant VALUES (10631, 'Nom_6_31', 'Prenom_31', '2005-01-19', 6);
INSERT INTO Etudiant VALUES (10632, 'Nom_6_32', 'Prenom_32', '2005-07-17', 6);
INSERT INTO Etudiant VALUES (20601, 'Nom_6_1', 'Prenom_1', '2004-12-25', 6);
INSERT INTO Etudiant VALUES (20602, 'Nom_6_2', 'Prenom_2', '2004-09-15', 6);
INSERT INTO Etudiant VALUES (20603, 'Nom_6_3', 'Prenom_3', '2004-08-13', 6);
INSERT INTO Etudiant VALUES (20604, 'Nom_6_4', 'Prenom_4', '2004-02-01', 6);
INSERT INTO Etudiant VALUES (20605, 'Nom_6_5', 'Prenom_5', '2004-06-27', 6);
INSERT INTO Etudiant VALUES (20606, 'Nom_6_6', 'Prenom_6', '2004-11-12', 6);
INSERT INTO Etudiant VALUES (20607, 'Nom_6_7', 'Prenom_7', '2004-03-12', 6);
INSERT INTO Etudiant VALUES (20608, 'Nom_6_8', 'Prenom_8', '2004-03-09', 6);
INSERT INTO Etudiant VALUES (20609, 'Nom_6_9', 'Prenom_9', '2004-09-01', 6);
INSERT INTO Etudiant VALUES (20610, 'Nom_6_10', 'Prenom_10', '2004-06-25', 6);
INSERT INTO Etudiant VALUES (20611, 'Nom_6_11', 'Prenom_11', '2004-09-17', 6);
INSERT INTO Etudiant VALUES (20612, 'Nom_6_12', 'Prenom_12', '2004-02-02', 6);
INSERT INTO Etudiant VALUES (20613, 'Nom_6_13', 'Prenom_13', '2004-12-18', 6);
INSERT INTO Etudiant VALUES (20614, 'Nom_6_14', 'Prenom_14', '2004-06-12', 6);
INSERT INTO Etudiant VALUES (20615, 'Nom_6_15', 'Prenom_15', '2004-12-21', 6);
INSERT INTO Etudiant VALUES (20616, 'Nom_6_16', 'Prenom_16', '2004-05-05', 6);
INSERT INTO Etudiant VALUES (20617, 'Nom_6_17', 'Prenom_17', '2004-01-10', 6);
INSERT INTO Etudiant VALUES (20618, 'Nom_6_18', 'Prenom_18', '2004-07-09', 6);
INSERT INTO Etudiant VALUES (20619, 'Nom_6_19', 'Prenom_19', '2004-12-25', 6);
INSERT INTO Etudiant VALUES (20620, 'Nom_6_20', 'Prenom_20', '2004-06-02', 6);
INSERT INTO Etudiant VALUES (20621, 'Nom_6_21', 'Prenom_21', '2004-02-26', 6);
INSERT INTO Etudiant VALUES (20622, 'Nom_6_22', 'Prenom_22', '2004-09-21', 6);
INSERT INTO Etudiant VALUES (20623, 'Nom_6_23', 'Prenom_23', '2004-10-28', 6);
INSERT INTO Etudiant VALUES (20624, 'Nom_6_24', 'Prenom_24', '2004-01-21', 6);
INSERT INTO Etudiant VALUES (20625, 'Nom_6_25', 'Prenom_25', '2004-11-13', 6);
INSERT INTO Etudiant VALUES (20626, 'Nom_6_26', 'Prenom_26', '2004-10-12', 6);
INSERT INTO Etudiant VALUES (20627, 'Nom_6_27', 'Prenom_27', '2004-04-04', 6);
INSERT INTO Etudiant VALUES (20628, 'Nom_6_28', 'Prenom_28', '2004-05-01', 6);
INSERT INTO Etudiant VALUES (20629, 'Nom_6_29', 'Prenom_29', '2004-06-10', 6);
INSERT INTO Etudiant VALUES (20630, 'Nom_6_30', 'Prenom_30', '2004-10-11', 6);
INSERT INTO Etudiant VALUES (20631, 'Nom_6_31', 'Prenom_31', '2004-11-07', 6);
INSERT INTO Etudiant VALUES (20632, 'Nom_6_32', 'Prenom_32', '2004-12-06', 6);
INSERT INTO Etudiant VALUES (30601, 'Nom_6_1', 'Prenom_1', '2003-12-15', 6);
INSERT INTO Etudiant VALUES (30602, 'Nom_6_2', 'Prenom_2', '2003-11-05', 6);
INSERT INTO Etudiant VALUES (30603, 'Nom_6_3', 'Prenom_3', '2003-11-10', 6);
INSERT INTO Etudiant VALUES (30604, 'Nom_6_4', 'Prenom_4', '2003-08-09', 6);
INSERT INTO Etudiant VALUES (30605, 'Nom_6_5', 'Prenom_5', '2003-03-03', 6);
INSERT INTO Etudiant VALUES (30606, 'Nom_6_6', 'Prenom_6', '2003-03-28', 6);
INSERT INTO Etudiant VALUES (30607, 'Nom_6_7', 'Prenom_7', '2003-11-08', 6);
INSERT INTO Etudiant VALUES (30608, 'Nom_6_8', 'Prenom_8', '2003-08-29', 6);
INSERT INTO Etudiant VALUES (30609, 'Nom_6_9', 'Prenom_9', '2003-04-14', 6);
INSERT INTO Etudiant VALUES (30610, 'Nom_6_10', 'Prenom_10', '2003-04-20', 6);
INSERT INTO Etudiant VALUES (30611, 'Nom_6_11', 'Prenom_11', '2003-03-12', 6);
INSERT INTO Etudiant VALUES (30612, 'Nom_6_12', 'Prenom_12', '2003-04-04', 6);
INSERT INTO Etudiant VALUES (30613, 'Nom_6_13', 'Prenom_13', '2003-06-30', 6);
INSERT INTO Etudiant VALUES (30614, 'Nom_6_14', 'Prenom_14', '2003-09-21', 6);
INSERT INTO Etudiant VALUES (30615, 'Nom_6_15', 'Prenom_15', '2003-02-27', 6);
INSERT INTO Etudiant VALUES (30616, 'Nom_6_16', 'Prenom_16', '2003-05-16', 6);
INSERT INTO Etudiant VALUES (30617, 'Nom_6_17', 'Prenom_17', '2003-07-03', 6);
INSERT INTO Etudiant VALUES (30618, 'Nom_6_18', 'Prenom_18', '2003-04-08', 6);
INSERT INTO Etudiant VALUES (30619, 'Nom_6_19', 'Prenom_19', '2003-03-08', 6);
INSERT INTO Etudiant VALUES (30620, 'Nom_6_20', 'Prenom_20', '2003-01-24', 6);
INSERT INTO Etudiant VALUES (30621, 'Nom_6_21', 'Prenom_21', '2003-07-29', 6);
INSERT INTO Etudiant VALUES (30622, 'Nom_6_22', 'Prenom_22', '2003-10-18', 6);
INSERT INTO Etudiant VALUES (30623, 'Nom_6_23', 'Prenom_23', '2003-03-28', 6);
INSERT INTO Etudiant VALUES (30624, 'Nom_6_24', 'Prenom_24', '2003-05-05', 6);
INSERT INTO Etudiant VALUES (30625, 'Nom_6_25', 'Prenom_25', '2003-04-15', 6);
INSERT INTO Etudiant VALUES (30626, 'Nom_6_26', 'Prenom_26', '2003-12-29', 6);
INSERT INTO Etudiant VALUES (30627, 'Nom_6_27', 'Prenom_27', '2003-04-19', 6);
INSERT INTO Etudiant VALUES (30628, 'Nom_6_28', 'Prenom_28', '2003-09-18', 6);
INSERT INTO Etudiant VALUES (30629, 'Nom_6_29', 'Prenom_29', '2003-05-08', 6);
INSERT INTO Etudiant VALUES (10701, 'Nom_7_1', 'Prenom_1', '2005-09-22', 7);
INSERT INTO Etudiant VALUES (10702, 'Nom_7_2', 'Prenom_2', '2005-02-21', 7);
INSERT INTO Etudiant VALUES (10703, 'Nom_7_3', 'Prenom_3', '2005-07-11', 7);
INSERT INTO Etudiant VALUES (10704, 'Nom_7_4', 'Prenom_4', '2005-02-12', 7);
INSERT INTO Etudiant VALUES (10705, 'Nom_7_5', 'Prenom_5', '2005-01-27', 7);
INSERT INTO Etudiant VALUES (10706, 'Nom_7_6', 'Prenom_6', '2005-05-28', 7);
INSERT INTO Etudiant VALUES (10707, 'Nom_7_7', 'Prenom_7', '2005-09-09', 7);
INSERT INTO Etudiant VALUES (10708, 'Nom_7_8', 'Prenom_8', '2005-11-29', 7);
INSERT INTO Etudiant VALUES (10709, 'Nom_7_9', 'Prenom_9', '2005-04-23', 7);
INSERT INTO Etudiant VALUES (10710, 'Nom_7_10', 'Prenom_10', '2005-02-22', 7);
INSERT INTO Etudiant VALUES (10711, 'Nom_7_11', 'Prenom_11', '2005-04-15', 7);
INSERT INTO Etudiant VALUES (10712, 'Nom_7_12', 'Prenom_12', '2005-04-29', 7);
INSERT INTO Etudiant VALUES (10713, 'Nom_7_13', 'Prenom_13', '2005-03-09', 7);
INSERT INTO Etudiant VALUES (10714, 'Nom_7_14', 'Prenom_14', '2005-03-02', 7);
INSERT INTO Etudiant VALUES (10715, 'Nom_7_15', 'Prenom_15', '2005-04-29', 7);
INSERT INTO Etudiant VALUES (10716, 'Nom_7_16', 'Prenom_16', '2005-01-16', 7);
INSERT INTO Etudiant VALUES (10717, 'Nom_7_17', 'Prenom_17', '2005-03-26', 7);
INSERT INTO Etudiant VALUES (10718, 'Nom_7_18', 'Prenom_18', '2005-11-17', 7);
INSERT INTO Etudiant VALUES (10719, 'Nom_7_19', 'Prenom_19', '2005-04-15', 7);
INSERT INTO Etudiant VALUES (10720, 'Nom_7_20', 'Prenom_20', '2005-11-16', 7);
INSERT INTO Etudiant VALUES (10721, 'Nom_7_21', 'Prenom_21', '2005-04-05', 7);
INSERT INTO Etudiant VALUES (10722, 'Nom_7_22', 'Prenom_22', '2005-11-17', 7);
INSERT INTO Etudiant VALUES (10723, 'Nom_7_23', 'Prenom_23', '2005-02-11', 7);
INSERT INTO Etudiant VALUES (10724, 'Nom_7_24', 'Prenom_24', '2005-03-11', 7);
INSERT INTO Etudiant VALUES (10725, 'Nom_7_25', 'Prenom_25', '2005-04-07', 7);
INSERT INTO Etudiant VALUES (10726, 'Nom_7_26', 'Prenom_26', '2005-04-30', 7);
INSERT INTO Etudiant VALUES (10727, 'Nom_7_27', 'Prenom_27', '2005-11-15', 7);
INSERT INTO Etudiant VALUES (10728, 'Nom_7_28', 'Prenom_28', '2005-10-19', 7);
INSERT INTO Etudiant VALUES (10729, 'Nom_7_29', 'Prenom_29', '2005-05-21', 7);
INSERT INTO Etudiant VALUES (20701, 'Nom_7_1', 'Prenom_1', '2004-07-12', 7);
INSERT INTO Etudiant VALUES (20702, 'Nom_7_2', 'Prenom_2', '2004-11-11', 7);
INSERT INTO Etudiant VALUES (20703, 'Nom_7_3', 'Prenom_3', '2004-07-27', 7);
INSERT INTO Etudiant VALUES (20704, 'Nom_7_4', 'Prenom_4', '2004-12-04', 7);
INSERT INTO Etudiant VALUES (20705, 'Nom_7_5', 'Prenom_5', '2004-03-23', 7);
INSERT INTO Etudiant VALUES (20706, 'Nom_7_6', 'Prenom_6', '2004-07-14', 7);
INSERT INTO Etudiant VALUES (20707, 'Nom_7_7', 'Prenom_7', '2004-07-28', 7);
INSERT INTO Etudiant VALUES (20708, 'Nom_7_8', 'Prenom_8', '2004-10-05', 7);
INSERT INTO Etudiant VALUES (20709, 'Nom_7_9', 'Prenom_9', '2004-10-13', 7);
INSERT INTO Etudiant VALUES (20710, 'Nom_7_10', 'Prenom_10', '2004-08-31', 7);
INSERT INTO Etudiant VALUES (20711, 'Nom_7_11', 'Prenom_11', '2004-09-29', 7);
INSERT INTO Etudiant VALUES (20712, 'Nom_7_12', 'Prenom_12', '2004-08-12', 7);
INSERT INTO Etudiant VALUES (20713, 'Nom_7_13', 'Prenom_13', '2004-08-08', 7);
INSERT INTO Etudiant VALUES (20714, 'Nom_7_14', 'Prenom_14', '2004-09-26', 7);
INSERT INTO Etudiant VALUES (20715, 'Nom_7_15', 'Prenom_15', '2004-10-10', 7);
INSERT INTO Etudiant VALUES (20716, 'Nom_7_16', 'Prenom_16', '2004-10-13', 7);
INSERT INTO Etudiant VALUES (20717, 'Nom_7_17', 'Prenom_17', '2004-10-31', 7);
INSERT INTO Etudiant VALUES (20718, 'Nom_7_18', 'Prenom_18', '2004-11-03', 7);
INSERT INTO Etudiant VALUES (20719, 'Nom_7_19', 'Prenom_19', '2004-11-27', 7);
INSERT INTO Etudiant VALUES (20720, 'Nom_7_20', 'Prenom_20', '2004-01-05', 7);
INSERT INTO Etudiant VALUES (20721, 'Nom_7_21', 'Prenom_21', '2004-11-24', 7);
INSERT INTO Etudiant VALUES (20722, 'Nom_7_22', 'Prenom_22', '2004-12-05', 7);
INSERT INTO Etudiant VALUES (20723, 'Nom_7_23', 'Prenom_23', '2004-12-11', 7);
INSERT INTO Etudiant VALUES (20724, 'Nom_7_24', 'Prenom_24', '2004-07-24', 7);
INSERT INTO Etudiant VALUES (20725, 'Nom_7_25', 'Prenom_25', '2004-03-24', 7);
INSERT INTO Etudiant VALUES (20726, 'Nom_7_26', 'Prenom_26', '2004-04-09', 7);
INSERT INTO Etudiant VALUES (20727, 'Nom_7_27', 'Prenom_27', '2004-03-07', 7);
INSERT INTO Etudiant VALUES (20728, 'Nom_7_28', 'Prenom_28', '2004-07-24', 7);
INSERT INTO Etudiant VALUES (30701, 'Nom_7_1', 'Prenom_1', '2003-05-30', 7);
INSERT INTO Etudiant VALUES (30702, 'Nom_7_2', 'Prenom_2', '2003-11-18', 7);
INSERT INTO Etudiant VALUES (30703, 'Nom_7_3', 'Prenom_3', '2003-09-09', 7);
INSERT INTO Etudiant VALUES (30704, 'Nom_7_4', 'Prenom_4', '2003-06-06', 7);
INSERT INTO Etudiant VALUES (30705, 'Nom_7_5', 'Prenom_5', '2003-12-25', 7);
INSERT INTO Etudiant VALUES (30706, 'Nom_7_6', 'Prenom_6', '2003-11-30', 7);
INSERT INTO Etudiant VALUES (30707, 'Nom_7_7', 'Prenom_7', '2003-01-21', 7);
INSERT INTO Etudiant VALUES (30708, 'Nom_7_8', 'Prenom_8', '2003-03-25', 7);
INSERT INTO Etudiant VALUES (30709, 'Nom_7_9', 'Prenom_9', '2003-12-04', 7);
INSERT INTO Etudiant VALUES (30710, 'Nom_7_10', 'Prenom_10', '2003-03-05', 7);
INSERT INTO Etudiant VALUES (30711, 'Nom_7_11', 'Prenom_11', '2003-10-19', 7);
INSERT INTO Etudiant VALUES (30712, 'Nom_7_12', 'Prenom_12', '2003-05-28', 7);
INSERT INTO Etudiant VALUES (30713, 'Nom_7_13', 'Prenom_13', '2003-03-10', 7);
INSERT INTO Etudiant VALUES (30714, 'Nom_7_14', 'Prenom_14', '2003-09-28', 7);
INSERT INTO Etudiant VALUES (30715, 'Nom_7_15', 'Prenom_15', '2003-08-24', 7);
INSERT INTO Etudiant VALUES (30716, 'Nom_7_16', 'Prenom_16', '2003-06-23', 7);
INSERT INTO Etudiant VALUES (30717, 'Nom_7_17', 'Prenom_17', '2003-08-30', 7);
INSERT INTO Etudiant VALUES (30718, 'Nom_7_18', 'Prenom_18', '2003-06-25', 7);
INSERT INTO Etudiant VALUES (30719, 'Nom_7_19', 'Prenom_19', '2003-06-24', 7);
INSERT INTO Etudiant VALUES (30720, 'Nom_7_20', 'Prenom_20', '2003-11-29', 7);
INSERT INTO Etudiant VALUES (30721, 'Nom_7_21', 'Prenom_21', '2003-02-17', 7);
INSERT INTO Etudiant VALUES (30722, 'Nom_7_22', 'Prenom_22', '2003-08-29', 7);
INSERT INTO Etudiant VALUES (30723, 'Nom_7_23', 'Prenom_23', '2003-07-18', 7);
INSERT INTO Etudiant VALUES (30724, 'Nom_7_24', 'Prenom_24', '2003-08-26', 7);
INSERT INTO Etudiant VALUES (30725, 'Nom_7_25', 'Prenom_25', '2003-12-10', 7);
INSERT INTO Etudiant VALUES (30726, 'Nom_7_26', 'Prenom_26', '2003-05-03', 7);
INSERT INTO Etudiant VALUES (30727, 'Nom_7_27', 'Prenom_27', '2003-10-27', 7);
INSERT INTO Etudiant VALUES (30728, 'Nom_7_28', 'Prenom_28', '2003-02-08', 7);
INSERT INTO Etudiant VALUES (10801, 'Nom_8_1', 'Prenom_1', '2005-11-10', 8);
INSERT INTO Etudiant VALUES (10802, 'Nom_8_2', 'Prenom_2', '2005-05-29', 8);
INSERT INTO Etudiant VALUES (10803, 'Nom_8_3', 'Prenom_3', '2005-09-28', 8);
INSERT INTO Etudiant VALUES (10804, 'Nom_8_4', 'Prenom_4', '2005-08-07', 8);
INSERT INTO Etudiant VALUES (10805, 'Nom_8_5', 'Prenom_5', '2005-05-28', 8);
INSERT INTO Etudiant VALUES (10806, 'Nom_8_6', 'Prenom_6', '2005-11-14', 8);
INSERT INTO Etudiant VALUES (10807, 'Nom_8_7', 'Prenom_7', '2005-08-06', 8);
INSERT INTO Etudiant VALUES (10808, 'Nom_8_8', 'Prenom_8', '2005-03-23', 8);
INSERT INTO Etudiant VALUES (10809, 'Nom_8_9', 'Prenom_9', '2005-05-23', 8);
INSERT INTO Etudiant VALUES (10810, 'Nom_8_10', 'Prenom_10', '2005-07-26', 8);
INSERT INTO Etudiant VALUES (10811, 'Nom_8_11', 'Prenom_11', '2005-10-24', 8);
INSERT INTO Etudiant VALUES (10812, 'Nom_8_12', 'Prenom_12', '2005-10-03', 8);
INSERT INTO Etudiant VALUES (10813, 'Nom_8_13', 'Prenom_13', '2005-12-06', 8);
INSERT INTO Etudiant VALUES (10814, 'Nom_8_14', 'Prenom_14', '2005-11-21', 8);
INSERT INTO Etudiant VALUES (10815, 'Nom_8_15', 'Prenom_15', '2005-12-29', 8);
INSERT INTO Etudiant VALUES (10816, 'Nom_8_16', 'Prenom_16', '2005-03-07', 8);
INSERT INTO Etudiant VALUES (10817, 'Nom_8_17', 'Prenom_17', '2005-11-20', 8);
INSERT INTO Etudiant VALUES (10818, 'Nom_8_18', 'Prenom_18', '2005-02-06', 8);
INSERT INTO Etudiant VALUES (10819, 'Nom_8_19', 'Prenom_19', '2005-02-20', 8);
INSERT INTO Etudiant VALUES (10820, 'Nom_8_20', 'Prenom_20', '2005-11-14', 8);
INSERT INTO Etudiant VALUES (10821, 'Nom_8_21', 'Prenom_21', '2005-07-23', 8);
INSERT INTO Etudiant VALUES (10822, 'Nom_8_22', 'Prenom_22', '2005-11-05', 8);
INSERT INTO Etudiant VALUES (10823, 'Nom_8_23', 'Prenom_23', '2005-03-12', 8);
INSERT INTO Etudiant VALUES (10824, 'Nom_8_24', 'Prenom_24', '2005-05-03', 8);
INSERT INTO Etudiant VALUES (10825, 'Nom_8_25', 'Prenom_25', '2005-07-10', 8);
INSERT INTO Etudiant VALUES (10826, 'Nom_8_26', 'Prenom_26', '2005-01-30', 8);
INSERT INTO Etudiant VALUES (10827, 'Nom_8_27', 'Prenom_27', '2005-04-04', 8);
INSERT INTO Etudiant VALUES (10828, 'Nom_8_28', 'Prenom_28', '2005-05-06', 8);
INSERT INTO Etudiant VALUES (10829, 'Nom_8_29', 'Prenom_29', '2005-03-01', 8);
INSERT INTO Etudiant VALUES (10830, 'Nom_8_30', 'Prenom_30', '2005-01-03', 8);
INSERT INTO Etudiant VALUES (20801, 'Nom_8_1', 'Prenom_1', '2004-03-20', 8);
INSERT INTO Etudiant VALUES (20802, 'Nom_8_2', 'Prenom_2', '2004-05-04', 8);
INSERT INTO Etudiant VALUES (20803, 'Nom_8_3', 'Prenom_3', '2004-08-06', 8);
INSERT INTO Etudiant VALUES (20804, 'Nom_8_4', 'Prenom_4', '2004-10-23', 8);
INSERT INTO Etudiant VALUES (20805, 'Nom_8_5', 'Prenom_5', '2004-01-09', 8);
INSERT INTO Etudiant VALUES (20806, 'Nom_8_6', 'Prenom_6', '2004-03-16', 8);
INSERT INTO Etudiant VALUES (20807, 'Nom_8_7', 'Prenom_7', '2004-01-31', 8);
INSERT INTO Etudiant VALUES (20808, 'Nom_8_8', 'Prenom_8', '2004-07-26', 8);
INSERT INTO Etudiant VALUES (20809, 'Nom_8_9', 'Prenom_9', '2004-09-18', 8);
INSERT INTO Etudiant VALUES (20810, 'Nom_8_10', 'Prenom_10', '2004-04-21', 8);
INSERT INTO Etudiant VALUES (20811, 'Nom_8_11', 'Prenom_11', '2004-11-06', 8);
INSERT INTO Etudiant VALUES (20812, 'Nom_8_12', 'Prenom_12', '2004-04-11', 8);
INSERT INTO Etudiant VALUES (20813, 'Nom_8_13', 'Prenom_13', '2004-05-06', 8);
INSERT INTO Etudiant VALUES (20814, 'Nom_8_14', 'Prenom_14', '2004-06-10', 8);
INSERT INTO Etudiant VALUES (20815, 'Nom_8_15', 'Prenom_15', '2004-04-06', 8);
INSERT INTO Etudiant VALUES (20816, 'Nom_8_16', 'Prenom_16', '2004-09-25', 8);
INSERT INTO Etudiant VALUES (20817, 'Nom_8_17', 'Prenom_17', '2004-03-17', 8);
INSERT INTO Etudiant VALUES (20818, 'Nom_8_18', 'Prenom_18', '2004-07-30', 8);
INSERT INTO Etudiant VALUES (20819, 'Nom_8_19', 'Prenom_19', '2004-11-09', 8);
INSERT INTO Etudiant VALUES (20820, 'Nom_8_20', 'Prenom_20', '2004-04-08', 8);
INSERT INTO Etudiant VALUES (20821, 'Nom_8_21', 'Prenom_21', '2004-04-02', 8);
INSERT INTO Etudiant VALUES (20822, 'Nom_8_22', 'Prenom_22', '2004-08-08', 8);
INSERT INTO Etudiant VALUES (20823, 'Nom_8_23', 'Prenom_23', '2004-04-05', 8);
INSERT INTO Etudiant VALUES (20824, 'Nom_8_24', 'Prenom_24', '2004-03-13', 8);
INSERT INTO Etudiant VALUES (20825, 'Nom_8_25', 'Prenom_25', '2004-11-09', 8);
INSERT INTO Etudiant VALUES (20826, 'Nom_8_26', 'Prenom_26', '2004-01-02', 8);
INSERT INTO Etudiant VALUES (20827, 'Nom_8_27', 'Prenom_27', '2004-06-05', 8);
INSERT INTO Etudiant VALUES (20828, 'Nom_8_28', 'Prenom_28', '2004-12-20', 8);
INSERT INTO Etudiant VALUES (30801, 'Nom_8_1', 'Prenom_1', '2003-11-12', 8);
INSERT INTO Etudiant VALUES (30802, 'Nom_8_2', 'Prenom_2', '2003-12-26', 8);
INSERT INTO Etudiant VALUES (30803, 'Nom_8_3', 'Prenom_3', '2003-07-29', 8);
INSERT INTO Etudiant VALUES (30804, 'Nom_8_4', 'Prenom_4', '2003-04-03', 8);
INSERT INTO Etudiant VALUES (30805, 'Nom_8_5', 'Prenom_5', '2003-01-22', 8);
INSERT INTO Etudiant VALUES (30806, 'Nom_8_6', 'Prenom_6', '2003-04-01', 8);
INSERT INTO Etudiant VALUES (30807, 'Nom_8_7', 'Prenom_7', '2003-01-03', 8);
INSERT INTO Etudiant VALUES (30808, 'Nom_8_8', 'Prenom_8', '2003-02-22', 8);
INSERT INTO Etudiant VALUES (30809, 'Nom_8_9', 'Prenom_9', '2003-04-05', 8);
INSERT INTO Etudiant VALUES (30810, 'Nom_8_10', 'Prenom_10', '2003-08-12', 8);
INSERT INTO Etudiant VALUES (30811, 'Nom_8_11', 'Prenom_11', '2003-03-30', 8);
INSERT INTO Etudiant VALUES (30812, 'Nom_8_12', 'Prenom_12', '2003-07-08', 8);
INSERT INTO Etudiant VALUES (30813, 'Nom_8_13', 'Prenom_13', '2003-01-18', 8);
INSERT INTO Etudiant VALUES (30814, 'Nom_8_14', 'Prenom_14', '2003-09-25', 8);
INSERT INTO Etudiant VALUES (30815, 'Nom_8_15', 'Prenom_15', '2003-01-01', 8);
INSERT INTO Etudiant VALUES (30816, 'Nom_8_16', 'Prenom_16', '2003-07-09', 8);
INSERT INTO Etudiant VALUES (30817, 'Nom_8_17', 'Prenom_17', '2003-06-21', 8);
INSERT INTO Etudiant VALUES (30818, 'Nom_8_18', 'Prenom_18', '2003-10-06', 8);
INSERT INTO Etudiant VALUES (30819, 'Nom_8_19', 'Prenom_19', '2003-12-02', 8);
INSERT INTO Etudiant VALUES (30820, 'Nom_8_20', 'Prenom_20', '2003-03-29', 8);
INSERT INTO Etudiant VALUES (30821, 'Nom_8_21', 'Prenom_21', '2003-04-25', 8);
INSERT INTO Etudiant VALUES (30822, 'Nom_8_22', 'Prenom_22', '2003-07-31', 8);
INSERT INTO Etudiant VALUES (30823, 'Nom_8_23', 'Prenom_23', '2003-03-06', 8);
INSERT INTO Etudiant VALUES (30824, 'Nom_8_24', 'Prenom_24', '2003-10-21', 8);
INSERT INTO Etudiant VALUES (30825, 'Nom_8_25', 'Prenom_25', '2003-01-26', 8);
INSERT INTO Etudiant VALUES (30826, 'Nom_8_26', 'Prenom_26', '2003-03-09', 8);
INSERT INTO Etudiant VALUES (30827, 'Nom_8_27', 'Prenom_27', '2003-02-19', 8);
INSERT INTO Etudiant VALUES (30828, 'Nom_8_28', 'Prenom_28', '2003-07-01', 8);
INSERT INTO Etudiant VALUES (30829, 'Nom_8_29', 'Prenom_29', '2003-12-15', 8);
INSERT INTO Etudiant VALUES (10901, 'Nom_9_1', 'Prenom_1', '2005-02-23', 9);
INSERT INTO Etudiant VALUES (10902, 'Nom_9_2', 'Prenom_2', '2005-03-14', 9);
INSERT INTO Etudiant VALUES (10903, 'Nom_9_3', 'Prenom_3', '2005-01-09', 9);
INSERT INTO Etudiant VALUES (10904, 'Nom_9_4', 'Prenom_4', '2005-01-21', 9);
INSERT INTO Etudiant VALUES (10905, 'Nom_9_5', 'Prenom_5', '2005-12-22', 9);
INSERT INTO Etudiant VALUES (10906, 'Nom_9_6', 'Prenom_6', '2005-04-08', 9);
INSERT INTO Etudiant VALUES (10907, 'Nom_9_7', 'Prenom_7', '2005-09-28', 9);
INSERT INTO Etudiant VALUES (10908, 'Nom_9_8', 'Prenom_8', '2005-06-25', 9);
INSERT INTO Etudiant VALUES (10909, 'Nom_9_9', 'Prenom_9', '2005-02-28', 9);
INSERT INTO Etudiant VALUES (10910, 'Nom_9_10', 'Prenom_10', '2005-09-14', 9);
INSERT INTO Etudiant VALUES (10911, 'Nom_9_11', 'Prenom_11', '2005-10-12', 9);
INSERT INTO Etudiant VALUES (10912, 'Nom_9_12', 'Prenom_12', '2005-08-26', 9);
INSERT INTO Etudiant VALUES (10913, 'Nom_9_13', 'Prenom_13', '2005-03-08', 9);
INSERT INTO Etudiant VALUES (10914, 'Nom_9_14', 'Prenom_14', '2005-12-14', 9);
INSERT INTO Etudiant VALUES (10915, 'Nom_9_15', 'Prenom_15', '2005-02-09', 9);
INSERT INTO Etudiant VALUES (10916, 'Nom_9_16', 'Prenom_16', '2005-04-29', 9);
INSERT INTO Etudiant VALUES (10917, 'Nom_9_17', 'Prenom_17', '2005-02-18', 9);
INSERT INTO Etudiant VALUES (10918, 'Nom_9_18', 'Prenom_18', '2005-06-18', 9);
INSERT INTO Etudiant VALUES (10919, 'Nom_9_19', 'Prenom_19', '2005-09-07', 9);
INSERT INTO Etudiant VALUES (10920, 'Nom_9_20', 'Prenom_20', '2005-10-13', 9);
INSERT INTO Etudiant VALUES (10921, 'Nom_9_21', 'Prenom_21', '2005-10-02', 9);
INSERT INTO Etudiant VALUES (10922, 'Nom_9_22', 'Prenom_22', '2005-09-14', 9);
INSERT INTO Etudiant VALUES (10923, 'Nom_9_23', 'Prenom_23', '2005-12-04', 9);
INSERT INTO Etudiant VALUES (10924, 'Nom_9_24', 'Prenom_24', '2005-06-06', 9);
INSERT INTO Etudiant VALUES (10925, 'Nom_9_25', 'Prenom_25', '2005-10-26', 9);
INSERT INTO Etudiant VALUES (10926, 'Nom_9_26', 'Prenom_26', '2005-01-30', 9);
INSERT INTO Etudiant VALUES (10927, 'Nom_9_27', 'Prenom_27', '2005-02-10', 9);
INSERT INTO Etudiant VALUES (10928, 'Nom_9_28', 'Prenom_28', '2005-04-26', 9);
INSERT INTO Etudiant VALUES (10929, 'Nom_9_29', 'Prenom_29', '2005-10-18', 9);
INSERT INTO Etudiant VALUES (20901, 'Nom_9_1', 'Prenom_1', '2004-01-21', 9);
INSERT INTO Etudiant VALUES (20902, 'Nom_9_2', 'Prenom_2', '2004-01-11', 9);
INSERT INTO Etudiant VALUES (20903, 'Nom_9_3', 'Prenom_3', '2004-03-29', 9);
INSERT INTO Etudiant VALUES (20904, 'Nom_9_4', 'Prenom_4', '2004-02-22', 9);
INSERT INTO Etudiant VALUES (20905, 'Nom_9_5', 'Prenom_5', '2004-08-23', 9);
INSERT INTO Etudiant VALUES (20906, 'Nom_9_6', 'Prenom_6', '2004-04-27', 9);
INSERT INTO Etudiant VALUES (20907, 'Nom_9_7', 'Prenom_7', '2004-04-11', 9);
INSERT INTO Etudiant VALUES (20908, 'Nom_9_8', 'Prenom_8', '2004-11-26', 9);
INSERT INTO Etudiant VALUES (20909, 'Nom_9_9', 'Prenom_9', '2004-04-01', 9);
INSERT INTO Etudiant VALUES (20910, 'Nom_9_10', 'Prenom_10', '2004-03-24', 9);
INSERT INTO Etudiant VALUES (20911, 'Nom_9_11', 'Prenom_11', '2004-10-15', 9);
INSERT INTO Etudiant VALUES (20912, 'Nom_9_12', 'Prenom_12', '2004-07-21', 9);
INSERT INTO Etudiant VALUES (20913, 'Nom_9_13', 'Prenom_13', '2004-01-30', 9);
INSERT INTO Etudiant VALUES (20914, 'Nom_9_14', 'Prenom_14', '2004-11-09', 9);
INSERT INTO Etudiant VALUES (20915, 'Nom_9_15', 'Prenom_15', '2004-12-31', 9);
INSERT INTO Etudiant VALUES (20916, 'Nom_9_16', 'Prenom_16', '2004-08-31', 9);
INSERT INTO Etudiant VALUES (20917, 'Nom_9_17', 'Prenom_17', '2004-03-21', 9);
INSERT INTO Etudiant VALUES (20918, 'Nom_9_18', 'Prenom_18', '2004-06-04', 9);
INSERT INTO Etudiant VALUES (20919, 'Nom_9_19', 'Prenom_19', '2004-02-28', 9);
INSERT INTO Etudiant VALUES (20920, 'Nom_9_20', 'Prenom_20', '2004-11-15', 9);
INSERT INTO Etudiant VALUES (20921, 'Nom_9_21', 'Prenom_21', '2004-03-06', 9);
INSERT INTO Etudiant VALUES (20922, 'Nom_9_22', 'Prenom_22', '2004-12-06', 9);
INSERT INTO Etudiant VALUES (20923, 'Nom_9_23', 'Prenom_23', '2004-01-17', 9);
INSERT INTO Etudiant VALUES (20924, 'Nom_9_24', 'Prenom_24', '2004-11-11', 9);
INSERT INTO Etudiant VALUES (20925, 'Nom_9_25', 'Prenom_25', '2004-05-05', 9);
INSERT INTO Etudiant VALUES (20926, 'Nom_9_26', 'Prenom_26', '2004-12-13', 9);
INSERT INTO Etudiant VALUES (20927, 'Nom_9_27', 'Prenom_27', '2004-05-21', 9);
INSERT INTO Etudiant VALUES (20928, 'Nom_9_28', 'Prenom_28', '2004-03-15', 9);
INSERT INTO Etudiant VALUES (20929, 'Nom_9_29', 'Prenom_29', '2004-05-28', 9);
INSERT INTO Etudiant VALUES (20930, 'Nom_9_30', 'Prenom_30', '2004-10-17', 9);
INSERT INTO Etudiant VALUES (30901, 'Nom_9_1', 'Prenom_1', '2003-05-10', 9);
INSERT INTO Etudiant VALUES (30902, 'Nom_9_2', 'Prenom_2', '2003-06-20', 9);
INSERT INTO Etudiant VALUES (30903, 'Nom_9_3', 'Prenom_3', '2003-11-05', 9);
INSERT INTO Etudiant VALUES (30904, 'Nom_9_4', 'Prenom_4', '2003-02-05', 9);
INSERT INTO Etudiant VALUES (30905, 'Nom_9_5', 'Prenom_5', '2003-07-02', 9);
INSERT INTO Etudiant VALUES (30906, 'Nom_9_6', 'Prenom_6', '2003-05-21', 9);
INSERT INTO Etudiant VALUES (30907, 'Nom_9_7', 'Prenom_7', '2003-09-24', 9);
INSERT INTO Etudiant VALUES (30908, 'Nom_9_8', 'Prenom_8', '2003-03-12', 9);
INSERT INTO Etudiant VALUES (30909, 'Nom_9_9', 'Prenom_9', '2003-06-26', 9);
INSERT INTO Etudiant VALUES (30910, 'Nom_9_10', 'Prenom_10', '2003-02-02', 9);
INSERT INTO Etudiant VALUES (30911, 'Nom_9_11', 'Prenom_11', '2003-06-20', 9);
INSERT INTO Etudiant VALUES (30912, 'Nom_9_12', 'Prenom_12', '2003-03-24', 9);
INSERT INTO Etudiant VALUES (30913, 'Nom_9_13', 'Prenom_13', '2003-06-29', 9);
INSERT INTO Etudiant VALUES (30914, 'Nom_9_14', 'Prenom_14', '2003-09-22', 9);
INSERT INTO Etudiant VALUES (30915, 'Nom_9_15', 'Prenom_15', '2003-08-15', 9);
INSERT INTO Etudiant VALUES (30916, 'Nom_9_16', 'Prenom_16', '2003-12-24', 9);
INSERT INTO Etudiant VALUES (30917, 'Nom_9_17', 'Prenom_17', '2003-10-24', 9);
INSERT INTO Etudiant VALUES (30918, 'Nom_9_18', 'Prenom_18', '2003-11-04', 9);
INSERT INTO Etudiant VALUES (30919, 'Nom_9_19', 'Prenom_19', '2003-01-25', 9);
INSERT INTO Etudiant VALUES (30920, 'Nom_9_20', 'Prenom_20', '2003-01-07', 9);
INSERT INTO Etudiant VALUES (30921, 'Nom_9_21', 'Prenom_21', '2003-07-26', 9);
INSERT INTO Etudiant VALUES (30922, 'Nom_9_22', 'Prenom_22', '2003-07-22', 9);
INSERT INTO Etudiant VALUES (30923, 'Nom_9_23', 'Prenom_23', '2003-12-25', 9);
INSERT INTO Etudiant VALUES (30924, 'Nom_9_24', 'Prenom_24', '2003-08-01', 9);
INSERT INTO Etudiant VALUES (30925, 'Nom_9_25', 'Prenom_25', '2003-02-16', 9);
INSERT INTO Etudiant VALUES (30926, 'Nom_9_26', 'Prenom_26', '2003-08-20', 9);
INSERT INTO Etudiant VALUES (30927, 'Nom_9_27', 'Prenom_27', '2003-04-06', 9);
INSERT INTO Etudiant VALUES (30928, 'Nom_9_28', 'Prenom_28', '2003-11-06', 9);
INSERT INTO Etudiant VALUES (30929, 'Nom_9_29', 'Prenom_29', '2003-09-08', 9);
INSERT INTO Etudiant VALUES (30930, 'Nom_9_30', 'Prenom_30', '2003-01-28', 9);
INSERT INTO Etudiant VALUES (30931, 'Nom_9_31', 'Prenom_31', '2003-06-17', 9);
INSERT INTO Etudiant VALUES (11001, 'Nom_10_1', 'Prenom_1', '2005-03-15', 10);
INSERT INTO Etudiant VALUES (11002, 'Nom_10_2', 'Prenom_2', '2005-12-18', 10);
INSERT INTO Etudiant VALUES (11003, 'Nom_10_3', 'Prenom_3', '2005-02-08', 10);
INSERT INTO Etudiant VALUES (11004, 'Nom_10_4', 'Prenom_4', '2005-11-09', 10);
INSERT INTO Etudiant VALUES (11005, 'Nom_10_5', 'Prenom_5', '2005-08-24', 10);
INSERT INTO Etudiant VALUES (11006, 'Nom_10_6', 'Prenom_6', '2005-12-28', 10);
INSERT INTO Etudiant VALUES (11007, 'Nom_10_7', 'Prenom_7', '2005-12-26', 10);
INSERT INTO Etudiant VALUES (11008, 'Nom_10_8', 'Prenom_8', '2005-06-17', 10);
INSERT INTO Etudiant VALUES (11009, 'Nom_10_9', 'Prenom_9', '2005-05-30', 10);
INSERT INTO Etudiant VALUES (11010, 'Nom_10_10', 'Prenom_10', '2005-08-24', 10);
INSERT INTO Etudiant VALUES (11011, 'Nom_10_11', 'Prenom_11', '2005-08-14', 10);
INSERT INTO Etudiant VALUES (11012, 'Nom_10_12', 'Prenom_12', '2005-01-19', 10);
INSERT INTO Etudiant VALUES (11013, 'Nom_10_13', 'Prenom_13', '2005-01-20', 10);
INSERT INTO Etudiant VALUES (11014, 'Nom_10_14', 'Prenom_14', '2005-07-21', 10);
INSERT INTO Etudiant VALUES (11015, 'Nom_10_15', 'Prenom_15', '2005-08-06', 10);
INSERT INTO Etudiant VALUES (11016, 'Nom_10_16', 'Prenom_16', '2005-10-10', 10);
INSERT INTO Etudiant VALUES (11017, 'Nom_10_17', 'Prenom_17', '2005-02-23', 10);
INSERT INTO Etudiant VALUES (11018, 'Nom_10_18', 'Prenom_18', '2005-07-18', 10);
INSERT INTO Etudiant VALUES (11019, 'Nom_10_19', 'Prenom_19', '2005-11-25', 10);
INSERT INTO Etudiant VALUES (11020, 'Nom_10_20', 'Prenom_20', '2005-01-09', 10);
INSERT INTO Etudiant VALUES (11021, 'Nom_10_21', 'Prenom_21', '2005-07-20', 10);
INSERT INTO Etudiant VALUES (11022, 'Nom_10_22', 'Prenom_22', '2005-12-26', 10);
INSERT INTO Etudiant VALUES (11023, 'Nom_10_23', 'Prenom_23', '2005-01-02', 10);
INSERT INTO Etudiant VALUES (11024, 'Nom_10_24', 'Prenom_24', '2005-03-08', 10);
INSERT INTO Etudiant VALUES (11025, 'Nom_10_25', 'Prenom_25', '2005-10-17', 10);
INSERT INTO Etudiant VALUES (11026, 'Nom_10_26', 'Prenom_26', '2005-11-19', 10);
INSERT INTO Etudiant VALUES (11027, 'Nom_10_27', 'Prenom_27', '2005-03-17', 10);
INSERT INTO Etudiant VALUES (11028, 'Nom_10_28', 'Prenom_28', '2005-03-31', 10);
INSERT INTO Etudiant VALUES (11029, 'Nom_10_29', 'Prenom_29', '2005-04-28', 10);
INSERT INTO Etudiant VALUES (21001, 'Nom_10_1', 'Prenom_1', '2004-06-20', 10);
INSERT INTO Etudiant VALUES (21002, 'Nom_10_2', 'Prenom_2', '2004-12-29', 10);
INSERT INTO Etudiant VALUES (21003, 'Nom_10_3', 'Prenom_3', '2004-05-31', 10);
INSERT INTO Etudiant VALUES (21004, 'Nom_10_4', 'Prenom_4', '2004-12-12', 10);
INSERT INTO Etudiant VALUES (21005, 'Nom_10_5', 'Prenom_5', '2004-01-08', 10);
INSERT INTO Etudiant VALUES (21006, 'Nom_10_6', 'Prenom_6', '2004-07-16', 10);
INSERT INTO Etudiant VALUES (21007, 'Nom_10_7', 'Prenom_7', '2004-04-20', 10);
INSERT INTO Etudiant VALUES (21008, 'Nom_10_8', 'Prenom_8', '2004-06-16', 10);
INSERT INTO Etudiant VALUES (21009, 'Nom_10_9', 'Prenom_9', '2004-12-29', 10);
INSERT INTO Etudiant VALUES (21010, 'Nom_10_10', 'Prenom_10', '2004-07-30', 10);
INSERT INTO Etudiant VALUES (21011, 'Nom_10_11', 'Prenom_11', '2004-08-13', 10);
INSERT INTO Etudiant VALUES (21012, 'Nom_10_12', 'Prenom_12', '2004-12-30', 10);
INSERT INTO Etudiant VALUES (21013, 'Nom_10_13', 'Prenom_13', '2004-08-22', 10);
INSERT INTO Etudiant VALUES (21014, 'Nom_10_14', 'Prenom_14', '2004-07-16', 10);
INSERT INTO Etudiant VALUES (21015, 'Nom_10_15', 'Prenom_15', '2004-02-22', 10);
INSERT INTO Etudiant VALUES (21016, 'Nom_10_16', 'Prenom_16', '2004-02-03', 10);
INSERT INTO Etudiant VALUES (21017, 'Nom_10_17', 'Prenom_17', '2004-12-06', 10);
INSERT INTO Etudiant VALUES (21018, 'Nom_10_18', 'Prenom_18', '2004-09-28', 10);
INSERT INTO Etudiant VALUES (21019, 'Nom_10_19', 'Prenom_19', '2004-05-31', 10);
INSERT INTO Etudiant VALUES (21020, 'Nom_10_20', 'Prenom_20', '2004-07-01', 10);
INSERT INTO Etudiant VALUES (21021, 'Nom_10_21', 'Prenom_21', '2004-02-29', 10);
INSERT INTO Etudiant VALUES (21022, 'Nom_10_22', 'Prenom_22', '2004-06-07', 10);
INSERT INTO Etudiant VALUES (21023, 'Nom_10_23', 'Prenom_23', '2004-03-15', 10);
INSERT INTO Etudiant VALUES (21024, 'Nom_10_24', 'Prenom_24', '2004-10-10', 10);
INSERT INTO Etudiant VALUES (21025, 'Nom_10_25', 'Prenom_25', '2004-03-04', 10);
INSERT INTO Etudiant VALUES (21026, 'Nom_10_26', 'Prenom_26', '2004-05-23', 10);
INSERT INTO Etudiant VALUES (21027, 'Nom_10_27', 'Prenom_27', '2004-03-30', 10);
INSERT INTO Etudiant VALUES (21028, 'Nom_10_28', 'Prenom_28', '2004-06-13', 10);
INSERT INTO Etudiant VALUES (21029, 'Nom_10_29', 'Prenom_29', '2004-01-01', 10);
INSERT INTO Etudiant VALUES (21030, 'Nom_10_30', 'Prenom_30', '2004-01-10', 10);
INSERT INTO Etudiant VALUES (21031, 'Nom_10_31', 'Prenom_31', '2004-10-30', 10);
INSERT INTO Etudiant VALUES (31001, 'Nom_10_1', 'Prenom_1', '2003-08-18', 10);
INSERT INTO Etudiant VALUES (31002, 'Nom_10_2', 'Prenom_2', '2003-09-22', 10);
INSERT INTO Etudiant VALUES (31003, 'Nom_10_3', 'Prenom_3', '2003-04-20', 10);
INSERT INTO Etudiant VALUES (31004, 'Nom_10_4', 'Prenom_4', '2003-01-12', 10);
INSERT INTO Etudiant VALUES (31005, 'Nom_10_5', 'Prenom_5', '2003-03-02', 10);
INSERT INTO Etudiant VALUES (31006, 'Nom_10_6', 'Prenom_6', '2003-09-26', 10);
INSERT INTO Etudiant VALUES (31007, 'Nom_10_7', 'Prenom_7', '2003-03-20', 10);
INSERT INTO Etudiant VALUES (31008, 'Nom_10_8', 'Prenom_8', '2003-09-06', 10);
INSERT INTO Etudiant VALUES (31009, 'Nom_10_9', 'Prenom_9', '2003-01-17', 10);
INSERT INTO Etudiant VALUES (31010, 'Nom_10_10', 'Prenom_10', '2003-11-22', 10);
INSERT INTO Etudiant VALUES (31011, 'Nom_10_11', 'Prenom_11', '2003-12-12', 10);
INSERT INTO Etudiant VALUES (31012, 'Nom_10_12', 'Prenom_12', '2003-05-26', 10);
INSERT INTO Etudiant VALUES (31013, 'Nom_10_13', 'Prenom_13', '2003-10-21', 10);
INSERT INTO Etudiant VALUES (31014, 'Nom_10_14', 'Prenom_14', '2003-08-14', 10);
INSERT INTO Etudiant VALUES (31015, 'Nom_10_15', 'Prenom_15', '2003-04-15', 10);
INSERT INTO Etudiant VALUES (31016, 'Nom_10_16', 'Prenom_16', '2003-01-04', 10);
INSERT INTO Etudiant VALUES (31017, 'Nom_10_17', 'Prenom_17', '2003-06-19', 10);
INSERT INTO Etudiant VALUES (31018, 'Nom_10_18', 'Prenom_18', '2003-10-12', 10);
INSERT INTO Etudiant VALUES (31019, 'Nom_10_19', 'Prenom_19', '2003-08-07', 10);
INSERT INTO Etudiant VALUES (31020, 'Nom_10_20', 'Prenom_20', '2003-01-03', 10);
INSERT INTO Etudiant VALUES (31021, 'Nom_10_21', 'Prenom_21', '2003-06-10', 10);
INSERT INTO Etudiant VALUES (31022, 'Nom_10_22', 'Prenom_22', '2003-05-19', 10);
INSERT INTO Etudiant VALUES (31023, 'Nom_10_23', 'Prenom_23', '2003-05-03', 10);
INSERT INTO Etudiant VALUES (31024, 'Nom_10_24', 'Prenom_24', '2003-08-17', 10);
INSERT INTO Etudiant VALUES (31025, 'Nom_10_25', 'Prenom_25', '2003-04-21', 10);
INSERT INTO Etudiant VALUES (31026, 'Nom_10_26', 'Prenom_26', '2003-10-15', 10);
INSERT INTO Etudiant VALUES (31027, 'Nom_10_27', 'Prenom_27', '2003-03-06', 10);
INSERT INTO Etudiant VALUES (31028, 'Nom_10_28', 'Prenom_28', '2003-06-29', 10);
INSERT INTO Etudiant VALUES (31029, 'Nom_10_29', 'Prenom_29', '2003-03-18', 10);
INSERT INTO Etudiant VALUES (31030, 'Nom_10_30', 'Prenom_30', '2003-10-24', 10);
INSERT INTO Etudiant VALUES (11101, 'Nom_11_1', 'Prenom_1', '2005-12-16', 11);
INSERT INTO Etudiant VALUES (11102, 'Nom_11_2', 'Prenom_2', '2005-02-19', 11);
INSERT INTO Etudiant VALUES (11103, 'Nom_11_3', 'Prenom_3', '2005-01-21', 11);
INSERT INTO Etudiant VALUES (11104, 'Nom_11_4', 'Prenom_4', '2005-09-14', 11);
INSERT INTO Etudiant VALUES (11105, 'Nom_11_5', 'Prenom_5', '2005-03-21', 11);
INSERT INTO Etudiant VALUES (11106, 'Nom_11_6', 'Prenom_6', '2005-04-23', 11);
INSERT INTO Etudiant VALUES (11107, 'Nom_11_7', 'Prenom_7', '2005-10-15', 11);
INSERT INTO Etudiant VALUES (11108, 'Nom_11_8', 'Prenom_8', '2005-10-30', 11);
INSERT INTO Etudiant VALUES (11109, 'Nom_11_9', 'Prenom_9', '2005-03-19', 11);
INSERT INTO Etudiant VALUES (11110, 'Nom_11_10', 'Prenom_10', '2005-03-01', 11);
INSERT INTO Etudiant VALUES (11111, 'Nom_11_11', 'Prenom_11', '2005-04-18', 11);
INSERT INTO Etudiant VALUES (11112, 'Nom_11_12', 'Prenom_12', '2005-09-25', 11);
INSERT INTO Etudiant VALUES (11113, 'Nom_11_13', 'Prenom_13', '2005-04-16', 11);
INSERT INTO Etudiant VALUES (11114, 'Nom_11_14', 'Prenom_14', '2005-07-19', 11);
INSERT INTO Etudiant VALUES (11115, 'Nom_11_15', 'Prenom_15', '2005-01-06', 11);
INSERT INTO Etudiant VALUES (11116, 'Nom_11_16', 'Prenom_16', '2005-05-12', 11);
INSERT INTO Etudiant VALUES (11117, 'Nom_11_17', 'Prenom_17', '2005-08-09', 11);
INSERT INTO Etudiant VALUES (11118, 'Nom_11_18', 'Prenom_18', '2005-08-16', 11);
INSERT INTO Etudiant VALUES (11119, 'Nom_11_19', 'Prenom_19', '2005-08-27', 11);
INSERT INTO Etudiant VALUES (11120, 'Nom_11_20', 'Prenom_20', '2005-09-28', 11);
INSERT INTO Etudiant VALUES (11121, 'Nom_11_21', 'Prenom_21', '2005-07-13', 11);
INSERT INTO Etudiant VALUES (11122, 'Nom_11_22', 'Prenom_22', '2005-12-03', 11);
INSERT INTO Etudiant VALUES (11123, 'Nom_11_23', 'Prenom_23', '2005-04-13', 11);
INSERT INTO Etudiant VALUES (11124, 'Nom_11_24', 'Prenom_24', '2005-06-22', 11);
INSERT INTO Etudiant VALUES (11125, 'Nom_11_25', 'Prenom_25', '2005-11-16', 11);
INSERT INTO Etudiant VALUES (11126, 'Nom_11_26', 'Prenom_26', '2005-04-05', 11);
INSERT INTO Etudiant VALUES (11127, 'Nom_11_27', 'Prenom_27', '2005-07-26', 11);
INSERT INTO Etudiant VALUES (11128, 'Nom_11_28', 'Prenom_28', '2005-06-09', 11);
INSERT INTO Etudiant VALUES (11129, 'Nom_11_29', 'Prenom_29', '2005-04-05', 11);
INSERT INTO Etudiant VALUES (21101, 'Nom_11_1', 'Prenom_1', '2004-11-07', 11);
INSERT INTO Etudiant VALUES (21102, 'Nom_11_2', 'Prenom_2', '2004-03-25', 11);
INSERT INTO Etudiant VALUES (21103, 'Nom_11_3', 'Prenom_3', '2004-01-22', 11);
INSERT INTO Etudiant VALUES (21104, 'Nom_11_4', 'Prenom_4', '2004-03-30', 11);
INSERT INTO Etudiant VALUES (21105, 'Nom_11_5', 'Prenom_5', '2004-04-01', 11);
INSERT INTO Etudiant VALUES (21106, 'Nom_11_6', 'Prenom_6', '2004-03-04', 11);
INSERT INTO Etudiant VALUES (21107, 'Nom_11_7', 'Prenom_7', '2004-04-17', 11);
INSERT INTO Etudiant VALUES (21108, 'Nom_11_8', 'Prenom_8', '2004-07-14', 11);
INSERT INTO Etudiant VALUES (21109, 'Nom_11_9', 'Prenom_9', '2004-07-06', 11);
INSERT INTO Etudiant VALUES (21110, 'Nom_11_10', 'Prenom_10', '2004-07-04', 11);
INSERT INTO Etudiant VALUES (21111, 'Nom_11_11', 'Prenom_11', '2004-12-16', 11);
INSERT INTO Etudiant VALUES (21112, 'Nom_11_12', 'Prenom_12', '2004-02-13', 11);
INSERT INTO Etudiant VALUES (21113, 'Nom_11_13', 'Prenom_13', '2004-08-12', 11);
INSERT INTO Etudiant VALUES (21114, 'Nom_11_14', 'Prenom_14', '2004-06-07', 11);
INSERT INTO Etudiant VALUES (21115, 'Nom_11_15', 'Prenom_15', '2004-09-22', 11);
INSERT INTO Etudiant VALUES (21116, 'Nom_11_16', 'Prenom_16', '2004-11-10', 11);
INSERT INTO Etudiant VALUES (21117, 'Nom_11_17', 'Prenom_17', '2004-09-06', 11);
INSERT INTO Etudiant VALUES (21118, 'Nom_11_18', 'Prenom_18', '2004-03-08', 11);
INSERT INTO Etudiant VALUES (21119, 'Nom_11_19', 'Prenom_19', '2004-01-12', 11);
INSERT INTO Etudiant VALUES (21120, 'Nom_11_20', 'Prenom_20', '2004-04-25', 11);
INSERT INTO Etudiant VALUES (21121, 'Nom_11_21', 'Prenom_21', '2004-07-02', 11);
INSERT INTO Etudiant VALUES (21122, 'Nom_11_22', 'Prenom_22', '2004-10-15', 11);
INSERT INTO Etudiant VALUES (21123, 'Nom_11_23', 'Prenom_23', '2004-08-18', 11);
INSERT INTO Etudiant VALUES (21124, 'Nom_11_24', 'Prenom_24', '2004-07-28', 11);
INSERT INTO Etudiant VALUES (21125, 'Nom_11_25', 'Prenom_25', '2004-12-05', 11);
INSERT INTO Etudiant VALUES (21126, 'Nom_11_26', 'Prenom_26', '2004-01-09', 11);
INSERT INTO Etudiant VALUES (21127, 'Nom_11_27', 'Prenom_27', '2004-12-08', 11);
INSERT INTO Etudiant VALUES (21128, 'Nom_11_28', 'Prenom_28', '2004-01-27', 11);
INSERT INTO Etudiant VALUES (21129, 'Nom_11_29', 'Prenom_29', '2004-06-20', 11);
INSERT INTO Etudiant VALUES (31101, 'Nom_11_1', 'Prenom_1', '2003-04-13', 11);
INSERT INTO Etudiant VALUES (31102, 'Nom_11_2', 'Prenom_2', '2003-11-16', 11);
INSERT INTO Etudiant VALUES (31103, 'Nom_11_3', 'Prenom_3', '2003-05-20', 11);
INSERT INTO Etudiant VALUES (31104, 'Nom_11_4', 'Prenom_4', '2003-01-27', 11);
INSERT INTO Etudiant VALUES (31105, 'Nom_11_5', 'Prenom_5', '2003-01-07', 11);
INSERT INTO Etudiant VALUES (31106, 'Nom_11_6', 'Prenom_6', '2003-10-05', 11);
INSERT INTO Etudiant VALUES (31107, 'Nom_11_7', 'Prenom_7', '2003-01-20', 11);
INSERT INTO Etudiant VALUES (31108, 'Nom_11_8', 'Prenom_8', '2003-05-09', 11);
INSERT INTO Etudiant VALUES (31109, 'Nom_11_9', 'Prenom_9', '2003-11-23', 11);
INSERT INTO Etudiant VALUES (31110, 'Nom_11_10', 'Prenom_10', '2003-04-02', 11);
INSERT INTO Etudiant VALUES (31111, 'Nom_11_11', 'Prenom_11', '2003-06-27', 11);
INSERT INTO Etudiant VALUES (31112, 'Nom_11_12', 'Prenom_12', '2003-03-05', 11);
INSERT INTO Etudiant VALUES (31113, 'Nom_11_13', 'Prenom_13', '2003-06-20', 11);
INSERT INTO Etudiant VALUES (31114, 'Nom_11_14', 'Prenom_14', '2003-06-04', 11);
INSERT INTO Etudiant VALUES (31115, 'Nom_11_15', 'Prenom_15', '2003-01-06', 11);
INSERT INTO Etudiant VALUES (31116, 'Nom_11_16', 'Prenom_16', '2003-08-08', 11);
INSERT INTO Etudiant VALUES (31117, 'Nom_11_17', 'Prenom_17', '2003-12-06', 11);
INSERT INTO Etudiant VALUES (31118, 'Nom_11_18', 'Prenom_18', '2003-01-26', 11);
INSERT INTO Etudiant VALUES (31119, 'Nom_11_19', 'Prenom_19', '2003-09-22', 11);
INSERT INTO Etudiant VALUES (31120, 'Nom_11_20', 'Prenom_20', '2003-08-15', 11);
INSERT INTO Etudiant VALUES (31121, 'Nom_11_21', 'Prenom_21', '2003-06-24', 11);
INSERT INTO Etudiant VALUES (31122, 'Nom_11_22', 'Prenom_22', '2003-01-24', 11);
INSERT INTO Etudiant VALUES (31123, 'Nom_11_23', 'Prenom_23', '2003-04-03', 11);
INSERT INTO Etudiant VALUES (31124, 'Nom_11_24', 'Prenom_24', '2003-03-03', 11);
INSERT INTO Etudiant VALUES (31125, 'Nom_11_25', 'Prenom_25', '2003-01-07', 11);
INSERT INTO Etudiant VALUES (31126, 'Nom_11_26', 'Prenom_26', '2003-04-24', 11);
INSERT INTO Etudiant VALUES (31127, 'Nom_11_27', 'Prenom_27', '2003-01-26', 11);
INSERT INTO Etudiant VALUES (31128, 'Nom_11_28', 'Prenom_28', '2003-08-26', 11);
INSERT INTO Etudiant VALUES (31129, 'Nom_11_29', 'Prenom_29', '2003-08-11', 11);
INSERT INTO Etudiant VALUES (31130, 'Nom_11_30', 'Prenom_30', '2003-11-13', 11);
INSERT INTO Etudiant VALUES (11201, 'Nom_12_1', 'Prenom_1', '2005-05-30', 12);
INSERT INTO Etudiant VALUES (11202, 'Nom_12_2', 'Prenom_2', '2005-09-04', 12);
INSERT INTO Etudiant VALUES (11203, 'Nom_12_3', 'Prenom_3', '2005-01-10', 12);
INSERT INTO Etudiant VALUES (11204, 'Nom_12_4', 'Prenom_4', '2005-01-21', 12);
INSERT INTO Etudiant VALUES (11205, 'Nom_12_5', 'Prenom_5', '2005-01-19', 12);
INSERT INTO Etudiant VALUES (11206, 'Nom_12_6', 'Prenom_6', '2005-11-20', 12);
INSERT INTO Etudiant VALUES (11207, 'Nom_12_7', 'Prenom_7', '2005-10-23', 12);
INSERT INTO Etudiant VALUES (11208, 'Nom_12_8', 'Prenom_8', '2005-07-06', 12);
INSERT INTO Etudiant VALUES (11209, 'Nom_12_9', 'Prenom_9', '2005-06-12', 12);
INSERT INTO Etudiant VALUES (11210, 'Nom_12_10', 'Prenom_10', '2005-07-11', 12);
INSERT INTO Etudiant VALUES (11211, 'Nom_12_11', 'Prenom_11', '2005-12-07', 12);
INSERT INTO Etudiant VALUES (11212, 'Nom_12_12', 'Prenom_12', '2005-02-10', 12);
INSERT INTO Etudiant VALUES (11213, 'Nom_12_13', 'Prenom_13', '2005-05-19', 12);
INSERT INTO Etudiant VALUES (11214, 'Nom_12_14', 'Prenom_14', '2005-08-07', 12);
INSERT INTO Etudiant VALUES (11215, 'Nom_12_15', 'Prenom_15', '2005-09-23', 12);
INSERT INTO Etudiant VALUES (11216, 'Nom_12_16', 'Prenom_16', '2005-10-22', 12);
INSERT INTO Etudiant VALUES (11217, 'Nom_12_17', 'Prenom_17', '2005-04-28', 12);
INSERT INTO Etudiant VALUES (11218, 'Nom_12_18', 'Prenom_18', '2005-06-10', 12);
INSERT INTO Etudiant VALUES (11219, 'Nom_12_19', 'Prenom_19', '2005-04-16', 12);
INSERT INTO Etudiant VALUES (11220, 'Nom_12_20', 'Prenom_20', '2005-07-17', 12);
INSERT INTO Etudiant VALUES (11221, 'Nom_12_21', 'Prenom_21', '2005-11-06', 12);
INSERT INTO Etudiant VALUES (11222, 'Nom_12_22', 'Prenom_22', '2005-12-27', 12);
INSERT INTO Etudiant VALUES (11223, 'Nom_12_23', 'Prenom_23', '2005-07-15', 12);
INSERT INTO Etudiant VALUES (11224, 'Nom_12_24', 'Prenom_24', '2005-11-07', 12);
INSERT INTO Etudiant VALUES (11225, 'Nom_12_25', 'Prenom_25', '2005-04-27', 12);
INSERT INTO Etudiant VALUES (11226, 'Nom_12_26', 'Prenom_26', '2005-11-14', 12);
INSERT INTO Etudiant VALUES (11227, 'Nom_12_27', 'Prenom_27', '2005-03-18', 12);
INSERT INTO Etudiant VALUES (11228, 'Nom_12_28', 'Prenom_28', '2005-11-07', 12);
INSERT INTO Etudiant VALUES (21201, 'Nom_12_1', 'Prenom_1', '2004-06-23', 12);
INSERT INTO Etudiant VALUES (21202, 'Nom_12_2', 'Prenom_2', '2004-01-03', 12);
INSERT INTO Etudiant VALUES (21203, 'Nom_12_3', 'Prenom_3', '2004-11-29', 12);
INSERT INTO Etudiant VALUES (21204, 'Nom_12_4', 'Prenom_4', '2004-11-09', 12);
INSERT INTO Etudiant VALUES (21205, 'Nom_12_5', 'Prenom_5', '2004-04-13', 12);
INSERT INTO Etudiant VALUES (21206, 'Nom_12_6', 'Prenom_6', '2004-04-04', 12);
INSERT INTO Etudiant VALUES (21207, 'Nom_12_7', 'Prenom_7', '2004-10-05', 12);
INSERT INTO Etudiant VALUES (21208, 'Nom_12_8', 'Prenom_8', '2004-04-07', 12);
INSERT INTO Etudiant VALUES (21209, 'Nom_12_9', 'Prenom_9', '2004-12-26', 12);
INSERT INTO Etudiant VALUES (21210, 'Nom_12_10', 'Prenom_10', '2004-07-30', 12);
INSERT INTO Etudiant VALUES (21211, 'Nom_12_11', 'Prenom_11', '2004-01-21', 12);
INSERT INTO Etudiant VALUES (21212, 'Nom_12_12', 'Prenom_12', '2004-09-28', 12);
INSERT INTO Etudiant VALUES (21213, 'Nom_12_13', 'Prenom_13', '2004-05-25', 12);
INSERT INTO Etudiant VALUES (21214, 'Nom_12_14', 'Prenom_14', '2004-11-05', 12);
INSERT INTO Etudiant VALUES (21215, 'Nom_12_15', 'Prenom_15', '2004-04-08', 12);
INSERT INTO Etudiant VALUES (21216, 'Nom_12_16', 'Prenom_16', '2004-10-17', 12);
INSERT INTO Etudiant VALUES (21217, 'Nom_12_17', 'Prenom_17', '2004-05-08', 12);
INSERT INTO Etudiant VALUES (21218, 'Nom_12_18', 'Prenom_18', '2004-10-20', 12);
INSERT INTO Etudiant VALUES (21219, 'Nom_12_19', 'Prenom_19', '2004-11-13', 12);
INSERT INTO Etudiant VALUES (21220, 'Nom_12_20', 'Prenom_20', '2004-06-23', 12);
INSERT INTO Etudiant VALUES (21221, 'Nom_12_21', 'Prenom_21', '2004-06-14', 12);
INSERT INTO Etudiant VALUES (21222, 'Nom_12_22', 'Prenom_22', '2004-03-31', 12);
INSERT INTO Etudiant VALUES (21223, 'Nom_12_23', 'Prenom_23', '2004-11-12', 12);
INSERT INTO Etudiant VALUES (21224, 'Nom_12_24', 'Prenom_24', '2004-12-27', 12);
INSERT INTO Etudiant VALUES (21225, 'Nom_12_25', 'Prenom_25', '2004-01-21', 12);
INSERT INTO Etudiant VALUES (21226, 'Nom_12_26', 'Prenom_26', '2004-09-30', 12);
INSERT INTO Etudiant VALUES (21227, 'Nom_12_27', 'Prenom_27', '2004-05-20', 12);
INSERT INTO Etudiant VALUES (21228, 'Nom_12_28', 'Prenom_28', '2004-02-02', 12);
INSERT INTO Etudiant VALUES (31201, 'Nom_12_1', 'Prenom_1', '2003-08-09', 12);
INSERT INTO Etudiant VALUES (31202, 'Nom_12_2', 'Prenom_2', '2003-08-30', 12);
INSERT INTO Etudiant VALUES (31203, 'Nom_12_3', 'Prenom_3', '2003-02-03', 12);
INSERT INTO Etudiant VALUES (31204, 'Nom_12_4', 'Prenom_4', '2003-10-13', 12);
INSERT INTO Etudiant VALUES (31205, 'Nom_12_5', 'Prenom_5', '2003-03-27', 12);
INSERT INTO Etudiant VALUES (31206, 'Nom_12_6', 'Prenom_6', '2003-02-22', 12);
INSERT INTO Etudiant VALUES (31207, 'Nom_12_7', 'Prenom_7', '2003-12-29', 12);
INSERT INTO Etudiant VALUES (31208, 'Nom_12_8', 'Prenom_8', '2003-08-06', 12);
INSERT INTO Etudiant VALUES (31209, 'Nom_12_9', 'Prenom_9', '2003-07-22', 12);
INSERT INTO Etudiant VALUES (31210, 'Nom_12_10', 'Prenom_10', '2003-03-26', 12);
INSERT INTO Etudiant VALUES (31211, 'Nom_12_11', 'Prenom_11', '2003-04-25', 12);
INSERT INTO Etudiant VALUES (31212, 'Nom_12_12', 'Prenom_12', '2003-10-31', 12);
INSERT INTO Etudiant VALUES (31213, 'Nom_12_13', 'Prenom_13', '2003-10-11', 12);
INSERT INTO Etudiant VALUES (31214, 'Nom_12_14', 'Prenom_14', '2003-01-01', 12);
INSERT INTO Etudiant VALUES (31215, 'Nom_12_15', 'Prenom_15', '2003-04-25', 12);
INSERT INTO Etudiant VALUES (31216, 'Nom_12_16', 'Prenom_16', '2003-09-06', 12);
INSERT INTO Etudiant VALUES (31217, 'Nom_12_17', 'Prenom_17', '2003-01-03', 12);
INSERT INTO Etudiant VALUES (31218, 'Nom_12_18', 'Prenom_18', '2003-01-23', 12);
INSERT INTO Etudiant VALUES (31219, 'Nom_12_19', 'Prenom_19', '2003-06-08', 12);
INSERT INTO Etudiant VALUES (31220, 'Nom_12_20', 'Prenom_20', '2003-09-03', 12);
INSERT INTO Etudiant VALUES (31221, 'Nom_12_21', 'Prenom_21', '2003-01-29', 12);
INSERT INTO Etudiant VALUES (31222, 'Nom_12_22', 'Prenom_22', '2003-12-08', 12);
INSERT INTO Etudiant VALUES (31223, 'Nom_12_23', 'Prenom_23', '2003-01-22', 12);
INSERT INTO Etudiant VALUES (31224, 'Nom_12_24', 'Prenom_24', '2003-07-24', 12);
INSERT INTO Etudiant VALUES (31225, 'Nom_12_25', 'Prenom_25', '2003-10-13', 12);
INSERT INTO Etudiant VALUES (31226, 'Nom_12_26', 'Prenom_26', '2003-01-24', 12);
INSERT INTO Etudiant VALUES (31227, 'Nom_12_27', 'Prenom_27', '2003-03-18', 12);
INSERT INTO Etudiant VALUES (31228, 'Nom_12_28', 'Prenom_28', '2003-09-23', 12);

-- Inscription

-- L1
INSERT INTO Inscription (num_etu, code_ue, annee_univ, semestre, statut_validation)
SELECT e.num_etu, sp.code_ue, '2023-2024', sp.semestrePrevu, 'en_cours'
FROM Etudiant e
         JOIN Structure_Parcours sp ON sp.id_parcours = e.id_parcours
WHERE e.num_etu BETWEEN 10000 AND 19999
  AND sp.semestrePrevu IN (1,2);

-- L2
INSERT INTO Inscription (num_etu, code_ue, annee_univ, semestre, statut_validation)
SELECT e.num_etu, sp.code_ue,
       CASE WHEN sp.semestrePrevu IN (1,2) THEN '2022-2023' ELSE '2023-2024' END,
       sp.semestrePrevu,
       CASE WHEN sp.semestrePrevu IN (1,2) THEN 'valide' ELSE 'en_cours' END
FROM Etudiant e
         JOIN Structure_Parcours sp ON sp.id_parcours = e.id_parcours
WHERE e.num_etu BETWEEN 20000 AND 29999
  AND sp.semestrePrevu IN (1,2,3,4);

-- L3
INSERT INTO Inscription (num_etu, code_ue, annee_univ, semestre, statut_validation)
SELECT e.num_etu, sp.code_ue,
       CASE
           WHEN sp.semestrePrevu IN (1,2) THEN '2021-2022'
           WHEN sp.semestrePrevu IN (3,4) THEN '2022-2023'
           ELSE '2023-2024'
           END,
       sp.semestrePrevu,
       CASE
           WHEN sp.semestrePrevu IN (1,2,3,4) THEN 'valide'
           ELSE 'en_cours'
           END
FROM Etudiant e
         JOIN Structure_Parcours sp ON sp.id_parcours = e.id_parcours
WHERE e.num_etu BETWEEN 30000 AND 39999
  AND sp.semestrePrevu IN (1,2,3,4,5,6);


DROP TABLE IF EXISTS Prenoms;
DROP TABLE IF EXISTS Noms;

CREATE TABLE Prenoms (
                         id_prenom INT PRIMARY KEY,
                         prenom VARCHAR(50) NOT NULL
);

CREATE TABLE Noms (
                      id_nom INT PRIMARY KEY,
                      nom VARCHAR(50) NOT NULL
);

INSERT INTO Prenoms (id_prenom, prenom) VALUES
                                            (1,'Lucas'),
                                            (2,'Emma'),
                                            (3,'Hugo'),
                                            (4,'Jade'),
                                            (5,'Louis'),
                                            (6,'Lina'),
                                            (7,'Nathan'),
                                            (8,'Chloe'),
                                            (9,'Leo'),
                                            (10,'Manon'),
                                            (11,'Gabriel'),
                                            (12,'Sarah'),
                                            (13,'Arthur'),
                                            (14,'Ines'),
                                            (15,'Adam'),
                                            (16,'Camille'),
                                            (17,'Noah'),
                                            (18,'Lea'),
                                            (19,'Tom'),
                                            (20,'Eva'),
                                            (21,'Theo'),
                                            (22,'Clara'),
                                            (23,'Paul'),
                                            (24,'Lola'),
                                            (25,'Mathis'),
                                            (26,'Juliette'),
                                            (27,'Maxime'),
                                            (28,'Anais'),
                                            (29,'Baptiste'),
                                            (30,'Marine'),
                                            (31,'Ethan'),
                                            (32,'Charlotte'),
                                            (33,'Alexandre'),
                                            (34,'Lucie'),
                                            (35,'Antoine'),
                                            (36,'Elise'),
                                            (37,'Romain'),
                                            (38,'Nina'),
                                            (39,'Victor'),
                                            (40,'Alice'),
                                            (41,'Julien'),
                                            (42,'Mael'),
                                            (43,'Valentin'),
                                            (44,'Zoe'),
                                            (45,'Samuel'),
                                            (46,'Margot'),
                                            (47,'Thomas'),
                                            (48,'Jeanne'),
                                            (49,'Benjamin'),
                                            (50,'Pauline');

INSERT INTO Noms (id_nom, nom) VALUES
                                   (1,'Martin'),
                                   (2,'Bernard'),
                                   (3,'Thomas'),
                                   (4,'Petit'),
                                   (5,'Robert'),
                                   (6,'Richard'),
                                   (7,'Durand'),
                                   (8,'Dubois'),
                                   (9,'Moreau'),
                                   (10,'Laurent'),
                                   (11,'Simon'),
                                   (12,'Michel'),
                                   (13,'Lefebvre'),
                                   (14,'Leroy'),
                                   (15,'Roux'),
                                   (16,'David'),
                                   (17,'Bertrand'),
                                   (18,'Morel'),
                                   (19,'Fournier'),
                                   (20,'Girard'),
                                   (21,'Bonnet'),
                                   (22,'Dupont'),
                                   (23,'Lambert'),
                                   (24,'Fontaine'),
                                   (25,'Rousseau'),
                                   (26,'Vincent'),
                                   (27,'Muller'),
                                   (28,'Lefevre'),
                                   (29,'Faure'),
                                   (30,'Andre'),
                                   (31,'Mercier'),
                                   (32,'Blanc'),
                                   (33,'Guerin'),
                                   (34,'Boyer'),
                                   (35,'Garnier'),
                                   (36,'Chevalier'),
                                   (37,'Francois'),
                                   (38,'Legrand'),
                                   (39,'Gauthier'),
                                   (40,'Garcia'),
                                   (41,'Perrin'),
                                   (42,'Robin'),
                                   (43,'Clement'),
                                   (44,'Morin'),
                                   (45,'Henry'),
                                   (46,'Roussel'),
                                   (47,'Mathieu'),
                                   (48,'Gautier'),
                                   (49,'Masson'),
                                   (50,'Marchand');

UPDATE Etudiant e
    JOIN Noms n
    ON n.id_nom = ((e.num_etu - 1) MOD 50) + 1
    JOIN Prenoms p
    ON p.id_prenom = (((e.num_etu DIV 10) + (e.id_parcours * 7) - 1) MOD 50) + 1
SET
    e.nom = n.nom,
    e.prenom = p.prenom;