db:
	docker exec -it db bash
php:
	docker exec -it devtool_php bash
build:
	docker-compose up --build -d
supervisor:
	docker exec -i devtool_php sh -c '/usr/bin/supervisord'

