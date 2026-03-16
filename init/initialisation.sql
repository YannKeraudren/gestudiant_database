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
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, id_parcours) VALUES
                                                                             (11001, 'Aubert', 'Alice', '2005-02-14', 1), (11002, 'Baudry', 'Bastien', '2005-06-21', 1),
                                                                             (11003, 'Caron', 'Chloe', '2004-11-03', 1), (11004, 'Dumont', 'David', '2005-01-30', 1),
                                                                             (11005, 'Evrard', 'Emma', '2005-08-12', 1);

INSERT INTO Inscription (num_etu, code_ue, annee_univ, semestre, statut_validation) VALUES
-- Étudiant 11001
(11001, 'ANG_S1', '2023-2024', 1, 'en_cours'), (11001, 'COMPRO_S1', '2023-2024', 1, 'en_cours'), (11001, 'ALGO_S1', '2023-2024', 1, 'en_cours'), (11001, 'MDISC_S1', '2023-2024', 1, 'en_cours'), (11001, 'ECOG_S1', '2023-2024', 1, 'en_cours'), (11001, 'COMP_S1', '2023-2024', 1, 'en_cours'), (11001, 'SINF_S1', '2023-2024', 1, 'en_cours'), (11001, 'DWEB_S1', '2023-2024', 1, 'en_cours'),
(11001, 'ANG_S2', '2023-2024', 2, 'en_cours'), (11001, 'COMPRO_S2', '2023-2024', 2, 'en_cours'), (11001, 'ALGO_S2', '2023-2024', 2, 'en_cours'), (11001, 'MDISC_S2', '2023-2024', 2, 'en_cours'), (11001, 'ECOG_S2', '2023-2024', 2, 'en_cours'), (11001, 'COMP_S2', '2023-2024', 2, 'en_cours'), (11001, 'SINF_S2', '2023-2024', 2, 'en_cours'), (11001, 'DWEB_S2', '2023-2024', 2, 'en_cours'),
-- Étudiant 11002
(11002, 'ANG_S1', '2023-2024', 1, 'en_cours'), (11002, 'COMPRO_S1', '2023-2024', 1, 'en_cours'), (11002, 'ALGO_S1', '2023-2024', 1, 'en_cours'), (11002, 'MDISC_S1', '2023-2024', 1, 'en_cours'), (11002, 'ECOG_S1', '2023-2024', 1, 'en_cours'), (11002, 'COMP_S1', '2023-2024', 1, 'en_cours'), (11002, 'SINF_S1', '2023-2024', 1, 'en_cours'), (11002, 'DWEB_S1', '2023-2024', 1, 'en_cours'),
(11002, 'ANG_S2', '2023-2024', 2, 'en_cours'), (11002, 'COMPRO_S2', '2023-2024', 2, 'en_cours'), (11002, 'ALGO_S2', '2023-2024', 2, 'en_cours'), (11002, 'MDISC_S2', '2023-2024', 2, 'en_cours'), (11002, 'ECOG_S2', '2023-2024', 2, 'en_cours'), (11002, 'COMP_S2', '2023-2024', 2, 'en_cours'), (11002, 'SINF_S2', '2023-2024', 2, 'en_cours'), (11002, 'DWEB_S2', '2023-2024', 2, 'en_cours'),
-- Étudiant 11003
(11003, 'ANG_S1', '2023-2024', 1, 'en_cours'), (11003, 'COMPRO_S1', '2023-2024', 1, 'en_cours'), (11003, 'ALGO_S1', '2023-2024', 1, 'en_cours'), (11003, 'MDISC_S1', '2023-2024', 1, 'en_cours'), (11003, 'ECOG_S1', '2023-2024', 1, 'en_cours'), (11003, 'COMP_S1', '2023-2024', 1, 'en_cours'), (11003, 'SINF_S1', '2023-2024', 1, 'en_cours'), (11003, 'DWEB_S1', '2023-2024', 1, 'en_cours'),
(11003, 'ANG_S2', '2023-2024', 2, 'en_cours'), (11003, 'COMPRO_S2', '2023-2024', 2, 'en_cours'), (11003, 'ALGO_S2', '2023-2024', 2, 'en_cours'), (11003, 'MDISC_S2', '2023-2024', 2, 'en_cours'), (11003, 'ECOG_S2', '2023-2024', 2, 'en_cours'), (11003, 'COMP_S2', '2023-2024', 2, 'en_cours'), (11003, 'SINF_S2', '2023-2024', 2, 'en_cours'), (11003, 'DWEB_S2', '2023-2024', 2, 'en_cours'),
-- Étudiant 11004
(11004, 'ANG_S1', '2023-2024', 1, 'en_cours'), (11004, 'COMPRO_S1', '2023-2024', 1, 'en_cours'), (11004, 'ALGO_S1', '2023-2024', 1, 'en_cours'), (11004, 'MDISC_S1', '2023-2024', 1, 'en_cours'), (11004, 'ECOG_S1', '2023-2024', 1, 'en_cours'), (11004, 'COMP_S1', '2023-2024', 1, 'en_cours'), (11004, 'SINF_S1', '2023-2024', 1, 'en_cours'), (11004, 'DWEB_S1', '2023-2024', 1, 'en_cours'),
(11004, 'ANG_S2', '2023-2024', 2, 'en_cours'), (11004, 'COMPRO_S2', '2023-2024', 2, 'en_cours'), (11004, 'ALGO_S2', '2023-2024', 2, 'en_cours'), (11004, 'MDISC_S2', '2023-2024', 2, 'en_cours'), (11004, 'ECOG_S2', '2023-2024', 2, 'en_cours'), (11004, 'COMP_S2', '2023-2024', 2, 'en_cours'), (11004, 'SINF_S2', '2023-2024', 2, 'en_cours'), (11004, 'DWEB_S2', '2023-2024', 2, 'en_cours'),
-- Étudiant 11005
(11005, 'ANG_S1', '2023-2024', 1, 'en_cours'), (11005, 'COMPRO_S1', '2023-2024', 1, 'en_cours'), (11005, 'ALGO_S1', '2023-2024', 1, 'en_cours'), (11005, 'MDISC_S1', '2023-2024', 1, 'en_cours'), (11005, 'ECOG_S1', '2023-2024', 1, 'en_cours'), (11005, 'COMP_S1', '2023-2024', 1, 'en_cours'), (11005, 'SINF_S1', '2023-2024', 1, 'en_cours'), (11005, 'DWEB_S1', '2023-2024', 1, 'en_cours'),
(11005, 'ANG_S2', '2023-2024', 2, 'en_cours'), (11005, 'COMPRO_S2', '2023-2024', 2, 'en_cours'), (11005, 'ALGO_S2', '2023-2024', 2, 'en_cours'), (11005, 'MDISC_S2', '2023-2024', 2, 'en_cours'), (11005, 'ECOG_S2', '2023-2024', 2, 'en_cours'), (11005, 'COMP_S2', '2023-2024', 2, 'en_cours'), (11005, 'SINF_S2', '2023-2024', 2, 'en_cours'), (11005, 'DWEB_S2', '2023-2024', 2, 'en_cours');

