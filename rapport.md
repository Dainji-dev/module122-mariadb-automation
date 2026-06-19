# Table des matières

- [[#1. Introduction|Introduction]]
- [[#2. S'informer|S'informer]]
- [[#3. Planifier|Planifier]]
- [[#4. Décider|Décider]]
- [[#5. Réaliser|Réaliser]]
- [[#6. Contrôler|Contrôler]]
- [[#7. Évaluer|Évaluer]]
- [[#8. Conclusion|Conclusion]]

---

# 1. Introduction

Ce document présente la réalisation d'un script Bash permettant d'automatiser l'installation, la configuration et la sécurisation de MariaDB sur un système Debian. Le script prend en charge l'ensemble du processus sans aucune intervention manuelle : mise à jour des paquets, installation du service, sécurisation de la base de données, création d'un utilisateur dédié avec ses droits, et journalisation complète des opérations.

Le rapport suit la méthode des 6 étapes :

- S'informer — analyse du mandat et recherche des informations nécessaires
- Planifier — définition des étapes et des livrables
- Décider — justification des choix techniques
- Réaliser — développement du script et documentation
- Contrôler — tests et validation
- Évaluer — retour d'expérience

---

# 2. S'informer

## 2.1 Cahier des charges

### 📋 Cahier des charges

### 1. Environnement de travail

Le script doit être réalisé sur une **machine virtuelle Linux VMware**.

Distribution attendue :

Ubuntu Server ou Debian

Le script doit être écrit en :

Bash

Nom du script :

install_mariadb.sh

---

### 2. Fonction principale du script

Le script doit automatiquement :

1. Mettre à jour la liste des paquets.
    
2. Installer MariaDB Server.
    
3. Démarrer le service MariaDB.
    
4. Activer MariaDB au démarrage du système.
    
5. Sécuriser MariaDB.
    
6. Créer une base de données.
    
7. Créer un utilisateur MariaDB.
    
8. Donner les droits nécessaires à cet utilisateur.
    
9. Écrire toutes les opérations dans un fichier de log.
    
10. Publier le projet dans un dépôt GitHub.
    

---

### 3. Contraintes importantes

Le script doit être **entièrement automatisé**.

Cela signifie :

- aucune question posée pendant l'exécution ;
    
- aucune saisie clavier demandée à l'utilisateur ;
    
- toutes les informations nécessaires doivent être passées en **arguments du script**


---

### 4. Paramètres obligatoires

Ton script doit recevoir les paramètres suivants :

|Paramètre|Description|Exemple|
|---|---|---|
|`$1`|Mot de passe root MariaDB|`Root123!`|
|`$2`|Nom de la base de données à créer|`app_interne`|
|`$3`|Nom de l'utilisateur MariaDB|`app_user`|
|`$4`|Mot de passe de l'utilisateur MariaDB|`User123!`|
|`$5`|Nom du fichier de log|`install_mariadb.log`|

### 5. Exemple de lancement attendu

sudo ./install_mariadb.sh "Root123!" "app_interne" "app_user" "User123!" "install_mariadb.log"

---

### 6. Sécurisation attendue

Ton script doit appliquer au minimum les mesures suivantes :

- définir ou modifier le mot de passe root MariaDB ;
    
- supprimer les utilisateurs anonymes ;
    
- interdire la connexion root à distance ;
    
- supprimer la base de test ;
    
- recharger les privilèges MariaDB.
    

---

### 7. Création de la base de données

Le script doit :

- créer la base de données passée en paramètre ;
    
- créer l'utilisateur passé en paramètre ;
    
- attribuer les droits nécessaires à cet utilisateur sur cette base ;
    
- recharger les privilèges.
    

---

### 8. Gestion du fichier log

Le fichier log doit contenir :

- les opérations réussies avec `>>` ;
    
- les erreurs éventuelles avec `2>>`.
    

Exemple attendu :

echo "Installation de MariaDB réussie" >> "$LOG"

apt install mariadb-server -y 2>> "$LOG"

Le log doit permettre de comprendre ce qui s'est passé pendant l'exécution.

---

### 9. Tests obligatoires

Avant de remettre ton projet, tu dois tester :

- lancement du script sans paramètres ;
    
- lancement avec des paramètres corrects ;
    
- vérification que MariaDB est installé ;
    
- vérification que le service MariaDB fonctionne ;
    
- vérification que la base de données existe ;
    
- vérification que l'utilisateur existe ;
    
- lecture du fichier log.
    

---

### 10. Dépôt GitHub

Tu dois créer un **nouveau dépôt GitHub** dans ton compte.

Nom proposé :

module122-mariadb-automation

Le dépôt doit contenir :

module122-mariadb-automation/
├── README.md
├── install_mariadb.sh
├── rapport.md
├── logs/
│ └── install_mariadb.log
└── captures/
```
└── preuves_tests.png
```

---

### 11. README.md attendu

Ton fichier `README.md` doit contenir :

- titre du projet ;
    
- contexte professionnel ;
    
- objectif du script ;
    
- liste des paramètres ;
    
- exemple d'exécution ;
    
- description des actions réalisées ;
    
- emplacement du fichier log ;
    
- procédure de test ;
    
- auteur.
    

### 📦 Livrables à remettre

- Lien du dépôt GitHub
    
- `install_mariadb.sh`
    
- `README.md`
    
- `rapport.md`
    
- fichier log
    
- capture ou preuve des tests
    

---

### ✅ Critères de réussite

Ton travail est réussi si :

- le script s'exécute sans intervention manuelle ;
    
- MariaDB est installé ;
    
- MariaDB est sécurisé ;
    
- la base de données est créée ;
    
- l'utilisateur MariaDB est créé ;
    
- les droits sont attribués ;
    
- le fichier log contient les réussites et les erreurs ;
    
- le dépôt GitHub est complet et organisé ;
    
- le rapport suit les 6 étapes.
    

---

## 2.2 Analyse du besoin

L'automatisation de cette tâche permet :

- de gagner du temps lors de la préparation de nouveaux serveurs, en évitant de répéter manuellement les mêmes opérations ;
- de réduire les risques d'oubli de configuration, notamment pour les étapes de sécurisation ;
- d'assurer une installation identique et reproductible sur chaque serveur ;
- de conserver une trace complète des opérations grâce à la journalisation.

## 2.3 Recherches effectuées

Pour réaliser ce script, les éléments suivants ont nécessité des recherches :

**Le heredoc `<<EOF`** — cette syntaxe Bash permet d'envoyer plusieurs lignes de texte à une commande, ici à `mysql`, sans interaction manuelle.

**La sécurisation de MariaDB sans `mysql_secure_installation`** — la commande habituelle `mysql_secure_installation` est interactive et ne peut pas être utilisée dans un script automatisé. Il a fallu rechercher les équivalents SQL permettant d'appliquer les mêmes mesures de sécurité directement via des requêtes.

---

# 3. Planifier

## 3.1 Description de l'algorithme en français

Le script suit les étapes suivantes :

1. Vérifier que le script est lancé en tant que root.
2. Vérifier que les 5 paramètres obligatoires ont été fournis.
3. Vérifier que le fichier de log a bien l'extension `.log`.
4. Créer le dossier `logs/` si nécessaire.
5. Mettre à jour la liste des paquets.
6. Vérifier si MariaDB est déjà installé — si non, l'installer.
7. Activer le démarrage automatique de MariaDB.
8. Démarrer le service MariaDB.
9. Appliquer la sécurisation : mot de passe root, suppression des anonymes, désactivation de l'accès distant, suppression de la base de test.
10. Créer la base de données passée en paramètre.
11. Créer l'utilisateur passé en paramètre.
12. Attribuer les droits à cet utilisateur sur la base de données.
13. Enregistrer toutes les opérations dans le fichier de log.

## 3.2 Éléments à produire

Pour réaliser cette activité, les éléments suivants doivent être créés :

- Le lien du GitHub
- Le script `install_mariadb.sh`
- Un `README.md`
- Un `rapport.md`
- Les fichiers logs
- Des captures ou preuves des tests

---

# 4. Décider

## 4.1 Choix techniques

**Langage Bash** — le cahier des charges impose Bash, et c'est le langage adapté pour l'administration système sur Linux. Il permet d'interagir directement avec les commandes système sans dépendance supplémentaire.

**Passage par paramètres plutôt qu'interaction utilisateur** — le cahier des charges exige un script entièrement automatisé. Il a donc été décidé de passer toutes les informations nécessaires en arguments du script, ce qui permet également de l'intégrer dans des pipelines d'automatisation sans modification.

**Journalisation dans un fichier `.log`** — chaque opération réussie ou échouée est enregistrée dans un fichier de log. Cela permet de diagnostiquer rapidement un problème en cas d'échec, sans avoir à relancer le script.

**Vérification de MariaDB avant installation** — plutôt que d'installer MariaDB à l'aveugle, le script vérifie d'abord si la commande `mariadb` est disponible. Si c'est le cas, l'étape est ignorée et l'utilisateur en est informé, ce qui rend le script réutilisable sans risque d'erreur.

**Publication sur GitHub** — le dépôt GitHub permet de versionner le projet, de le partager facilement et de conserver un historique des modifications.

## 4.2 Structure du dépôt GitHub

```text
module122-mariadb-automation/
├── README.md
├── install_mariadb.sh
├── rapport.md
├── logs/
│   └── install_mariadb.log
└── captures/
    └── preuves_tests.png
```

---

# 5. Réaliser

## 5.1 Script Bash

```bash
#!/bin/bash

# =============================================================================

# Nom du script : install_mariadb.sh

# Description : Script d'installation et de sécurisation automatique de MariaDB permettant de

# choisir un mot de passe root, le nom de la base de donnée, le nom d'utilisateur

# ainsi que son mot de passe. Le script doit être lancé en mode super utilisateur.

# Auteur : Romain Perez

# Date : 18.06.2026

# Utilisation : ./install_mariadb.sh [MDP_ROOT] [DB_NOM] [NOM_UTILISATEUR] [MDP_UTILISATEUR] [NOM_FICHIER_LOG]

# =============================================================================

  
  

ROOT_PASSWD="$1"

DB_NAME="$2"

DB_USERNAME="$3"

USER_PASSWD="$4"

LOG="logs/$5"

  
  

# Vérifier que le script soit lancé en tant que root

if [ "$UID" -ne 0 ]; then

echo "Ce script doit être exécuté en tant que root."

exit 1

fi

  
  

# Vérification des paramètres

if [ $# -ne 5 ]; then

echo "Utilisation : sudo ./install_mariadb.sh <MDP_ROOT> <DB_NOM> <NOM_UTILISATEUR> <MDP_UTILISATEUR> <NOM_FICHIER_LOG.log>"

exit 1

fi

  
  

# Vérifier que le fichier log ait bien l'extension .log

if [[ "$LOG" != *.log ]]; then

echo "Le fichier '$LOG' doit avoir l'extension .log"

exit 1

fi

  
  

# Création du dossier logs

echo "Création du dossier de logs..."

mkdir -p logs

if [ $? -ne 0 ]; then

echo "[ERREUR] Le dossier 'logs/' n'a pas pu être créé"

exit 1

fi

  
  

# Début du script

echo "=== Début installation MariaDB $(date) ===" >> "$LOG"

echo "[OK] Le dossier 'logs/' a été créé avec succès" >> "$LOG"

  
  

# Mettre les paquets à jour

echo "Mise à jour des paquets en cours..."

apt update -y >> "$LOG" 2>> "$LOG"

if [ $? -ne 0 ]; then

echo "[ERREUR] Mise à jour des paquets a échoué" >> "$LOG"

echo "ERREUR : Mise à jour des paquets a échoué. Consultez $LOG pour les détails."

exit 1

fi

echo "[OK] Mise à jour des paquets effectuée avec succès" >> "$LOG"

echo "Mise à jour des paquets effectuée avec succès."

  
  

# Vérifier si MariaDB est déjà installé, si non : l'installer

if command -v mariadb > /dev/null 2>&1; then

VERSION=$(mariadb --version)

echo "MariaDB déjà installé : $VERSION"

echo "[OK] MariaDB déjà installé : $VERSION" >> "$LOG"

else

echo "Installation de MariaDB en cours..."

apt install mariadb-server -y >> "$LOG" 2>> "$LOG"

if [ $? -ne 0 ]; then

echo "[ERREUR] Installation de MariaDB a échoué" >> "$LOG"

echo "ERREUR : Installation de MariaDB a échoué. Consultez $LOG pour les détails."

exit 1

fi

echo "[OK] Installation de MariaDB effectuée avec succès" >> "$LOG"

echo "Installation de MariaDB effectuée avec succès."

fi

  
  

# Activer le démarrage automatique de MariaDB

echo "Activation du démarrage automatique de MariaDB..."

systemctl enable mariadb >> "$LOG" 2>> "$LOG"

if [ $? -ne 0 ]; then

echo "[ERREUR] Activation du démarrage automatique de MariaDB a échoué" >> "$LOG"

echo "ERREUR : Activation du démarrage automatique de MariaDB a échoué. Consultez $LOG pour les détails."

exit 1

fi

echo "[OK] Démarrage automatique de MariaDB activé avec succès" >> "$LOG"

echo "Démarrage automatique de MariaDB activé avec succès."

  
  

# Démarrer MariaDB

echo "Démarrage du service MariaDB..."

systemctl start mariadb >> "$LOG" 2>> "$LOG"

if [ $? -ne 0 ]; then

echo "[ERREUR] Démarrage du service MariaDB a échoué" >> "$LOG"

echo "ERREUR : Démarrage du service MariaDB a échoué. Consultez $LOG pour les détails."

exit 1

fi

echo "[OK] Service MariaDB démarré avec succès" >> "$LOG"

echo "Service MariaDB démarré avec succès."

  
  

# Sécurisation de la base de données :

# Changement du mot de passe root

# Supprimer les utilisateurs anonymes

# Interdire la connexion root à distance

# Supprimer la base de test

# Recharger les privilèges MariaDB

echo "Sécurisation de MariaDB en cours..."

mysql -u root <<EOF >> "$LOG" 2>> "$LOG"

ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASSWD';

DELETE FROM mysql.user WHERE User='';

DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost');

DROP DATABASE IF EXISTS test;

DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

FLUSH PRIVILEGES;

EOF

if [ $? -ne 0 ]; then

echo "[ERREUR] Sécurisation de MariaDB a échoué" >> "$LOG"

echo "ERREUR : Sécurisation de MariaDB a échoué. Consultez $LOG pour les détails."

exit 1

fi

echo "[OK] Sécurisation de MariaDB effectuée avec succès" >> "$LOG"

echo "Sécurisation de MariaDB effectuée avec succès."

  
  

# Création de la base de données

echo "Création de la base de données '$DB_NAME' en cours..."

mysql -u root -p"$ROOT_PASSWD" <<EOF >> "$LOG" 2>> "$LOG"

CREATE DATABASE IF NOT EXISTS $DB_NAME;

EOF

if [ $? -ne 0 ]; then

echo "[ERREUR] Création de la base de données '$DB_NAME' a échoué" >> "$LOG"

echo "ERREUR : Création de la base de données '$DB_NAME' a échoué. Consultez $LOG pour les détails."

exit 1

fi

echo "[OK] Base de données '$DB_NAME' créée avec succès" >> "$LOG"

echo "Base de données '$DB_NAME' créée avec succès."

  
  

# Créer l'utilisateur

echo "Création de l'utilisateur '$DB_USERNAME' en cours..."

mysql -u root -p"$ROOT_PASSWD" <<EOF >> "$LOG" 2>> "$LOG"

CREATE USER IF NOT EXISTS '$DB_USERNAME'@'localhost' IDENTIFIED BY '$USER_PASSWD';

EOF

if [ $? -ne 0 ]; then

echo "[ERREUR] Création de l'utilisateur '$DB_USERNAME' a échoué" >> "$LOG"

echo "ERREUR : Création de l'utilisateur '$DB_USERNAME' a échoué. Consultez $LOG pour les détails."

exit 1

fi

echo "[OK] Utilisateur '$DB_USERNAME' créé avec succès" >> "$LOG"

echo "Utilisateur '$DB_USERNAME' créé avec succès."

  
  

# Attribuer les droits nécessaires à l'utilisateur et recharger les privilèges

echo "Attribution des droits à '$DB_USERNAME' sur '$DB_NAME' en cours..."

mysql -u root -p"$ROOT_PASSWD" <<EOF >> "$LOG" 2>> "$LOG"

GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USERNAME'@'localhost';

FLUSH PRIVILEGES;

EOF

if [ $? -ne 0 ]; then

echo "[ERREUR] Attribution des droits à '$DB_USERNAME' a échoué" >> "$LOG"

echo "ERREUR : Attribution des droits à '$DB_USERNAME' a échoué. Consultez $LOG pour les détails."

exit 1

fi

echo "[OK] Droits attribués à '$DB_USERNAME' sur '$DB_NAME' avec succès" >> "$LOG"

echo "Droits attribués à '$DB_USERNAME' sur '$DB_NAME' avec succès."

  
  

# Message de fin du script

echo "=== Fin installation MariaDB $(date) ===" >> "$LOG"

echo "Installation terminée. Consultez $LOG pour les détails."
```

## 5.2 Journalisation

### Exemple d'un fichier log sans erreur

```txt
=== Début installation MariaDB jeu 18 jun 2026 15:32:54 CEST ===
[OK]     Le dossier 'logs/' a été créé avec succès

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Atteint : 1 http://deb.debian.org/debian trixie InRelease
Atteint : 2 http://security.debian.org/debian-security trixie-security InRelease
Atteint : 3 http://deb.debian.org/debian trixie-updates InRelease
Lecture des listes de paquets…
Construction de l'arbre des dépendances…
Lecture des informations d'état…
Tous les paquets sont à jour.
[OK]     Mise à jour des paquets effectuée avec succès

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Lecture des listes de paquets…
[...]
[OK]     Installation de MariaDB effectuée avec succès
Synchronizing state of mariadb.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install enable mariadb
[OK]     Démarrage automatique de MariaDB activé avec succès
[OK]     Service MariaDB démarré avec succès
[OK]     Sécurisation de MariaDB effectuée avec succès
[OK]     Base de données 'app_interne' créée avec succès
[OK]     Utilisateur 'app_user' créé avec succès
[OK]     Droits attribués à 'app_user' sur 'app_interne' avec succès
=== Fin installation MariaDB jeu 18 jun 2026 15:33:13 CEST ===
```

---

# 6. Contrôler

## 6.1 Cas de test réalisés

### Test 1 : Lancement sans paramètres

Résultat attendu :

- Message d'utilisation affiché, le script s'arrête

Résultat obtenu :

```bash
romain@debian ~/Bureau [1]> sudo ./install_mariadb.sh
[sudo] Mot de passe de romain : 
Utilisation : sudo ./install_mariadb.sh <MDP_ROOT> <DB_NOM> <NOM_UTILISATEUR> <MDP_UTILISATEUR> <NOM_FICHIER_LOG.log>
```

---

### Test 2 : Lancement sans droits root

Résultat attendu :

- Le script ne doit pas s'exécuter

Résultat obtenu :

```bash
romain@debian ~/Bureau> ./install_mariadb.sh Root123! app_interne app_user User123! install_mariadb.log
Ce script doit être exécuté en tant que root.
romain@debian ~/Bureau [1]> 
```

---

### Test 3 : Échec d'installation MariaDB

Résultat attendu :

- Échec d'installation de MariaDB, le script ne doit pas continuer

Résultat obtenu :

```bash
root@debian ~/Bureau# ./install_mariadb.sh Root123! app_interne app_user User123! install_mariadb.log
Création du dossier de logs...
Mise à jour des paquets en cours...
Mise à jour des paquets effectuée avec succès.
Installation de MariaDB en cours...
ERREUR : Installation de MariaDB a échoué. Consultez logs/install_mariadb.log pour les détails.
```

---

### Test 4 : Lancement avec paramètres corrects

Résultat attendu :

- Exécution complète du script sans erreur

Résultat obtenu :

```bash
root@debian ~/Bureau# ./install_mariadb.sh Root123! app_interne app_user User123! install_mariadb.log
Création du dossier de logs...
Mise à jour des paquets en cours...
Mise à jour des paquets effectuée avec succès.
Installation de MariaDB en cours...
Installation de MariaDB effectuée avec succès.
Activation du démarrage automatique de MariaDB...
Démarrage automatique de MariaDB activé avec succès.
Démarrage du service MariaDB...
Service MariaDB démarré avec succès.
Sécurisation de MariaDB en cours...
Sécurisation de MariaDB effectuée avec succès.
Création de la base de données 'app_interne' en cours...
Base de données 'app_interne' créée avec succès.
Création de l'utilisateur 'app_user' en cours...
Utilisateur 'app_user' créé avec succès.
Attribution des droits à 'app_user' sur 'app_interne' en cours...
Droits attribués à 'app_user' sur 'app_interne' avec succès.
Installation terminée. Consultez logs/install_mariadb.log pour les détails.
root@debian ~/Bureau# 
```

---

### Test 5 : Vérification que MariaDB est installé

Résultat attendu :

- La version de MariaDB s'affiche

Résultat obtenu :

```bash
MariaDB déjà installé : mariadb from 11.8.6-MariaDB, client 15.2 for debian-linux-gnu (x86_64) using  EditLine wrapper
```

---

### Test 6 : Vérification que le service MariaDB fonctionne

Résultat attendu :

- Le service est actif (`active (running)`)

Résultat obtenu :

```bash
Executing: /usr/lib/systemd/systemd-sysv-install enable mariadb
[OK]     Démarrage automatique de MariaDB activé avec succès
[OK]     Service MariaDB démarré avec succès
```

---

### Test 7 : Vérification que la base de données existe

Résultat attendu :

- `app_interne` apparaît dans la liste des bases

Résultat obtenu :

```bash
root@debian:~# mysql -u root -p -e "SHOW DATABASES;"
Enter password: 
+--------------------+
| Database           |
+--------------------+
| app_interne        |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
root@debian:~# 
```

---

### Test 8 : Vérification que l'utilisateur existe

Résultat attendu :

- `app_user` apparaît dans la liste des utilisateurs

Résultat obtenu :

```bash
root@debian:~# mysql -u root -p -e "SELECT User FROM mysql.user;"
Enter password: 
+-------------+
| User        |
+-------------+
| app_user    |
| mariadb.sys |
| mysql       |
| root        |
+-------------+
root@debian:~# 
```

---

## 6.2 Exemple de fichier log

```txt
=== Début installation MariaDB jeu 18 jun 2026 15:32:54 CEST ===
[OK]     Le dossier 'logs/' a été créé avec succès

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Atteint : 1 http://deb.debian.org/debian trixie InRelease
Atteint : 2 http://security.debian.org/debian-security trixie-security InRelease
Atteint : 3 http://deb.debian.org/debian trixie-updates InRelease
Lecture des listes de paquets…
Construction de l'arbre des dépendances…
Lecture des informations d'état…
Tous les paquets sont à jour.
[OK]     Mise à jour des paquets effectuée avec succès

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Lecture des listes de paquets…
Construction de l'arbre des dépendances…
Lecture des informations d'état…
Installation de :
  mariadb-server

Installation de dépendances : 
  galera-4                 mariadb-common
  libaio1t64               mariadb-plugin-provider-bzip2
  libconfig-inifiles-perl  mariadb-plugin-provider-lz4
  libdbd-mariadb-perl      mariadb-plugin-provider-lzma
  libdbi-perl              mariadb-plugin-provider-lzo
  libhtml-template-perl    mariadb-plugin-provider-snappy
  libmariadb3              mariadb-server-core
  libpcre2-posix3          mysql-common
  mariadb-client           pv
  mariadb-client-core      socat

Paquets suggérés :
  libnet-daemon-perl     libipc-sharedcache-perl  mariadb-test    doc-base
  libsql-statement-perl  mailx                    netcat-openbsd

Préconfiguration des paquets...
Sommaire :
  Mise à niveau de : 0. Installation de : 21Supprimé : 0. Non mis à jour : 0
Taille du téléchargement : 0 B / 18.9 MB
  Espace nécessaire : 196 MB / 13.1 GB disponible

[...]
[OK]     Installation de MariaDB effectuée avec succès
Synchronizing state of mariadb.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install enable mariadb
[OK]     Démarrage automatique de MariaDB activé avec succès
[OK]     Service MariaDB démarré avec succès
[OK]     Sécurisation de MariaDB effectuée avec succès
[OK]     Base de données 'app_interne' créée avec succès
[OK]     Utilisateur 'app_user' créé avec succès
[OK]     Droits attribués à 'app_user' sur 'app_interne' avec succès
=== Fin installation MariaDB jeu 18 jun 2026 15:33:13 CEST ===
```

---

# 7. Évaluer

Cette activité m'a permis de mettre en pratique l'automatisation de tâches d'administration système réelles avec Bash. La contrainte d'automatisation complète à obligé à trouver des alternatives aux outils interactifs habituels comme `mysql_secure_installation`.

Les points qui ont été faciles :

- La gestion des variables et des paramètres `$1`, `$2`... qui étaient déjà bien maîtrisés.
- La structure générale du script et l'enchaînement des étapes.

Les principales difficultés rencontrées :

- Le heredoc `<<EOF` pour envoyer des commandes SQL à MariaDB sans interaction manuelle. Cette syntaxe n'était pas connue et a nécessité des recherches et plusieurs essais avant de fonctionner correctement.
- Lors du premier test, la réinstallation de MariaDB a échoué à cause de fichiers de configuration résiduels laissés par la désinstallation. Il a fallu nettoyer manuellement les dossiers `/etc/mysql` et `/var/lib/mysql` avant de pouvoir relancer le script.

Des améliorations pourraient être apportées :

- Ajouter une vérification que les paramètres données n'existent pas déjà dans une base de données existante.
- Gérer le cas où MariaDB est installé mais où le mot de passe root est déjà défini — les commandes SQL actuelles échoueraient dans ce cas.
- Permettre de passer plusieurs bases de données et utilisateurs en paramètres pour une installation plus flexible.

---

# 8. Conclusion

Le script développé répond à l'ensemble des exigences du cahier des charges. Il installe, configure et sécurise MariaDB de manière entièrement automatisée, sans aucune intervention manuelle, et journalise chaque opération dans un fichier de log structuré.

L'utilisation de paramètres à la place d'une interaction utilisateur rend le script réutilisable sur n'importe quel serveur Debian sans modification du code. La gestion d'erreur sur chaque étape garantit que le script s'arrête immédiatement en cas de problème, avec un message clair pour l'utilisateur et une trace dans le log.

Ce projet a permis de découvrir des techniques Bash avancées comme le heredoc, de comprendre le fonctionnement interne de la sécurisation de MariaDB, et de mettre en place une approche professionnelle de la journalisation et de la gestion d'erreurs.