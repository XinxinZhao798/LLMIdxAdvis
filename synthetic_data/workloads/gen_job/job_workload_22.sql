SELECT ct.kind AS cast_type, AVG(movcomp_notes.note_length) AS average_note_length, COUNT(DISTINCT movcomp.movie_id) AS number_of_movies, COUNT(DISTINCT comp.name) AS number_of_companies, SUM(CASE WHEN movcomp.company_type_id = 1 THEN 1 ELSE 0 END) AS number_of_producers, MAX(comp_cast.subject_id) AS max_subject_id_for_cast_type FROM complete_cast AS comp_cast JOIN comp_cast_type AS ct ON comp_cast.subject_id = ct.id JOIN movie_companies AS movcomp ON movcomp.movie_id = comp_cast.movie_id JOIN company_name AS comp ON movcomp.company_id = comp.id LEFT JOIN (SELECT movie_id, LENGTH(note) AS note_length FROM movie_companies) AS movcomp_notes ON movcomp.movie_id = movcomp_notes.movie_id WHERE comp_cast.id IN (4264, 2513, 575, 1032) AND comp_cast.subject_id = 1 AND ct.id = 4 GROUP BY ct.kind;
SELECT kt.kind, AVG(CAST(mi.info AS FLOAT)) AS average_rating, COUNT(DISTINCT cc.movie_id) AS unique_movies, COUNT(DISTINCT rt.id) AS different_roles FROM movie_info mi INNER JOIN movie_info_idx mi_idx ON mi.movie_id = mi_idx.movie_id AND mi.info_type_id = mi_idx.info_type_id INNER JOIN kind_type kt ON mi.movie_id = kt.id INNER JOIN complete_cast cc ON mi.movie_id = cc.movie_id INNER JOIN comp_cast_type cct ON cc.status_id = cct.id INNER JOIN role_type rt ON cct.kind = rt.role WHERE mi_idx.info_type_id = (SELECT id FROM info_type WHERE info = 'rating') AND CAST(mi_idx.info AS FLOAT) > 0 AND kt.kind IN ('tv movie', 'video movie', 'video game') GROUP BY kt.kind ORDER BY average_rating DESC;
SELECT kt.kind AS movie_kind, COUNT(DISTINCT at.id) AS total_titles, COUNT(DISTINCT at.movie_id) AS unique_movies, AVG(at.production_year) AS avg_production_year, SUM(CASE WHEN lt.link = 'alternate language version of' THEN 1 ELSE 0 END) AS alt_lang_versions, SUM(CASE WHEN lt.link = 'version of' THEN 1 ELSE 0 END) AS versions, SUM(CASE WHEN lt.link = 'features' THEN 1 ELSE 0 END) AS features_count FROM aka_title at JOIN kind_type kt ON at.kind_id = kt.id JOIN movie_info_idx mii ON at.movie_id = mii.movie_id JOIN link_type lt ON mii.id = lt.id WHERE at.imdb_index = 'IV' AND at.episode_of_id IN ('11942', '6153', '1980', '7480', '8274') AND kt.kind IN ('tv series', 'video movie', 'video game', 'tv mini series') AND mii.info_type_id IN (SELECT id FROM info_type WHERE info LIKE '%0..11202%' OR info LIKE '.0..002212') GROUP BY kt.kind;
SELECT mk.keyword_id, COUNT(DISTINCT ci.movie_id) AS number_of_movies, COUNT(ci.person_id) AS total_cast_members, AVG(CAST(ci.nr_order AS DECIMAL)) AS average_cast_order FROM movie_keyword AS mk INNER JOIN cast_info AS ci ON mk.movie_id = ci.movie_id INNER JOIN link_type AS lt ON ci.person_role_id = lt.id WHERE lt.link IN ('followed by', 'edited into', 'similar to') GROUP BY mk.keyword_id ORDER BY number_of_movies DESC, average_cast_order ASC;
SELECT mc.company_id, mc.company_type_id, COUNT(mc.movie_id) AS total_movies, AVG(at.production_year) AS avg_production_year, SUM(k.id) AS total_keyword_id_sum FROM movie_companies mc JOIN aka_title at ON mc.movie_id = at.movie_id LEFT JOIN keyword k ON at.id = k.id WHERE mc.movie_id IN (19080, 25456, 14762, 19670, 32217, 10568) GROUP BY mc.company_id, mc.company_type_id ORDER BY total_movies DESC, avg_production_year DESC;
SELECT ct.kind as cast_type, COUNT(DISTINCT mk.movie_id) as num_movies, COUNT(DISTINCT k.id) as num_keywords, AVG(sub.num_keywords_per_movie) as avg_keywords_per_movie, SUM(sub.num_keywords_per_movie) as total_keywords FROM movie_keyword as mk INNER JOIN keyword as k ON mk.keyword_id = k.id INNER JOIN comp_cast_type as ct ON ct.id = mk.movie_id INNER JOIN ( SELECT mk.movie_id, COUNT(mk.keyword_id) as num_keywords_per_movie FROM movie_keyword as mk GROUP BY mk.movie_id ) sub ON mk.movie_id = sub.movie_id GROUP BY ct.kind;
SELECT kt.kind, COUNT(DISTINCT cc.movie_id) AS total_movies_with_complete_cast, AVG(mc.company_id) AS average_company_id, SUM(ml.linked_movie_id) AS total_linked_movie_ids FROM complete_cast cc JOIN kind_type kt ON cc.subject_id = kt.id JOIN movie_companies mc ON cc.movie_id = mc.movie_id JOIN movie_link ml ON cc.movie_id = ml.movie_id WHERE cc.status_id IN (1, 2) AND kt.id IN (1, 2, 5, 3) AND mc.id IN (2678, 1671, 621, 430) AND ml.movie_id IN (20571, 5979, 11130) GROUP BY kt.kind;
SELECT AVG(akat.production_year) AS average_production_year, COUNT(DISTINCT mc.movie_id) AS number_of_movies, COUNT(DISTINCT cn.id) AS number_of_unique_characters, SUM(CASE WHEN ct.kind = 'Production' THEN 1 ELSE 0 END) AS total_production_companies, MAX(mc.note) AS longest_note FROM aka_title AS akat JOIN movie_companies AS mc ON akat.movie_id = mc.movie_id JOIN company_type AS ct ON mc.company_type_id = ct.id JOIN char_name AS cn ON akat.id = cn.id WHERE akat.production_year BETWEEN 2000 AND 2020 AND ct.kind IN ('Production', 'Distributors', 'Special Effects') GROUP BY ct.kind ORDER BY average_production_year DESC, number_of_movies DESC;
SELECT kt.kind AS movie_type, COUNT(DISTINCT t.id) AS total_movies, AVG(t.production_year) AS average_production_year, SUM(CASE WHEN n.gender = 'F' THEN 1 ELSE 0 END) AS female_cast_count, SUM(CASE WHEN n.gender = 'M' THEN 1 ELSE 0 END) AS male_cast_count, COUNT(DISTINCT n.id) AS total_actors, COUNT(DISTINCT mc.company_id) AS total_companies_involved, COUNT(DISTINCT person_info.person_id) AS total_person_info_entries FROM title t JOIN kind_type kt ON t.kind_id = kt.id LEFT JOIN cast_info ci ON t.id = ci.movie_id LEFT JOIN name n ON ci.person_id = n.id LEFT JOIN movie_companies mc ON t.id = mc.movie_id LEFT JOIN person_info ON ci.person_id = person_info.person_id WHERE n.surname_pcode IN ('A41', 'A431') AND n.name_pcode_nf IN ('I2154', 'G45') AND t.phonetic_code IN ('A5353', 'M6323', 'B4312', 'U1236') AND ci.note NOT LIKE '%(archive footage)%' GROUP BY kt.kind;
SELECT COUNT(DISTINCT ci.person_id) AS total_actors, AVG(ci.nr_order) AS average_cast_order, SUM(CASE WHEN n.gender = 'F' THEN 1 ELSE 0 END) AS female_actors_count, SUM(CASE WHEN n.gender = 'M' THEN 1 ELSE 0 END) AS male_actors_count, t.production_year, COUNT(DISTINCT k.id) AS total_keywords_used, COUNT(DISTINCT t.id) AS total_movies FROM cast_info ci JOIN name n ON ci.person_id = n.id JOIN title t ON ci.movie_id = t.id JOIN movie_keyword mk ON t.id = mk.movie_id JOIN keyword k ON mk.keyword_id = k.id WHERE t.production_year >= 2000 AND t.kind_id = 1 GROUP BY t.production_year ORDER BY t.production_year DESC;
SELECT it.info AS info_type, COUNT(DISTINCT akn.person_id) AS unique_person_count, COUNT(DISTINCT k.id) AS unique_keyword_count, AVG(mc.company_id) AS average_company_id, SUM(CASE WHEN k.phonetic_code IN ('S6252', 'C351', 'F2352') THEN 1 ELSE 0 END) AS specific_phonetic_code_count FROM aka_name akn JOIN info_type it ON akn.surname_pcode = it.info JOIN keyword k ON akn.name_pcode_nf = k.phonetic_code JOIN movie_companies mc ON akn.person_id = mc.company_id GROUP BY it.info ORDER BY unique_person_count DESC, unique_keyword_count DESC;
SELECT COUNT(DISTINCT ci.person_id) AS total_cast_members, AVG(at.production_year) AS avg_production_year, SUM(CASE WHEN at.kind_id = 6 THEN 1 ELSE 0 END) AS total_season_6_titles, COUNT(DISTINCT mc.company_id) AS total_companies_involved, COUNT(DISTINCT mi_finnish.movie_id) AS total_finnish_movies FROM cast_info ci JOIN aka_title at ON ci.movie_id = at.movie_id JOIN movie_companies mc ON ci.movie_id = mc.movie_id LEFT JOIN movie_info mi_finnish ON ci.movie_id = mi_finnish.movie_id AND mi_finnish.info = 'Finnish' WHERE ci.note LIKE '%(as %)' AND at.season_nr IN (1, 9) GROUP BY at.production_year;
SELECT ct.kind AS cast_type, rt.ROLE AS role, COUNT(DISTINCT cn.id) AS number_of_companies, COUNT(DISTINCT n.id) AS number_of_people, AVG(mk.keyword_id) AS average_keyword_id, SUM(CASE WHEN ml.link_type_id = 1 THEN 1 ELSE 0 END) AS count_movie_sequels FROM comp_cast_type ct JOIN role_type rt ON ct.id = rt.id JOIN company_name cn ON cn.country_code = 'us' JOIN name n ON n.gender = 'f' JOIN movie_keyword mk ON mk.movie_id = n.id JOIN movie_link ml ON ml.movie_id = n.id GROUP BY ct.kind, rt.ROLE HAVING COUNT(DISTINCT mk.keyword_id) > 10;
SELECT COUNT(DISTINCT n.id) AS number_of_actors, AVG(n.imdb_id) AS average_imdb_id, SUM(CASE WHEN n.gender = 'F' THEN 1 ELSE 0 END) AS female_actors_count, SUM(CASE WHEN n.gender = 'M' THEN 1 ELSE 0 END) AS male_actors_count, COUNT(DISTINCT an.id) AS number_of_alternative_names, COUNT(DISTINCT cct.id) AS number_of_cast_types, AVG(LENGTH(n.name)) AS average_actor_name_length FROM name n LEFT JOIN aka_name an ON n.id = an.person_id LEFT JOIN comp_cast_type cct ON an.id = cct.id WHERE n.name LIKE '%Amplify%' OR an.name IN ('Allen, ''Barefoot'' Chris', 'Alsamia, Etienne', 'Altamirano, Lisa Mariea', 'Aller, Gina', 'Smith, Mary Alice') GROUP BY n.gender;
