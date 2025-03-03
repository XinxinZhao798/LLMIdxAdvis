SELECT kt.kind, COUNT(DISTINCT mi.movie_id) AS movie_count, AVG(CAST(NULLIF(mi.info, '') AS numeric)) FILTER (WHERE it.info = 'rating') AS average_rating, SUM(CAST(NULLIF(mi.info, '') AS numeric)) FILTER (WHERE it.info = 'budget') AS total_budget FROM movie_info mi JOIN movie_keyword mk ON mi.movie_id = mk.movie_id JOIN kind_type kt ON kt.id = mk.keyword_id JOIN (SELECT id, info FROM movie_info WHERE info_type_id IN (SELECT id FROM info_type WHERE info IN ('rating', 'budget'))) it ON mi.id = it.id WHERE mi.movie_id IN (925861, 925697, 924285) AND kt.id IN (1, 5, 7) GROUP BY kt.kind;
SELECT kt.kind, COUNT(DISTINCT mk.movie_id) AS total_movies, COUNT(DISTINCT mk.keyword_id) AS unique_keywords, AVG(subquery.avg_keyword_count) AS average_keywords_per_movie FROM kind_type kt JOIN movie_keyword mk ON mk.movie_id = kt.id JOIN (SELECT movie_id, AVG(keyword_count) AS avg_keyword_count FROM (SELECT movie_id, COUNT(keyword_id) AS keyword_count FROM movie_keyword GROUP BY movie_id) AS sub GROUP BY movie_id) AS subquery ON subquery.movie_id = mk.movie_id WHERE kt.id IN (4, 3, 7) AND mk.keyword_id = 1463 GROUP BY kt.kind;
SELECT kt.kind, it.info AS genre, AVG(LENGTH(mi.info)) AS avg_info_length, COUNT(DISTINCT ml.movie_id) AS movie_count, COUNT(DISTINCT ml.link_type_id) AS link_type_count FROM kind_type kt JOIN movie_info mi ON mi.info IN ('Persian', 'Korean', 'Swedish', 'Kalmyk-Oirat', 'Cantonese', 'Estonian') JOIN info_type it ON it.id = mi.info_type_id AND it.info = 'genres' JOIN movie_link ml ON ml.movie_id = mi.movie_id JOIN link_type lt ON lt.id = ml.link_type_id AND lt.id IN ('3', '6', '13', '5', '10') WHERE kt.kind IN ('episode', 'tv series') AND mi.movie_id IN ('924200', '924460', '929898', '929803', '926981') GROUP BY kt.kind, it.info;
SELECT kt.kind AS movie_kind, AVG(CAST(mi.info AS INTEGER)) AS average_budget, COUNT(DISTINCT mc.movie_id) AS number_of_movies, COUNT(DISTINCT at.id) AS number_of_alternate_titles, SUM(CASE WHEN cc.status_id = 1 THEN 1 ELSE 0 END) AS completed_cast_count FROM movie_info mi JOIN movie_companies mc ON mc.movie_id = mi.movie_id JOIN kind_type kt ON kt.id = (SELECT kind_id FROM aka_title WHERE movie_id = mi.movie_id LIMIT 1) LEFT JOIN aka_title at ON at.movie_id = mi.movie_id LEFT JOIN complete_cast cc ON cc.movie_id = mi.movie_id WHERE mi.info_type_id = 3 AND mc.company_type_id = 2 AND mi.movie_id IN ('929898', '931171', '924369', '925167', '939922') AND kt.kind <> 'tv series' GROUP BY kt.kind ORDER BY average_budget DESC;
SELECT kt.kind AS content_type, COUNT(DISTINCT k.id) AS total_keywords, COUNT(DISTINCT n.id) AS total_people, AVG(n.imdb_id) AS average_imdb_id, COUNT(DISTINCT ak.id) AS total_aka_names, MAX(it.id) AS max_info_type_id, MIN(lt.id) AS min_link_type_id FROM kind_type kt LEFT JOIN keyword k ON kt.id = k.id LEFT JOIN name n ON n.surname_pcode = k.phonetic_code LEFT JOIN aka_name ak ON ak.person_id = n.id LEFT JOIN info_type it ON it.id = ak.id LEFT JOIN link_type lt ON lt.id = it.id GROUP BY kt.kind;
SELECT kt.kind AS movie_type, COUNT(DISTINCT ci.movie_id) AS movie_count, AVG(ci.nr_order) AS average_order_of_appearance, COUNT(DISTINCT pi.person_id) AS distinct_actors_count, SUM(CASE WHEN ci.role_id = 1 THEN 1 ELSE 0 END) AS total_lead_roles FROM cast_info ci JOIN kind_type kt ON ci.role_id = kt.id LEFT JOIN person_info pi ON ci.person_id = pi.person_id WHERE ci.person_role_id IN (1344, 1214) GROUP BY kt.kind ORDER BY movie_count DESC;
SELECT cct.kind AS cast_type_kind, AVG(mi_idx.info::numeric) AS average_movie_length, COUNT(DISTINCT mk.movie_id) AS number_of_movies_with_keywords, COUNT(DISTINCT pi.person_id) AS number_of_people_with_info FROM comp_cast_type cct JOIN movie_info_idx mi_idx ON cct.id = mi_idx.info_type_id JOIN movie_keyword mk ON mi_idx.movie_id = mk.movie_id JOIN person_info pi ON pi.info_type_id = mi_idx.info_type_id WHERE mk.keyword_id IN (3246, 2661, 3786) AND mi_idx.info_type_id = cct.id AND pi.info_type_id = cct.id GROUP BY cct.kind;
SELECT COUNT(DISTINCT ci.person_id) AS total_actors, AVG(ci.nr_order) AS average_cast_position, SUM(CASE WHEN lt.link LIKE '%producer%' THEN 1 ELSE 0 END) AS total_producers_linked, COUNT(DISTINCT mk.keyword_id) AS total_unique_keywords, COUNT(DISTINCT mc.company_id) AS total_companies_involved FROM cast_info ci JOIN movie_companies mc ON ci.movie_id = mc.movie_id JOIN movie_keyword mk ON ci.movie_id = mk.movie_id JOIN link_type lt ON mc.company_type_id = lt.id WHERE ci.person_role_id IS NOT NULL AND mc.note IS NULL AND ci.movie_id IN (SELECT movie_id FROM movie_companies WHERE id = '3813') GROUP BY ci.movie_id;
SELECT COUNT(DISTINCT cn.id) AS number_of_companies, kt.kind AS movie_kind, AVG(cc.status_id) AS average_status, SUM(CASE WHEN cn.country_code = '[fi]' THEN 1 ELSE 0 END) AS finnish_companies_count, COUNT(DISTINCT cc.movie_id) AS movies_count FROM company_name AS cn JOIN complete_cast AS cc ON cn.imdb_id = cc.movie_id JOIN kind_type AS kt ON cc.subject_id = kt.id WHERE cn.md5sum IN ('df5f53a18aca1956d39f4c3e8efba40d', '1f4fb34b400c593a88ee241792a10246', '528802a0236e52af987bb556a2a18522', '5dfe4406cd7d44d4e65cce35f75b02cb') AND kt.kind = 'video movie' AND cc.status_id IN (4, 3) AND cc.movie_id = 51584 GROUP BY kt.kind;
SELECT COUNT(DISTINCT ci.movie_id) AS num_movies, AVG(ci.nr_order) AS avg_cast_position, SUM(case when cct.kind = 'cast' then 1 else 0 end) AS total_cast_entries, SUM(case when cct.kind = 'crew' then 1 else 0 end) AS total_crew_entries, MAX(n.name) AS most_recently_added_person, COUNT(DISTINCT mc.company_id) AS num_companies_involved, COUNT(DISTINCT k.id) AS num_keywords_associated FROM cast_info ci JOIN complete_cast cc ON ci.movie_id = cc.movie_id JOIN comp_cast_type cct ON cc.subject_id = cct.id JOIN name n ON ci.person_id = n.id JOIN movie_companies mc ON ci.movie_id = mc.movie_id JOIN keyword k ON k.id = ANY (SELECT mk.keyword_id FROM movie_keyword mk WHERE mk.movie_id = ci.movie_id) WHERE mc.movie_id IN ('10521', '18817') AND cct.kind IN ('complete+verified', 'cast', 'crew', 'complete') GROUP BY cct.kind;
SELECT ct.kind AS company_kind, AVG(mc.id) AS average_movie_company_id, COUNT(DISTINCT k.id) AS total_distinct_keywords, SUM(CASE WHEN at.production_year > 2000 THEN 1 ELSE 0 END) AS movies_after_2000, COUNT(DISTINCT rt.id) AS total_distinct_roles FROM movie_companies AS mc JOIN company_type AS ct ON mc.company_type_id = ct.id JOIN aka_title AS at ON mc.movie_id = at.movie_id JOIN movie_link AS ml ON at.movie_id = ml.movie_id JOIN keyword AS k ON k.id = ml.id JOIN role_type AS rt ON rt.id = ml.link_type_id GROUP BY ct.kind HAVING COUNT(DISTINCT at.id) > 5;
SELECT rt.role AS role_type, COUNT(DISTINCT ci.person_id) AS number_of_persons, AVG(mi_idx.info::numeric) AS average_rating, SUM(CASE WHEN mi.info = 'Greek' THEN 1 ELSE 0 END) AS greek_language_movies, SUM(CASE WHEN mi.info = 'Hindi' THEN 1 ELSE 0 END) AS hindi_language_movies, SUM(CASE WHEN mi.info = 'Kyrgyz' THEN 1 ELSE 0 END) AS kyrgyz_language_movies FROM role_type AS rt JOIN cast_info AS ci ON rt.id = ci.role_id JOIN movie_info AS mi ON ci.movie_id = mi.movie_id JOIN movie_info_idx AS mi_idx ON mi.movie_id = mi_idx.movie_id WHERE rt.role = 'writer' AND mi_idx.info_type_id = (SELECT id FROM info_type WHERE info = 'rating') AND mi.info_type_id IN (SELECT id FROM info_type WHERE info IN ('languages', 'language')) GROUP BY rt.role;
SELECT it.info AS info_category, COUNT(DISTINCT mi.movie_id) AS total_movies, AVG(CASE WHEN n.gender = 'm' THEN 1.0 ELSE NULL END) AS avg_male_involvement, AVG(CASE WHEN n.gender = 'f' THEN 1.0 ELSE NULL END) AS avg_female_involvement, COUNT(DISTINCT an.person_id) AS unique_aka_names, SUM(CASE WHEN mi.info_type_id = 4 THEN 1 ELSE 0 END) AS count_info_type_4 FROM movie_info mi INNER JOIN info_type it ON mi.info_type_id = it.id LEFT JOIN aka_name an ON an.person_id = mi.movie_id LEFT JOIN name n ON n.id = mi.movie_id WHERE mi.info LIKE '%Mandarin%' OR mi.info_type_id IN ('47', '5', '7') OR n.surname_pcode IN ('A432', 'A416', 'A414') OR n.imdb_index IN ('VI', 'XVII', 'XIV', 'I') GROUP BY it.info;
SELECT ct.kind AS company_type, cn.country_code, COUNT(DISTINCT t.id) AS total_movies, AVG(t.imdb_id) AS average_imdb_id FROM title AS t JOIN movie_link AS ml ON t.id = ml.movie_id JOIN company_name AS cn ON cn.imdb_id = ml.linked_movie_id JOIN company_type AS ct ON cn.id = ct.id WHERE t.production_year BETWEEN 2010 AND 2020 AND cn.country_code IN ('US', 'GB', 'CA') GROUP BY ct.kind, cn.country_code ORDER BY total_movies DESC, average_imdb_id ASC;
SELECT kt.kind, COUNT(DISTINCT cn.id) AS num_companies, COUNT(DISTINCT mi.movie_id) AS num_movies, AVG(CAST(mi.info AS NUMERIC)) FILTER (WHERE it1.info = 'rating') AS avg_rating, SUM(CAST(mi.info AS NUMERIC)) FILTER (WHERE it1.info = 'budget') AS total_budget FROM kind_type AS kt JOIN movie_info AS mi ON mi.info_type_id = kt.id JOIN company_name AS cn ON cn.imdb_id = mi.movie_id JOIN movie_info AS it1 ON mi.movie_id = it1.movie_id AND it1.info_type_id = kt.id WHERE kt.id IN ('4', '5', '1') AND kt.kind IN ('episode', 'tv series', 'video game') AND mi.info_type_id IN (SELECT id FROM info_type WHERE info IN ('rating', 'budget')) GROUP BY kt.kind;
SELECT kt.kind AS movie_kind, count(DISTINCT ci.movie_id) AS num_movies, avg(ci.nr_order) AS avg_cast_order, count(DISTINCT pi.person_id) AS num_people, sum(case when pi.info LIKE '%tropical fever%' then 1 else 0 end) AS count_tropical_fever_mentions, min(a.name) AS example_actor_name, max(k.keyword) AS example_keyword FROM cast_info AS ci JOIN kind_type AS kt ON ci.movie_id = kt.id JOIN person_info AS pi ON ci.person_id = pi.person_id JOIN aka_name AS a ON ci.person_id = a.person_id JOIN keyword AS k ON pi.info LIKE '%' || k.keyword || '%' WHERE a.name_pcode_nf IN ('L6543', 'E3624', 'F6543', 'F6261', 'A5242', 'F6526') AND ci.person_id IN ('21277', '11977', '18600') GROUP BY kt.kind ORDER BY num_movies DESC;
SELECT kt.kind AS movie_kind, AVG(t.production_year) AS avg_production_year, SUM(CASE WHEN rt.role = 'actress' THEN 1 ELSE 0 END) AS total_actress_roles, SUM(CASE WHEN rt.role = 'producer' THEN 1 ELSE 0 END) AS total_producer_roles, COUNT(DISTINCT mc.company_id) AS number_of_companies_involved FROM title AS t JOIN kind_type AS kt ON t.kind_id = kt.id LEFT JOIN movie_companies AS mc ON t.id = mc.movie_id LEFT JOIN movie_info AS mi ON t.id = mi.movie_id LEFT JOIN role_type AS rt ON mi.info_type_id = rt.id AND rt.role IN ('actress', 'producer') GROUP BY kt.kind ORDER BY number_of_companies_involved DESC, avg_production_year;
SELECT rt.role, COUNT(DISTINCT n.id) AS number_of_people, AVG(t.production_year) AS average_production_year, MIN(t.production_year) AS earliest_production_year, MAX(t.production_year) AS latest_production_year, SUM(CASE WHEN mi.info = 'Cantonese' THEN 1 ELSE 0 END) AS cantonese_movies, SUM(CASE WHEN mi.info = 'Polish' THEN 1 ELSE 0 END) AS polish_movies, SUM(CASE WHEN mi.info = 'Russian' THEN 1 ELSE 0 END) AS russian_movies, SUM(CASE WHEN mi.info = 'Vietnamese' THEN 1 ELSE 0 END) AS vietnamese_movies, SUM(CASE WHEN mi.info = 'Faroese' THEN 1 ELSE 0 END) AS faroese_movies, SUM(CASE WHEN mi.info = 'Catalan' THEN 1 ELSE 0 END) AS catalan_movies FROM role_type rt JOIN movie_companies mc ON mc.company_type_id = rt.id JOIN title t ON mc.movie_id = t.id JOIN name n ON n.id = mc.company_id JOIN movie_info mi ON mi.movie_id = t.id AND mi.info_type_id = '4' WHERE rt.id = '8' AND rt.role = 'miscellaneous crew' GROUP BY rt.role;
SELECT COUNT(DISTINCT mk.movie_id) AS number_of_movies_with_keywords, AVG(sub.avg_keywords_per_movie) AS average_keywords_per_movie, SUM(sub.keyword_count) AS total_keywords, COUNT(DISTINCT pi.person_id) AS number_of_people_with_info FROM movie_keyword AS mk JOIN keyword AS k ON mk.keyword_id = k.id JOIN (SELECT mk.movie_id, COUNT(mk.keyword_id) AS keyword_count, AVG(COUNT(mk.keyword_id)) OVER () AS avg_keywords_per_movie FROM movie_keyword AS mk GROUP BY mk.movie_id) AS sub ON mk.movie_id = sub.movie_id LEFT JOIN person_info AS pi ON pi.info = k.keyword WHERE k.phonetic_code IN ('G2532', 'R232');
SELECT AVG(cast_info.nr_order) as average_nr_order, COUNT(DISTINCT cast_info.movie_id) as total_movies, COUNT(DISTINCT person_info.person_id) as total_people_involved, SUM(case when movie_companies.company_id IN (1253, 1225, 1085, 846, 859) then 1 else 0 end) as total_movies_by_selected_companies FROM cast_info JOIN movie_companies ON cast_info.movie_id = movie_companies.movie_id JOIN person_info ON cast_info.person_id = person_info.person_id WHERE cast_info.person_role_id = 181 AND person_info.info LIKE '%(19[789][0-9])%' GROUP BY cast_info.person_role_id;
SELECT cn.country_code, COUNT(DISTINCT cn.id) AS number_of_companies, COUNT(DISTINCT cc.movie_id) AS number_of_movies, COUNT(DISTINCT mc.movie_id) AS number_of_movies_with_companies, AVG(cc.status_id) AS average_status_id, SUM(CASE WHEN cc.status_id = 3 THEN 1 ELSE 0 END) AS status_id_3_count, SUM(CASE WHEN cc.status_id = 4 THEN 1 ELSE 0 END) AS status_id_4_count FROM company_name cn LEFT JOIN movie_companies mc ON cn.id = mc.company_id LEFT JOIN complete_cast cc ON mc.movie_id = cc.movie_id GROUP BY cn.country_code ORDER BY number_of_movies_with_companies DESC;
SELECT COUNT(DISTINCT an.id) AS number_of_aka_names, AVG(cc.status_id) AS average_status_id, SUM(CASE WHEN cct.kind = 'complete+verified' THEN 1 ELSE 0 END) AS complete_verified_count, SUM(CASE WHEN cct.kind = 'complete' THEN 1 ELSE 0 END) AS complete_count, COUNT(DISTINCT cc.movie_id) AS number_of_movies_with_complete_cast, SUM(CASE WHEN an.surname_pcode = 'P6' THEN 1 ELSE 0 END) AS surname_pcode_P6_count, SUM(CASE WHEN an.surname_pcode = 'A625' THEN 1 ELSE 0 END) AS surname_pcode_A625_count, SUM(CASE WHEN an.surname_pcode = 'C43' THEN 1 ELSE 0 END) AS surname_pcode_C43_count FROM aka_name AS an JOIN complete_cast AS cc ON an.person_id = cc.subject_id JOIN comp_cast_type AS cct ON cc.status_id = cct.id WHERE cc.movie_id IN ('1679404', '51426', '1649449', '1656947', '1656720', '2526470') AND cct.id IN ('1', '4');
SELECT lt.LINK AS link_type, COUNT(*) AS total_links, AVG(at.production_year) AS average_production_year, SUM(mc.company_type_id) AS sum_company_types, MIN(n.name) AS earliest_name_entry FROM movie_link AS ml JOIN link_type AS lt ON ml.link_type_id = lt.id JOIN aka_title AS at ON ml.movie_id = at.movie_id JOIN movie_companies AS mc ON mc.movie_id = at.movie_id JOIN name AS n ON n.imdb_id = ANY(ARRAY[at.movie_id, ml.linked_movie_id]) WHERE lt.id IN ('14', '15', '17', '12') AND mc.company_type_id BETWEEN 1 AND 10 AND n.gender = 'M' GROUP BY lt.LINK ORDER BY total_links DESC, average_production_year;
