SELECT ct.kind AS cast_type, AVG(t.production_year) AS avg_production_year, COUNT(DISTINCT cn.id) AS total_companies, SUM(CASE WHEN pi.info_type_id = 17 THEN 1 ELSE 0 END) AS count_info_type_17, COUNT(DISTINCT k.id) AS total_keywords, COUNT(DISTINCT t.id) FILTER (WHERE t.production_year > 2010) AS titles_after_2010 FROM title AS t JOIN comp_cast_type AS ct ON t.kind_id = ct.id LEFT JOIN company_name AS cn ON cn.md5sum IN ('46757a84e182ecbce2485bbe4f94c35c', '042c3abaa3eee3219096099e572cbd78', '055c9414a7d1b5428c44a7840e634a28') LEFT JOIN person_info AS pi ON pi.info IN ('Elektra', '23 September 1989') LEFT JOIN keyword AS k ON k.keyword LIKE '%' LEFT JOIN link_type AS lt ON lt.link = 'similar to' AND lt.id = 13 WHERE (t.episode_of_id = '86208' OR cn.name_pcode_nf = 'M6421') GROUP BY ct.kind;
SELECT COUNT(DISTINCT mk.movie_id) AS total_movies, k.keyword, AVG(lt.id) AS average_link_type_id, SUM(CASE WHEN k.phonetic_code = 'T2351' THEN 1 ELSE 0 END) AS count_t2351, SUM(CASE WHEN k.phonetic_code = 'D35' THEN 1 ELSE 0 END) AS count_d35 FROM movie_keyword AS mk JOIN keyword AS k ON mk.keyword_id = k.id JOIN link_type AS lt ON mk.id = lt.id GROUP BY k.keyword ORDER BY total_movies DESC, k.keyword;
SELECT rt.role AS role_type, COUNT(DISTINCT pi.person_id) AS number_of_people, AVG(CASE WHEN pi.info LIKE '%cm' THEN CAST(SUBSTRING(pi.info FROM '^[0-9]+') AS INTEGER) END) AS average_height, COUNT(DISTINCT cn.id) AS number_of_companies, cn.country_code, SUM(CASE WHEN pi.info LIKE '%Bad Faith%' THEN 1 ELSE 0 END) AS bad_faith_count FROM person_info pi JOIN role_type rt ON rt.id = pi.info_type_id JOIN name n ON n.id = pi.person_id JOIN company_name cn ON cn.imdb_id = n.imdb_id WHERE rt.role IN ('writer', 'producer', 'actor') AND cn.country_code IN ('US', 'GB', 'CA') GROUP BY rt.role, cn.country_code ORDER BY role_type, cn.country_code;
SELECT ct.kind AS company_kind, cn.country_code, COUNT(DISTINCT cn.id) AS total_companies, AVG(cn.imdb_id) AS average_imdb_id, COUNT(DISTINCT k.phonetic_code) AS unique_keyword_phonetic_codes FROM company_name cn JOIN company_type ct ON cn.id = ct.id LEFT JOIN keyword k ON cn.id = k.id GROUP BY ct.kind, cn.country_code ORDER BY total_companies DESC, unique_keyword_phonetic_codes DESC;
SELECT kt.kind, COUNT(DISTINCT cc.movie_id) AS number_of_movies, AVG(cc.status_id) AS average_status_id, SUM(CASE WHEN n.gender = 'f' THEN 1 ELSE 0 END) AS female_cast_count, SUM(CASE WHEN n.gender = 'm' THEN 1 ELSE 0 END) AS male_cast_count FROM complete_cast cc JOIN kind_type kt ON cc.subject_id = kt.id JOIN name n ON cc.movie_id = n.id WHERE kt.kind IN ('video movie', 'tv series') GROUP BY kt.kind ORDER BY number_of_movies DESC;
SELECT ct.kind AS company_kind, it.info AS info_category, AVG(t.production_year) AS average_production_year, COUNT(t.id) AS total_titles, SUM(CASE WHEN p.info = 'Adams, Terry Wayne' THEN 1 ELSE 0 END) AS count_terry_wayne_adams_mentions, SUM(CASE WHEN p.info = '14 March 1879' THEN 1 ELSE 0 END) AS count_14_march_1879_mentions FROM title AS t JOIN company_type AS ct ON t.kind_id = ct.id JOIN person_info AS p ON p.info_type_id = ct.id JOIN info_type AS it ON p.info_type_id = it.id WHERE t.production_year BETWEEN 1990 AND 2020 GROUP BY ct.kind, it.info HAVING COUNT(t.id) > 10;
SELECT kt.kind AS movie_genre, COUNT(DISTINCT t.id) AS total_movies, AVG(t.production_year) AS average_production_year, COUNT(DISTINCT mc.company_id) AS total_production_companies, COUNT(DISTINCT n.id) AS total_unique_actors FROM title AS t JOIN kind_type AS kt ON t.kind_id = kt.id JOIN movie_companies AS mc ON t.id = mc.movie_id JOIN cast_info AS ci ON t.id = ci.movie_id JOIN name AS n ON ci.person_id = n.id WHERE t.production_year > 1990 AND mc.movie_id IN ('9013', '18754', '19628', '12173') AND mc.id IN ('2363', '1293', '1757', '2957') GROUP BY kt.kind ORDER BY total_movies DESC;
SELECT cn.country_code, COUNT(DISTINCT cn.id) AS number_of_companies, COUNT(DISTINCT cc.movie_id) AS number_of_movies, COUNT(DISTINCT mc.movie_id) AS number_of_movies_with_companies, AVG(cc.status_id) AS average_status_id, SUM(CASE WHEN cc.status_id = 3 THEN 1 ELSE 0 END) AS status_id_3_count, SUM(CASE WHEN cc.status_id = 4 THEN 1 ELSE 0 END) AS status_id_4_count FROM company_name cn LEFT JOIN movie_companies mc ON cn.id = mc.company_id LEFT JOIN complete_cast cc ON mc.movie_id = cc.movie_id GROUP BY cn.country_code ORDER BY number_of_movies_with_companies DESC;
SELECT rt.ROLE AS role_type, COUNT(DISTINCT cn.id) AS number_of_companies, COUNT(DISTINCT mk.movie_id) AS number_of_movies_with_keywords, AVG(cn.imdb_id) AS average_imdb_id, SUM(CASE WHEN cn.country_code = 'US' THEN 1 ELSE 0 END) AS us_based_companies_count FROM role_type rt LEFT JOIN comp_cast_type cct ON rt.id = cct.id LEFT JOIN company_name cn ON cn.name_pcode_nf = 'M5236' OR cn.name_pcode_sf = 'L5612' LEFT JOIN movie_keyword mk ON mk.keyword_id IN (3479, 3152) WHERE cn.id IN (69171, 31595, 57187, 23935, 26659, 14910) AND rt.id IN (6, 5, 1, 7, 2) GROUP BY rt.ROLE ORDER BY number_of_companies DESC, number_of_movies_with_keywords DESC;
SELECT kt.kind AS movie_type, COUNT(DISTINCT at.id) AS total_alternate_titles, AVG(cc.status_id) AS average_status_id, SUM(CASE WHEN at.kind_id = 7 THEN 1 ELSE 0 END) AS total_tv_shows, SUM(CASE WHEN at.kind_id = 2 THEN 1 ELSE 0 END) AS total_movies, COUNT(DISTINCT mi.id) AS total_movie_info_entries, COUNT(DISTINCT cc.id) AS total_complete_cast_entries FROM aka_title at JOIN kind_type kt ON at.kind_id = kt.id JOIN complete_cast cc ON at.movie_id = cc.movie_id LEFT JOIN movie_info_idx mi ON at.movie_id = mi.movie_id GROUP BY kt.kind ORDER BY total_alternate_titles DESC;
SELECT it.info AS info_type, COUNT(DISTINCT pi.person_id) AS total_people, AVG(pi.person_id) AS average_person_id, MIN(t.production_year) AS earliest_production_year, MAX(t.production_year) AS latest_production_year, SUM(CASE WHEN ml.link_type_id = '16' THEN 1 ELSE 0 END) AS count_link_type_16, SUM(CASE WHEN ml.link_type_id = '7' THEN 1 ELSE 0 END) AS count_link_type_7, COUNT(DISTINCT mk.movie_id) AS total_movies_with_keywords, COUNT(DISTINCT aka.id) AS total_aka_names FROM person_info AS pi JOIN info_type AS it ON pi.info_type_id = it.id LEFT JOIN movie_link AS ml ON ml.movie_id = pi.person_id LEFT JOIN movie_keyword AS mk ON mk.movie_id = pi.person_id LEFT JOIN aka_name AS aka ON aka.person_id = pi.person_id LEFT JOIN title AS t ON t.id = pi.person_id WHERE pi.person_id IN ('9199', '7096', '7497', '4410', '8830') AND aka.md5sum IN ('777e5dd36014a444dcb9fd6b6e79db1b', 'c858ae027357bb0cc527c2bf2cd39730', 'bead886d98c81cafedcdcb186c8d7fc8') GROUP BY it.info;
SELECT cc.kind AS cast_kind, AVG(cc.id) AS average_cast_id, CN.name AS company_name, COUNT(*) AS number_of_movies, SUM(MI.id) AS sum_movie_info_id, AVG(MI.info_type_id) AS average_info_type_id FROM cast_info CI JOIN comp_cast_type CC ON CI.person_role_id = CC.id JOIN company_name CN ON CN.country_code = CI.note JOIN movie_info_idx MI ON CI.movie_id = MI.movie_id WHERE CI.nr_order IN (56, 62, 2, 74) AND CI.movie_id IN (1884275, 2284142, 1084092) AND CN.country_code IN ('[xyu]', '[suhh]', '[lv]', '[nl]', '[cn]') AND CN.name_pcode_sf IN ('W4216', 'A4526', 'S4163', 'C1616') GROUP BY cc.kind, CN.name ORDER BY number_of_movies DESC, company_name;
SELECT rt.role AS role_type, AVG(at.production_year) AS avg_production_year, COUNT(DISTINCT ci.movie_id) AS total_movies_with_writers, COUNT(DISTINCT ci.person_id) AS total_different_writers, SUM(CASE WHEN at.title ILIKE 'The %' THEN 1 ELSE 0 END) AS movies_beginning_with_the FROM cast_info ci INNER JOIN role_type rt ON ci.role_id = rt.id AND rt.role = 'writer' LEFT JOIN aka_title at ON ci.movie_id = at.movie_id WHERE at.kind_id = 1 AND rt.id = 11 GROUP BY rt.role;
SELECT rt.role AS role_type, COUNT(ml.movie_id) AS number_of_movies, AVG(it.id) AS average_info_type_id, SUM(CASE WHEN ml.link_type_id = 8 THEN 1 ELSE 0 END) AS count_link_type_8, SUM(CASE WHEN ml.link_type_id = 11 THEN 1 ELSE 0 END) AS count_link_type_11, SUM(CASE WHEN ml.link_type_id = 3 THEN 1 ELSE 0 END) AS count_link_type_3 FROM movie_link AS ml JOIN role_type AS rt ON rt.id = ml.link_type_id JOIN info_type AS it ON it.id = ml.link_type_id GROUP BY rt.role ORDER BY number_of_movies DESC, average_info_type_id DESC;
SELECT rt.ROLE, COUNT(DISTINCT ci.movie_id) AS num_movies, COUNT(ci.person_id) AS num_performances, AVG(at.production_year) AS avg_production_year, SUM(CASE WHEN k.keyword = 'drama' THEN 1 ELSE 0 END) AS drama_keyword_count FROM cast_info ci JOIN role_type rt ON ci.role_id = rt.id JOIN aka_title at ON ci.movie_id = at.movie_id LEFT JOIN (SELECT mk.movie_id, k.keyword FROM movie_keyword mk JOIN keyword k ON mk.keyword_id = k.id) AS k ON ci.movie_id = k.movie_id WHERE rt.id IN ('12', '7', '9', '3') AND ci.person_id IN ('1145', '1200', '1289') AND at.movie_id IN ('19436', '18749', '11251', '18754', '17100') GROUP BY rt.ROLE HAVING COUNT(DISTINCT ci.movie_id) > 1 ORDER BY num_movies DESC, num_performances DESC;
SELECT it.info AS info_type, COUNT(DISTINCT cn.id) AS unique_character_names, AVG(cn.imdb_id) AS average_imdb_id, SUM(CASE WHEN cc.status_id = '4' THEN 1 ELSE 0 END) AS count_complete_status, SUM(CASE WHEN cc.status_id = '3' THEN 1 ELSE 0 END) AS count_incomplete_status, COUNT(DISTINCT lt.id) AS count_link_types FROM char_name AS cn JOIN complete_cast AS cc ON cn.id = cc.movie_id JOIN info_type AS it ON it.id = cn.imdb_index::integer JOIN link_type AS lt ON lt.id = cn.surname_pcode::integer WHERE cn.imdb_index IN ('10', '21') AND lt.id IN (13, 8, 5, 18) AND cc.status_id IN ('4', '3') GROUP BY it.info;
SELECT kt.kind AS movie_kind, AVG(CAST(mi.info AS INTEGER)) AS average_budget, COUNT(DISTINCT mc.movie_id) AS number_of_movies, COUNT(DISTINCT at.id) AS number_of_alternate_titles, SUM(CASE WHEN cc.status_id = 1 THEN 1 ELSE 0 END) AS completed_cast_count FROM movie_info mi JOIN movie_companies mc ON mc.movie_id = mi.movie_id JOIN kind_type kt ON kt.id = (SELECT kind_id FROM aka_title WHERE movie_id = mi.movie_id LIMIT 1) LEFT JOIN aka_title at ON at.movie_id = mi.movie_id LEFT JOIN complete_cast cc ON cc.movie_id = mi.movie_id WHERE mi.info_type_id = 3 AND mc.company_type_id = 2 AND mi.movie_id IN ('929898', '931171', '924369', '925167', '939922') AND kt.kind <> 'tv series' GROUP BY kt.kind ORDER BY average_budget DESC;
SELECT kt.kind as movie_type, COUNT(DISTINCT mk.movie_id) as number_of_movies, COUNT(DISTINCT k.id) as number_of_unique_keywords, STRING_AGG(DISTINCT k.keyword, ', ') as keywords_list FROM kind_type kt JOIN movie_keyword mk ON kt.id = mk.movie_id JOIN keyword k ON mk.keyword_id = k.id JOIN movie_info mi ON mk.movie_id = mi.movie_id WHERE kt.kind = 'movie' AND mk.id IN ('3186', '2034', '2102', '2766', '2505', '305') GROUP BY kt.kind ORDER BY number_of_movies DESC;
SELECT cn.name AS company_name, AVG(CAST(mi_idx.info AS NUMERIC)) AS average_rating, COUNT(DISTINCT rt.id) AS number_of_roles, SUM(CASE WHEN cn.name_pcode_sf = 'Y5214' THEN 1 ELSE 0 END) AS count_Y5214_companies, SUM(CASE WHEN cn.name_pcode_sf = 'F2536' THEN 1 ELSE 0 END) AS count_F2536_companies FROM company_name AS cn JOIN movie_companies AS mc ON mc.company_id = cn.id JOIN movie_info_idx AS mi_idx ON mi_idx.movie_id = mc.movie_id JOIN cast_info AS ci ON ci.movie_id = mc.movie_id JOIN role_type AS rt ON rt.id = ci.role_id WHERE mi_idx.info_type_id = (SELECT id FROM info_type WHERE info = 'rating') GROUP BY cn.name HAVING COUNT(DISTINCT rt.id) > 1 ORDER BY average_rating DESC;
SELECT it.info AS info_category, COUNT(DISTINCT mc.movie_id) AS number_of_movies, COUNT(DISTINCT mc.company_id) AS number_of_companies, AVG(CAST(mi_idx.info AS numeric)) AS average_movie_info, SUM(CAST(mi_idx.info AS numeric)) AS total_movie_info FROM movie_companies mc JOIN movie_info_idx mi_idx ON mc.movie_id = mi_idx.movie_id JOIN info_type it ON mi_idx.info_type_id = it.id WHERE mc.id IN (2842, 2303, 4675, 3814) AND mi_idx.movie_id IN (14671, 8865) AND mi_idx.note IS NOT NULL GROUP BY it.info;
SELECT AVG(CAST(pi.info AS numeric)) AS average_rating, COUNT(cc.id) AS total_cast_members, COUNT(DISTINCT at.id) AS total_alternate_titles, SUM(CASE WHEN at.title ILIKE '%love%' THEN 1 ELSE 0 END) AS titles_with_love FROM aka_title at JOIN complete_cast cc ON at.movie_id = cc.movie_id JOIN person_info pi ON cc.movie_id = pi.person_id WHERE at.movie_id IN (52294, 98509, 1635723, 1678623) AND pi.info_type_id = 101 GROUP BY at.movie_id;
SELECT COUNT(DISTINCT ci.person_id) AS total_actors, AVG(ci.nr_order) AS average_roles_per_movie, COUNT(DISTINCT ci.movie_id) AS total_movies, COUNT(DISTINCT k.id) AS total_keywords FROM cast_info ci JOIN keyword k ON k.keyword = 'christ-the-redeemer-rio-de-janeiro' JOIN link_type lt ON lt.id = ci.role_id WHERE lt.link IN ('edited into', 'features', 'follows', 'similar to', 'edited from') GROUP BY ci.movie_id;
SELECT ct.kind AS company_type, COUNT(DISTINCT mi_idx.movie_id) AS number_of_movies, AVG(CASE WHEN mi_idx.info_type_id = 100 THEN CAST(mi_idx.info AS FLOAT) END) AS average_rating, SUM(CASE WHEN mi_idx.info_type_id = 101 THEN CAST(mi_idx.info AS INTEGER) END) AS total_budget, COUNT(DISTINCT pi.person_id) AS number_of_persons_involved FROM movie_info_idx mi_idx JOIN company_type ct ON mi_idx.info_type_id = ct.id LEFT JOIN person_info pi ON mi_idx.movie_id = pi.person_id WHERE mi_idx.info_type_id IN (100, 101, 99) GROUP BY ct.kind;
