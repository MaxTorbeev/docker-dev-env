## Start

- open --background -a Docker
- docker-compose up -d

## Mysql restore from dump

- docker exec -i devtool_mysql sh -c 'exec mysql -u root -p"$MYSQL_ROOT_PASSWORD"  mp' < marketplace_beta.sql

## Remove all proccesses

!! Warning

- docker stop $(docker ps -a -q) - stop processes && docker rm $(docker ps -a -q)
- docker rm $(docker ps -a -q)

# clean docker system

- docker system prune -a

# Inspect processes

- docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq)

# Ssl generate

- openssl req -x509 -out talgic.docker.crt -keyout talgic.docker.key -newkey rsa:2048 -nodes -sha256 -subj '
  /CN=talgic.docker' -extensions EXT -config <( printf "[dn]\nCN=talgic.docker\n[req]\ndistinguished_name = dn\n[EXT]
  \nsubjectAltName=DNS:talgic.docker\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
