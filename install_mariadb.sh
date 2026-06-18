#!/bin/bash
# =============================================================================
# Nom du script : install_mariadb.sh
# Description   : Script d'installation et de sécurisation automatique de MariaDB permettant de
#                 choisir un mot de passe root, le nom de la base de donnée, le nom d'utilisateur
#                 ainsi que son mot de passe. Le script doit être lancé en mode super utilisateur.
# Auteur        : Romain Perez
# Date          : 18.06.2026
# Utilisation   : ./install_mariadb.sh [MDP_ROOT] [DB_NOM] [NOM_UTILISATEUR] [MDP_UTILISATEUR] [NOM_FICHIER_LOG]
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
echo "[OK]     Le dossier 'logs/' a été créé avec succès" >> "$LOG"


# Mettre les paquets à jour
echo "Mise à jour des paquets en cours..."
apt update -y >> "$LOG" 2>> "$LOG"
if [ $? -ne 0 ]; then
    echo "[ERREUR] Mise à jour des paquets a échoué" >> "$LOG"
    echo "ERREUR : Mise à jour des paquets a échoué. Consultez $LOG pour les détails."
    exit 1
fi
echo "[OK]     Mise à jour des paquets effectuée avec succès" >> "$LOG"
echo "Mise à jour des paquets effectuée avec succès."


# Vérifier si MariaDB est déjà installé, si non : l'installer
if command -v mariadb > /dev/null 2>&1; then
    echo "MariaDB est déjà installé, passage à l'étape suivante."
    echo "[OK]     MariaDB déjà installé, installation ignorée" >> "$LOG"
else
    echo "Installation de MariaDB en cours..."
    apt install mariadb-server -y >> "$LOG" 2>> "$LOG"
    if [ $? -ne 0 ]; then
        echo "[ERREUR] Installation de MariaDB a échoué" >> "$LOG"
        echo "ERREUR : Installation de MariaDB a échoué. Consultez $LOG pour les détails."
        exit 1
    fi
    echo "[OK]     Installation de MariaDB effectuée avec succès" >> "$LOG"
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
echo "[OK]     Démarrage automatique de MariaDB activé avec succès" >> "$LOG"
echo "Démarrage automatique de MariaDB activé avec succès."


# Démarrer MariaDB
echo "Démarrage du service MariaDB..."
systemctl start mariadb >> "$LOG" 2>> "$LOG"
if [ $? -ne 0 ]; then
    echo "[ERREUR] Démarrage du service MariaDB a échoué" >> "$LOG"
    echo "ERREUR : Démarrage du service MariaDB a échoué. Consultez $LOG pour les détails."
    exit 1
fi
echo "[OK]     Service MariaDB démarré avec succès" >> "$LOG"
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
echo "[OK]     Sécurisation de MariaDB effectuée avec succès" >> "$LOG"
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
echo "[OK]     Base de données '$DB_NAME' créée avec succès" >> "$LOG"
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
echo "[OK]     Utilisateur '$DB_USERNAME' créé avec succès" >> "$LOG"
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
echo "[OK]     Droits attribués à '$DB_USERNAME' sur '$DB_NAME' avec succès" >> "$LOG"
echo "Droits attribués à '$DB_USERNAME' sur '$DB_NAME' avec succès."


# Message de fin du script
echo "=== Fin installation MariaDB $(date) ===" >> "$LOG"
echo "Installation terminée. Consultez $LOG pour les détails."