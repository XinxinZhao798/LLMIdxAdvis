SELECT rt.role AS role_type, COUNT(DISTINCT ci.person_id) AS number_of_persons, AVG(mi_idx.info::numeric) AS average_rating, SUM(CASE WHEN mi.info = 'Greek' THEN 1 ELSE 0 END) AS greek_language_movies, SUM(CASE WHEN mi.info = 'Hindi' THEN 1 ELSE 0 END) AS hindi_language_movies, SUM(CASE WHEN mi.info = 'Kyrgyz' THEN 1 ELSE 0 END) AS kyrgyz_language_movies FROM role_type AS rt JOIN cast_info AS ci ON rt.id = ci.role_id JOIN movie_info AS mi ON ci.movie_id = mi.movie_id JOIN movie_info_idx AS mi_idx ON mi.movie_id = mi_idx.movie_id WHERE rt.role = 'writer' AND mi_idx.info_type_id = (SELECT id FROM info_type WHERE info = 'rating') AND mi.info_type_id IN (SELECT id FROM info_type WHERE info IN ('languages', 'language')) GROUP BY rt.role;
SELECT t.title, kt.kind, COUNT(DISTINCT cn.id) AS total_characters, COUNT(DISTINCT comp_n.id) AS total_companies, AVG(t.production_year) AS average_production_year, MAX(it.info) AS most_frequent_info FROM title t JOIN kind_type kt ON t.kind_id = kt.id LEFT JOIN movie_info_idx mii ON t.id = mii.movie_id LEFT JOIN info_type it ON mii.info_type_id = it.id LEFT JOIN char_name cn ON t.id = cn.id LEFT JOIN company_name comp_n ON t.id = comp_n.id GROUP BY t.title, kt.kind ORDER BY total_characters DESC, total_companies DESC;
SELECT n.gender, count(DISTINCT n.id) AS number_of_actors, avg(ci.nr_order) AS average_cast_order, sum(CASE WHEN ci.role_id = 1 THEN 1 ELSE 0 END) AS number_of_leading_roles, count(DISTINCT k.id) AS number_of_unique_keywords, it.info AS info_type, count(DISTINCT ci.movie_id) AS number_of_movies FROM cast_info ci JOIN name n ON ci.person_id = n.id JOIN keyword k ON k.phonetic_code = ci.note JOIN info_type it ON ci.person_role_id = it.id WHERE ci.role_id = 1 AND ci.nr_order IN (101, 69) AND n.gender = 'm' AND it.info IN ('essays', 'LD sharpness', 'bottom 10 rank', 'soundtrack', 'magazine cover photo', 'LD color information') GROUP BY n.gender, it.info ORDER BY number_of_actors DESC;
SELECT it.info AS info_type, COUNT(mi.id) AS total_movie_info_entries, AVG(LENGTH(mi.info)) AS average_info_length, SUM(CASE WHEN mi.note IS NOT NULL THEN 1 ELSE 0 END) AS count_with_notes FROM movie_info mi JOIN info_type it ON mi.info_type_id = it.id JOIN keyword k ON k.id = ANY(ARRAY[8402, 763, 4258, 5648]) WHERE it.id IN (16, 97, 31, 104, 71) GROUP BY it.info ORDER BY total_movie_info_entries DESC, average_info_length DESC;
SELECT COUNT(DISTINCT an.id) AS number_of_aka_names, AVG(cc.status_id) AS average_status_id, SUM(CASE WHEN cct.kind = 'complete+verified' THEN 1 ELSE 0 END) AS complete_verified_count, SUM(CASE WHEN cct.kind = 'complete' THEN 1 ELSE 0 END) AS complete_count, COUNT(DISTINCT cc.movie_id) AS number_of_movies_with_complete_cast, SUM(CASE WHEN an.surname_pcode = 'P6' THEN 1 ELSE 0 END) AS surname_pcode_P6_count, SUM(CASE WHEN an.surname_pcode = 'A625' THEN 1 ELSE 0 END) AS surname_pcode_A625_count, SUM(CASE WHEN an.surname_pcode = 'C43' THEN 1 ELSE 0 END) AS surname_pcode_C43_count FROM aka_name AS an JOIN complete_cast AS cc ON an.person_id = cc.subject_id JOIN comp_cast_type AS cct ON cc.status_id = cct.id WHERE cc.movie_id IN ('1679404', '51426', '1649449', '1656947', '1656720', '2526470') AND cct.id IN ('1', '4');
SELECT COUNT(DISTINCT akn.id) AS total_aka_names, COUNT(DISTINCT n.id) AS total_names, COUNT(DISTINCT pi.id) AS total_person_infos, AVG(n.imdb_id) AS average_imdb_id, MAX(ct.kind) AS largest_company_type, MIN(k.keyword) AS first_keyword FROM aka_name akn INNER JOIN name n ON akn.person_id = n.id INNER JOIN person_info pi ON n.id = pi.person_id LEFT JOIN company_type ct ON ct.id = pi.info_type_id LEFT JOIN keyword k ON k.phonetic_code = 'M4314' WHERE akn.surname_pcode = 'G235' AND (n.md5sum = '027846e5567882de4f67c71cfac3ae12' OR n.md5sum = 'f3a34ae0735af63ad03a7b5fb923a27e' OR n.md5sum = '073c556aa9cb435efd04b6f217cb153f' OR n.md5sum = '6f661ba1a459d8ee448710953f2f2216' OR n.md5sum = '144786e8a288b6b896bdb277a8bf9155') AND pi.info_type_id IN ('20', '23', '26', '28') GROUP BY k.keyword ORDER BY total_aka_names DESC, total_names DESC, total_person_infos DESC;
SELECT cct.kind AS cast_type_kind, it.info AS info_type, AVG(t.production_year) AS average_production_year, COUNT(DISTINCT t.id) AS count_of_movies, SUM(CASE WHEN ml.linked_movie_id IS NOT NULL THEN 1 ELSE 0 END) AS sum_of_linked_movies FROM title t JOIN comp_cast_type cct ON t.kind_id = cct.id JOIN complete_cast cc ON t.id = cc.movie_id JOIN movie_info mi ON t.id = mi.movie_id JOIN info_type it ON mi.info_type_id = it.id LEFT JOIN movie_link ml ON t.id = ml.movie_id WHERE cc.status_id IN ('3', '4') GROUP BY cct.kind, it.info ORDER BY count_of_movies DESC, sum_of_linked_movies DESC;
SELECT rt.ROLE AS role_type, COUNT(DISTINCT ci.id) AS total_actors, AVG(at.production_year) AS average_production_year, SUM(mc.company_id) AS total_companies_involved, COUNT(DISTINCT cn.id) AS total_character_names, COUNT(DISTINCT at.id) AS total_alternative_titles FROM cast_info ci JOIN role_type rt ON ci.role_id = rt.id JOIN aka_title at ON ci.movie_id = at.movie_id JOIN movie_companies mc ON ci.movie_id = mc.movie_id JOIN char_name cn ON ci.person_id = cn.id WHERE rt.ROLE = 'director' AND mc.company_type_id = 1 AND cn.md5sum IN ('4ddcdcf6282d436a10b411b7016b9fb2', '4e926214a66707706c1fe2bb2f000f18') AND at.note LIKE '%(video box title)%' GROUP BY rt.ROLE;
SELECT t.title AS movie_title, COUNT(DISTINCT mi.id) AS info_count, AVG(CAST(mi.info AS NUMERIC)) FILTER (WHERE it.info = 'rating') AS average_rating, SUM(mc.company_id) FILTER (WHERE mc.company_type_id = 1) AS sum_production_companies, COUNT(DISTINCT cc.id) AS cast_count, MAX(t.production_year) AS latest_production_year FROM title AS t JOIN movie_info AS mi ON t.id = mi.movie_id JOIN movie_companies AS mc ON t.id = mc.movie_id JOIN complete_cast AS cc ON t.id = cc.movie_id JOIN info_type AS it ON mi.info_type_id = it.id WHERE t.production_year > 1990 AND (mi.info_type_id IN (SELECT id FROM info_type WHERE info = 'rating' OR info = 'countries')) AND mc.company_type_id = 1 AND (mc.note NOT LIKE '%(USA)%' OR mc.note IS NULL) AND (cc.status_id = 1 OR cc.status_id = 2) GROUP BY t.title ORDER BY average_rating DESC, sum_production_companies DESC LIMIT 10;
SELECT kt.kind AS movie_kind, COUNT(DISTINCT ci.person_id) AS total_unique_actors, AVG(CAST(t.production_year AS DECIMAL)) AS average_production_year, AVG(CAST(sub.nr_roles AS DECIMAL)) AS average_roles_per_movie FROM title t INNER JOIN kind_type kt ON t.kind_id = kt.id LEFT JOIN ( SELECT movie_id, COUNT(*) AS nr_roles FROM cast_info GROUP BY movie_id ) sub ON t.id = sub.movie_id LEFT JOIN cast_info ci ON t.id = ci.movie_id WHERE t.production_year IS NOT NULL AND t.id IN ('19580', '17102', '17123', '10072') GROUP BY kt.kind;
SELECT it.info AS info_category, COUNT(pi.id) AS total_person_info_records, AVG(mi.movie_id) AS average_movie_id, SUM(CASE WHEN pi.note = 'anonymous' THEN 1 ELSE 0 END) AS anonymous_count, SUM(CASE WHEN pi.note = 'Spook Show Entertainment' THEN 1 ELSE 0 END) AS spook_show_count, MAX(pi.id) AS max_person_info_id, MIN(mi.id) AS min_movie_info_id FROM person_info pi JOIN info_type it ON pi.info_type_id = it.id JOIN movie_info mi ON pi.person_id = mi.movie_id JOIN comp_cast_type cct ON mi.info_type_id = cct.id AND cct.kind = 'complete' GROUP BY it.info HAVING COUNT(pi.id) > 5 ORDER BY total_person_info_records DESC;
SELECT COUNT(DISTINCT t.id) AS total_movies, AVG(t.production_year) AS average_production_year, SUM(CASE WHEN n.gender = 'F' THEN 1 ELSE 0 END) AS female_cast_count, SUM(CASE WHEN n.gender = 'M' THEN 1 ELSE 0 END) AS male_cast_count, COUNT(DISTINCT k.id) AS total_distinct_keywords, MAX(t.production_year) AS latest_production_year FROM title t INNER JOIN aka_title at ON t.id = at.movie_id INNER JOIN movie_info_idx mi ON t.id = mi.movie_id INNER JOIN name n ON n.md5sum = at.md5sum INNER JOIN keyword k ON k.phonetic_code = at.phonetic_code WHERE t.production_year BETWEEN 2000 AND 2010 AND mi.info_type_id IN ('100', '101', '99') AND at.episode_of_id IN ('14284', '16059', '8468', '2167', '20079', '24526') AND n.name_pcode_cf IN ('A4165', 'A3423') GROUP BY t.kind_id ORDER BY total_movies DESC;
SELECT cn.country_code, COUNT(DISTINCT mc.movie_id) AS number_of_movies, AVG(m_link.link_type_id) AS average_link_type_id, SUM(CASE WHEN n.gender = 'M' THEN 1 ELSE 0 END) AS male_actors_count, SUM(CASE WHEN n.gender = 'F' THEN 1 ELSE 0 END) AS female_actors_count FROM company_name cn JOIN movie_companies mc ON cn.id = mc.company_id JOIN movie_link m_link ON mc.movie_id = m_link.movie_id JOIN name n ON n.name_pcode_nf IN ('A6354', 'D1345') WHERE mc.company_type_id = 1 GROUP BY cn.country_code HAVING COUNT(DISTINCT mc.movie_id) > 10 ORDER BY number_of_movies DESC;
SELECT ct.kind AS company_kind, COUNT(DISTINCT cn.id) AS total_companies, AVG(ci.nr_order) AS average_order, SUM(CASE WHEN cct.kind = 'cast' THEN 1 ELSE 0 END) AS total_cast_roles, SUM(CASE WHEN cct.kind = 'crew' THEN 1 ELSE 0 END) AS total_crew_roles FROM company_name cn JOIN company_type ct ON cn.id = ct.id JOIN movie_companies mc ON cn.id = mc.company_id JOIN cast_info ci ON mc.movie_id = ci.movie_id JOIN comp_cast_type cct ON ci.person_role_id = cct.id WHERE (cn.name = 'Laska Productions' OR cn.name = 'Curzon Film World' OR cn.name = 'Jernigan Films' OR cn.name = 'Clark Productions') AND ct.kind IN ('production companies', 'distributors') AND ci.person_id IN (1732, 1053, 1788, 1668, 1056, 1817) AND ci.person_role_id IN (374, 366) AND cct.id IN (1, 2, 3, 4) GROUP BY ct.kind;
SELECT rt.role, COUNT(DISTINCT cn.id) AS total_characters, AVG(p.id) AS average_person_id, SUM(mc.company_id) AS total_company_id_sum, COUNT(DISTINCT k.id) AS total_unique_keywords FROM role_type rt LEFT JOIN char_name cn ON CAST(cn.id AS VARCHAR) = rt.id::varchar LEFT JOIN person_info p ON p.info_type_id = rt.id LEFT JOIN movie_companies mc ON mc.movie_id = cn.id LEFT JOIN keyword k ON k.id = mc.movie_id LEFT JOIN company_name cnm ON cnm.id = mc.company_id WHERE rt.role IN ('costume designer', 'miscellaneous crew', 'writer', 'actress', 'cinematographer', 'editor') AND mc.movie_id IN (12988, 12661, 11129, 26451, 19305, 12141) AND cnm.id IN (59673, 4533, 60539, 5934, 16779) GROUP BY rt.role ORDER BY total_unique_keywords DESC, total_characters DESC;
SELECT kt.kind AS movie_kind, COUNT(DISTINCT ci.movie_id) AS total_movies, AVG(ci.nr_order) AS average_cast_order, COUNT(DISTINCT pi.person_id) AS total_actors, COUNT(DISTINCT pi2.person_id) AS total_crew_members, COUNT(DISTINCT lt.id) AS total_link_types_used FROM cast_info ci JOIN kind_type kt ON ci.person_role_id = kt.id JOIN person_info pi ON ci.person_id = pi.person_id JOIN person_info pi2 ON ci.person_role_id = pi2.person_id AND pi2.info_type_id = ci.role_id JOIN link_type lt ON ci.role_id = lt.id WHERE ci.person_role_id IN (675, 613) AND pi.note NOT IN ('Jon C. Hopwood', 'CelebrityLoop.com', 'Adler and Associates Entertainment', 'Self.', 'ali aga') AND pi.info NOT IN ('15 August 1966', 'First president to live in the White House.', 'Rejowiec Fabryczny, Lubelskie, Poland') AND lt.id IN (15, 11, 8, 17) AND lt.link IN ('featured in', 'edited from', 'unknown link', 'spin off from', 'followed by') GROUP BY kt.kind;
