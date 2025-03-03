SELECT a.production_year, c.name as company_name, COUNT(DISTINCT a.movie_id) as number_of_titles, AVG(m.link_type_id) as average_link_type_id, SUM(CASE WHEN n.gender = 'F' THEN 1 ELSE 0 END) as female_count, SUM(CASE WHEN n.gender = 'M' THEN 1 ELSE 0 END) as male_count FROM aka_title a JOIN movie_link m ON a.movie_id = m.movie_id JOIN company_name c ON c.country_code = 'US' LEFT JOIN name n ON a.id = n.id WHERE a.production_year BETWEEN 1990 AND 2020 AND a.imdb_index IN ('I', 'IV') AND a.md5sum IN ('36b455987fe6d9fa28aa7bc9c575f2c2', 'c46fadf1cdd2338d8d67bb2b82a1f890') GROUP BY a.production_year, c.name ORDER BY a.production_year, c.name;
SELECT AVG(ak.title_count) AS average_titles_per_movie, SUM(mc.company_count) AS total_companies_involved, COUNT(DISTINCT n.id) AS unique_actors_count FROM (SELECT movie_id, COUNT(*) AS title_count FROM aka_title GROUP BY movie_id) ak JOIN aka_title at ON ak.movie_id = at.movie_id JOIN (SELECT movie_id, COUNT(*) AS company_count FROM movie_companies GROUP BY movie_id) mc ON at.movie_id = mc.movie_id JOIN complete_cast cc ON at.movie_id = cc.movie_id JOIN comp_cast_type cct ON cc.subject_id = cct.id JOIN name n ON cc.movie_id = n.id JOIN movie_companies mcom ON mcom.movie_id = ak.movie_id JOIN company_type ct ON mcom.company_type_id = ct.id JOIN link_type lt ON lt.id = 15 WHERE cct.kind = 'actors' AND ct.kind LIKE '%production%' AND lt.link = 'features' AND at.production_year BETWEEN 2000 AND 2010 GROUP BY ak.movie_id;
SELECT COUNT(DISTINCT t.id) AS number_of_movies, AVG(t.production_year) AS average_production_year, SUM(CASE WHEN at.episode_of_id IS NOT NULL THEN 1 ELSE 0 END) AS number_of_episodes, it.info AS info_type_description, COUNT(DISTINCT an.person_id) AS number_of_actors, COUNT(DISTINCT at.movie_id) AS number_of_aka_titles FROM title AS t LEFT JOIN aka_title AS at ON t.id = at.movie_id LEFT JOIN movie_info_idx AS mi_idx ON t.id = mi_idx.movie_id LEFT JOIN info_type AS it ON mi_idx.info_type_id = it.id LEFT JOIN aka_name AS an ON an.id = mi_idx.movie_id WHERE t.production_year BETWEEN 1990 AND 2020 AND (mi_idx.info_type_id IN (100, 101, 99) OR mi_idx.info IS NOT NULL) AND (at.episode_of_id IN (24960, 8508, 3016, 7633) OR at.episode_of_id IS NULL) AND an.surname_pcode IN ('T653', 'E164', 'H56', 'A526') GROUP BY it.info;
SELECT COUNT(DISTINCT a.id) AS total_aka_titles, AVG(a.production_year) AS average_production_year, COUNT(DISTINCT m.company_id) AS total_companies_involved, COUNT(DISTINCT n.id) AS total_unique_names, COUNT(DISTINCT ml.movie_id) AS total_movies_with_links, SUM(CASE WHEN a.production_year BETWEEN 1990 AND 2000 THEN 1 ELSE 0 END) AS titles_from_90s FROM aka_title AS a JOIN movie_companies AS m ON a.movie_id = m.movie_id JOIN name AS n ON n.md5sum = a.md5sum LEFT JOIN movie_link AS ml ON a.movie_id = ml.movie_id WHERE a.production_year IS NOT NULL AND m.note IS NOT NULL AND n.gender IN ('F', 'M') GROUP BY n.gender ORDER BY total_aka_titles DESC;
SELECT rt.ROLE, COUNT(DISTINCT ci.person_id) AS number_of_persons, AVG(ci.nr_order) AS average_order, SUM(mc.company_id) AS total_companies_involved, COUNT(DISTINCT mi.movie_id) AS number_of_movies_with_info FROM cast_info ci JOIN role_type rt ON ci.role_id = rt.id JOIN movie_companies mc ON ci.movie_id = mc.movie_id AND mc.company_type_id = 1 JOIN movie_info_idx mi ON ci.movie_id = mi.movie_id JOIN complete_cast cc ON ci.movie_id = cc.movie_id AND cc.subject_id = 1 WHERE ci.person_id IN (3767, 4155) AND ci.person_role_id IS NOT NULL AND mi.info LIKE '..00011111%' AND mi.info_type_id IN (15, 28, 24) GROUP BY rt.ROLE;
SELECT n.name AS actor_name, COUNT(DISTINCT ci.movie_id) AS total_movies, AVG(mi.rating) AS average_rating, SUM(CASE WHEN p.gender = 'M' THEN 1 ELSE 0 END) AS male_actors_count, SUM(CASE WHEN p.gender = 'F' THEN 1 ELSE 0 END) AS female_actors_count FROM cast_info ci JOIN name n ON ci.person_id = n.id JOIN (SELECT movie_id, CAST(info AS NUMERIC) AS rating FROM movie_info WHERE info_type_id = (SELECT id FROM info_type WHERE info = 'rating') ) mi ON ci.movie_id = mi.movie_id JOIN person_info pi ON ci.person_id = pi.person_id JOIN name p ON pi.person_id = p.id GROUP BY n.name HAVING COUNT(DISTINCT ci.movie_id) > 5 ORDER BY average_rating DESC, total_movies DESC LIMIT 10;
SELECT rt.ROLE AS role_type, COUNT(DISTINCT n.id) AS total_actors, AVG(nk.keyword_count) AS average_keywords_per_actor, SUM(nk.keyword_count) AS total_keywords FROM name AS n INNER JOIN ( SELECT mk.movie_id, COUNT(*) AS keyword_count FROM movie_keyword AS mk INNER JOIN keyword AS k ON mk.keyword_id = k.id WHERE k.phonetic_code IN ('H525', 'C4252', 'P3624', 'A543', 'F6526', 'M1525') GROUP BY mk.movie_id ) AS nk ON nk.movie_id = n.id INNER JOIN role_type AS rt ON rt.id IN ('1', '2', '6', '10', '5', '4') INNER JOIN movie_companies AS mc ON mc.movie_id = nk.movie_id WHERE n.gender IS NOT NULL GROUP BY rt.ROLE ORDER BY total_actors DESC;
SELECT ct.kind AS company_kind, COUNT(DISTINCT cc.id) AS total_complete_casts, COUNT(DISTINCT ml.id) AS total_movie_links, AVG(cc.status_id) AS average_status_id, SUM(CASE WHEN cc.subject_id = 1 THEN 1 ELSE 0 END) AS subject_1_cast_count FROM company_type ct LEFT JOIN complete_cast cc ON cc.subject_id = ct.id LEFT JOIN movie_link ml ON ml.movie_id = cc.movie_id GROUP BY ct.kind ORDER BY total_complete_casts DESC;
SELECT ct.kind AS company_kind, COUNT(DISTINCT mc.movie_id) AS num_movies, COUNT(DISTINCT ci.person_id) AS num_people_involved, AVG(ci.nr_order) AS average_cast_order, SUM(CASE WHEN n.gender = 'M' THEN 1 ELSE 0 END) AS num_male_actors, SUM(CASE WHEN n.gender = 'F' THEN 1 ELSE 0 END) AS num_female_actors FROM movie_companies AS mc JOIN company_type AS ct ON mc.company_type_id = ct.id LEFT JOIN cast_info AS ci ON mc.movie_id = ci.movie_id LEFT JOIN name AS n ON ci.person_id = n.id WHERE ct.id IN (2, 3, 4) GROUP BY ct.kind
SELECT t.production_year, COUNT(DISTINCT t.id) AS number_of_movies, AVG(t.season_nr) AS average_season_number, SUM(mov_comp.company_id) AS total_company_contributions, rt.ROLE, COUNT(DISTINCT cn.id) AS number_of_companies, COUNT(DISTINCT an.person_id) AS number_of_actors_with_aliases, MAX(t.episode_nr) AS max_episode_number FROM title AS t JOIN movie_companies AS mov_comp ON mov_comp.movie_id = t.id JOIN company_name AS cn ON cn.id = mov_comp.company_id JOIN role_type AS rt ON rt.id = mov_comp.company_type_id LEFT JOIN aka_name AS an ON an.person_id = t.id WHERE t.production_year BETWEEN 1990 AND 2020 AND cn.name IN ('Vestron UK', 'Messina Films') AND rt.id = 9 AND t.id IN ('17038', '13408', '18586', '19239', '26429') GROUP BY t.production_year, rt.ROLE ORDER BY t.production_year DESC, number_of_movies DESC;
SELECT COUNT(DISTINCT cn.id) AS total_characters, AVG(mii.movie_id) AS average_movie_id, SUM(CASE WHEN kt.keyword_id IS NOT NULL THEN 1 ELSE 0 END) AS total_keywords_linked, COUNT(DISTINCT cc.movie_id) AS total_movies_with_complete_cast, MAX(mii_idx.info) AS max_movie_votes FROM char_name cn LEFT JOIN movie_info_idx mii_idx ON cn.id = mii_idx.movie_id LEFT JOIN complete_cast cc ON cc.movie_id = mii_idx.movie_id LEFT JOIN movie_info_idx mii ON mii.movie_id = cc.movie_id LEFT JOIN keyword k ON k.phonetic_code LIKE 'A%' LEFT JOIN ( SELECT mk.movie_id, mk.keyword_id FROM movie_keyword mk INNER JOIN keyword k ON k.id = mk.keyword_id WHERE k.phonetic_code = 'A323' OR k.phonetic_code = 'B124' ) AS kt ON kt.movie_id = mii.movie_id WHERE cn.name_pcode_nf IN ('C614', 'J525', 'C6346', 'A4152') AND cc.id IN ('2966', '2652', '3214', '2072', '724', '2015') GROUP BY cn.surname_pcode;
SELECT it.info AS info_category, COUNT(DISTINCT n.id) AS total_people, COUNT(DISTINCT pi.person_id) AS people_with_info, AVG(n.imdb_id) AS average_imdb_id, SUM(CASE WHEN n.gender = 'M' THEN 1 ELSE 0 END) AS total_males, SUM(CASE WHEN n.gender = 'F' THEN 1 ELSE 0 END) AS total_females FROM name AS n LEFT JOIN person_info AS pi ON n.id = pi.person_id JOIN info_type AS it ON pi.info_type_id = it.id GROUP BY it.info;
SELECT rt.ROLE, COUNT(*) AS role_count, AVG(ci.nr_order) AS average_order, SUM(ci.nr_order) AS total_order, MAX(ci.nr_order) AS max_order, MIN(ci.nr_order) AS min_order FROM cast_info ci JOIN role_type rt ON ci.role_id = rt.id JOIN movie_keyword mk ON ci.movie_id = mk.movie_id JOIN movie_info mi ON ci.movie_id = mi.movie_id JOIN movie_link ml ON ci.movie_id = ml.movie_id WHERE mk.keyword_id IN (3544, 4170, 355, 3797, 2901) AND ci.movie_id IN (14730, 8894, 18741, 18773, 15355, 12280, 2069434, 2317758, 2267299) GROUP BY rt.ROLE ORDER BY role_count DESC, average_order;
SELECT t.production_year, COUNT(DISTINCT t.id) AS number_of_movies, AVG(mi_idx.info::numeric) AS average_rating, SUM(CASE WHEN mc.company_type_id = 1 THEN 1 ELSE 0 END) AS number_of_productions, SUM(CASE WHEN mc.company_type_id = 2 THEN 1 ELSE 0 END) AS number_of_distributions FROM title AS t JOIN movie_companies AS mc ON t.id = mc.movie_id JOIN movie_info_idx AS mi_idx ON t.id = mi_idx.movie_id AND mi_idx.info_type_id = 101 LEFT JOIN movie_info AS mi ON t.id = mi.movie_id AND mi.info_type_id = 3 WHERE t.kind_id = 1 AND mc.company_type_id IN (1, 2) AND t.production_year BETWEEN 2000 AND 2020 GROUP BY t.production_year ORDER BY t.production_year;
SELECT MAX(cn.name) AS company_name, ct.kind AS company_kind, COUNT(DISTINCT cn.id) AS num_companies, AVG(cn.imdb_id) AS average_imdb_id, COUNT(DISTINCT cct.id) AS cast_type_count, SUM(CASE WHEN cn.country_code = 'US' THEN 1 ELSE 0 END) AS us_based_companies, COUNT(DISTINCT it.id) AS info_type_count, COUNT(DISTINCT lt.id) AS link_type_count FROM company_name cn JOIN company_type ct ON cn.id = ct.id JOIN comp_cast_type cct ON cn.id = cct.id JOIN info_type it ON cn.id = it.id JOIN link_type lt ON cn.id = lt.id WHERE cn.country_code IN ('US', 'JP', 'FR') AND cn.name_pcode_sf IN ('M3652', 'A6163', 'L2641', 'D6123') AND ct.id IN (1, 2, 3, 4) AND ct.kind IN ('special effects companies', 'miscellaneous companies', 'production companies', 'distributors') GROUP BY ct.kind ORDER BY us_based_companies DESC, num_companies DESC;
SELECT lt.LINK AS link_type, COUNT(DISTINCT ml.movie_id) AS total_movies, AVG(ak.production_year) AS average_production_year, SUM(CASE WHEN ak.note LIKE '%(USA)%' THEN 1 ELSE 0 END) AS total_us_titles, COUNT(DISTINCT mk.keyword_id) AS distinct_keywords_used, COUNT(DISTINCT n.id) AS number_of_contributors FROM movie_link AS ml JOIN link_type AS lt ON ml.link_type_id = lt.id JOIN aka_title AS ak ON ml.movie_id = ak.movie_id JOIN movie_keyword AS mk ON ml.movie_id = mk.movie_id JOIN name AS n ON ak.id = n.id WHERE ak.title IS NOT NULL AND n.gender IN ('m', 'f') AND lt.id IN (3, 6) GROUP BY lt.LINK ORDER BY total_movies DESC;
SELECT ct.kind AS cast_type, AVG(movcomp_notes.note_length) AS average_note_length, COUNT(DISTINCT movcomp.movie_id) AS number_of_movies, COUNT(DISTINCT comp.name) AS number_of_companies, SUM(CASE WHEN movcomp.company_type_id = 1 THEN 1 ELSE 0 END) AS number_of_producers, MAX(comp_cast.subject_id) AS max_subject_id_for_cast_type FROM complete_cast AS comp_cast JOIN comp_cast_type AS ct ON comp_cast.subject_id = ct.id JOIN movie_companies AS movcomp ON movcomp.movie_id = comp_cast.movie_id JOIN company_name AS comp ON movcomp.company_id = comp.id LEFT JOIN (SELECT movie_id, LENGTH(note) AS note_length FROM movie_companies) AS movcomp_notes ON movcomp.movie_id = movcomp_notes.movie_id WHERE comp_cast.id IN (4264, 2513, 575, 1032) AND comp_cast.subject_id = 1 AND ct.id = 4 GROUP BY ct.kind;
SELECT kt.kind, COUNT(DISTINCT at.movie_id) AS num_movies, AVG(at.production_year) AS avg_production_year, COUNT(DISTINCT ml.movie_id) AS num_linked_movies, COUNT(DISTINCT cn.id) AS num_companies_involved, SUM(CASE WHEN at.kind_id = 4 THEN 1 ELSE 0 END) AS count_video_movie, SUM(CASE WHEN at.kind_id = 7 THEN 1 ELSE 0 END) AS count_tv_movie FROM aka_title at JOIN kind_type kt ON at.kind_id = kt.id LEFT JOIN movie_link ml ON at.movie_id = ml.movie_id LEFT JOIN company_name cn ON cn.id = ANY(ARRAY[68879, 29883]) WHERE kt.id IN (4, 7) AND kt.kind IN ('video movie', 'tv movie') AND ml.linked_movie_id IN (577922, 468657, 898205, 1933962) GROUP BY kt.kind ORDER BY num_movies DESC;
SELECT COUNT(DISTINCT ci.movie_id) AS number_of_movies, AVG(mi_idx_cnt.count) AS average_keywords_per_movie, SUM(case when n.gender = 'M' then 1 else 0 end) AS male_actors_count, SUM(case when f.gender = 'F' then 1 else 0 end) AS female_actors_count, MIN(n.name) AS most_common_male_actor_name, MIN(f.name) AS most_common_female_actor_name FROM cast_info ci LEFT JOIN name n ON ci.person_id = n.id AND n.gender = 'M' LEFT JOIN name f ON ci.person_id = f.id AND f.gender = 'F' LEFT JOIN ( SELECT movie_id, COUNT(keyword_id) AS count FROM movie_keyword GROUP BY movie_id ) mi_idx_cnt ON ci.movie_id = mi_idx_cnt.movie_id WHERE ci.nr_order = 1 GROUP BY ci.person_id;
SELECT SUM(mc.company_id) AS total_company_ids, AVG(CASE WHEN mc.company_type_id = 1 THEN mc.movie_id ELSE NULL END) AS average_movie_id_for_type_1, COUNT(DISTINCT ml.link_type_id) AS unique_link_types, COUNT(DISTINCT pi.person_id) AS unique_person_count, AVG(CASE WHEN pi.info_type_id = 5 THEN LENGTH(pi.info) ELSE NULL END) AS average_info_length_for_type_5 FROM movie_companies mc FULL OUTER JOIN movie_link ml ON mc.movie_id = ml.movie_id FULL OUTER JOIN person_info pi ON mc.company_id = pi.person_id GROUP BY mc.company_type_id;
SELECT ct.kind AS company_type, AVG(akat.production_year) AS average_production_year, COUNT(DISTINCT mki.movie_id) AS total_movies, COUNT(DISTINCT kw.id) AS total_unique_keywords, SUM(CASE WHEN akat.note LIKE '%(USA)%' THEN 1 ELSE 0 END) AS total_usa_dubbed_versions FROM aka_title akat JOIN movie_keyword mkw ON akat.movie_id = mkw.movie_id JOIN keyword kw ON mkw.keyword_id = kw.id JOIN movie_info_idx mki ON akat.movie_id = mki.movie_id JOIN company_type ct ON mki.info_type_id = ct.id WHERE akat.production_year BETWEEN 2000 AND 2020 GROUP BY ct.kind ORDER BY total_movies DESC;
SELECT ct.kind AS company_kind, AVG(mi.info::numeric) AS average_movie_length, COUNT(DISTINCT ci.person_id) AS number_of_actors, COUNT(DISTINCT mc.movie_id) AS number_of_movies, COUNT(DISTINCT ml.link_type_id) AS distinct_link_types, SUM(CASE WHEN pi.info_type_id = '26' THEN 1 ELSE 0 END) AS count_info_type_26, SUM(CASE WHEN pi.info_type_id = '23' THEN 1 ELSE 0 END) AS count_info_type_23, SUM(CASE WHEN pi.info_type_id = '34' THEN 1 ELSE 0 END) AS count_info_type_34 FROM movie_companies AS mc JOIN comp_cast_type AS ct ON mc.company_type_id = ct.id JOIN movie_info AS mi ON mc.movie_id = mi.movie_id JOIN cast_info AS ci ON mc.movie_id = ci.movie_id JOIN movie_link AS ml ON mc.movie_id = ml.movie_id JOIN person_info AS pi ON ci.person_id = pi.person_id WHERE mi.info_type_id = (SELECT id FROM info_type WHERE info = 'runtime') AND mc.note NOT LIKE '%(TV)%' AND mc.note LIKE '%(USA)%' AND pi.person_id IN ('2159', '1740245', '2140') GROUP BY ct.kind HAVING COUNT(DISTINCT ci.person_id) > 10;
SELECT COUNT(DISTINCT akn.id) AS total_aka_names, COUNT(DISTINCT n.id) AS total_names, COUNT(DISTINCT pi.id) AS total_person_infos, AVG(n.imdb_id) AS average_imdb_id, MAX(ct.kind) AS largest_company_type, MIN(k.keyword) AS first_keyword FROM aka_name akn INNER JOIN name n ON akn.person_id = n.id INNER JOIN person_info pi ON n.id = pi.person_id LEFT JOIN company_type ct ON ct.id = pi.info_type_id LEFT JOIN keyword k ON k.phonetic_code = 'M4314' WHERE akn.surname_pcode = 'G235' AND (n.md5sum = '027846e5567882de4f67c71cfac3ae12' OR n.md5sum = 'f3a34ae0735af63ad03a7b5fb923a27e' OR n.md5sum = '073c556aa9cb435efd04b6f217cb153f' OR n.md5sum = '6f661ba1a459d8ee448710953f2f2216' OR n.md5sum = '144786e8a288b6b896bdb277a8bf9155') AND pi.info_type_id IN ('20', '23', '26', '28') GROUP BY k.keyword ORDER BY total_aka_names DESC, total_names DESC, total_person_infos DESC;
SELECT cct.kind AS cast_type, COUNT(DISTINCT mk.movie_id) AS movie_count, COUNT(mk.id) AS keyword_count, AVG(ct.id) AS average_company_type_id FROM comp_cast_type cct JOIN movie_keyword mk ON cct.id = mk.movie_id JOIN company_type ct ON mk.keyword_id = ct.id GROUP BY cct.kind HAVING COUNT(DISTINCT mk.movie_id) > 5 ORDER BY movie_count DESC, keyword_count DESC;
SELECT MIN(t.title) AS movie_title, MIN(at.title) AS alternative_title, AVG(ci.nr_order) AS average_cast_order, COUNT(DISTINCT t.id) AS number_of_movies, COUNT(DISTINCT ci.person_id) AS number_of_unique_actors, SUM(CASE WHEN t.production_year BETWEEN 1970 AND 1980 THEN 1 ELSE 0 END) AS movies_produced_1970_to_1980, SUM(CASE WHEN t.production_year BETWEEN 1981 AND 1990 THEN 1 ELSE 0 END) AS movies_produced_1981_to_1990, SUM(CASE WHEN t.production_year BETWEEN 1991 AND 2000 THEN 1 ELSE 0 END) AS movies_produced_1991_to_2000 FROM title AS t INNER JOIN aka_title AS at ON t.id = at.movie_id AND at.kind_id IN (1, 3) INNER JOIN cast_info AS ci ON t.id = ci.movie_id WHERE t.production_year IN (1985, 1975, 1950, 1972) GROUP BY t.kind_id HAVING COUNT(DISTINCT ci.person_id) > 10 ORDER BY number_of_movies DESC, average_cast_order;
SELECT lt.LINK AS link_type, COUNT(DISTINCT ml.movie_id) AS number_of_movies, COUNT(DISTINCT ml.linked_movie_id) AS number_of_linked_movies, AVG(kw.id) AS average_keyword_id, MAX(n.name) AS most_common_name, SUM(CASE WHEN n.gender = 'm' THEN 1 ELSE 0 END) AS male_count, SUM(CASE WHEN n.gender <> 'm' THEN 1 ELSE 0 END) AS non_male_count FROM movie_link AS ml JOIN link_type AS lt ON ml.link_type_id = lt.id JOIN cast_info AS ci ON ml.movie_id = ci.movie_id JOIN keyword AS kw ON ci.id = kw.id JOIN name AS n ON ci.person_id = n.id GROUP BY lt.LINK ORDER BY number_of_movies DESC, number_of_linked_movies DESC;
SELECT rt.ROLE, COUNT(DISTINCT cn.id) AS total_characters, COUNT(DISTINCT pi.person_id) AS total_people, COUNT(DISTINCT cc.movie_id) AS total_movies, AVG(pi.id) AS average_person_info_id, SUM(ct.id) AS sum_company_type_ids FROM role_type rt JOIN char_name cn ON cn.md5sum IN ('87fb1da22896f8674cfb742fe549ec67', 'bf85b5265ca46bac451dcdce6f3625f7', '74802eebae1a12921215b7402178254c') JOIN person_info pi ON pi.person_id = cn.id JOIN complete_cast cc ON cc.subject_id = cn.id JOIN company_type ct ON ct.id = 2 WHERE rt.ROLE IN ('actress', 'miscellaneous crew', 'editor', 'director', 'composer') AND pi.note IN ('frankfob2@yahoo.com', 'Deception Films', 'CelebrityLoop.com', 'Spook Show Entertainment', 'E Adamson') AND pi.person_id IN ('3716', '1740595') GROUP BY rt.ROLE ORDER BY total_movies DESC;
SELECT kt.kind AS movie_type, MIN(at.title) AS example_movie, COUNT(DISTINCT mk.movie_id) AS total_movies_with_keywords, AVG(at.production_year) AS average_production_year, SUM(CASE WHEN at.note LIKE '%(imdb display title)%' THEN 1 ELSE 0 END) AS imdb_display_title_count FROM aka_title at JOIN kind_type kt ON at.kind_id = kt.id JOIN movie_keyword mk ON at.movie_id = mk.movie_id JOIN movie_info mi ON at.movie_id = mi.movie_id WHERE at.production_year BETWEEN 1990 AND 2020 AND at.note LIKE '%(imdb display title)%' AND mi.movie_id IN ('931220', '926777', '925133') GROUP BY kt.kind HAVING COUNT(DISTINCT at.movie_id) > 10 ORDER BY total_movies_with_keywords DESC;
SELECT kt.kind AS movie_kind, COUNT(DISTINCT ci.movie_id) AS number_of_movies, AVG(ci.nr_order) AS average_cast_order, COUNT(DISTINCT cn.id) AS number_of_characters, SUM(CASE WHEN mi_idx.info_type_id = '100' THEN 1 ELSE 0 END) AS count_of_type_100_info, SUM(CASE WHEN mi_idx.info_type_id = '101' THEN 1 ELSE 0 END) AS count_of_type_101_info FROM cast_info ci JOIN kind_type kt ON ci.role_id = kt.id JOIN char_name cn ON ci.person_id = cn.id JOIN movie_info_idx mi_idx ON ci.movie_id = mi_idx.movie_id WHERE ci.person_id IN ('1761', '1644', '1317', '1004') AND cn.name_pcode_nf IN ('W4126', 'D563', 'P3632') AND kt.id IN ('7', '3', '5') AND mi_idx.info_type_id IN ('100', '101') GROUP BY kt.kind;
SELECT ct.kind AS company_type, COUNT(DISTINCT cn.name) AS distinct_company_names, COUNT(DISTINCT cn.country_code) AS distinct_country_codes, AVG(cc.movie_id) AS average_movie_id, SUM(CASE WHEN rt.role = 'producer' THEN 1 ELSE 0 END) AS total_producers, SUM(CASE WHEN rt.role = 'editor' THEN 1 ELSE 0 END) AS total_editors, COUNT(DISTINCT cc.movie_id) AS distinct_movies_with_complete_cast, MAX(cc.status_id) AS max_status_id FROM company_name cn JOIN company_type ct ON cn.id = ct.id JOIN complete_cast cc ON cc.movie_id = cn.imdb_id JOIN role_type rt ON rt.id = cc.subject_id WHERE cn.country_code != 'US' AND rt.role IN ('guest', 'actress', 'editor', 'producer') GROUP BY ct.kind ORDER BY total_producers DESC;
