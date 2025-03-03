SELECT cn.country_code, COUNT(DISTINCT t.id) AS total_movies, ROUND(AVG(t.production_year), 2) AS avg_production_year, COUNT(DISTINCT CASE WHEN mk.keyword_id = '3096' THEN t.id ELSE NULL END) AS keyword_3096_count, COUNT(DISTINCT CASE WHEN mk.keyword_id = '2967' THEN t.id ELSE NULL END) AS keyword_2967_count, COUNT(DISTINCT CASE WHEN mk.keyword_id = '3179' THEN t.id ELSE NULL END) AS keyword_3179_count FROM company_name cn JOIN movie_companies mc ON cn.id = mc.company_id JOIN title t ON mc.movie_id = t.id LEFT JOIN movie_keyword mk ON t.id = mk.movie_id GROUP BY cn.country_code ORDER BY total_movies DESC;
SELECT kt.kind, COUNT(DISTINCT mi.movie_id) AS number_of_movies, AVG(subquery.keyword_count) AS average_keywords_per_movie, COUNT(DISTINCT n.id) AS unique_actors FROM kind_type kt LEFT JOIN movie_info mi ON mi.info_type_id = kt.id LEFT JOIN ( SELECT mk.movie_id, COUNT(mk.keyword_id) AS keyword_count FROM movie_keyword mk GROUP BY mk.movie_id ) AS subquery ON mi.movie_id = subquery.movie_id LEFT JOIN name n ON n.imdb_index = mi.info WHERE n.imdb_index IN ('VII', 'IV', 'X', 'XXII', 'VI') AND mi.info_type_id IN (SELECT id FROM info_type WHERE id IN ('40', '7', '30', '74', '34', '76')) GROUP BY kt.kind;
SELECT COUNT(DISTINCT ml.movie_id) AS linked_movies_count, AVG(CAST(pi.info AS NUMERIC)) AS average_rating, SUM(CASE WHEN it.info = 'opening weekend' THEN CAST(pi.info AS NUMERIC) ELSE 0 END) AS total_opening_weekend_revenue, lt.LINK AS link_type, cct.kind AS company_type FROM movie_link AS ml JOIN link_type AS lt ON ml.link_type_id = lt.id JOIN movie_companies AS mc ON ml.movie_id = mc.movie_id JOIN comp_cast_type AS cct ON mc.company_type_id = cct.id JOIN person_info AS pi ON ml.movie_id = pi.person_id JOIN info_type AS it ON pi.info_type_id = it.id WHERE it.info IN ('LD language', 'opening weekend', 'LD digital sound') AND it.id IN ('58', '108', '37', '73', '112') AND pi.info ~ '^[0-9]+(\.[0-9]+)?$' GROUP BY lt.LINK, cct.kind ORDER BY total_opening_weekend_revenue DESC;
SELECT it.info AS info_category, COUNT(pi.id) AS total_person_info_records, AVG(mi.movie_id) AS average_movie_id, SUM(CASE WHEN pi.note = 'anonymous' THEN 1 ELSE 0 END) AS anonymous_count, SUM(CASE WHEN pi.note = 'Spook Show Entertainment' THEN 1 ELSE 0 END) AS spook_show_count, MAX(pi.id) AS max_person_info_id, MIN(mi.id) AS min_movie_info_id FROM person_info pi JOIN info_type it ON pi.info_type_id = it.id JOIN movie_info mi ON pi.person_id = mi.movie_id JOIN comp_cast_type cct ON mi.info_type_id = cct.id AND cct.kind = 'complete' GROUP BY it.info HAVING COUNT(pi.id) > 5 ORDER BY total_person_info_records DESC;
SELECT SUM(CASE WHEN ni.gender = 'M' THEN 1 ELSE 0 END) AS male_count, SUM(CASE WHEN ni.gender = 'F' THEN 1 ELSE 0 END) AS female_count, COUNT(DISTINCT mi.movie_id) AS movie_count, COUNT(DISTINCT pi.person_id) AS person_count, AVG(pi.info_type_id) AS avg_info_type_id FROM name ni JOIN movie_info mi ON ni.id = mi.movie_id JOIN person_info pi ON ni.id = pi.person_id GROUP BY ni.gender;
SELECT kt.kind, COUNT(DISTINCT cc.movie_id) AS total_movies, COUNT(DISTINCT mk.keyword_id) AS total_unique_keywords, SUM(CASE WHEN mk.keyword_id = 1849 THEN 1 ELSE 0 END) AS keyword_1849_count, SUM(CASE WHEN mk.keyword_id = 830 THEN 1 ELSE 0 END) AS keyword_830_count, SUM(CASE WHEN mk.keyword_id = 3752 THEN 1 ELSE 0 END) AS keyword_3752_count, AVG(cc.status_id) AS average_status_id FROM complete_cast AS cc JOIN movie_keyword AS mk ON cc.movie_id = mk.movie_id JOIN kind_type AS kt ON cc.subject_id = kt.id WHERE kt.kind IN ('video movie', 'tv series', 'video game') GROUP BY kt.kind;
