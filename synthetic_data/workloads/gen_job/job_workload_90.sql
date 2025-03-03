SELECT ct.kind AS company_type, AVG(ak.production_year) AS average_production_year, COUNT(DISTINCT ak.movie_id) AS number_of_movies, COUNT(DISTINCT cc.subject_id) AS number_of_subjects, SUM(CASE WHEN n.gender = 'm' THEN 1 ELSE 0 END) AS male_actor_count, SUM(CASE WHEN n.gender = 'f' THEN 1 ELSE 0 END) AS female_actor_count, COUNT(DISTINCT k.id) AS number_of_unique_keywords FROM aka_title ak JOIN complete_cast cc ON ak.movie_id = cc.movie_id JOIN company_type ct ON ak.kind_id = ct.id JOIN keyword k ON ak.id = k.id JOIN name n ON ak.id = n.id WHERE ak.production_year BETWEEN 2000 AND 2010 AND n.md5sum IN ('660ea0ef9bdefafcda003d019848f703', '6d0c221bb93b310ab2904bdd75c8a442', 'a24f9431335b1461f14ac1933840f6cf', 'afaebb48a6577994f1924c5910d75467', 'e755250c050a467046983653e209cf90', '3978c1bc47a6deab5ab0956b3cb08ada') GROUP BY ct.kind;
SELECT kt.kind AS movie_kind, CASE WHEN ml.id IS NOT NULL THEN 'Part of series' ELSE 'Standalone' END AS series_status, COUNT(DISTINCT mi.movie_id) AS total_movies, AVG(CASE WHEN mi_idx.info_type_id = 1 THEN mi_idx.info::FLOAT END) AS average_rating, AVG(CASE WHEN mi.info_type_id = 2 THEN mi.info::FLOAT END) AS average_budget FROM kind_type AS kt LEFT JOIN movie_info_idx AS mi_idx ON mi_idx.info_type_id = 1 LEFT JOIN movie_info AS mi ON mi.movie_id = mi_idx.movie_id AND mi.info_type_id = 2 LEFT JOIN movie_link AS ml ON ml.movie_id = mi.movie_id LEFT JOIN movie_companies AS mc ON mc.movie_id = mi.movie_id WHERE kt.id IN (7, 2) GROUP BY kt.kind, series_status ORDER BY total_movies DESC;
SELECT kt.kind AS movie_kind, COUNT(DISTINCT ci.movie_id) AS total_movies, AVG(ci.nr_order) AS average_cast_order, SUM(CASE WHEN ci.person_id = 1867 THEN 1 ELSE 0 END) AS total_movies_person_1867, SUM(CASE WHEN ci.person_id = 1769 THEN 1 ELSE 0 END) AS total_movies_person_1769, SUM(CASE WHEN ci.person_id = 1459 THEN 1 ELSE 0 END) AS total_movies_person_1459, COUNT(DISTINCT cn.id) AS total_companies, COUNT(DISTINCT mi.info) AS distinct_movie_info_types FROM kind_type AS kt JOIN movie_info AS mi ON mi.movie_id = kt.id JOIN cast_info AS ci ON ci.movie_id = kt.id JOIN company_name AS cn ON cn.imdb_id = ci.movie_id WHERE kt.kind = 'movie' AND ci.person_id IN (1867, 1769, 1459, 1473, 1640, 1126) AND ci.movie_id IN (152924, 2374081, 1326173, 1098477, 1321487, 1288531) GROUP BY kt.kind;
SELECT kt.kind, COUNT(DISTINCT mc.movie_id) AS total_movies, COUNT(DISTINCT mc.company_id) AS total_companies_involved, AVG(aka_count.aka_name_count) AS average_aka_names_per_movie_kind FROM kind_type kt JOIN movie_info_idx t ON kt.id = t.info_type_id JOIN movie_companies mc ON t.movie_id = mc.movie_id LEFT JOIN ( SELECT an.person_id, COUNT(*) as aka_name_count FROM aka_name an GROUP BY an.person_id ) aka_count ON mc.movie_id = aka_count.person_id GROUP BY kt.kind ORDER BY total_movies DESC;
SELECT ct.kind AS company_kind, rt.ROLE AS role_description, COUNT(DISTINCT cn.id) AS number_of_companies, COUNT(DISTINCT ci.person_id) AS number_of_people, AVG(ci.nr_order) AS average_cast_order, SUM(CASE WHEN lt.LINK = 'follows' THEN 1 ELSE 0 END) AS total_follows_links FROM cast_info ci JOIN role_type rt ON ci.role_id = rt.id JOIN company_name cn ON ci.movie_id = cn.id JOIN company_type ct ON cn.id = ct.id JOIN link_type lt ON cn.id = lt.id WHERE ci.person_role_id IS NOT NULL AND cn.country_code = 'US' AND rt.ROLE IN ('actor', 'actress', 'producer', 'director') AND lt.LINK IN ('remade as', 'version of', 'spin off from', 'follows') GROUP BY ct.kind, rt.ROLE ORDER BY number_of_people DESC, average_cast_order;
SELECT kt.kind, COUNT(DISTINCT at.movie_id) AS number_of_movies, COUNT(at.id) AS number_of_alt_titles, AVG(at.production_year) AS average_production_year, SUM(CASE WHEN at.episode_of_id IS NOT NULL THEN 1 ELSE 0 END) AS number_of_episodes FROM aka_title at INNER JOIN comp_cast_type kt ON at.kind_id = kt.id GROUP BY kt.kind ORDER BY number_of_movies DESC;
SELECT kt.kind AS movie_kind, AVG(akat.production_year) AS average_production_year, COUNT(DISTINCT cn.id) AS number_of_actors, COUNT(DISTINCT kn.id) AS number_of_keywords, SUM(CASE WHEN cn.name LIKE 'A%' THEN 1 ELSE 0 END) AS actors_starting_with_a, COUNT(DISTINCT cmn.id) AS number_of_companies, MAX(akat.episode_nr) AS max_episode_number FROM aka_title akat JOIN kind_type kt ON akat.kind_id = kt.id LEFT JOIN complete_cast cc ON akat.movie_id = cc.movie_id LEFT JOIN char_name cn ON cn.id = cc.subject_id LEFT JOIN movie_keyword mk ON akat.movie_id = mk.movie_id LEFT JOIN keyword kn ON mk.keyword_id = kn.id AND kn.phonetic_code IN ('D525', 'G6431', 'T2623', 'S1425', 'M4165', 'G5123') LEFT JOIN movie_companies mc ON akat.movie_id = mc.movie_id LEFT JOIN company_name cmn ON mc.company_id = cmn.id WHERE akat.production_year >= 2000 GROUP BY kt.kind
SELECT rt.ROLE, AVG(miidx.info::NUMERIC) AS average_rating, COUNT(DISTINCT cn.id) AS number_of_companies, COUNT(DISTINCT cl.movie_id) AS number_of_movies_linked, COUNT(DISTINCT mk.keyword_id) AS number_of_unique_keywords FROM role_type rt LEFT JOIN char_name cn ON cn.surname_pcode = rt.id::CHARACTER VARYING LEFT JOIN movie_link cl ON cl.link_type_id = rt.id LEFT JOIN movie_keyword mk ON mk.movie_id = cl.movie_id LEFT JOIN movie_info_idx miidx ON miidx.movie_id = cl.movie_id WHERE rt.ROLE IN ('production designer', 'guest', 'editor', 'cinematographer') AND cn.name_pcode_nf IN ('T3452', 'A423', 'D653', 'A5426', 'H5161', 'B3216') AND miidx.info_type_id = 101 /* Assuming 101 is the info_type_id for 'rating' */ GROUP BY rt.ROLE;
SELECT lt.LINK AS link_type, COUNT(*) AS total_links, AVG(ml.movie_id) AS average_movie_id, SUM(CASE WHEN pi.info_type_id = 7 THEN 1 ELSE 0 END) AS count_info_with_type_7, MAX(pi.note) AS latest_note FROM movie_link AS ml JOIN link_type AS lt ON ml.link_type_id = lt.id JOIN person_info AS pi ON ml.movie_id = pi.person_id GROUP BY lt.LINK ORDER BY total_links DESC;
SELECT mc.company_type_id, COUNT(DISTINCT t.id) AS number_of_movies, SUM(CASE WHEN t.kind_id = 2 THEN 1 ELSE 0 END) AS total_series_movies, ROUND(AVG(t.production_year), 2) AS average_production_year, SUM(CASE WHEN rt.role = 'producer' THEN 1 ELSE 0 END) AS total_producer_roles FROM title t JOIN movie_companies mc ON mc.movie_id = t.id LEFT JOIN role_type rt ON rt.id = mc.company_type_id WHERE t.production_year > 2000 GROUP BY mc.company_type_id HAVING COUNT(DISTINCT t.id) > 0 ORDER BY number_of_movies DESC, total_series_movies DESC;
SELECT kt.kind AS movie_type, COUNT(DISTINCT at.id) AS total_alternate_titles, AVG(cc.status_id) AS average_status_id, SUM(CASE WHEN at.kind_id = 7 THEN 1 ELSE 0 END) AS total_tv_shows, SUM(CASE WHEN at.kind_id = 2 THEN 1 ELSE 0 END) AS total_movies, COUNT(DISTINCT mi.id) AS total_movie_info_entries, COUNT(DISTINCT cc.id) AS total_complete_cast_entries FROM aka_title at JOIN kind_type kt ON at.kind_id = kt.id JOIN complete_cast cc ON at.movie_id = cc.movie_id LEFT JOIN movie_info_idx mi ON at.movie_id = mi.movie_id GROUP BY kt.kind ORDER BY total_alternate_titles DESC;
SELECT AT.production_year, COUNT(DISTINCT AT.movie_id) AS total_movies, COUNT(DISTINCT ML.movie_id) AS total_linked_movies, AVG(CASE WHEN N.gender = 'F' THEN 1 ELSE 0 END) AS avg_female_actors, SUM(CASE WHEN MI_IDX.info_type_id = 1 THEN 1 ELSE 0 END) AS total_genre_info FROM aka_title AT JOIN movie_link ML ON AT.movie_id = ML.movie_id JOIN movie_info_idx MI_IDX ON AT.movie_id = MI_IDX.movie_id JOIN name N ON N.id = MI_IDX.movie_id WHERE AT.production_year BETWEEN 1960 AND 1970 AND ML.link_type_id IN (1, 2, 10, 13) AND N.gender IN ('F', 'M') GROUP BY AT.production_year ORDER BY AT.production_year;
