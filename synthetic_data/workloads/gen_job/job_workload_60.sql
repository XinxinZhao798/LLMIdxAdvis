SELECT ct.kind AS company_type, AVG(CAST(mi.info AS NUMERIC)) AS average_rating, COUNT(DISTINCT mk.movie_id) AS movie_count, COUNT(k.id) AS keyword_count, SUM(CASE WHEN it.info = 'LD official retail price' THEN CAST(mi.info AS NUMERIC) ELSE 0 END) AS total_official_retail_price FROM company_type ct JOIN movie_info mi ON ct.id = mi.info_type_id JOIN movie_keyword mk ON mi.movie_id = mk.movie_id JOIN keyword k ON mk.keyword_id = k.id JOIN info_type it ON mi.info_type_id = it.id WHERE mk.keyword_id IN (2506, 2862, 589, 3476, 4237) AND k.phonetic_code IN ('D1653', 'H532', 'M6321', 'H4326', 'F2426', 'A3513') AND it.id IN (15, 16, 18, 76, 39, 111) AND mi.movie_id IN (9091, 13237, 927238) AND (mi.note ILIKE '%(English subtitles)%' OR mi.note ILIKE '%(Original version)%') GROUP BY ct.kind;
SELECT rt.ROLE, COUNT(DISTINCT ci.person_id) AS number_of_actors, AVG(ci.nr_order) AS average_cast_position, SUM(CASE WHEN ct.kind = 'production companies' THEN 1 ELSE 0 END) AS count_production_companies, SUM(CASE WHEN ct.kind = 'distributors' THEN 1 ELSE 0 END) AS count_distributors, SUM(CASE WHEN ct.kind = 'special effects companies' THEN 1 ELSE 0 END) AS count_special_effects_companies, SUM(CASE WHEN ct.kind = 'miscellaneous companies' THEN 1 ELSE 0 END) AS count_miscellaneous_companies FROM cast_info ci JOIN role_type rt ON ci.role_id = rt.id JOIN movie_companies mc ON ci.movie_id = mc.movie_id JOIN company_type ct ON mc.company_type_id = ct.id WHERE ci.movie_id IN ('1061075', '1326354', '1324782', '1249308', '2383083', '2172643') AND mc.company_id IN ('22', '900', '1231', '886') GROUP BY rt.ROLE;
SELECT kt.kind, COUNT(DISTINCT ml.movie_id) AS total_movies, COUNT(DISTINCT cn.id) AS distinct_companies, cn.country_code, AVG(cn.imdb_id) AS avg_imdb_id_of_companies FROM movie_link AS ml INNER JOIN kind_type AS kt ON ml.link_type_id = kt.id INNER JOIN movie_link AS ml2 ON ml.movie_id = ml2.movie_id INNER JOIN company_name AS cn ON ml2.movie_id = cn.id GROUP BY kt.kind, cn.country_code ORDER BY total_movies DESC;
SELECT pi.person_id, COUNT(DISTINCT ci.movie_id) AS number_of_movies, AVG(ci.nr_order) AS average_cast_order, SUM(CASE WHEN ci.note LIKE '%(as %' THEN 1 ELSE 0 END) AS number_of_alias_roles, COUNT(DISTINCT pi.info_type_id) AS distinct_info_types FROM person_info pi JOIN cast_info ci ON pi.person_id = ci.person_id JOIN company_type ct ON ci.role_id = ct.id WHERE ci.person_id IN (1575, 1003, 1034, 1127, 1520, 1048) AND ci.note SIMILAR TO '%(\(pelotari\)|\(as [^)]+\)|\(2011\))%' GROUP BY pi.person_id ORDER BY number_of_movies DESC;
SELECT cn.name AS character_name, COUNT(DISTINCT cl.movie_id) AS total_linked_movies, COUNT(ci.person_id) AS total_roles_played, AVG(ci.nr_order) AS average_role_order FROM char_name AS cn JOIN cast_info AS ci ON cn.id = ci.person_id JOIN movie_link AS cl ON ci.movie_id = cl.movie_id WHERE cn.name IN ('Boy Negro''s Gang', 'Lazoglu', 'Paco Hernández Gil', 'Tedddy Hart', 'Funcionario prisión', 'Make Up Man') GROUP BY cn.name ORDER BY total_linked_movies DESC, total_roles_played DESC;
SELECT kt.kind, COUNT(DISTINCT mk.movie_id) AS number_of_movies, AVG(CAST(mi.info AS INTEGER)) AS average_rating, SUM(CASE WHEN n.gender = 'M' THEN 1 ELSE 0 END) AS male_actors, SUM(CASE WHEN n.gender = 'F' THEN 1 ELSE 0 END) AS female_actors, COUNT(DISTINCT ml.linked_movie_id) AS number_of_linked_movies FROM kind_type kt JOIN movie_info mi ON mi.info_type_id = 4 JOIN movie_keyword mk ON mk.movie_id = mi.movie_id JOIN name n ON n.surname_pcode IN ('A43', 'A415', 'A451', 'A412') JOIN movie_link ml ON ml.movie_id = mk.movie_id WHERE kt.id IN (SELECT id FROM kind_type WHERE kind IN ('movie', 'tv series', 'video game', 'video movie', 'episode')) AND ml.linked_movie_id = 2405240 GROUP BY kt.kind;
SELECT ct.kind AS company_type, COUNT(*) AS total_movies, AVG(ak.production_year) AS average_production_year, SUM(CASE WHEN ci.role_id = 1 THEN 1 ELSE 0 END) AS total_actor_roles, SUM(CASE WHEN ci.person_role_id IN (444, 927, 278, 35) THEN 1 ELSE 0 END) AS specific_person_roles FROM company_name AS cn JOIN company_type AS ct ON cn.id = ct.id JOIN complete_cast AS cc ON cn.id = cc.movie_id JOIN aka_title AS ak ON cc.movie_id = ak.movie_id JOIN cast_info AS ci ON ak.movie_id = ci.movie_id WHERE cn.country_code = 'US' GROUP BY ct.kind HAVING COUNT(*) > 10 ORDER BY total_movies DESC;
SELECT ct.kind AS company_kind, AVG(t.production_year) AS average_production_year, COUNT(DISTINCT t.id) AS number_of_movies, SUM(CASE WHEN t.production_year >= 2000 THEN 1 ELSE 0 END) AS movies_since_2000 FROM title AS t JOIN movie_keyword AS mk ON t.id = mk.movie_id JOIN company_type AS ct ON t.kind_id = ct.id WHERE ct.kind IN ('special effects companies', 'distributors') AND t.production_year IS NOT NULL GROUP BY ct.kind;
SELECT kt.kind AS movie_genre, COUNT(DISTINCT mi_idx.movie_id) AS number_of_movies, AVG(CAST(mi_idx.info AS INTEGER)) AS average_rating, SUM(CAST(person_info.info AS INTEGER)) AS total_movie_budget, COUNT(DISTINCT name.id) AS number_of_actors, COUNT(DISTINCT mk.keyword_id) AS number_of_unique_keywords FROM movie_info_idx mi_idx JOIN kind_type kt ON mi_idx.info_type_id = kt.id JOIN movie_keyword mk ON mi_idx.movie_id = mk.movie_id JOIN movie_info_idx budget_idx ON mi_idx.movie_id = budget_idx.movie_id AND budget_idx.info_type_id = (SELECT id FROM kind_type WHERE kind = 'budget') JOIN person_info ON mi_idx.movie_id = person_info.person_id JOIN name ON person_info.person_id = name.id WHERE kt.id IN ('6', '3', '5', '7', '2', '1') AND name.name_pcode_cf IN ('A2545', 'A2651', 'A4236', 'A4341', 'A2456', 'A2632') GROUP BY movie_genre ORDER BY number_of_movies DESC, average_rating DESC;
