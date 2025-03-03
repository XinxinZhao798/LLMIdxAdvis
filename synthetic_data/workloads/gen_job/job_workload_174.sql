SELECT COUNT(DISTINCT mc.movie_id) AS number_of_movies, AVG(t.production_year) AS average_production_year, cct.kind AS company_type, MIN(cn.name) AS company_name, SUM(CASE WHEN n.gender = 'M' THEN 1 ELSE 0 END) AS male_actors, SUM(CASE WHEN n.gender = 'F' THEN 1 ELSE 0 END) AS female_actors FROM movie_companies AS mc JOIN title AS t ON mc.movie_id = t.id JOIN company_name AS cn ON mc.company_id = cn.id JOIN comp_cast_type AS cct ON mc.company_type_id = cct.id LEFT JOIN name AS n ON n.md5sum = mc.note WHERE cn.country_code NOT LIKE '[pl]' AND t.production_year BETWEEN 1950 AND 1999 AND t.phonetic_code = 'D323' AND n.name_pcode_nf IN ('N6454', 'I4364', 'O2464', 'D54', 'M3526', 'G6534') GROUP BY cct.kind;
SELECT ct.kind AS company_type, COUNT(DISTINCT mki.movie_id) AS num_movies, AVG(nk.id) AS average_keyword_id, SUM(CAST(mi.info AS INTEGER)) AS total_movie_budget FROM movie_info_idx AS mi JOIN info_type AS it ON mi.info_type_id = it.id JOIN movie_keyword AS mk ON mi.movie_id = mk.movie_id JOIN keyword AS k ON mk.keyword_id = k.id JOIN movie_keyword AS mki ON mk.movie_id = mki.movie_id JOIN name AS nk ON mi.movie_id = nk.id JOIN company_type AS ct ON mi.movie_id = ct.id WHERE it.info = 'budget' AND nk.md5sum IN ('e15cd3fa3bbc8a9b94815e7c53272e8d', '210114d8aeab34bd1116444c16687fcf') AND mi.note IS NOT NULL AND k.keyword LIKE '%action%' GROUP BY ct.kind;
SELECT t.kind_id, COUNT(DISTINCT t.id) AS total_movies, AVG(t.production_year) AS average_production_year, SUM(CASE WHEN mi.info = 'Estonian' THEN 1 ELSE 0 END) AS total_estonian_movies, SUM(CASE WHEN mi.info = 'German' THEN 1 ELSE 0 END) AS total_german_movies, SUM(CASE WHEN mi.info = 'Dutch' THEN 1 ELSE 0 END) AS total_dutch_movies, SUM(CASE WHEN mi.info = 'Vietnamese' THEN 1 ELSE 0 END) AS total_vietnamese_movies, SUM(CASE WHEN mi.info = 'Greek' THEN 1 ELSE 0 END) AS total_greek_movies, SUM(CASE WHEN mi.info = 'Croatian' THEN 1 ELSE 0 END) AS total_croatian_movies, COUNT(DISTINCT an.id) AS total_aka_names, COUNT(DISTINCT cc.id) AS total_complete_casts, COUNT(DISTINCT lt.id) AS total_link_types FROM title AS t LEFT JOIN movie_info AS mi ON t.id = mi.movie_id AND mi.info_type_id = '4' LEFT JOIN aka_name AS an ON t.id = an.person_id LEFT JOIN complete_cast AS cc ON t.id = cc.movie_id AND cc.subject_id = '1' AND cc.status_id IN ('3', '4') LEFT JOIN link_type AS lt ON lt.link IN ('edited into', 'similar to', 'spin off from') GROUP BY t.kind_id;
SELECT lt.LINK AS link_type, COUNT(ml.id) AS total_links, AVG(ml.movie_id) AS average_movie_id, MIN(cn.name) AS character_name_with_min_id, MAX(an.name) AS aka_name_with_max_id FROM movie_link AS ml JOIN link_type AS lt ON ml.link_type_id = lt.id LEFT JOIN char_name AS cn ON cn.id = ml.movie_id AND cn.surname_pcode = 'E2146' LEFT JOIN aka_name AS an ON an.id = ml.linked_movie_id AND an.md5sum = '7df6a930bde6eff675fae9eecfb9ff7e' GROUP BY lt.LINK ORDER BY total_links DESC;
SELECT cn.country_code, COUNT(DISTINCT mi.movie_id) AS movie_count, AVG(pi.info_type_id::numeric) AS avg_person_info_type, COUNT(DISTINCT cn.name) AS company_count, COUNT(DISTINCT chn.name) AS character_name_count FROM movie_info mi JOIN movie_info_idx mii ON mi.movie_id = mii.movie_id AND mi.info_type_id = mii.info_type_id JOIN company_name cn ON mi.movie_id = cn.imdb_id JOIN person_info pi ON mi.movie_id = pi.person_id JOIN char_name chn ON mi.movie_id = chn.imdb_id WHERE cn.country_code IN ('[np]', '[kr]', '[cn]', '[tw]', '[sa]', '[my]') AND pi.note IN ('info@aeberhard.com', 'Chris Hendren', 'Quincy Johnson', 'Ian Adema', 'isabelleadriani@yahoo.it') AND pi.info_type_id IN ('34', '36') AND mi.info IN ('Galician', 'Flemish', 'Persian', 'Czech') GROUP BY cn.country_code ORDER BY movie_count DESC, avg_person_info_type DESC;
SELECT mi.info AS Movie_Language, rt.ROLE AS Role_Type, COUNT(DISTINCT ci.person_id) AS Total_People, AVG(ci.nr_order) AS Average_Cast_Order FROM movie_info mi JOIN cast_info ci ON mi.movie_id = ci.movie_id JOIN role_type rt ON ci.role_id = rt.id WHERE mi.info IN ('Bosnian', 'Serbian', 'Finnish', 'Greek') GROUP BY mi.info, rt.ROLE ORDER BY Movie_Language, Total_People DESC;
SELECT kt.kind AS content_type, COUNT(DISTINCT ci.movie_id) AS total_movies, COUNT(DISTINCT ci.person_id) AS total_actors, AVG(movie_link.id) AS average_movie_link_id, SUM(mc.company_id) AS total_company_ids, COUNT(DISTINCT k.id) AS unique_keywords FROM cast_info ci JOIN kind_type kt ON ci.movie_id IN (2360100, 2237184, 947729, 1615145) JOIN movie_link ON movie_link.movie_id = ci.movie_id JOIN movie_companies mc ON ci.movie_id = mc.movie_id JOIN keyword k ON k.phonetic_code IN ('S4623', 'P4162', 'M4252') WHERE kt.kind IN ('video game', 'tv movie', 'episode', 'video movie', 'tv series', 'tv mini series') AND ci.nr_order IN (87, 12, 8, 34) AND movie_link.id IN (1606, 3369, 1804, 3838) GROUP BY kt.kind;
SELECT kt.kind AS movie_kind, AVG(akat.production_year) AS average_production_year, COUNT(DISTINCT akat.movie_id) AS total_movies, SUM(CASE WHEN cn.country_code LIKE 'US%' THEN 1 ELSE 0 END) AS total_usa_productions FROM aka_title AS akat JOIN kind_type AS kt ON akat.kind_id = kt.id JOIN company_name AS cn ON akat.movie_id = cn.imdb_id WHERE akat.production_year BETWEEN 1990 AND 2000 AND kt.kind IN ('tv movie', 'movie') AND cn.country_code IN ('USA', 'CAN', 'GBR') GROUP BY kt.kind ORDER BY total_movies DESC;
SELECT kt.kind AS movie_type, COUNT(DISTINCT t.id) AS total_movies, AVG(t.production_year) AS average_production_year, COUNT(DISTINCT cn.id) AS total_characters, COUNT(DISTINCT cc.subject_id) AS total_subjects, SUM(CASE WHEN ml.link_type_id = 1 THEN 1 ELSE 0 END) AS total_prequels, SUM(CASE WHEN ml.link_type_id = 2 THEN 1 ELSE 0 END) AS total_sequels, SUM(CASE WHEN ml.link_type_id = 3 THEN 1 ELSE 0 END) AS total_remakes FROM title t JOIN kind_type kt ON t.kind_id = kt.id LEFT JOIN char_name cn ON cn.id IN (6979, 93733, 25881, 73653) LEFT JOIN complete_cast cc ON cc.movie_id = t.id LEFT JOIN movie_link ml ON ml.movie_id = t.id GROUP BY kt.kind ORDER BY total_movies DESC;
SELECT ct.kind AS company_kind, COUNT(DISTINCT n.id) AS number_of_people, AVG(t.production_year) AS average_production_year, SUM(CASE WHEN t.season_nr IS NOT NULL THEN 1 ELSE 0 END) AS total_series_episodes, COUNT(DISTINCT at.id) AS number_of_alternate_titles FROM name n JOIN aka_name an ON n.id = an.person_id JOIN title t ON n.id = t.id JOIN aka_title at ON t.id = at.movie_id JOIN company_type ct ON ct.kind = 'production companies' GROUP BY ct.kind;
SELECT AVG(aka.production_year) AS average_production_year, COUNT(DISTINCT aka.id) AS total_alternate_titles, COUNT(DISTINCT pi.person_id) AS total_persons_involved, SUM(CASE WHEN ct.kind = 'Distributor' THEN 1 ELSE 0 END) AS total_distributors, MAX(mi_idx.info) AS max_rating_info, MIN(mi_idx.info) AS min_rating_info FROM aka_title AS aka JOIN movie_info_idx AS mi_idx ON aka.movie_id = mi_idx.movie_id JOIN person_info AS pi ON pi.info_type_id = mi_idx.info_type_id JOIN company_type AS ct ON ct.id = mi_idx.info_type_id WHERE aka.production_year BETWEEN 1990 AND 2020 AND mi_idx.note IS NOT NULL AND aka.md5sum IN ('8173fbc966e75848163d8bf3766b4497', 'b17609e6b3c789ed4cc36812549fe2b4', 'df5fc0502294c32330a516626ef75c18') GROUP BY mi_idx.info_type_id HAVING COUNT(DISTINCT aka.movie_id) > 10 ORDER BY average_production_year DESC, total_alternate_titles;
SELECT ct.kind AS company_kind, COUNT(DISTINCT cc.id) AS total_complete_casts, COUNT(DISTINCT ml.id) AS total_movie_links, AVG(cc.status_id) AS average_status_id, SUM(CASE WHEN cc.subject_id = 1 THEN 1 ELSE 0 END) AS subject_1_cast_count FROM company_type ct LEFT JOIN complete_cast cc ON cc.subject_id = ct.id LEFT JOIN movie_link ml ON ml.movie_id = cc.movie_id GROUP BY ct.kind ORDER BY total_complete_casts DESC;
SELECT kt.kind AS movie_kind, COUNT(DISTINCT t.id) AS total_movies, AVG(t.production_year) AS average_production_year, SUM(CASE WHEN mc.note LIKE '%(TV)%' THEN 1 ELSE 0 END) AS total_tv_movies, COUNT(DISTINCT cn.id) AS total_characters, COUNT(DISTINCT an.person_id) AS total_actors_with_aliases FROM title t JOIN kind_type kt ON t.kind_id = kt.id LEFT JOIN movie_companies mc ON t.id = mc.movie_id LEFT JOIN char_name cn ON cn.imdb_id = t.imdb_id LEFT JOIN aka_name an ON an.person_id = t.id WHERE t.production_year > 2000 AND t.kind_id IN (2, 3, 6, 7) AND (mc.note LIKE '%(TV)%' OR mc.note IS NULL) AND (cn.surname_pcode = 'B654' OR cn.surname_pcode IS NULL) AND (mc.company_type_id = kt.id OR mc.company_type_id IS NULL) GROUP BY kt.kind ORDER BY total_movies DESC;
SELECT ct.kind AS company_type, AVG(t.production_year) AS average_production_year, COUNT(DISTINCT t.id) AS number_of_movies, SUM(CASE WHEN ak.season_nr IS NOT NULL THEN 1 ELSE 0 END) AS number_of_series_episodes, COUNT(DISTINCT mk.keyword_id) AS unique_keywords_used, COUNT(DISTINCT ml.linked_movie_id) AS number_of_linked_movies FROM title AS t LEFT JOIN aka_title AS ak ON t.id = ak.movie_id LEFT JOIN movie_companies AS mc ON t.id = mc.movie_id LEFT JOIN company_type AS ct ON mc.company_type_id = ct.id LEFT JOIN movie_keyword AS mk ON t.id = mk.movie_id LEFT JOIN movie_link AS ml ON t.id = ml.movie_id WHERE t.production_year BETWEEN 2000 AND 2010 AND mc.note LIKE '%(TV)%' AND (ak.season_nr IN ('13', '5', '19') OR ak.season_nr IS NULL) AND (ak.production_year = '2008' OR ak.production_year IS NULL) GROUP BY ct.kind ORDER BY average_production_year DESC, number_of_movies DESC;
SELECT it.info AS info_category, COUNT(DISTINCT mi_idx.movie_id) AS total_movies, AVG(cast_info.nr_order) AS average_order, SUM(CASE WHEN cn.surname_pcode IS NOT NULL THEN 1 ELSE 0 END) AS total_with_surname_code, MAX(cast_info.nr_order) AS max_order_in_cast, MIN(cast_info.nr_order) AS min_order_in_cast FROM movie_info_idx AS mi_idx JOIN info_type AS it ON mi_idx.info_type_id = it.id JOIN char_name AS cn ON cn.imdb_id = mi_idx.movie_id JOIN cast_info ON cast_info.movie_id = mi_idx.movie_id WHERE it.info IN ('LD sound encoding', 'spouse', 'copyright holder') AND cn.name_pcode_nf = 'R1513' AND mi_idx.movie_id = 8488 GROUP BY it.info;
SELECT COUNT(DISTINCT at.id) AS number_of_titles, AVG(at.production_year) AS average_production_year, rt.role AS role_type, COUNT(DISTINCT mi.id) AS number_of_movie_infos, SUM(CASE WHEN at.kind_id = '1' THEN 1 ELSE 0 END) AS number_of_movies, SUM(CASE WHEN at.kind_id = '2' THEN 1 ELSE 0 END) AS number_of_tv_shows, COUNT(DISTINCT at.episode_of_id) AS number_of_unique_series, MAX(at.season_nr) AS max_season_number, MAX(at.episode_nr) AS max_episode_number FROM aka_title at JOIN movie_info mi ON at.movie_id = mi.movie_id JOIN role_type rt ON mi.info_type_id = rt.id WHERE at.production_year BETWEEN 1990 AND 2020 AND mi.info LIKE '%color%' GROUP BY rt.role ORDER BY number_of_titles DESC, average_production_year;
SELECT AVG(CAST(mi_idx.info AS numeric)) AS average_rating, COUNT(DISTINCT a_n.person_id) AS unique_actors, COUNT(DISTINCT m_c.movie_id) AS movies_produced, SUM(CASE WHEN m_c.company_id IN (379, 594, 23, 1262, 1213, 38) THEN 1 ELSE 0 END) AS movies_by_selected_companies FROM movie_info_idx AS mi_idx JOIN movie_companies AS m_c ON mi_idx.movie_id = m_c.movie_id JOIN aka_name AS a_n ON a_n.person_id = m_c.company_id WHERE mi_idx.info_type_id IN (100, 101, 99) AND m_c.id IN (4668, 2403) AND a_n.surname_pcode = 'C34' AND mi_idx.info SIMILAR TO '%(0|1|2|3|4|5|6|7|8|9)%' GROUP BY mi_idx.info_type_id;