-- ------------------------------------------
-- PROMO L2 (5 Étudiants) - S1/S2 validés, S3/S4 en_cours
-- ------------------------------------------
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, id_parcours) VALUES
                                                                             (12001, 'Fabre', 'Florent', '2004-03-15', 1), (12002, 'Garnier', 'Gisele', '2003-12-08', 1),
                                                                             (12003, 'Huet', 'Hugo', '2004-07-22', 1), (12004, 'Imbert', 'Ines', '2004-02-11', 1),
                                                                             (12005, 'Jacquot', 'Jules', '2004-09-05', 1);

INSERT INTO Inscription (num_etu, code_ue, annee_univ, semestre, statut_validation) VALUES
-- Étudiant 12001 (A tout validé en L1 l'an dernier)
(12001, 'ANG_S1', '2022-2023', 1, 'valide'), (12001, 'COMPRO_S1', '2022-2023', 1, 'valide'), (12001, 'ALGO_S1', '2022-2023', 1, 'valide'), (12001, 'MDISC_S1', '2022-2023', 1, 'valide'), (12001, 'ECOG_S1', '2022-2023', 1, 'valide'), (12001, 'COMP_S1', '2022-2023', 1, 'valide'), (12001, 'SINF_S1', '2022-2023', 1, 'valide'), (12001, 'DWEB_S1', '2022-2023', 1, 'valide'),
(12001, 'ANG_S2', '2022-2023', 2, 'valide'), (12001, 'COMPRO_S2', '2022-2023', 2, 'valide'), (12001, 'ALGO_S2', '2022-2023', 2, 'valide'), (12001, 'MDISC_S2', '2022-2023', 2, 'valide'), (12001, 'ECOG_S2', '2022-2023', 2, 'valide'), (12001, 'COMP_S2', '2022-2023', 2, 'valide'), (12001, 'SINF_S2', '2022-2023', 2, 'valide'), (12001, 'DWEB_S2', '2022-2023', 2, 'valide'),
(12001, 'ANG_S3', '2023-2024', 3, 'en_cours'), (12001, 'COMPRO_S3', '2023-2024', 3, 'en_cours'), (12001, 'ALGO_S3', '2023-2024', 3, 'en_cours'), (12001, 'MDISC_S3', '2023-2024', 3, 'en_cours'), (12001, 'ECOG_S3', '2023-2024', 3, 'en_cours'), (12001, 'COMP_S3', '2023-2024', 3, 'en_cours'), (12001, 'SINF_S3', '2023-2024', 3, 'en_cours'), (12001, 'DWEB_S3', '2023-2024', 3, 'en_cours'),
(12001, 'ANG_S4', '2023-2024', 4, 'en_cours'), (12001, 'COMPRO_S4', '2023-2024', 4, 'en_cours'), (12001, 'ALGO_S4', '2023-2024', 4, 'en_cours'), (12001, 'MDISC_S4', '2023-2024', 4, 'en_cours'), (12001, 'ECOG_S4', '2023-2024', 4, 'en_cours'), (12001, 'COMP_S4', '2023-2024', 4, 'en_cours'), (12001, 'SINF_S4', '2023-2024', 4, 'en_cours'), (12001, 'DWEB_S4', '2023-2024', 4, 'en_cours'),
-- Étudiant 12002
(12002, 'ANG_S1', '2022-2023', 1, 'valide'), (12002, 'COMPRO_S1', '2022-2023', 1, 'valide'), (12002, 'ALGO_S1', '2022-2023', 1, 'valide'), (12002, 'MDISC_S1', '2022-2023', 1, 'valide'), (12002, 'ECOG_S1', '2022-2023', 1, 'valide'), (12002, 'COMP_S1', '2022-2023', 1, 'valide'), (12002, 'SINF_S1', '2022-2023', 1, 'valide'), (12002, 'DWEB_S1', '2022-2023', 1, 'valide'),
(12002, 'ANG_S2', '2022-2023', 2, 'valide'), (12002, 'COMPRO_S2', '2022-2023', 2, 'valide'), (12002, 'ALGO_S2', '2022-2023', 2, 'valide'), (12002, 'MDISC_S2', '2022-2023', 2, 'valide'), (12002, 'ECOG_S2', '2022-2023', 2, 'valide'), (12002, 'COMP_S2', '2022-2023', 2, 'valide'), (12002, 'SINF_S2', '2022-2023', 2, 'valide'), (12002, 'DWEB_S2', '2022-2023', 2, 'valide'),
(12002, 'ANG_S3', '2023-2024', 3, 'en_cours'), (12002, 'COMPRO_S3', '2023-2024', 3, 'en_cours'), (12002, 'ALGO_S3', '2023-2024', 3, 'en_cours'), (12002, 'MDISC_S3', '2023-2024', 3, 'en_cours'), (12002, 'ECOG_S3', '2023-2024', 3, 'en_cours'), (12002, 'COMP_S3', '2023-2024', 3, 'en_cours'), (12002, 'SINF_S3', '2023-2024', 3, 'en_cours'), (12002, 'DWEB_S3', '2023-2024', 3, 'en_cours'),
(12002, 'ANG_S4', '2023-2024', 4, 'en_cours'), (12002, 'COMPRO_S4', '2023-2024', 4, 'en_cours'), (12002, 'ALGO_S4', '2023-2024', 4, 'en_cours'), (12002, 'MDISC_S4', '2023-2024', 4, 'en_cours'), (12002, 'ECOG_S4', '2023-2024', 4, 'en_cours'), (12002, 'COMP_S4', '2023-2024', 4, 'en_cours'), (12002, 'SINF_S4', '2023-2024', 4, 'en_cours'), (12002, 'DWEB_S4', '2023-2024', 4, 'en_cours'),
-- Étudiant 12003 (Avec un échec rattrapé)
(12003, 'ANG_S1', '2022-2023', 1, 'valide'), (12003, 'COMPRO_S1', '2022-2023', 1, 'valide'), (12003, 'ALGO_S1', '2022-2023', 1, 'echoue'), (12003, 'MDISC_S1', '2022-2023', 1, 'valide'), (12003, 'ECOG_S1', '2022-2023', 1, 'valide'), (12003, 'COMP_S1', '2022-2023', 1, 'valide'), (12003, 'SINF_S1', '2022-2023', 1, 'valide'), (12003, 'DWEB_S1', '2022-2023', 1, 'valide'),
(12003, 'ANG_S2', '2022-2023', 2, 'valide'), (12003, 'COMPRO_S2', '2022-2023', 2, 'valide'), (12003, 'ALGO_S2', '2022-2023', 2, 'valide'), (12003, 'MDISC_S2', '2022-2023', 2, 'valide'), (12003, 'ECOG_S2', '2022-2023', 2, 'valide'), (12003, 'COMP_S2', '2022-2023', 2, 'valide'), (12003, 'SINF_S2', '2022-2023', 2, 'valide'), (12003, 'DWEB_S2', '2022-2023', 2, 'valide'),
(12003, 'ALGO_S1', '2023-2024', 1, 'en_cours'), -- Rattrapage de la L1 !
(12003, 'ANG_S3', '2023-2024', 3, 'en_cours'), (12003, 'COMPRO_S3', '2023-2024', 3, 'en_cours'), (12003, 'ALGO_S3', '2023-2024', 3, 'en_cours'), (12003, 'MDISC_S3', '2023-2024', 3, 'en_cours'), (12003, 'ECOG_S3', '2023-2024', 3, 'en_cours'), (12003, 'COMP_S3', '2023-2024', 3, 'en_cours'), (12003, 'SINF_S3', '2023-2024', 3, 'en_cours'), (12003, 'DWEB_S3', '2023-2024', 3, 'en_cours'),
(12003, 'ANG_S4', '2023-2024', 4, 'en_cours'), (12003, 'COMPRO_S4', '2023-2024', 4, 'en_cours'), (12003, 'ALGO_S4', '2023-2024', 4, 'en_cours'), (12003, 'MDISC_S4', '2023-2024', 4, 'en_cours'), (12003, 'ECOG_S4', '2023-2024', 4, 'en_cours'), (12003, 'COMP_S4', '2023-2024', 4, 'en_cours'), (12003, 'SINF_S4', '2023-2024', 4, 'en_cours'), (12003, 'DWEB_S4', '2023-2024', 4, 'en_cours'),
-- Étudiant 12004
(12004, 'ANG_S1', '2022-2023', 1, 'valide'), (12004, 'COMPRO_S1', '2022-2023', 1, 'valide'), (12004, 'ALGO_S1', '2022-2023', 1, 'valide'), (12004, 'MDISC_S1', '2022-2023', 1, 'valide'), (12004, 'ECOG_S1', '2022-2023', 1, 'valide'), (12004, 'COMP_S1', '2022-2023', 1, 'valide'), (12004, 'SINF_S1', '2022-2023', 1, 'valide'), (12004, 'DWEB_S1', '2022-2023', 1, 'valide'),
(12004, 'ANG_S2', '2022-2023', 2, 'valide'), (12004, 'COMPRO_S2', '2022-2023', 2, 'valide'), (12004, 'ALGO_S2', '2022-2023', 2, 'valide'), (12004, 'MDISC_S2', '2022-2023', 2, 'valide'), (12004, 'ECOG_S2', '2022-2023', 2, 'valide'), (12004, 'COMP_S2', '2022-2023', 2, 'valide'), (12004, 'SINF_S2', '2022-2023', 2, 'valide'), (12004, 'DWEB_S2', '2022-2023', 2, 'valide'),
(12004, 'ANG_S3', '2023-2024', 3, 'en_cours'), (12004, 'COMPRO_S3', '2023-2024', 3, 'en_cours'), (12004, 'ALGO_S3', '2023-2024', 3, 'en_cours'), (12004, 'MDISC_S3', '2023-2024', 3, 'en_cours'), (12004, 'ECOG_S3', '2023-2024', 3, 'en_cours'), (12004, 'COMP_S3', '2023-2024', 3, 'en_cours'), (12004, 'SINF_S3', '2023-2024', 3, 'en_cours'), (12004, 'DWEB_S3', '2023-2024', 3, 'en_cours'),
(12004, 'ANG_S4', '2023-2024', 4, 'en_cours'), (12004, 'COMPRO_S4', '2023-2024', 4, 'en_cours'), (12004, 'ALGO_S4', '2023-2024', 4, 'en_cours'), (12004, 'MDISC_S4', '2023-2024', 4, 'en_cours'), (12004, 'ECOG_S4', '2023-2024', 4, 'en_cours'), (12004, 'COMP_S4', '2023-2024', 4, 'en_cours'), (12004, 'SINF_S4', '2023-2024', 4, 'en_cours'), (12004, 'DWEB_S4', '2023-2024', 4, 'en_cours'),
-- Étudiant 12005
(12005, 'ANG_S1', '2022-2023', 1, 'valide'), (12005, 'COMPRO_S1', '2022-2023', 1, 'valide'), (12005, 'ALGO_S1', '2022-2023', 1, 'valide'), (12005, 'MDISC_S1', '2022-2023', 1, 'valide'), (12005, 'ECOG_S1', '2022-2023', 1, 'valide'), (12005, 'COMP_S1', '2022-2023', 1, 'valide'), (12005, 'SINF_S1', '2022-2023', 1, 'valide'), (12005, 'DWEB_S1', '2022-2023', 1, 'valide'),
(12005, 'ANG_S2', '2022-2023', 2, 'valide'), (12005, 'COMPRO_S2', '2022-2023', 2, 'valide'), (12005, 'ALGO_S2', '2022-2023', 2, 'valide'), (12005, 'MDISC_S2', '2022-2023', 2, 'valide'), (12005, 'ECOG_S2', '2022-2023', 2, 'valide'), (12005, 'COMP_S2', '2022-2023', 2, 'valide'), (12005, 'SINF_S2', '2022-2023', 2, 'valide'), (12005, 'DWEB_S2', '2022-2023', 2, 'valide'),
(12005, 'ANG_S3', '2023-2024', 3, 'en_cours'), (12005, 'COMPRO_S3', '2023-2024', 3, 'en_cours'), (12005, 'ALGO_S3', '2023-2024', 3, 'en_cours'), (12005, 'MDISC_S3', '2023-2024', 3, 'en_cours'), (12005, 'ECOG_S3', '2023-2024', 3, 'en_cours'), (12005, 'COMP_S3', '2023-2024', 3, 'en_cours'), (12005, 'SINF_S3', '2023-2024', 3, 'en_cours'), (12005, 'DWEB_S3', '2023-2024', 3, 'en_cours'),
(12005, 'ANG_S4', '2023-2024', 4, 'en_cours'), (12005, 'COMPRO_S4', '2023-2024', 4, 'en_cours'), (12005, 'ALGO_S4', '2023-2024', 4, 'en_cours'), (12005, 'MDISC_S4', '2023-2024', 4, 'en_cours'), (12005, 'ECOG_S4', '2023-2024', 4, 'en_cours'), (12005, 'COMP_S4', '2023-2024', 4, 'en_cours'), (12005, 'SINF_S4', '2023-2024', 4, 'en_cours'), (12005, 'DWEB_S4', '2023-2024', 4, 'en_cours');


-- ------------------------------------------
-- PROMO L3 (5 Étudiants) - S1 à S4 validés, S5/S6 en_cours
-- ------------------------------------------
INSERT INTO Etudiant (num_etu, nom, prenom, date_naissance, id_parcours) VALUES
                                                                             (13001, 'Lambert', 'Leo', '2003-05-18', 1), (13002, 'Martin', 'Manon', '2002-10-09', 1),
                                                                             (13003, 'Navarro', 'Noa', '2003-01-27', 1), (13004, 'Olivier', 'Ocean', '2002-08-14', 1),
                                                                             (13005, 'Perrin', 'Paul', '2003-12-01', 1);

INSERT INTO Inscription (num_etu, code_ue, annee_univ, semestre, statut_validation) VALUES
-- Étudiant 13001 (A tout validé ses 2 premières années !)
(13001, 'ANG_S1', '2021-2022', 1, 'valide'), (13001, 'COMPRO_S1', '2021-2022', 1, 'valide'), (13001, 'ALGO_S1', '2021-2022', 1, 'valide'), (13001, 'MDISC_S1', '2021-2022', 1, 'valide'), (13001, 'ECOG_S1', '2021-2022', 1, 'valide'), (13001, 'COMP_S1', '2021-2022', 1, 'valide'), (13001, 'SINF_S1', '2021-2022', 1, 'valide'), (13001, 'DWEB_S1', '2021-2022', 1, 'valide'),
(13001, 'ANG_S2', '2021-2022', 2, 'valide'), (13001, 'COMPRO_S2', '2021-2022', 2, 'valide'), (13001, 'ALGO_S2', '2021-2022', 2, 'valide'), (13001, 'MDISC_S2', '2021-2022', 2, 'valide'), (13001, 'ECOG_S2', '2021-2022', 2, 'valide'), (13001, 'COMP_S2', '2021-2022', 2, 'valide'), (13001, 'SINF_S2', '2021-2022', 2, 'valide'), (13001, 'DWEB_S2', '2021-2022', 2, 'valide'),
(13001, 'ANG_S3', '2022-2023', 3, 'valide'), (13001, 'COMPRO_S3', '2022-2023', 3, 'valide'), (13001, 'ALGO_S3', '2022-2023', 3, 'valide'), (13001, 'MDISC_S3', '2022-2023', 3, 'valide'), (13001, 'ECOG_S3', '2022-2023', 3, 'valide'), (13001, 'COMP_S3', '2022-2023', 3, 'valide'), (13001, 'SINF_S3', '2022-2023', 3, 'valide'), (13001, 'DWEB_S3', '2022-2023', 3, 'valide'),
(13001, 'ANG_S4', '2022-2023', 4, 'valide'), (13001, 'COMPRO_S4', '2022-2023', 4, 'valide'), (13001, 'ALGO_S4', '2022-2023', 4, 'valide'), (13001, 'MDISC_S4', '2022-2023', 4, 'valide'), (13001, 'ECOG_S4', '2022-2023', 4, 'valide'), (13001, 'COMP_S4', '2022-2023', 4, 'valide'), (13001, 'SINF_S4', '2022-2023', 4, 'valide'), (13001, 'DWEB_S4', '2022-2023', 4, 'valide'),
(13001, 'ANG_S5', '2023-2024', 5, 'en_cours'), (13001, 'COMPRO_S5', '2023-2024', 5, 'en_cours'), (13001, 'ALGO_S5', '2023-2024', 5, 'en_cours'), (13001, 'MDISC_S5', '2023-2024', 5, 'en_cours'), (13001, 'ECOG_S5', '2023-2024', 5, 'en_cours'), (13001, 'COMP_S5', '2023-2024', 5, 'en_cours'), (13001, 'SINF_S5', '2023-2024', 5, 'en_cours'), (13001, 'DWEB_S5', '2023-2024', 5, 'en_cours'),
(13001, 'ANG_S6', '2023-2024', 6, 'en_cours'), (13001, 'COMPRO_S6', '2023-2024', 6, 'en_cours'), (13001, 'ALGO_S6', '2023-2024', 6, 'en_cours'), (13001, 'MDISC_S6', '2023-2024', 6, 'en_cours'), (13001, 'ECOG_S6', '2023-2024', 6, 'en_cours'), (13001, 'COMP_S6', '2023-2024', 6, 'en_cours'), (13001, 'SINF_S6', '2023-2024', 6, 'en_cours'), (13001, 'DWEB_S6', '2023-2024', 6, 'en_cours'),

-- Étudiant 13002
(13002, 'ANG_S1', '2021-2022', 1, 'valide'), (13002, 'COMPRO_S1', '2021-2022', 1, 'valide'), (13002, 'ALGO_S1', '2021-2022', 1, 'valide'), (13002, 'MDISC_S1', '2021-2022', 1, 'valide'), (13002, 'ECOG_S1', '2021-2022', 1, 'valide'), (13002, 'COMP_S1', '2021-2022', 1, 'valide'), (13002, 'SINF_S1', '2021-2022', 1, 'valide'), (13002, 'DWEB_S1', '2021-2022', 1, 'valide'),
(13002, 'ANG_S2', '2021-2022', 2, 'valide'), (13002, 'COMPRO_S2', '2021-2022', 2, 'valide'), (13002, 'ALGO_S2', '2021-2022', 2, 'valide'), (13002, 'MDISC_S2', '2021-2022', 2, 'valide'), (13002, 'ECOG_S2', '2021-2022', 2, 'valide'), (13002, 'COMP_S2', '2021-2022', 2, 'valide'), (13002, 'SINF_S2', '2021-2022', 2, 'valide'), (13002, 'DWEB_S2', '2021-2022', 2, 'valide'),
(13002, 'ANG_S3', '2022-2023', 3, 'valide'), (13002, 'COMPRO_S3', '2022-2023', 3, 'valide'), (13002, 'ALGO_S3', '2022-2023', 3, 'valide'), (13002, 'MDISC_S3', '2022-2023', 3, 'valide'), (13002, 'ECOG_S3', '2022-2023', 3, 'valide'), (13002, 'COMP_S3', '2022-2023', 3, 'valide'), (13002, 'SINF_S3', '2022-2023', 3, 'valide'), (13002, 'DWEB_S3', '2022-2023', 3, 'valide'),
(13002, 'ANG_S4', '2022-2023', 4, 'valide'), (13002, 'COMPRO_S4', '2022-2023', 4, 'valide'), (13002, 'ALGO_S4', '2022-2023', 4, 'valide'), (13002, 'MDISC_S4', '2022-2023', 4, 'valide'), (13002, 'ECOG_S4', '2022-2023', 4, 'valide'), (13002, 'COMP_S4', '2022-2023', 4, 'valide'), (13002, 'SINF_S4', '2022-2023', 4, 'valide'), (13002, 'DWEB_S4', '2022-2023', 4, 'valide'),
(13002, 'ANG_S5', '2023-2024', 5, 'en_cours'), (13002, 'COMPRO_S5', '2023-2024', 5, 'en_cours'), (13002, 'ALGO_S5', '2023-2024', 5, 'en_cours'), (13002, 'MDISC_S5', '2023-2024', 5, 'en_cours'), (13002, 'ECOG_S5', '2023-2024', 5, 'en_cours'), (13002, 'COMP_S5', '2023-2024', 5, 'en_cours'), (13002, 'SINF_S5', '2023-2024', 5, 'en_cours'), (13002, 'DWEB_S5', '2023-2024', 5, 'en_cours'),
(13002, 'ANG_S6', '2023-2024', 6, 'en_cours'), (13002, 'COMPRO_S6', '2023-2024', 6, 'en_cours'), (13002, 'ALGO_S6', '2023-2024', 6, 'en_cours'), (13002, 'MDISC_S6', '2023-2024', 6, 'en_cours'), (13002, 'ECOG_S6', '2023-2024', 6, 'en_cours'), (13002, 'COMP_S6', '2023-2024', 6, 'en_cours'), (13002, 'SINF_S6', '2023-2024', 6, 'en_cours'), (13002, 'DWEB_S6', '2023-2024', 6, 'en_cours'),

-- Étudiant 13003
(13003, 'ANG_S1', '2021-2022', 1, 'valide'), (13003, 'COMPRO_S1', '2021-2022', 1, 'valide'), (13003, 'ALGO_S1', '2021-2022', 1, 'valide'), (13003, 'MDISC_S1', '2021-2022', 1, 'valide'), (13003, 'ECOG_S1', '2021-2022', 1, 'valide'), (13003, 'COMP_S1', '2021-2022', 1, 'valide'), (13003, 'SINF_S1', '2021-2022', 1, 'valide'), (13003, 'DWEB_S1', '2021-2022', 1, 'valide'),
(13003, 'ANG_S2', '2021-2022', 2, 'valide'), (13003, 'COMPRO_S2', '2021-2022', 2, 'valide'), (13003, 'ALGO_S2', '2021-2022', 2, 'valide'), (13003, 'MDISC_S2', '2021-2022', 2, 'valide'), (13003, 'ECOG_S2', '2021-2022', 2, 'valide'), (13003, 'COMP_S2', '2021-2022', 2, 'valide'), (13003, 'SINF_S2', '2021-2022', 2, 'valide'), (13003, 'DWEB_S2', '2021-2022', 2, 'valide'),
(13003, 'ANG_S3', '2022-2023', 3, 'valide'), (13003, 'COMPRO_S3', '2022-2023', 3, 'valide'), (13003, 'ALGO_S3', '2022-2023', 3, 'valide'), (13003, 'MDISC_S3', '2022-2023', 3, 'valide'), (13003, 'ECOG_S3', '2022-2023', 3, 'valide'), (13003, 'COMP_S3', '2022-2023', 3, 'valide'), (13003, 'SINF_S3', '2022-2023', 3, 'valide'), (13003, 'DWEB_S3', '2022-2023', 3, 'valide'),
(13003, 'ANG_S4', '2022-2023', 4, 'valide'), (13003, 'COMPRO_S4', '2022-2023', 4, 'valide'), (13003, 'ALGO_S4', '2022-2023', 4, 'valide'), (13003, 'MDISC_S4', '2022-2023', 4, 'valide'), (13003, 'ECOG_S4', '2022-2023', 4, 'valide'), (13003, 'COMP_S4', '2022-2023', 4, 'valide'), (13003, 'SINF_S4', '2022-2023', 4, 'valide'), (13003, 'DWEB_S4', '2022-2023', 4, 'valide'),
(13003, 'ANG_S5', '2023-2024', 5, 'en_cours'), (13003, 'COMPRO_S5', '2023-2024', 5, 'en_cours'), (13003, 'ALGO_S5', '2023-2024', 5, 'en_cours'), (13003, 'MDISC_S5', '2023-2024', 5, 'en_cours'), (13003, 'ECOG_S5', '2023-2024', 5, 'en_cours'), (13003, 'COMP_S5', '2023-2024', 5, 'en_cours'), (13003, 'SINF_S5', '2023-2024', 5, 'en_cours'), (13003, 'DWEB_S5', '2023-2024', 5, 'en_cours'),
(13003, 'ANG_S6', '2023-2024', 6, 'en_cours'), (13003, 'COMPRO_S6', '2023-2024', 6, 'en_cours'), (13003, 'ALGO_S6', '2023-2024', 6, 'en_cours'), (13003, 'MDISC_S6', '2023-2024', 6, 'en_cours'), (13003, 'ECOG_S6', '2023-2024', 6, 'en_cours'), (13003, 'COMP_S6', '2023-2024', 6, 'en_cours'), (13003, 'SINF_S6', '2023-2024', 6, 'en_cours'), (13003, 'DWEB_S6', '2023-2024', 6, 'en_cours'),

-- Étudiant 13004
(13004, 'ANG_S1', '2021-2022', 1, 'valide'), (13004, 'COMPRO_S1', '2021-2022', 1, 'valide'), (13004, 'ALGO_S1', '2021-2022', 1, 'valide'), (13004, 'MDISC_S1', '2021-2022', 1, 'valide'), (13004, 'ECOG_S1', '2021-2022', 1, 'valide'), (13004, 'COMP_S1', '2021-2022', 1, 'valide'), (13004, 'SINF_S1', '2021-2022', 1, 'valide'), (13004, 'DWEB_S1', '2021-2022', 1, 'valide'),
(13004, 'ANG_S2', '2021-2022', 2, 'valide'), (13004, 'COMPRO_S2', '2021-2022', 2, 'valide'), (13004, 'ALGO_S2', '2021-2022', 2, 'valide'), (13004, 'MDISC_S2', '2021-2022', 2, 'valide'), (13004, 'ECOG_S2', '2021-2022', 2, 'valide'), (13004, 'COMP_S2', '2021-2022', 2, 'valide'), (13004, 'SINF_S2', '2021-2022', 2, 'valide'), (13004, 'DWEB_S2', '2021-2022', 2, 'valide'),
(13004, 'ANG_S3', '2022-2023', 3, 'valide'), (13004, 'COMPRO_S3', '2022-2023', 3, 'valide'), (13004, 'ALGO_S3', '2022-2023', 3, 'valide'), (13004, 'MDISC_S3', '2022-2023', 3, 'valide'), (13004, 'ECOG_S3', '2022-2023', 3, 'valide'), (13004, 'COMP_S3', '2022-2023', 3, 'valide'), (13004, 'SINF_S3', '2022-2023', 3, 'valide'), (13004, 'DWEB_S3', '2022-2023', 3, 'valide'),
(13004, 'ANG_S4', '2022-2023', 4, 'valide'), (13004, 'COMPRO_S4', '2022-2023', 4, 'valide'), (13004, 'ALGO_S4', '2022-2023', 4, 'valide'), (13004, 'MDISC_S4', '2022-2023', 4, 'valide'), (13004, 'ECOG_S4', '2022-2023', 4, 'valide'), (13004, 'COMP_S4', '2022-2023', 4, 'valide'), (13004, 'SINF_S4', '2022-2023', 4, 'valide'), (13004, 'DWEB_S4', '2022-2023', 4, 'valide'),
(13004, 'ANG_S5', '2023-2024', 5, 'en_cours'), (13004, 'COMPRO_S5', '2023-2024', 5, 'en_cours'), (13004, 'ALGO_S5', '2023-2024', 5, 'en_cours'), (13004, 'MDISC_S5', '2023-2024', 5, 'en_cours'), (13004, 'ECOG_S5', '2023-2024', 5, 'en_cours'), (13004, 'COMP_S5', '2023-2024', 5, 'en_cours'), (13004, 'SINF_S5', '2023-2024', 5, 'en_cours'), (13004, 'DWEB_S5', '2023-2024', 5, 'en_cours'),
(13004, 'ANG_S6', '2023-2024', 6, 'en_cours'), (13004, 'COMPRO_S6', '2023-2024', 6, 'en_cours'), (13004, 'ALGO_S6', '2023-2024', 6, 'en_cours'), (13004, 'MDISC_S6', '2023-2024', 6, 'en_cours'), (13004, 'ECOG_S6', '2023-2024', 6, 'en_cours'), (13004, 'COMP_S6', '2023-2024', 6, 'en_cours'), (13004, 'SINF_S6', '2023-2024', 6, 'en_cours'), (13004, 'DWEB_S6', '2023-2024', 6, 'en_cours'),

-- Étudiant 13005
(13005, 'ANG_S1', '2021-2022', 1, 'valide'), (13005, 'COMPRO_S1', '2021-2022', 1, 'valide'), (13005, 'ALGO_S1', '2021-2022', 1, 'valide'), (13005, 'MDISC_S1', '2021-2022', 1, 'valide'), (13005, 'ECOG_S1', '2021-2022', 1, 'valide'), (13005, 'COMP_S1', '2021-2022', 1, 'valide'), (13005, 'SINF_S1', '2021-2022', 1, 'valide'), (13005, 'DWEB_S1', '2021-2022', 1, 'valide'),
(13005, 'ANG_S2', '2021-2022', 2, 'valide'), (13005, 'COMPRO_S2', '2021-2022', 2, 'valide'), (13005, 'ALGO_S2', '2021-2022', 2, 'valide'), (13005, 'MDISC_S2', '2021-2022', 2, 'valide'), (13005, 'ECOG_S2', '2021-2022', 2, 'valide'), (13005, 'COMP_S2', '2021-2022', 2, 'valide'), (13005, 'SINF_S2', '2021-2022', 2, 'valide'), (13005, 'DWEB_S2', '2021-2022', 2, 'valide'),
(13005, 'ANG_S3', '2022-2023', 3, 'valide'), (13005, 'COMPRO_S3', '2022-2023', 3, 'valide'), (13005, 'ALGO_S3', '2022-2023', 3, 'valide'), (13005, 'MDISC_S3', '2022-2023', 3, 'valide'), (13005, 'ECOG_S3', '2022-2023', 3, 'valide'), (13005, 'COMP_S3', '2022-2023', 3, 'valide'), (13005, 'SINF_S3', '2022-2023', 3, 'valide'), (13005, 'DWEB_S3', '2022-2023', 3, 'valide'),
(13005, 'ANG_S4', '2022-2023', 4, 'valide'), (13005, 'COMPRO_S4', '2022-2023', 4, 'valide'), (13005, 'ALGO_S4', '2022-2023', 4, 'valide'), (13005, 'MDISC_S4', '2022-2023', 4, 'valide'), (13005, 'ECOG_S4', '2022-2023', 4, 'valide'), (13005, 'COMP_S4', '2022-2023', 4, 'valide'), (13005, 'SINF_S4', '2022-2023', 4, 'valide'), (13005, 'DWEB_S4', '2022-2023', 4, 'valide'),
(13005, 'ANG_S5', '2023-2024', 5, 'en_cours'), (13005, 'COMPRO_S5', '2023-2024', 5, 'en_cours'), (13005, 'ALGO_S5', '2023-2024', 5, 'en_cours'), (13005, 'MDISC_S5', '2023-2024', 5, 'en_cours'), (13005, 'ECOG_S5', '2023-2024', 5, 'en_cours'), (13005, 'COMP_S5', '2023-2024', 5, 'en_cours'), (13005, 'SINF_S5', '2023-2024', 5, 'en_cours'), (13005, 'DWEB_S5', '2023-2024', 5, 'en_cours'),
(13005, 'ANG_S6', '2023-2024', 6, 'en_cours'), (13005, 'COMPRO_S6', '2023-2024', 6, 'en_cours'), (13005, 'ALGO_S6', '2023-2024', 6, 'en_cours'), (13005, 'MDISC_S6', '2023-2024', 6, 'en_cours'), (13005, 'ECOG_S6', '2023-2024', 6, 'en_cours'), (13005, 'COMP_S6', '2023-2024', 6, 'en_cours'), (13005, 'SINF_S6', '2023-2024', 6, 'en_cours'), (13005, 'DWEB_S6', '2023-2024', 6, 'en_cours');