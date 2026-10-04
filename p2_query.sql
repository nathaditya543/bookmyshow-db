-- P2: all shows on a given date at a given theatre, with show timings
-- Run p1_schema_and_data.sql first.

USE bookmyshow;

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
