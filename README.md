# module122-mariadb-automation

![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnubash&logoColor=white)
![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=flat&logo=mariadb&logoColor=white)
![Debian](https://img.shields.io/badge/Debian-A81D33?style=flat&logo=debian&logoColor=white)

Script Bash d'installation et de sécurisation automatique de MariaDB sur Debian/Ubuntu Server.

---

## Contexte professionnel

Dans le cadre du module M122, ce projet simule une situation réelle : un service systèmes doit préparer plusieurs serveurs Linux pour héberger des applications internes. Installer et sécuriser MariaDB manuellement sur chaque serveur est long et source d'oublis. Ce script automatise entièrement le processus sans aucune intervention manuelle.

---

## Objectif du script

Le script `install_mariadb.sh` réalise automatiquement les opérations suivantes :

- Mise à jour de la liste des paquets
- Installation de MariaDB Server (si non déjà installé)
- Activation et démarrage du service MariaDB
- Sécurisation de base (mot de passe root, suppression des anonymes, désactivation de l'accès root distant, suppression de la base de test)
- Création d'une base de données
- Création d'un utilisateur MariaDB dédié avec ses droits
- Journalisation de toutes les opérations dans un fichier de log

---

## Paramètres

| Paramètre | Description                        | Exemple               |
|-----------|------------------------------------|-----------------------|
| `$1`      | Mot de passe root MariaDB          | `Root123!`            |
| `$2`      | Nom de la base de données          | `app_interne`         |
| `$3`      | Nom de l'utilisateur MariaDB       | `app_user`            |
| `$4`      | Mot de passe de l'utilisateur      | `User123!`            |
| `$5`      | Nom du fichier de log (`.log`)     | `install_mariadb.log` |

---

## Exemple d'exécution

```bash
sudo ./install_mariadb.sh "Root123!" "app_interne" "app_user" "User123!" "install_mariadb.log"
```

> [!IMPORTANT]
> Le script doit être lancé en tant que root (`sudo`). Le fichier de log doit obligatoirement avoir l'extension `.log`.

---

## Structure du dépôt

```
module122-mariadb-automation/
├── README.md
├── install_mariadb.sh
├── rapport.md
├── rapport.pdf
├── logs/
│   └── install_mariadb.log
└── captures/
    └── preuves_tests.png
```

---

## Fichier de log

Le fichier de log est automatiquement créé dans le dossier `logs/` au lancement du script. Il contient :

- Les opérations réussies avec le préfixe `[OK]`
- Les erreurs éventuelles avec le préfixe `[ERREUR]`
- Un horodatage de début et de fin d'exécution

Exemple :
```
=== Début installation MariaDB jeu 18 jun 2026 15:30:42 CEST ===
[OK]     Le dossier 'logs/' a été créé avec succès
[OK]     Mise à jour des paquets effectuée avec succès
[OK]     Installation de MariaDB effectuée avec succès
...
=== Fin installation MariaDB jeu 18 jun 2026 15:31:05 CEST ===
```

---

## Tests

Avant de remettre le projet, les tests suivants ont été effectués :

| Test | Résultat |
|------|----------|
| Lancement sans paramètres | Message d'usage affiché, script arrêté |
| Lancement avec paramètres corrects | Installation complète réussie |
| MariaDB déjà installé | Étape ignorée, script continue |
| Vérification service MariaDB | `systemctl status mariadb` actif |
| Vérification base de données | Présente dans MariaDB |
| Vérification utilisateur | Présent avec les bons droits |
| Lecture du fichier log | Toutes les étapes journalisées |

---

## Auteur

**Romain Perez** — Apprenti informaticien, CFC Informatique  
Module M122 — Scripting Bash
