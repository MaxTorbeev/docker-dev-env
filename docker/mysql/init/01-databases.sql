-- create databases
CREATE DATABASE IF NOT EXISTS `mp` CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE IF NOT EXISTS `mp_tst` CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE IF NOT EXISTS `b2b` CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE IF NOT EXISTS `b2b_tst` CHARACTER SET utf8 COLLATE utf8_general_ci;

-- create root user and grant rights
DROP USER IF EXISTS 'devtool'@'localhost';
CREATE USER 'devtool'@'localhost' IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON *.* TO 'devtool'@'localhost';
