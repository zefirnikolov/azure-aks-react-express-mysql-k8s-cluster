CREATE DATABASE IF NOT EXISTS mydb;
GRANT ALL PRIVILEGES ON mydb.* TO 'cash100m'@'%';
FLUSH PRIVILEGES;

USE mydb;

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(5, 2) NOT NULL
);

INSERT INTO products (name, price) VALUES ('apples-green', 5.15);
INSERT INTO products (name, price) VALUES ('apples-red', 5.36);
INSERT INTO products (name, price) VALUES ('lemons-yellow', 2.51);
INSERT INTO products (name, price) VALUES ('lemons-limes', 7.59);
INSERT INTO products (name, price) VALUES ('cherries-first-class', 9.99);
INSERT INTO products (name, price) VALUES ('carrots-purple', 2.56);
INSERT INTO products (name, price) VALUES ('carrots-orange', 1.36);
INSERT INTO products (name, price) VALUES ('lettuce-top-quality', 4.99);
INSERT INTO products (name, price) VALUES ('potatoes', 1.50);
INSERT INTO products (name, price) VALUES ('potatoes-sweet', 3.44);
INSERT INTO products (name, price) VALUES ('chicken-roasted', 15.15);
INSERT INTO products (name, price) VALUES ('chicken-cool', 7.42);
INSERT INTO products (name, price) VALUES ('beef-roasted-steak-cut', 12.53);
INSERT INTO products (name, price) VALUES ('beef-steak', 14.58);
INSERT INTO products (name, price) VALUES ('chocolate-with-nuts', 2.59);
INSERT INTO products (name, price) VALUES ('chocolate-white', 2.99);
INSERT INTO products (name, price) VALUES ('candy-gummy-bears', 4.54);
INSERT INTO products (name, price) VALUES ('candy-bonbons', 4.54);
INSERT INTO products (name, price) VALUES ('ice-cream-cone', 1.99);
INSERT INTO products (name, price) VALUES ('ice-cream-stick', 1.99);
INSERT INTO products (name, price) VALUES ('alcoholic-whiskey', 63.44);
INSERT INTO products (name, price) VALUES ('alcoholic-wine', 15.15);
INSERT INTO products (name, price) VALUES ('alcohol-free-spring-water', 1.42);
INSERT INTO products (name, price) VALUES ('alcohol-free-juice', 2.57);
INSERT INTO products (name, price) VALUES ('t-shirts-orange', 22.89);
