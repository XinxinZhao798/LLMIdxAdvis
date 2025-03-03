SELECT COUNT(DISTINCT mc.movie_id) AS total_movies, AVG(mi.info::integer) AS average_movie_length, SUM(CASE WHEN cc.status_id = 4 THEN 1 ELSE 0 END) AS total_completed_movies, SUM(CASE WHEN mc.note LIKE '%(TV)%' THEN 1 ELSE 0 END) AS total_tv_movies, COUNT(DISTINCT pi.person_id) AS total_people_with_info FROM movie_companies mc JOIN movie_info mi ON mc.movie_id = mi.movie_id LEFT JOIN complete_cast cc ON mc.movie_id = cc.movie_id LEFT JOIN person_info pi ON pi.info_type_id IN (21, 25, 35) WHERE mc.company_type_id IN (SELECT id FROM movie_companies WHERE note LIKE '%(USA)%') AND mi.info_type_id = (SELECT id FROM movie_info WHERE info = 'length') AND mc.note NOT LIKE '%(edited version)%' GROUP BY mc.company_id HAVING COUNT(DISTINCT mc.movie_id) > 5 ORDER BY total_movies DESC, average_movie_length DESC;
SELECT ct.kind AS company_kind, COUNT(DISTINCT mc.movie_id) AS number_of_movies, AVG(CAST(mi_idx.info AS numeric)) AS average_rating, SUM(CASE WHEN cct.kind = 'complete+verified' THEN 1 ELSE 0 END) AS complete_verified_casts, COUNT(DISTINCT cn.id) AS number_of_actors FROM movie_companies AS mc JOIN company_type AS ct ON mc.company_type_id = ct.id LEFT JOIN movie_info_idx AS mi_idx ON mc.movie_id = mi_idx.movie_id LEFT JOIN complete_cast AS cc ON mc.movie_id = cc.movie_id LEFT JOIN comp_cast_type AS cct ON cc.status_id = cct.id LEFT JOIN char_name AS cn ON cc.subject_id = cn.id WHERE mc.movie_id IN (27359, 1639517, 1663098) AND mc.company_id IN (SELECT company_id FROM movie_companies WHERE company_type_id IN (1, 2)) GROUP BY ct.kind HAVING COUNT(DISTINCT mc.movie_id) > 1 ORDER BY number_of_movies DESC, average_rating DESC;
SELECT cn.name AS company_name, COUNT(DISTINCT mi_idx.movie_id) AS number_of_movies, AVG(CAST(mi_idx.info AS NUMERIC)) AS average_runtime, SUM(CASE WHEN it.info = 'locations' THEN 1 ELSE 0 END) AS total_locations, COUNT(DISTINCT mk.keyword_id) AS unique_keywords, COUNT(DISTINCT cc.movie_id) AS complete_cast_movies FROM movie_info_idx AS mi_idx JOIN info_type AS it ON mi_idx.info_type_id = it.id JOIN movie_keyword AS mk ON mi_idx.movie_id = mk.movie_id JOIN complete_cast AS cc ON mi_idx.movie_id = cc.movie_id JOIN company_name AS cn ON cn.imdb_id = mi_idx.movie_id WHERE it.info IN ('runtimes', 'locations') AND cn.name_pcode_nf = 'G2642' GROUP BY cn.name ORDER BY average_runtime DESC, number_of_movies DESC;
SELECT ct.kind AS company_type, COUNT(*) AS total_movies, AVG(ak.production_year) AS average_production_year, SUM(CASE WHEN ci.role_id = 1 THEN 1 ELSE 0 END) AS total_actor_roles, SUM(CASE WHEN ci.person_role_id IN (444, 927, 278, 35) THEN 1 ELSE 0 END) AS specific_person_roles FROM company_name AS cn JOIN company_type AS ct ON cn.id = ct.id JOIN complete_cast AS cc ON cn.id = cc.movie_id JOIN aka_title AS ak ON cc.movie_id = ak.movie_id JOIN cast_info AS ci ON ak.movie_id = ci.movie_id WHERE cn.country_code = 'US' GROUP BY ct.kind HAVING COUNT(*) > 10 ORDER BY total_movies DESC;
SELECT cct.kind AS cast_type_kind, AVG(CAST(mi_idx.info AS NUMERIC)) AS average_info_numeric_value, COUNT(DISTINCT mi_idx.movie_id) AS unique_movies_count, COUNT(mi_idx.note) AS notes_count FROM comp_cast_type cct JOIN movie_info_idx mi_idx ON cct.id = mi_idx.info_type_id WHERE cct.kind IN ('crew', 'cast', 'complete+verified') AND mi_idx.info_type_id = 99 GROUP BY cct.kind ORDER BY average_info_numeric_value DESC;
