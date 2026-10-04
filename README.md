# BookMyShow - Theatre Show Listing (DB Design)

For a given theatre, the user picks one of the next 7 dates and sees every movie running that day, grouped by language/format, with each showtime tagged by the screen's experience (Dolby 7.1, 4K ATMOS, ...).

Files:
- `p1_schema_and_data.sql` - P1: tables + sample rows (MySQL 8.x, re-runnable)
- `p2_query.sql` - P2: shows on a date at a theatre

## Entities and tables

### City
| Column | Type | Notes |
|---|---|---|
| city_id | INT | PK, auto increment |
| city_name | VARCHAR(100) | |
| state_name | VARCHAR(100) | UNIQUE with city_name |

| city_id | city_name | state_name |
|---|---|---|
| 1 | Bengaluru | Karnataka |
| 2 | Hyderabad | Telangana |

### Theatre
| Column | Type | Notes |
|---|---|---|
| theatre_id | INT | PK |
| theatre_name | VARCHAR(150) | |
| address | VARCHAR(255) | |
| city_id | INT | FK -> City |

| theatre_id | theatre_name | address | city_id |
|---|---|---|---|
| 1 | PVR: Nexus (Forum) | Koramangala, Bengaluru | 1 |
| 2 | PVR: Inorbit | Madhapur, Hyderabad | 2 |

### Screen
| Column | Type | Notes |
|---|---|---|
| screen_id | INT | PK |
| theatre_id | INT | FK -> Theatre; UNIQUE with screen_name |
| screen_name | VARCHAR(50) | |
| total_seats | INT | |
| experience | VARCHAR(50) | nullable; Dolby 7.1, 4K ATMOS, ... |

| screen_id | theatre_id | screen_name | total_seats | experience |
|---|---|---|---|---|
| 2 | 1 | Screen 2 | 100 | 4K ATMOS |
| 3 | 1 | Screen 3 | 90 | Dolby 7.1 |
| 5 | 1 | Screen 5 | 60 | Rajshahi 4K |

### Movie
| Column | Type | Notes |
|---|---|---|
| movie_id | INT | PK |
| title | VARCHAR(200) | |
| duration_minutes | INT | |
| genre | VARCHAR(100) | |
| release_date | DATE | |
| certificate | VARCHAR(10) | U, UA, A |

| movie_id | title | duration_minutes | genre | release_date | certificate |
|---|---|---|---|---|---|
| 1 | Dasara | 155 | Drama | 2023-03-30 | UA |
| 2 | Kisi Ka Bhai Kisi Ki Jaan | 155 | Action | 2023-04-21 | UA |
| 4 | Avatar: The Way of Water | 192 | Sci-Fi | 2022-12-16 | UA |

### Shows
(Named `Shows` to avoid clashing with the MySQL `SHOW` keyword.)

| Column | Type | Notes |
|---|---|---|
| show_id | INT | PK |
| movie_id | INT | FK -> Movie |
| screen_id | INT | FK -> Screen |
| show_date | DATE | |
| show_time | TIME | |
| show_language | VARCHAR(50) | varies per show |
| show_format | VARCHAR(10) | 2D / 3D |

UNIQUE (screen_id, show_date, show_time): a screen cannot run two shows at the same time.

| show_id | movie_id | screen_id | show_date | show_time | show_language | show_format |
|---|---|---|---|---|---|---|
| 1 | 1 | 1 | 2026-10-10 | 12:15:00 | Telugu | 2D |
| 2 | 2 | 2 | 2026-10-10 | 13:00:00 | Hindi | 2D |
| 7 | 4 | 3 | 2026-10-10 | 13:20:00 | English | 3D |
| 9 | 4 | 2 | 2026-10-11 | 18:00:00 | English | 3D |

## Relationships

City 1-N Theatre, Theatre 1-N Screen, Screen 1-N Shows, Movie 1-N Shows.

## Normalization

- **1NF**: all columns atomic (one language, one showtime, one format per row); every table has a PK.
- **2NF**: every table has a single-column PK, so no partial dependencies.
- **3NF**: no transitive dependencies. City name lives only in `City`, movie title only in `Movie`, and `experience` only in `Screen` (putting it in `Shows` would give `show_id -> screen_id -> experience`).
- **BCNF**: every determinant is a candidate key. In `Shows` the only determinants are `show_id` and `(screen_id, show_date, show_time)`, both candidate keys; in `Screen` they are `screen_id` and `(theatre_id, screen_name)`.

## P2 query

```sql
SELECT
    m.title         AS movie,
    m.certificate,
    s.show_language AS language,
    s.show_format   AS format,
    TIME_FORMAT(s.show_time, '%h:%i %p') AS show_time,
    sc.screen_name,
    sc.experience
FROM Shows s
JOIN Screen  sc ON sc.screen_id  = s.screen_id
JOIN Theatre t  ON t.theatre_id  = sc.theatre_id
JOIN Movie   m  ON m.movie_id    = s.movie_id
WHERE t.theatre_id = 1
  AND s.show_date  = '2026-10-10'
ORDER BY m.title, s.show_language, s.show_format, s.show_time;
```

Expected result for theatre 1 on 2026-10-10: Avatar 3D 01:20 PM; Dasara 12:15 PM; Kisi Ka Bhai Kisi Ki Jaan 01:00, 04:10, 07:20, 10:10 PM; Tu Jhoothi Main Makkaar 01:15 PM.

To run:
```bash
mysql -u root -p < p1_schema_and_data.sql
mysql -u root -p < p2_query.sql
```
