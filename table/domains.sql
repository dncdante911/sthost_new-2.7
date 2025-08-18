CREATE TABLE domains (
    id INT AUTO_INCREMENT PRIMARY KEY,
    domain_name VARCHAR(253) NOT NULL UNIQUE,
    tld VARCHAR(32) NOT NULL,
    price INT NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

Додай домени через phpMyAdmin або INSERT:
INSERT INTO domains (domain_name, tld, price, description)
VALUES
('com.ua', 'com.ua', 290, 'Бізнес, компанії України'),
('ua', 'ua', 600, 'Престижна національна зона'),
('org.ua', 'org.ua', 240, 'Організації, фонди, клуби'),
('net.ua', 'net.ua', 250, 'Інтернет та IT проекти'),
('in.ua', 'in.ua', 210, 'Індивідуальні імена, персональні сайти'),
('kiev.ua', 'kiev.ua', 250, 'Локальна зона Києва'),
('lviv.ua', 'lviv.ua', 260, 'Локальна зона Львова');
