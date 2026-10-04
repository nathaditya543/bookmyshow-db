-- P1: BookMyShow - theatre show listing schema + sample data (MySQL 8.x)

DROP DATABASE IF EXISTS bookmyshow;
CREATE DATABASE bookmyshow;
USE bookmyshow;

CREATE TABLE City (
    city_id    INT PRIMARY KEY AUTO_INCREMENT,
    city_name  VARCHAR(100) NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    UNIQUE (city_name, state_name)
) ENGINE=InnoDB;

CREATE TABLE Theatre (
    theatre_id   INT PRIMARY KEY AUTO_INCREMENT,
    theatre_name VARCHAR(150) NOT NULL,
    address      VARCHAR(255) NOT NULL,
    city_id      INT NOT NULL,
    FOREIGN KEY (city_id) REFERENCES City(city_id)
) ENGINE=InnoDB;

CREATE TABLE Screen (
    screen_id   INT PRIMARY KEY AUTO_INCREMENT,
    theatre_id  INT NOT NULL,
    screen_name VARCHAR(50) NOT NULL,
    total_seats INT NOT NULL,
    experience  VARCHAR(50) NULL,
    FOREIGN KEY (theatre_id) REFERENCES Theatre(theatre_id),
    UNIQUE (theatre_id, screen_name)
) ENGINE=InnoDB;

CREATE TABLE Movie (
    movie_id         INT PRIMARY KEY AUTO_INCREMENT,
    title            VARCHAR(200) NOT NULL,
    duration_minutes INT NOT NULL,
    genre            VARCHAR(100),
    release_date     DATE,
    certificate      VARCHAR(10)
) ENGINE=InnoDB;

CREATE TABLE Shows (
    show_id       INT PRIMARY KEY AUTO_INCREMENT,
    movie_id      INT NOT NULL,
    screen_id     INT NOT NULL,
    show_date     DATE NOT NULL,
    show_time     TIME NOT NULL,
    show_language VARCHAR(50) NOT NULL,
    show_format   VARCHAR(10) NOT NULL,
    FOREIGN KEY (movie_id)  REFERENCES Movie(movie_id),
    FOREIGN KEY (screen_id) REFERENCES Screen(screen_id),
    UNIQUE (screen_id, show_date, show_time)
) ENGINE=InnoDB;

-- Sample data
INSERT INTO City (city_id, city_name, state_name) VALUES
(1, 'Bengaluru', 'Karnataka'),
(2, 'Hyderabad', 'Telangana');

INSERT INTO Theatre (theatre_id, theatre_name, address, city_id) VALUES
(1, 'PVR: Nexus (Forum)', 'Koramangala, Bengaluru', 1),
(2, 'PVR: Inorbit',       'Madhapur, Hyderabad',    2);

INSERT INTO Screen (screen_id, theatre_id, screen_name, total_seats, experience) VALUES
(1, 1, 'Screen 1', 150, NULL),
(2, 1, 'Screen 2', 100, '4K ATMOS'),
(3, 1, 'Screen 3',  90, 'Dolby 7.1'),
(4, 1, 'Screen 4',  70, NULL),
(5, 1, 'Screen 5',  60, 'Rajshahi 4K'),
(6, 1, 'Screen 6', 110, 'Prashasti 4K'),
(7, 2, 'Audi 1',   120, 'Dolby 7.1');

INSERT INTO Movie (movie_id, title, duration_minutes, genre, release_date, certificate) VALUES
(1, 'Dasara',                    155, 'Drama',   '2023-03-30', 'UA'),
(2, 'Kisi Ka Bhai Kisi Ki Jaan', 155, 'Action',  '2023-04-21', 'UA'),
(3, 'Tu Jhoothi Main Makkaar',   165, 'Romance', '2023-03-08', 'UA'),
(4, 'Avatar: The Way of Water',  192, 'Sci-Fi',  '2022-12-16', 'UA');

INSERT INTO Shows (show_id, movie_id, screen_id, show_date, show_time, show_language, show_format) VALUES
-- Theatre 1, 2026-10-10
(1,  1, 1, '2026-10-10', '12:15:00', 'Telugu',  '2D'),
(2,  2, 2, '2026-10-10', '13:00:00', 'Hindi',   '2D'),
(3,  2, 3, '2026-10-10', '16:10:00', 'Hindi',   '2D'),
(4,  2, 4, '2026-10-10', '19:20:00', 'Hindi',   '2D'),
(5,  2, 5, '2026-10-10', '22:10:00', 'Hindi',   '2D'),
(6,  3, 6, '2026-10-10', '13:15:00', 'Hindi',   '2D'),
(7,  4, 3, '2026-10-10', '13:20:00', 'English', '3D'),
-- Theatre 1, 2026-10-11
(8,  1, 1, '2026-10-11', '10:30:00', 'Telugu',  '2D'),
(9,  4, 2, '2026-10-11', '18:00:00', 'English', '3D'),
-- Theatre 2, 2026-10-10
(10, 3, 7, '2026-10-10', '15:00:00', 'Hindi',   '2D');
