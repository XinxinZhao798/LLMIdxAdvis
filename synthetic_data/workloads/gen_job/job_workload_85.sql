SELECT it.info AS info_category, COUNT(DISTINCT mc.movie_id) AS number_of_movies, COUNT(DISTINCT mc.company_id) AS number_of_companies, AVG(CAST(mi_idx.info AS numeric)) AS average_movie_info, SUM(CAST(mi_idx.info AS numeric)) AS total_movie_info FROM movie_companies mc JOIN movie_info_idx mi_idx ON mc.movie_id = mi_idx.movie_id JOIN info_type it ON mi_idx.info_type_id = it.id WHERE mc.id IN (2842, 2303, 4675, 3814) AND mi_idx.movie_id IN (14671, 8865) AND mi_idx.note IS NOT NULL GROUP BY it.info;
SELECT AVG(t.production_year) AS average_production_year, COUNT(DISTINCT mk.keyword_id) AS number_of_unique_keywords, COUNT(DISTINCT at.id) AS number_of_alternative_titles, rt.ROLE, COUNT(*) AS total_movies_by_role_type FROM title AS t JOIN movie_keyword AS mk ON mk.movie_id = t.id JOIN aka_title AS at ON at.movie_id = t.id JOIN role_type AS rt ON rt.id = at.kind_id WHERE t.production_year BETWEEN 1990 AND 2000 AND rt.id IN ('5', '4', '6') AND t.imdb_index IN ('V', 'I', 'II') GROUP BY rt.ROLE ORDER BY total_movies_by_role_type DESC;
SELECT AVG(at.production_year) AS average_production_year, COUNT(DISTINCT ml.movie_id) AS count_of_movies_with_links, COUNT(DISTINCT at.movie_id) AS count_of_alternate_titles, SUM(CASE WHEN at.kind_id = 1 THEN 1 ELSE 0 END) AS count_of_movies, SUM(CASE WHEN at.kind_id = 3 THEN 1 ELSE 0 END) AS count_of_tv_shows, COUNT(DISTINCT k.id) AS count_of_unique_keywords FROM aka_title at LEFT JOIN movie_link ml ON at.movie_id = ml.movie_id LEFT JOIN keyword k ON at.title LIKE CONCAT('%', k.keyword, '%') WHERE at.production_year > 2000 AND (ml.id IN (4856, 1568, 48, 747, 1537, 3901) OR ml.linked_movie_id = 2323856) AND at.episode_nr IN (38, 29, 26, 64, 24) AND k.phonetic_code IS NOT NULL GROUP BY at.kind_id;
SELECT ct.kind AS company_kind, COUNT(DISTINCT mi.movie_id) AS number_of_movies, AVG(mi.id) AS average_movie_info_id, SUM(CASE WHEN mi.info_type_id = 1 THEN 1 ELSE 0 END) AS count_of_info_type_1, SUM(CASE WHEN mi.note IS NOT NULL THEN 1 ELSE 0 END) AS count_of_non_null_notes FROM movie_info mi JOIN movie_info_idx mii ON mi.movie_id = mii.movie_id JOIN company_type ct ON mii.info_type_id = ct.id WHERE mi.movie_id IN (939658, 924408, 929751) AND mi.id IN (7267027, 7270561, 7268356, 7270113) AND mii.id = 949 GROUP BY ct.kind;
SELECT kt.kind AS movie_kind, MIN(t.title) AS movie_title, AVG(t.production_year) AS average_production_year, COUNT(DISTINCT ml.movie_id) AS total_linked_movies, COUNT(DISTINCT mi_idx.movie_id) AS total_movies_with_info, SUM(CASE WHEN cc.status_id = 1 THEN 1 ELSE 0 END) AS sum_complete_status FROM title AS t INNER JOIN kind_type AS kt ON t.kind_id = kt.id LEFT JOIN movie_link AS ml ON t.id = ml.movie_id LEFT JOIN movie_info_idx AS mi_idx ON t.id = mi_idx.movie_id LEFT JOIN complete_cast AS cc ON t.id = cc.movie_id GROUP BY kt.kind ORDER BY total_linked_movies DESC;
SELECT lt.LINK AS link_type, COUNT(DISTINCT ml.linked_movie_id) AS num_linked_movies, AVG(ml.movie_id) AS avg_movie_id, COUNT(DISTINCT an.person_id) AS num_alternate_names FROM movie_link AS ml INNER JOIN link_type AS lt ON ml.link_type_id = lt.id LEFT JOIN aka_name AS an ON ml.movie_id = an.person_id GROUP BY lt.LINK ORDER BY num_linked_movies DESC;
SELECT COUNT(DISTINCT cn.id) AS total_companies, COUNT(DISTINCT n.id) AS total_actors, AVG(mi_idx.info::numeric) AS average_movie_length, SUM(CASE WHEN cn.country_code = 'US' THEN 1 ELSE 0 END) AS total_us_companies, COUNT(DISTINCT ml.movie_id) AS total_movies_with_links, MIN(n.name) AS earliest_actor_name FROM company_name AS cn JOIN movie_info AS mi ON cn.id = mi.movie_id JOIN movie_info_idx AS mi_idx ON mi.movie_id = mi_idx.movie_id AND mi_idx.info_type_id = 1 JOIN movie_link AS ml ON mi.movie_id = ml.movie_id JOIN name AS n ON n.id = cn.id JOIN aka_name AS an ON n.id = an.person_id WHERE mi.info_type_id = 3 AND an.name_pcode_cf IN ('C6156', 'A2535', 'K1254') AND an.name IN ('McPherson, Robert', 'Albert, Kimson ''Full Nerf''', 'Alonzo, Alicia', 'Alfredsson, Per', 'Allain, Gregg', 'Ackerman, Faith') AND n.gender = 'M' GROUP BY n.name ORDER BY earliest_actor_name ASC;
SELECT kt.kind AS movie_type, COUNT(DISTINCT t.id) AS number_of_movies, AVG(t.production_year) AS average_production_year, COUNT(DISTINCT mc.company_id) AS number_of_production_companies, COUNT(DISTINCT pi.person_id) AS number_of_individual_contributors, SUM(CASE WHEN t.md5sum IN ('1f1ce7379075bf949e40cb57616b3f4d', '0d05192e412a817cc87628ae56d58d5b') THEN 1 ELSE 0 END) AS count_of_specific_md5sum FROM title t JOIN kind_type kt ON t.kind_id = kt.id JOIN movie_companies mc ON t.id = mc.movie_id JOIN company_type ct ON mc.company_type_id = ct.id JOIN person_info pi ON pi.person_id = t.id WHERE ct.kind = 'production' AND t.production_year BETWEEN 1990 AND 2020 GROUP BY kt.kind ORDER BY number_of_movies DESC;
SELECT COUNT(DISTINCT cn.id) AS total_companies, COUNT(DISTINCT k.id) AS total_keywords, COUNT(DISTINCT pi.person_id) AS total_people, COUNT(DISTINCT at.id) AS total_titles, AVG(cc.status_id) AS average_cast_status, SUM(CASE WHEN cn.country_code = 'US' THEN 1 ELSE 0 END) AS total_us_companies, MAX(at.production_year) AS latest_production_year, MIN(at.production_year) AS earliest_production_year FROM company_name AS cn JOIN aka_title AS at ON cn.id = at.kind_id JOIN complete_cast AS cc ON at.movie_id = cc.movie_id JOIN person_info AS pi ON cc.subject_id = pi.person_id JOIN keyword AS k ON at.id = k.id WHERE cn.name IN ('Sunset Productions (II)', 'Coming Soon TV', 'Tucker Film', 'Windfall Films', 'NMK') AND k.keyword IN ('lavatory', 'society') AND at.production_year BETWEEN 2000 AND 2023 GROUP BY cn.country_code ORDER BY total_us_companies DESC, latest_production_year DESC;
SELECT COUNT(DISTINCT akat.id) AS total_alternate_titles, AVG(akat.production_year) AS average_production_year, SUM(CASE WHEN mcomp.company_type_id = 1 THEN 1 ELSE 0 END) AS total_producer_companies, COUNT(DISTINCT k.id) AS total_unique_keywords, COUNT(DISTINCT mlink.movie_id) AS total_linked_movies, COUNT(DISTINCT n.id) AS total_people FROM aka_title AS akat JOIN movie_companies AS mcomp ON akat.movie_id = mcomp.movie_id JOIN movie_link AS mlink ON akat.movie_id = mlink.movie_id JOIN keyword AS k ON akat.movie_id IN (SELECT mk.movie_id FROM movie_keyword AS mk WHERE mk.keyword_id = k.id) JOIN name AS n ON akat.movie_id IN ( SELECT ci.movie_id FROM cast_info AS ci WHERE ci.person_id = n.id ) WHERE akat.kind_id = 1 AND mcomp.company_type_id IN (1, 2, 3) AND mlink.link_type_id IN (13, 15, 12, 2) AND k.id IN ('2959', '4902', '2890') AND n.id IN ('5102', '4144', '5253', '8021', '11905', '4985') GROUP BY mcomp.company_type_id ORDER BY total_producer_companies DESC;
SELECT lt.LINK as link_type, AVG(ml.id) as average_movie_link_id, SUM(ml.linked_movie_id) as total_linked_movie_id, COUNT(ml.movie_id) as total_movies, COUNT(DISTINCT ml.movie_id) as unique_movies_linked, CCT.kind as comp_cast_type_kind, COUNT(CCT.id) as comp_cast_type_count FROM movie_link as ml JOIN link_type as lt ON ml.link_type_id = lt.id JOIN comp_cast_type as CCT ON CCT.id = ml.link_type_id GROUP BY lt.LINK, CCT.kind ORDER BY total_movies DESC;
SELECT MIN(t.title) AS movie_title, MIN(at.title) AS alternative_title, AVG(ci.nr_order) AS average_cast_order, COUNT(DISTINCT t.id) AS number_of_movies, COUNT(DISTINCT ci.person_id) AS number_of_unique_actors, SUM(CASE WHEN t.production_year BETWEEN 1970 AND 1980 THEN 1 ELSE 0 END) AS movies_produced_1970_to_1980, SUM(CASE WHEN t.production_year BETWEEN 1981 AND 1990 THEN 1 ELSE 0 END) AS movies_produced_1981_to_1990, SUM(CASE WHEN t.production_year BETWEEN 1991 AND 2000 THEN 1 ELSE 0 END) AS movies_produced_1991_to_2000 FROM title AS t INNER JOIN aka_title AS at ON t.id = at.movie_id AND at.kind_id IN (1, 3) INNER JOIN cast_info AS ci ON t.id = ci.movie_id WHERE t.production_year IN (1985, 1975, 1950, 1972) GROUP BY t.kind_id HAVING COUNT(DISTINCT ci.person_id) > 10 ORDER BY number_of_movies DESC, average_cast_order;
SELECT k.keyword, COUNT(DISTINCT mk.movie_id) AS movie_count, AVG(LENGTH(k.phonetic_code)) AS avg_phonetic_code_length, COUNT(DISTINCT rt.id) AS distinct_role_types FROM movie_keyword AS mk JOIN keyword AS k ON mk.keyword_id = k.id JOIN cast_info AS ci ON mk.movie_id = ci.movie_id JOIN role_type AS rt ON ci.role_id = rt.id WHERE mk.movie_id IN ('12183', '10549', '12251', '15502', '13890', '9703') AND mk.keyword_id IN ('2957', '3334', '3038', '2036') GROUP BY k.keyword ORDER BY movie_count DESC, avg_phonetic_code_length;
SELECT kt.kind AS movie_type, avg(akat.production_year) AS average_production_year, count(DISTINCT akat.movie_id) AS number_of_movies, count(DISTINCT mc.company_id) AS number_of_companies_involved, sum(CASE WHEN rt.role = 'director' THEN 1 ELSE 0 END) AS number_of_directors, sum(CASE WHEN rt.role = 'actress' THEN 1 ELSE 0 END) AS number_of_actresses, sum(CASE WHEN rt.role = 'cinematographer' THEN 1 ELSE 0 END) AS number_of_cinematographers, sum(CASE WHEN rt.role = 'composer' THEN 1 ELSE 0 END) AS number_of_composers FROM kind_type kt JOIN aka_title akat ON kt.id = akat.kind_id JOIN movie_companies mc ON akat.movie_id = mc.movie_id JOIN company_type ct ON mc.company_type_id = ct.id JOIN movie_link mlink ON akat.movie_id = mlink.movie_id JOIN role_type rt ON mlink.link_type_id = rt.id GROUP BY kt.kind ORDER BY number_of_movies DESC;
SELECT t.kind_id AS movie_kind, COUNT(DISTINCT t.id) AS number_of_movies, AVG(t.production_year) AS average_production_year, COUNT(DISTINCT pi.person_id) AS number_of_persons_involved, SUM(CASE WHEN t.imdb_index = 'V' THEN 1 ELSE 0 END) AS direct_to_video_count, SUM(CASE WHEN t.imdb_index IN ('I', 'II') THEN 1 ELSE 0 END) AS sequel_count, COUNT(DISTINCT k.id) AS number_of_unique_keywords, AVG(pi.info_type_id) AS average_info_type_id FROM title AS t LEFT JOIN person_info AS pi ON t.id = pi.person_id LEFT JOIN char_name AS cn ON cn.id = pi.person_id LEFT JOIN keyword AS k ON k.id = pi.info_type_id GROUP BY t.kind_id HAVING COUNT(DISTINCT cn.surname_pcode) > 1 ORDER BY number_of_movies DESC;
SELECT kt.kind, COUNT(DISTINCT mk.movie_id) AS number_of_movies, AVG(CAST(mi.info AS INTEGER)) AS average_rating, SUM(CASE WHEN n.gender = 'M' THEN 1 ELSE 0 END) AS male_actors, SUM(CASE WHEN n.gender = 'F' THEN 1 ELSE 0 END) AS female_actors, COUNT(DISTINCT ml.linked_movie_id) AS number_of_linked_movies FROM kind_type kt JOIN movie_info mi ON mi.info_type_id = 4 JOIN movie_keyword mk ON mk.movie_id = mi.movie_id JOIN name n ON n.surname_pcode IN ('A43', 'A415', 'A451', 'A412') JOIN movie_link ml ON ml.movie_id = mk.movie_id WHERE kt.id IN (SELECT id FROM kind_type WHERE kind IN ('movie', 'tv series', 'video game', 'video movie', 'episode')) AND ml.linked_movie_id = 2405240 GROUP BY kt.kind;
SELECT k.keyword, COUNT(DISTINCT ml.movie_id) AS linked_movies_count, AVG(sub_person_roles.roles_count) AS avg_roles_per_person, COUNT(DISTINCT an.id) AS unique_pseudonyms_count FROM keyword AS k LEFT JOIN movie_keyword AS mk ON k.id = mk.keyword_id LEFT JOIN movie_link AS ml ON mk.movie_id = ml.movie_id LEFT JOIN person_info AS pi ON pi.info_type_id = k.id LEFT JOIN (SELECT pi.person_id, COUNT(DISTINCT pi.info_type_id) AS roles_count FROM person_info AS pi INNER JOIN role_type AS rt ON pi.info_type_id = rt.id WHERE rt.id IN (1, 8, 7, 5) GROUP BY pi.person_id ) AS sub_person_roles ON pi.person_id = sub_person_roles.person_id LEFT JOIN aka_name AS an ON pi.person_id = an.person_id WHERE k.keyword IN ('murder', 'mystery', 'thriller') AND pi.info_type_id IN (70, 2, 75, 36, 50) GROUP BY k.keyword;
SELECT cn.name AS character_name, AVG(mi_idx.info::numeric) AS average_rating, COUNT(DISTINCT k.keyword) AS unique_keywords, COUNT(DISTINCT ml.linked_movie_id) AS number_of_linked_movies, SUM(CASE WHEN pi.info_type_id = 3 THEN 1 ELSE 0 END) AS number_of_birthdays_recorded FROM char_name cn LEFT JOIN movie_info_idx mi_idx ON cn.imdb_id = mi_idx.movie_id AND mi_idx.info_type_id = 101 LEFT JOIN movie_keyword mk ON mk.movie_id = mi_idx.movie_id LEFT JOIN keyword k ON k.id = mk.keyword_id LEFT JOIN movie_link ml ON ml.movie_id = mi_idx.movie_id LEFT JOIN person_info pi ON pi.person_id = cn.id AND pi.info_type_id = 3 WHERE cn.md5sum IN ('ad29d0b30522be696e375c0cf52fad0b', 'ca8d2f6f99875f835be5a698310d23a5', 'e195362a34d97e0c055cd5c7275fb81f', '60817b9dbbd1ec43e9d559147a578e08') AND cn.name_pcode_nf IN ('G5146', 'J2525', 'B5', 'K6252') GROUP BY cn.name;
SELECT rt.ROLE, COUNT(ci.id) AS num_cast_entries, AVG(ci.nr_order) AS average_order, SUM(ci.person_id) AS total_person_ids, MAX(pinfo.info) AS latest_info, MIN(pinfo.info) AS earliest_info FROM cast_info ci JOIN role_type rt ON ci.role_id = rt.id JOIN person_info pinfo ON ci.person_id = pinfo.person_id WHERE ci.nr_order IS NOT NULL AND pinfo.info_type_id = ( SELECT id FROM info_type WHERE info = 'quotes' ) GROUP BY rt.ROLE ORDER BY num_cast_entries DESC, average_order;
SELECT ct.kind AS company_type, COUNT(DISTINCT cn.id) AS num_companies, COUNT(DISTINCT ci.person_id) AS num_people, AVG(ci.nr_order) AS average_cast_order, SUM(CASE WHEN mk.keyword_id = '5000' THEN 1 ELSE 0 END) AS count_keyword_5000, SUM(CASE WHEN mk.keyword_id = '7107' THEN 1 ELSE 0 END) AS count_keyword_7107, COUNT(DISTINCT mk.movie_id) AS num_movies_with_keywords FROM company_name AS cn JOIN company_type AS ct ON cn.id = ct.id LEFT JOIN movie_keyword AS mk ON cn.id = mk.movie_id LEFT JOIN cast_info AS ci ON ci.movie_id = mk.movie_id WHERE cn.country_code IS NOT NULL AND ci.note NOT LIKE '%(segment "%' AND ci.note NOT LIKE '%(1998)%' GROUP BY ct.kind ORDER BY num_companies DESC, num_people DESC;
SELECT ct.kind AS company_type, AVG(at.production_year) AS avg_production_year, COUNT(DISTINCT ci.movie_id) AS num_movies_casted, SUM(CASE WHEN at.season_nr IS NOT NULL THEN 1 ELSE 0 END) AS total_seasons, COUNT(DISTINCT k.id) AS unique_keywords FROM movie_companies AS mc JOIN company_type AS ct ON mc.company_type_id = ct.id JOIN aka_title AS at ON mc.movie_id = at.movie_id JOIN cast_info AS ci ON ci.movie_id = mc.movie_id LEFT JOIN keyword AS k ON k.id = at.movie_id WHERE mc.note LIKE '%(20%)%' AND ci.nr_order IN (44, 146, 15, 7, 47) AND ci.role_id = 1 AND at.movie_id IN (879100, 610270, 1241825, 1678396, 1699805, 549252) GROUP BY ct.kind;
SELECT AVG(CAST(mi_idx.info AS NUMERIC)) AS average_movie_rating, COUNT(DISTINCT ci.movie_id) AS count_movies_with_keywords, COUNT(DISTINCT k.keyword) AS count_distinct_keywords, MIN(cn.name) AS company_name, SUM(CASE WHEN cc.status_id = 4 THEN 1 ELSE 0 END) AS count_complete_verified_casts, MAX(cn.country_code) AS country_code_with_most_movies FROM movie_keyword AS mk INNER JOIN keyword AS k ON mk.keyword_id = k.id INNER JOIN movie_link AS ml ON mk.movie_id = ml.movie_id INNER JOIN movie_info_idx AS mi_idx ON ml.movie_id = mi_idx.movie_id INNER JOIN cast_info AS ci ON ml.movie_id = ci.movie_id INNER JOIN company_name AS cn ON ci.person_id = cn.imdb_id INNER JOIN complete_cast AS cc ON mk.movie_id = cc.movie_id WHERE ml.link_type_id = 19 AND mk.movie_id IN (11231, 16365, 11116) AND cc.status_id IN (3, 4) AND cn.country_code IS NOT NULL GROUP BY cn.name ORDER BY average_movie_rating DESC, count_movies_with_keywords DESC;
