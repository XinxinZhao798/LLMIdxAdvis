SELECT it.info AS info_category, COUNT(DISTINCT n.id) AS total_people, COUNT(DISTINCT pi.person_id) AS people_with_info, AVG(n.imdb_id) AS average_imdb_id, SUM(CASE WHEN n.gender = 'M' THEN 1 ELSE 0 END) AS total_males, SUM(CASE WHEN n.gender = 'F' THEN 1 ELSE 0 END) AS total_females FROM name AS n LEFT JOIN person_info AS pi ON n.id = pi.person_id JOIN info_type AS it ON pi.info_type_id = it.id GROUP BY it.info;
SELECT ct.kind AS company_type, AVG(CAST(mi_idx.info AS NUMERIC)) AS average_rating, COUNT(DISTINCT mc.movie_id) AS number_of_movies FROM movie_companies AS mc INNER JOIN company_type AS ct ON mc.company_type_id = ct.id INNER JOIN movie_info_idx AS mi_idx ON mc.movie_id = mi_idx.movie_id WHERE mi_idx.info_type_id = (SELECT id FROM info_type WHERE info = 'rating') AND mi_idx.note IS DISTINCT FROM '1' GROUP BY ct.kind HAVING COUNT(DISTINCT mc.movie_id) > 10 ORDER BY average_rating DESC;
SELECT kt.kind AS movie_kind, AVG(mk.keyword_id) AS average_keyword_id, COUNT(DISTINCT mc.movie_id) AS number_of_movies, COUNT(DISTINCT cn.id) AS number_of_companies_involved, SUM(CASE WHEN cct.kind = 'crew' THEN 1 ELSE 0 END) AS total_crew_companies, MAX(cn.name) AS largest_company_name FROM movie_keyword AS mk JOIN movie_companies AS mc ON mk.movie_id = mc.movie_id JOIN company_name AS cn ON mc.company_id = cn.id JOIN comp_cast_type AS cct ON mc.company_type_id = cct.id JOIN movie_link AS ml ON mk.movie_id = ml.movie_id JOIN kind_type AS kt ON ml.link_type_id = kt.id WHERE ml.link_type_id IN ('7', '8') AND cct.id IN ('2', '1', '4', '3') GROUP BY kt.kind ORDER BY number_of_movies DESC, average_keyword_id;
SELECT rt.ROLE, COUNT(DISTINCT ci.person_id) AS total_people, AVG(CASE WHEN pi.info_type_id = 3 THEN pi.info::NUMERIC ELSE NULL END) AS average_salary, COUNT(DISTINCT mi_idx.movie_id) AS total_movies, SUM(CASE WHEN pi.info LIKE '%(1980s)%' THEN 1 ELSE 0 END) AS eighties_count FROM cast_info ci JOIN role_type rt ON ci.role_id = rt.id LEFT JOIN person_info pi ON ci.person_id = pi.person_id LEFT JOIN name n ON ci.person_id = n.id LEFT JOIN movie_info_idx mi_idx ON ci.movie_id = mi_idx.movie_id AND mi_idx.info_type_id = 4 WHERE ci.note NOT LIKE '%(credit only)%' AND n.name_pcode_nf IN ('M2424', 'R5434', 'N6416', 'P5232', 'J2545', 'M6235') GROUP BY rt.ROLE ORDER BY total_people DESC;
SELECT COUNT(DISTINCT ci.id) AS total_cast_members, AVG(ci.nr_order) AS average_cast_order, SUM(CASE WHEN n.gender = 'm' THEN 1 ELSE 0 END) AS total_male_cast, COUNT(DISTINCT cn.id) AS total_companies, COUNT(DISTINCT ml.id) AS total_movie_links, AVG(mi_idx.info::NUMERIC) AS average_movie_info_numeric_value FROM cast_info AS ci JOIN name AS n ON ci.person_id = n.id JOIN company_name AS cn ON cn.country_code = 'US' JOIN movie_link AS ml ON ml.movie_id = ci.movie_id JOIN movie_info_idx AS mi_idx ON mi_idx.movie_id = ci.movie_id WHERE n.name_pcode_nf IN ('I3542', 'I1425', 'A1346', 'A4152', 'E2415', 'A214') AND cn.name_pcode_sf IN ('T3612', 'A4135') AND ml.linked_movie_id IN ('566232', '327844', '2386590', '2368302', '1823148', '1881905') AND mi_idx.id IN ('3312', '4204') GROUP BY n.gender;
SELECT cn.name AS company_name, cn.country_code, COUNT(DISTINCT mc.movie_id) AS total_movies_produced, AVG(cn.imdb_id) AS average_movie_imdb_id, COUNT(DISTINCT k.id) AS total_unique_keywords FROM movie_companies mc JOIN company_name cn ON mc.company_id = cn.id JOIN kind_type kt ON mc.company_type_id = kt.id JOIN movie_info_idx mi ON mc.movie_id = mi.movie_id LEFT JOIN keyword k ON mi.info = k.keyword WHERE kt.id IN ('5', '2', '4', '1', '7') AND mc.note IN ('(2001-) (USA) (TV)', '(????) (Czech Republic) (TV)') AND mi.movie_id IN ('19232', '19598', '10553', '12245') GROUP BY cn.name, cn.country_code ORDER BY total_movies_produced DESC;
SELECT c.name AS company_name, it.info AS info_category, COUNT(DISTINCT mi.movie_id) AS num_movies, AVG(CAST(mi_idx.info AS numeric)) AS average_info, SUM(CAST((CASE WHEN mi_idx.note = '1' THEN 1 ELSE 0 END) AS integer)) AS sum_notes_flagged_1 FROM company_name c JOIN movie_info mi ON c.id = mi.movie_id JOIN movie_info_idx mi_idx ON mi.movie_id = mi_idx.movie_id AND mi.info_type_id = mi_idx.info_type_id JOIN info_type it ON mi.info_type_id = it.id JOIN movie_keyword mk ON mi.movie_id = mk.movie_id WHERE mi_idx.info_type_id IN ('100', '101', '99') AND mk.keyword_id IN ('4340', '3698', '3610', '2735') AND mi_idx.info IN ('0.0.010105', '1....1..6.', '1......413', '0..0000033') GROUP BY c.name, it.info ORDER BY num_movies DESC, average_info DESC;
SELECT kt.kind, COUNT(DISTINCT cc.movie_id) AS total_movies_with_complete_cast, AVG(mc.company_id) AS average_company_id, SUM(ml.linked_movie_id) AS total_linked_movie_ids FROM complete_cast cc JOIN kind_type kt ON cc.subject_id = kt.id JOIN movie_companies mc ON cc.movie_id = mc.movie_id JOIN movie_link ml ON cc.movie_id = ml.movie_id WHERE cc.status_id IN (1, 2) AND kt.id IN (1, 2, 5, 3) AND mc.id IN (2678, 1671, 621, 430) AND ml.movie_id IN (20571, 5979, 11130) GROUP BY kt.kind;
SELECT ct.kind AS company_kind, rt.ROLE AS role_description, COUNT(DISTINCT cn.id) AS number_of_companies, COUNT(DISTINCT ci.person_id) AS number_of_people, AVG(ci.nr_order) AS average_cast_order, SUM(CASE WHEN lt.LINK = 'follows' THEN 1 ELSE 0 END) AS total_follows_links FROM cast_info ci JOIN role_type rt ON ci.role_id = rt.id JOIN company_name cn ON ci.movie_id = cn.id JOIN company_type ct ON cn.id = ct.id JOIN link_type lt ON cn.id = lt.id WHERE ci.person_role_id IS NOT NULL AND cn.country_code = 'US' AND rt.ROLE IN ('actor', 'actress', 'producer', 'director') AND lt.LINK IN ('remade as', 'version of', 'spin off from', 'follows') GROUP BY ct.kind, rt.ROLE ORDER BY number_of_people DESC, average_cast_order;
SELECT cn.country_code, COUNT(DISTINCT mc.movie_id) AS number_of_movies, COUNT(DISTINCT mc.company_id) AS number_of_companies, AVG(ci.imdb_id) AS average_imdb_id, SUM(CASE WHEN mc.company_type_id = 1 THEN 1 ELSE 0 END) AS number_of_type_1_companies FROM movie_companies AS mc INNER JOIN company_name AS cn ON mc.company_id = cn.id LEFT JOIN name AS ci ON cn.imdb_id = ci.imdb_id WHERE cn.country_code IN ('[dm]', '[mt]', '[ph]', '[gb]', '[kz]', '[cz]') AND mc.note IN ('(1967) (USA) (TV) (original airing)', '(2009-2010) (Switzerland) (TV) (SF1)', '(2006) (Germany) (DVD)') GROUP BY cn.country_code
SELECT ct.kind AS company_kind, AVG(mi_idx.info::NUMERIC) AS average_movie_length, COUNT(DISTINCT ch_name.id) AS unique_character_count, COUNT(DISTINCT cn_name.id) AS unique_company_count, SUM(CASE WHEN ml.link_type_id = 2 THEN 1 ELSE 0 END) AS sequel_link_count FROM movie_info_idx AS mi_idx JOIN company_name AS cn_name ON cn_name.imdb_id = mi_idx.movie_id JOIN company_type AS ct ON cn_name.id = ct.id JOIN char_name AS ch_name ON ch_name.imdb_id = mi_idx.movie_id JOIN movie_link AS ml ON ml.movie_id = mi_idx.movie_id WHERE mi_idx.info_type_id = 1 AND ct.kind IN ('special effects companies', 'miscellaneous companies', 'production companies', 'distributors') AND ch_name.name IN ('Dr. Carlos Ventura', 'John Hartman Jr.', 'Paw Slawson', 'Pera', 'The Jester', 'Guitarist') GROUP BY ct.kind;
SELECT rt.ROLE, COUNT(DISTINCT ci.person_id) AS total_actors, COUNT(DISTINCT ci.movie_id) AS total_movies, AVG(ci.nr_order) AS average_cast_position, MIN(mi_idx.info) AS min_info_value, MAX(mi_idx.info) AS max_info_value, it.info AS info_type_description FROM cast_info ci JOIN role_type rt ON ci.role_id = rt.id JOIN movie_info_idx mi_idx ON ci.movie_id = mi_idx.movie_id JOIN info_type it ON mi_idx.info_type_id = it.id WHERE it.info IN ('sound mix', 'LD audio noise', 'LD dynamic range', 'magazine cover photo', 'novel', 'certificates') AND rt.ROLE IN ('actor', 'actress', 'producer', 'director') GROUP BY rt.ROLE, it.info ORDER BY total_movies DESC, total_actors DESC, average_cast_position;
SELECT kind.kind as cast_type, avg(mi_idx.info::numeric) as average_rating, count(distinct mk.movie_id) as number_of_movies_with_keywords, count(distinct pi.person_id) as number_of_persons_associated, sum(case when at.production_year > 2000 then 1 else 0 end) as movies_after_2000 FROM movie_info_idx mi_idx JOIN info_type it ON mi_idx.info_type_id = it.id AND it.id = 48 JOIN movie_keyword mk ON mi_idx.movie_id = mk.movie_id JOIN aka_title at ON mi_idx.movie_id = at.movie_id JOIN comp_cast_type kind ON at.kind_id = kind.id LEFT JOIN person_info pi ON mi_idx.movie_id = pi.person_id WHERE at.production_year IS NOT NULL AND at.production_year >= 1990 AND mi_idx.info::numeric > 2.0 GROUP BY kind.kind ORDER BY average_rating DESC;
SELECT comp.name AS company_name, COUNT(DISTINCT ci.movie_id) AS number_of_movies, AVG(ci.nr_order) AS average_cast_order, SUM(CASE WHEN mc.company_type_id = 1 THEN 1 ELSE 0 END) AS number_of_production_companies, SUM(CASE WHEN mc.company_type_id = 2 THEN 1 ELSE 0 END) AS number_of_distribution_companies FROM company_name AS comp JOIN movie_companies AS mc ON comp.id = mc.company_id JOIN cast_info AS ci ON mc.movie_id = ci.movie_id WHERE comp.name_pcode_sf IN ('A4514', 'G5251', 'A3432', 'U5416', 'G6265', 'J3216') GROUP BY comp.name ORDER BY number_of_movies DESC, average_cast_order;
