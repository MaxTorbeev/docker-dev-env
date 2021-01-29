USE mysql;
UPDATE user SET authentication_string=PASSWORD('secret') WHERE User='root';
FLUSH PRIVILEGES;
