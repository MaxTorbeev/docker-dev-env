## Start 
- open --background -a Docker
- docker-compose up -d
## Mysql restore from dump
- docker exec -i maxtor_mysql_1 sh -c 'exec mysql -u root -p"$MYSQL_ROOT_PASSWORD"  mp' < marketplace_beta.sql 
## Remove all proccesses
!! Warning
- docker stop $(docker ps -a -q) - stop processes
- docker rm $(docker ps -a -q)
# clean docker system
- docker system prune -a
# Inspect processes 
- docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq)