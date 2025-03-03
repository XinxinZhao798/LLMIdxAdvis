SELECT kt.kind, COUNT(DISTINCT t.id) AS num_productions, AVG(cast_count.num_cast) AS avg_cast_members, MAX(t.production_year) AS latest_production_year, MIN(t.production_year) AS earliest_production_year FROM title t JOIN kind_type kt ON t.kind_id = kt.id LEFT JOIN ( SELECT movie_id, COUNT(*) AS num_cast FROM cast_info GROUP BY movie_id ) cast_count ON t.id = cast_count.movie_id GROUP BY kt.kind ORDER BY num_productions DESC, avg_cast_members DESC;
SELECT kt.kind AS movie_kind, avg(title.production_year) AS average_production_year, count(DISTINCT title.id) AS number_of_titles, count(DISTINCT cast_info.person_id) AS number_of_participants, count(DISTINCT movie_keyword.keyword_id) AS number_of_unique_keywords, sum(case when role_type.role = 'actor' then 1 else 0 end) AS number_of_actors, sum(case when role_type.role = 'actress' then 1 else 0 end) AS number_of_actresses FROM title JOIN kind_type AS kt ON title.kind_id = kt.id LEFT JOIN cast_info ON title.id = cast_info.movie_id LEFT JOIN role_type ON cast_info.role_id = role_type.id LEFT JOIN movie_keyword ON title.id = movie_keyword.movie_id WHERE kt.kind IN ('video movie', 'video game') AND title.production_year BETWEEN 2000 AND 2020 GROUP BY kt.kind;
SELECT lt.LINK AS link_type, COUNT(ml.id) AS total_links, AVG(n.imdb_id) AS average_imdb_id, SUM(CASE WHEN n.gender = 'm' THEN 1 ELSE 0 END) AS total_males, COUNT(DISTINCT ml.movie_id) AS unique_movies_linked FROM movie_link AS ml JOIN link_type AS lt ON ml.link_type_id = lt.id JOIN name AS n ON ml.linked_movie_id = n.id WHERE lt.LINK IN ('features', 'featured in', 'spin off from', 'follows', 'followed by') AND ml.linked_movie_id IN (2362378, 227254, 1337065, 1230549) GROUP BY lt.LINK ORDER BY total_links DESC;
SELECT COUNT(DISTINCT t.id) AS total_movies, AVG(t.production_year) AS average_production_year, COUNT(DISTINCT k.id) AS total_keywords, COUNT(DISTINCT p.person_id) AS total_persons_involved, COUNT(DISTINCT c.company_id) AS total_companies_involved, SUM(CASE WHEN k.keyword = 'sherlock-holmes' THEN 1 ELSE 0 END) AS sherlock_holmes_keyword_count, MAX(t.production_year) AS latest_movie_year, MIN(t.production_year) AS oldest_movie_year FROM title AS t JOIN movie_companies AS c ON t.id = c.movie_id JOIN complete_cast AS cc ON t.id = cc.movie_id JOIN keyword AS k ON k.id = ANY(ARRAY[4287, 1968]) JOIN person_info AS p ON p.info_type_id = ANY(ARRAY[34, 28, 32, 33]) JOIN link_type AS lt ON lt.id = ANY(ARRAY[4821, 4781, 1175]) AND lt.link IN ('spoofs', 'featured in', 'edited from') WHERE t.kind_id != 0 GROUP BY t.kind_id;
SELECT t.title AS original_title, COUNT(DISTINCT at.id) AS number_of_alternative_titles, AVG(CAST(mi_idx.info AS INTEGER)) AS average_movie_rating, SUM(CASE WHEN mc.company_type_id = 1 THEN 1 ELSE 0 END) AS number_of_production_companies, SUM(CASE WHEN mc.company_type_id = 2 THEN 1 ELSE 0 END) AS number_of_distribution_companies, COUNT(DISTINCT n.id) AS number_of_unique_actors FROM title t LEFT JOIN aka_title at ON t.id = at.movie_id LEFT JOIN movie_info_idx mi_idx ON t.id = mi_idx.movie_id AND mi_idx.info_type_id = 100 LEFT JOIN movie_companies mc ON t.id = mc.movie_id LEFT JOIN name n ON n.id IN ('7238', '8193', '11843', '6809', '6894', '6651') LEFT JOIN movie_info mi ON t.id = mi.movie_id AND mi.info_type_id = 3 WHERE t.production_year BETWEEN 1990 AND 2000 AND n.id IS NOT NULL AND mi.note IS NOT NULL GROUP BY t.title ORDER BY average_movie_rating DESC LIMIT 10;
SELECT ct.kind AS company_kind, AVG(mc.id) AS average_movie_company_id, COUNT(DISTINCT k.id) AS total_distinct_keywords, SUM(CASE WHEN at.production_year > 2000 THEN 1 ELSE 0 END) AS movies_after_2000, COUNT(DISTINCT rt.id) AS total_distinct_roles FROM movie_companies AS mc JOIN company_type AS ct ON mc.company_type_id = ct.id JOIN aka_title AS at ON mc.movie_id = at.movie_id JOIN movie_link AS ml ON at.movie_id = ml.movie_id JOIN keyword AS k ON k.id = ml.id JOIN role_type AS rt ON rt.id = ml.link_type_id GROUP BY ct.kind HAVING COUNT(DISTINCT at.id) > 5;
SELECT rt.ROLE, COUNT(DISTINCT ml.movie_id) AS num_movies, AVG(cn.imdb_id) AS avg_imdb_id, COUNT(DISTINCT k.id) AS num_keywords FROM role_type rt LEFT JOIN cast_info ci ON rt.id = ci.role_id LEFT JOIN char_name cn ON ci.person_role_id = cn.id LEFT JOIN movie_link ml ON ci.movie_id = ml.movie_id LEFT JOIN movie_keyword mk ON ml.movie_id = mk.movie_id LEFT JOIN keyword k ON mk.keyword_id = k.id GROUP BY rt.ROLE ORDER BY num_movies DESC, avg_imdb_id DESC;
SELECT AVG(CAST(mi_idx.info AS numeric)) AS average_rating, COUNT(DISTINCT t.id) AS total_movies, COUNT(DISTINCT mc.company_id) AS total_companies_involved, SUM(CASE WHEN t.production_year > 2000 THEN 1 ELSE 0 END) AS movies_after_2000 FROM title AS t JOIN movie_info_idx AS mi_idx ON t.id = mi_idx.movie_id JOIN movie_companies AS mc ON t.id = mc.movie_id JOIN company_name AS cn ON mc.company_id = cn.id JOIN company_type AS ct ON mc.company_type_id = ct.id JOIN info_type AS it ON mi_idx.info_type_id = it.id WHERE it.info = 'rating' AND cn.country_code IS NOT NULL AND ct.kind <> 'production companies' AND t.kind_id NOT IN (SELECT id FROM comp_cast_type WHERE kind = 'tv series') GROUP BY cn.country_code, ct.kind ORDER BY average_rating DESC, total_movies DESC;
SELECT t.title AS movie_title, t.production_year, COUNT(ci.id) AS total_cast, AVG(ci.nr_order) AS average_cast_order, COUNT(DISTINCT a.id) AS total_alternate_titles, SUM(CASE WHEN n.gender = 'm' THEN 1 ELSE 0 END) AS male_cast_count, SUM(CASE WHEN n.gender = 'f' THEN 1 ELSE 0 END) AS female_cast_count, COUNT(DISTINCT mi.id) AS total_movie_info_entries FROM title t LEFT JOIN cast_info ci ON t.id = ci.movie_id LEFT JOIN aka_title a ON t.id = a.movie_id LEFT JOIN name n ON ci.person_id = n.id LEFT JOIN movie_info mi ON t.id = mi.movie_id WHERE t.production_year > 2000 AND n.name_pcode_cf IN ('A264', 'A4312') AND ci.nr_order IN (20, 21, 42) AND ci.person_role_id IN (936, 1189, 544) AND a.episode_of_id IN (23907, 8118) GROUP BY t.title, t.production_year ORDER BY t.production_year DESC, total_cast DESC;
SELECT it.info AS information_type, COUNT(DISTINCT ml.movie_id) AS number_of_movies, COUNT(DISTINCT ml.linked_movie_id) AS number_of_linked_movies, AVG(n.imdb_id) AS average_imdb_id, MAX(k.keyword) AS most_common_keyword, SUM(CASE WHEN n.gender = 'F' THEN 1 ELSE 0 END) AS female_count, SUM(CASE WHEN n.gender = 'M' THEN 1 ELSE 0 END) AS male_count FROM movie_link AS ml JOIN info_type AS it ON ml.link_type_id = it.id JOIN name AS n ON ml.movie_id = n.id JOIN keyword AS k ON k.id = ml.id WHERE ml.link_type_id = 9 AND k.phonetic_code IN ('I4243', 'B43', 'D63', 'B4523', 'T521') AND ml.linked_movie_id IN (2406273, 1737708, 1377064) GROUP BY it.info;
