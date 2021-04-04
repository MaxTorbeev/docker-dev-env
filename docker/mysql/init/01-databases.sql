-- create databases
CREATE DATABASE IF NOT EXISTS `mp`;
CREATE DATABASE IF NOT EXISTS `mp_tst`;
CREATE DATABASE IF NOT EXISTS `b2b`;
CREATE DATABASE IF NOT EXISTS `b2b_tst`;

-- create root user and grant rights
DROP USER IF EXISTS 'devtool'@'localhost';
CREATE USER 'devtool'@'localhost' IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON *.* TO 'devtool'@'localhost';
