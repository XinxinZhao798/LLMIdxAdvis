SELECT it.info AS cast_completeness, COUNT(DISTINCT cc.movie_id) AS number_of_movies, AVG(ci.person_count) AS average_roles_per_person FROM (SELECT movie_id, COUNT(DISTINCT person_id) AS person_count FROM cast_info GROUP BY movie_id) ci JOIN complete_cast cc ON ci.movie_id = cc.movie_id JOIN info_type it ON cc.status_id = it.id GROUP BY it.info;
SELECT kt.kind, t.production_year AS production_year, COUNT(DISTINCT t.id) AS number_of_titles, AVG(CAST(mi_idx.info AS FLOAT)) FILTER (WHERE mi_idx.info_type_id = 101) AS average_rating, COUNT(cc.id) AS complete_cast_count FROM title AS t LEFT JOIN kind_type AS kt ON t.kind_id = kt.id LEFT JOIN movie_info_idx AS mi_idx ON t.id = mi_idx.movie_id LEFT JOIN complete_cast AS cc ON t.id = cc.movie_id WHERE t.kind_id IN (2, 7) GROUP BY kt.kind, production_year ORDER BY kt.kind, production_year DESC;
SELECT kt.kind AS movie_kind, AVG(title.production_year) AS average_production_year, COUNT(DISTINCT cast_info.person_id) AS number_of_actors, COUNT(DISTINCT company_name.id) AS number_of_companies, SUM(case when cast_info.role_id = 1 then 1 else 0 end) AS number_of_lead_roles, MAX(movie_info.info) AS longest_movie_info FROM title JOIN kind_type AS kt ON title.kind_id = kt.id JOIN cast_info ON title.id = cast_info.movie_id JOIN movie_companies ON title.id = movie_companies.movie_id JOIN company_name ON movie_companies.company_id = company_name.id JOIN movie_info ON title.id = movie_info.movie_id WHERE title.production_year >= 2000 AND cast_info.role_id = 1 AND movie_companies.company_type_id IN (SELECT id FROM company_name WHERE country_code = 'US') GROUP BY kt.kind ORDER BY average_production_year DESC, number_of_actors DESC;
SELECT n.name AS actor_name, COUNT(DISTINCT ci.movie_id) AS movies_participated, AVG(mi_idx_nr_order.avg_nr_order) AS average_cast_order, SUM(CASE WHEN mi_info.info LIKE '%budget%' THEN 1 ELSE 0 END) AS budget_movies_count, MAX(CASE WHEN mi_info.info_type_id = (SELECT id FROM movie_info_idx WHERE info = 'release dates') THEN mi_info.info ELSE NULL END) AS latest_release_date FROM name n JOIN cast_info ci ON ci.person_id = n.id LEFT JOIN (SELECT movie_id, AVG(nr_order) AS avg_nr_order FROM cast_info GROUP BY movie_id) mi_idx_nr_order ON mi_idx_nr_order.movie_id = ci.movie_id LEFT JOIN movie_info mi_info ON mi_info.movie_id = ci.movie_id WHERE n.gender = 'm' AND n.surname_pcode IN ('A416', 'A43', 'A413', 'A462') GROUP BY n.name ORDER BY movies_participated DESC, average_cast_order;
SELECT rt.ROLE AS role_type, COUNT(DISTINCT ci.id) AS total_actors, AVG(at.production_year) AS average_production_year, SUM(mc.company_id) AS total_companies_involved, COUNT(DISTINCT cn.id) AS total_character_names, COUNT(DISTINCT at.id) AS total_alternative_titles FROM cast_info ci JOIN role_type rt ON ci.role_id = rt.id JOIN aka_title at ON ci.movie_id = at.movie_id JOIN movie_companies mc ON ci.movie_id = mc.movie_id JOIN char_name cn ON ci.person_id = cn.id WHERE rt.ROLE = 'director' AND mc.company_type_id = 1 AND cn.md5sum IN ('4ddcdcf6282d436a10b411b7016b9fb2', '4e926214a66707706c1fe2bb2f000f18') AND at.note LIKE '%(video box title)%' GROUP BY rt.ROLE;
SELECT COUNT(DISTINCT akat.id) AS total_alternate_titles, AVG(akat.production_year) AS average_production_year, SUM(CASE WHEN mcomp.company_type_id = 1 THEN 1 ELSE 0 END) AS total_producer_companies, COUNT(DISTINCT k.id) AS total_unique_keywords, COUNT(DISTINCT mlink.movie_id) AS total_linked_movies, COUNT(DISTINCT n.id) AS total_people FROM aka_title AS akat JOIN movie_companies AS mcomp ON akat.movie_id = mcomp.movie_id JOIN movie_link AS mlink ON akat.movie_id = mlink.movie_id JOIN keyword AS k ON akat.movie_id IN (SELECT mk.movie_id FROM movie_keyword AS mk WHERE mk.keyword_id = k.id) JOIN name AS n ON akat.movie_id IN ( SELECT ci.movie_id FROM cast_info AS ci WHERE ci.person_id = n.id ) WHERE akat.kind_id = 1 AND mcomp.company_type_id IN (1, 2, 3) AND mlink.link_type_id IN (13, 15, 12, 2) AND k.id IN ('2959', '4902', '2890') AND n.id IN ('5102', '4144', '5253', '8021', '11905', '4985') GROUP BY mcomp.company_type_id ORDER BY total_producer_companies DESC;
SELECT it.info AS info_type, COUNT(DISTINCT pi.person_id) AS total_people, AVG(pi.person_id) AS average_person_id, MIN(t.production_year) AS earliest_production_year, MAX(t.production_year) AS latest_production_year, SUM(CASE WHEN ml.link_type_id = '16' THEN 1 ELSE 0 END) AS count_link_type_16, SUM(CASE WHEN ml.link_type_id = '7' THEN 1 ELSE 0 END) AS count_link_type_7, COUNT(DISTINCT mk.movie_id) AS total_movies_with_keywords, COUNT(DISTINCT aka.id) AS total_aka_names FROM person_info AS pi JOIN info_type AS it ON pi.info_type_id = it.id LEFT JOIN movie_link AS ml ON ml.movie_id = pi.person_id LEFT JOIN movie_keyword AS mk ON mk.movie_id = pi.person_id LEFT JOIN aka_name AS aka ON aka.person_id = pi.person_id LEFT JOIN title AS t ON t.id = pi.person_id WHERE pi.person_id IN ('9199', '7096', '7497', '4410', '8830') AND aka.md5sum IN ('777e5dd36014a444dcb9fd6b6e79db1b', 'c858ae027357bb0cc527c2bf2cd39730', 'bead886d98c81cafedcdcb186c8d7fc8') GROUP BY it.info;
SELECT cn.name AS company_name, ct.kind AS company_type, AVG(CAST(mi.info AS NUMERIC)) AS average_movie_rating, COUNT(DISTINCT mk.movie_id) AS number_of_movies_with_keywords, COUNT(DISTINCT aka.person_id) AS number_of_unique_actors FROM company_name cn JOIN company_type ct ON cn.id = ct.id JOIN movie_info mi ON cn.id = mi.movie_id AND mi.info_type_id = (SELECT id FROM info_type WHERE info = 'rating') JOIN movie_keyword mk ON mi.movie_id = mk.movie_id AND mk.keyword_id IN (107, 3961, 2524, 3462, 4021, 2764) JOIN aka_name aka ON aka.person_id = mk.movie_id WHERE cn.country_code IN ('[cl]', '[md]', '[ir]', '[ma]', '[ddde]', '[tt]') AND EXISTS (SELECT 1 FROM complete_cast cc WHERE cc.movie_id = mk.movie_id AND cc.status_id IN (4, 3)) GROUP BY cn.name, ct.kind ORDER BY average_movie_rating DESC, number_of_movies_with_keywords DESC, number_of_unique_actors DESC LIMIT 10;
SELECT n.name AS actor_name, COUNT(DISTINCT ci.movie_id) AS total_movies, AVG(mi.rating) AS average_rating, SUM(CASE WHEN p.gender = 'M' THEN 1 ELSE 0 END) AS male_actors_count, SUM(CASE WHEN p.gender = 'F' THEN 1 ELSE 0 END) AS female_actors_count FROM cast_info ci JOIN name n ON ci.person_id = n.id JOIN (SELECT movie_id, CAST(info AS NUMERIC) AS rating FROM movie_info WHERE info_type_id = (SELECT id FROM info_type WHERE info = 'rating') ) mi ON ci.movie_id = mi.movie_id JOIN person_info pi ON ci.person_id = pi.person_id JOIN name p ON pi.person_id = p.id GROUP BY n.name HAVING COUNT(DISTINCT ci.movie_id) > 5 ORDER BY average_rating DESC, total_movies DESC LIMIT 10;
