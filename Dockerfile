# image MySQL
FROM mysql:8.0

# Scripts d'initialisation (s'exécutent au premier démarrage UNIQUEMENT si le data dir est vierge)
COPY init/ /docker-entrypoint-initdb.d/

# Configuration de MySQL
COPY my.cnf /etc/mysql/conf.d/my.cnf

# Expose le port MySQL
EXPOSE 3306

# Healthcheck
HEALTHCHECK --interval=10s --timeout=3s --retries=10 CMD \
  mysqladmin ping -h 127.0.0.1 -u root -p$MYSQL_ROOT_PASSWORD || exit 1