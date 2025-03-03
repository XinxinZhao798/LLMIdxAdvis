SELECT hd.hd_income_band_sk, count(distinct c.c_customer_sk) AS num_customers, sum(cs.cs_quantity) AS total_sales_quantity, sum(cs.cs_net_paid) AS total_sales_amount, sum(sr.sr_return_quantity) AS total_returned_quantity, sum(sr.sr_return_amt) AS total_returned_amount, sum(cs.cs_net_profit) - sum(coalesce(sr.sr_net_loss, 0)) AS net_profit FROM customer c JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk LEFT JOIN catalog_sales cs ON c.c_customer_sk = cs.cs_bill_customer_sk LEFT JOIN store_returns sr ON c.c_customer_sk = sr.sr_customer_sk WHERE hd.hd_income_band_sk IN ('17', '12', '15', '6', '4', '19') AND (cs.cs_sold_date_sk IS NOT NULL OR sr.sr_returned_date_sk IS NOT NULL) GROUP BY hd.hd_income_band_sk ORDER BY net_profit DESC;
SELECT hd.hd_income_band_sk, SUM(sr.sr_return_quantity) AS total_returned_quantity, AVG(sr.sr_return_amt) AS average_return_amount, COUNT(DISTINCT sr.sr_customer_sk) AS unique_customers_returned, SUM(CASE WHEN p.p_channel_email = 'Y' THEN sr.sr_return_quantity ELSE 0 END) AS email_promo_returned_quantity, SUM(sr.sr_net_loss) AS total_net_loss FROM store_returns sr JOIN household_demographics hd ON sr.sr_hdemo_sk = hd.hd_demo_sk JOIN promotion p ON sr.sr_item_sk = p.p_item_sk JOIN inventory i ON sr.sr_item_sk = i.inv_item_sk AND i.inv_warehouse_sk = 1 WHERE hd.hd_demo_sk IN (1588, 4700) AND sr.sr_refunded_cash IN (10.38, 1818.70) GROUP BY hd.hd_income_band_sk ORDER BY total_net_loss DESC;
SELECT c.c_customer_id, c.c_first_name, c.c_last_name, cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, SUM(cr.cr_return_quantity) AS total_catalog_return_quantity, AVG(cr.cr_return_amount) AS avg_catalog_return_amount, COUNT(DISTINCT cr.cr_order_number) AS num_catalog_orders_returned, SUM(sr.sr_return_quantity) AS total_store_return_quantity, AVG(sr.sr_return_amt) AS avg_store_return_amount, COUNT(DISTINCT sr.sr_ticket_number) AS num_store_tickets_returned, (SUM(cr.cr_return_quantity) + SUM(sr.sr_return_quantity)) AS total_combined_return_quantity, (SUM(cr.cr_return_amount) + SUM(sr.sr_return_amt)) AS total_combined_return_amount FROM customer c JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk LEFT JOIN catalog_returns cr ON c.c_customer_sk = cr.cr_refunded_customer_sk LEFT JOIN store_returns sr ON c.c_customer_sk = sr.sr_customer_sk WHERE cd.cd_dep_college_count = 0 AND (cd.cd_dep_count = 1 OR cd.cd_dep_count = 2) AND (c.c_birth_month IN (1, 5, 8)) AND (cr.cr_refunded_cdemo_sk IN (720990, 944590, 673975, 63720) OR cr.cr_refunded_cdemo_sk IS NULL) AND (sr.sr_ticket_number::text IN ('40123', '36273') OR sr.sr_ticket_number IS NULL) GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name, cd.cd_gender, cd.cd_marital_status, cd.cd_education_status ORDER BY total_combined_return_amount DESC, c.c_customer_id;
SELECT ws2.web_name AS website, ws2.web_market_manager AS market_manager, cd.cd_gender AS customer_gender, SUM(ws.ws_sales_price) AS total_sales, AVG(ws.ws_sales_price) AS average_sales, COUNT(DISTINCT ws.ws_order_number) AS number_of_orders, SUM(ws.ws_quantity) AS total_quantity_sold, COUNT(DISTINCT c.c_customer_sk) AS number_of_customers, ca.ca_state AS customer_state, ca.ca_city AS customer_city FROM web_sales ws JOIN web_site ws2 ON ws.ws_web_site_sk = ws2.web_site_sk JOIN customer c ON ws.ws_ship_customer_sk = c.c_customer_sk JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk WHERE ws.ws_sold_date_sk BETWEEN 2450815 AND 2450815 + 30 AND ws.ws_promo_sk = 212 AND ws2.web_market_manager IN ('Jeffrey Martin', 'William Reyes', 'Kelvin Lynch', 'Frank Cooper', 'Keith Williams', 'John Isaacs') AND ca.ca_gmt_offset BETWEEN -5 AND -3 GROUP BY ws2.web_name, ws2.web_market_manager, cd.cd_gender, ca.ca_state, ca.ca_city ORDER BY total_sales DESC, number_of_orders DESC;
SELECT s.s_store_name, p.p_promo_name, i.ib_lower_bound, i.ib_upper_bound, SUM(ws.ws_quantity) AS total_quantity_sold, AVG(ws.ws_sales_price) AS average_sales_price, COUNT(DISTINCT ws.ws_order_number) AS unique_orders, SUM(ws.ws_net_paid_inc_tax) AS total_revenue_inc_tax, SUM(CASE WHEN ws.ws_promo_sk IS NOT NULL THEN ws.ws_quantity ELSE 0 END) AS promo_quantity_sold, SUM(CASE WHEN ws.ws_promo_sk IS NOT NULL THEN ws.ws_sales_price ELSE 0 END) AS promo_sales_revenue FROM web_sales ws JOIN store s ON ws.ws_ship_addr_sk = s.s_store_sk LEFT JOIN promotion p ON ws.ws_promo_sk = p.p_promo_sk LEFT JOIN income_band i ON ws.ws_bill_cdemo_sk = i.ib_income_band_sk WHERE s.s_closed_date_sk NOT IN ('2451189', '2450910', '2451044') GROUP BY s.s_store_name, p.p_promo_name, i.ib_lower_bound, i.ib_upper_bound ORDER BY total_revenue_inc_tax DESC, s.s_store_name, p.p_promo_name;
SELECT d_year, SUM(cs_net_paid) AS total_sales, AVG(cs_net_profit) AS average_profit, COUNT(DISTINCT cs_bill_customer_sk) AS unique_customers, SUM(cr_return_amount) AS total_returns, AVG(cr_return_quantity) AS average_return_quantity, COUNT(DISTINCT cr_returning_customer_sk) AS unique_returning_customers FROM date_dim JOIN catalog_sales ON cs_sold_date_sk = d_date_sk JOIN catalog_returns ON cr_returned_date_sk = d_date_sk AND cs_order_number = cr_order_number WHERE d_year IN (2000, 2001, 2002) AND cs_ship_date_sk IS NOT NULL AND cr_returned_date_sk IS NOT NULL AND (cr_refunded_cdemo_sk IN ('719026', '1111847', '660009', '451051') OR cs_bill_cdemo_sk IN ('719026', '1111847', '660009', '451051')) AND cs_item_sk IN (SELECT inv_item_sk FROM inventory WHERE inv_quantity_on_hand > 100) GROUP BY d_year ORDER BY d_year;
SELECT ib_lower_bound, ib_upper_bound, ca_state, ca_city, AVG(ss_quantity) AS avg_quantity_sold, SUM(ss_net_paid) AS total_net_paid, SUM(ss_net_paid_inc_tax) AS total_net_paid_inc_tax, SUM(ss_net_profit) AS total_net_profit, COUNT(DISTINCT ss_customer_sk) AS unique_customers_count FROM store_sales JOIN customer_address ON store_sales.ss_addr_sk = customer_address.ca_address_sk JOIN household_demographics ON store_sales.ss_hdemo_sk = household_demographics.hd_demo_sk JOIN income_band ON household_demographics.hd_income_band_sk = income_band.ib_income_band_sk WHERE ca_zip IN ('65804', '18828', '28767', '57995') AND ss_sold_time_sk IN ('64456', '55232', '34662', '70640') AND ss_quantity IN (14, 26, 7, 79, 8, 63) GROUP BY ib_lower_bound, ib_upper_bound, ca_state, ca_city ORDER BY ca_state, ca_city, ib_lower_bound, ib_upper_bound;
SELECT ca.ca_state, ca.ca_city, COUNT(DISTINCT c.c_customer_sk) AS total_customers, SUM(ws.ws_quantity) AS total_items_sold, AVG(ws.ws_net_paid) AS average_net_paid_per_sale, SUM(ws.ws_net_profit) AS total_net_profit, COUNT(DISTINCT ws.ws_promo_sk) AS distinct_promotions_used FROM customer_address ca JOIN customer c ON c.c_current_addr_sk = ca.ca_address_sk JOIN web_sales ws ON ws.ws_bill_customer_sk = c.c_customer_sk JOIN promotion p ON ws.ws_promo_sk = p.p_promo_sk WHERE ca.ca_country = 'United States' AND p.p_channel_details IN ('Signs hear moreover nations. There perfect', 'Regional schemes would devise even loc') AND p.p_response_target = 1 AND ws.ws_sales_price > 0 GROUP BY ca.ca_state, ca.ca_city ORDER BY total_net_profit DESC, ca.ca_state, ca.ca_city;
SELECT hd.hd_dep_count, hd.hd_vehicle_count, ib.ib_lower_bound, ib.ib_upper_bound, COUNT(DISTINCT p.p_promo_sk) AS num_promotions, SUM(p.p_cost) AS total_promo_cost, AVG(p.p_cost) AS avg_promo_cost, COUNT(DISTINCT r.r_reason_sk) AS num_reasons, AVG(hd.hd_vehicle_count) AS avg_vehicle_count, SUM(CASE WHEN p.p_channel_event = 'N' THEN 1 ELSE 0 END) AS non_event_promos, SUM(CASE WHEN p.p_response_target = 1 THEN 1 ELSE 0 END) AS target_response_promos FROM promotion p JOIN household_demographics hd ON p.p_item_sk = hd.hd_demo_sk JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk LEFT JOIN reason r ON r.r_reason_sk = p.p_promo_sk WHERE p.p_channel_event = 'N' AND p.p_response_target = 1 GROUP BY hd.hd_dep_count, hd.hd_vehicle_count, ib.ib_lower_bound, ib.ib_upper_bound ORDER BY total_promo_cost DESC, num_promotions DESC;
SELECT cc.cc_name AS call_center_name, i.i_category AS item_category, SUM(ws.ws_quantity) AS total_quantity_sold, AVG(ws.ws_sales_price) AS average_sales_price, COUNT(DISTINCT ws.ws_order_number) AS total_orders, SUM(ws.ws_net_profit) AS total_net_profit FROM web_sales ws JOIN call_center cc ON ws.ws_bill_customer_sk = cc.cc_call_center_sk JOIN item i ON ws.ws_item_sk = i.i_item_sk JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk JOIN time_dim t ON ws.ws_sold_time_sk = t.t_time_sk JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk WHERE cc.cc_manager IN ('Bob Belcher', 'Felipe Perkins', 'Larry Mccray', 'Mark Hightower') AND i.i_container = 'Unknown' AND ws.ws_ship_hdemo_sk IN (6862, 4638, 2050, 5884, 1108) AND d.d_year = 2023 AND t.t_am_pm = 'PM' GROUP BY call_center_name, item_category ORDER BY total_net_profit DESC;
SELECT cp.cp_department, hd.hd_buy_potential, w.w_state, SUM(ss.ss_quantity) AS total_quantity_sold, AVG(ss.ss_sales_price) AS average_sales_price, COUNT(DISTINCT ss.ss_ticket_number) AS unique_tickets, SUM(ss.ss_net_paid_inc_tax) AS total_revenue_inc_tax, SUM(ss.ss_net_profit) AS total_net_profit FROM catalog_page cp JOIN store_sales ss ON cp.cp_catalog_page_sk = ss.ss_sold_date_sk JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk JOIN warehouse w ON ss.ss_addr_sk = w.w_warehouse_sk WHERE cp.cp_end_date_sk IN ('2451509', '2451817', '2451635') AND hd.hd_vehicle_count IN (0, 1, 2, 3, 4) AND w.w_state = 'TN' AND ss.ss_ticket_number IN (3518, 3677) GROUP BY cp.cp_department, hd.hd_buy_potential, w.w_state ORDER BY total_net_profit DESC;
SELECT td.t_shift, sum(ws.ws_quantity) AS total_quantity_sold, avg(ws.ws_sales_price) AS average_sales_price, count(distinct ws.ws_order_number) AS total_orders, count(distinct hd.hd_demo_sk) AS unique_customers, sum(ws.ws_net_profit) AS total_net_profit FROM web_sales ws JOIN time_dim td ON ws.ws_sold_time_sk = td.t_time_sk JOIN household_demographics hd ON ws.ws_bill_hdemo_sk = hd.hd_demo_sk WHERE ws.ws_sold_date_sk IS NOT NULL AND ws.ws_warehouse_sk IN (1, 2) AND hd.hd_demo_sk IN (821, 42, 4135, 4677, 808) GROUP BY ROLLUP(td.t_shift) ORDER BY total_net_profit DESC, td.t_shift;
SELECT s.s_city, COUNT(DISTINCT s.s_store_sk) AS number_of_stores, SUM(s.s_number_employees) AS total_employees, SUM(s.s_floor_space) AS total_floor_space, AVG(w.w_warehouse_sq_ft) AS avg_warehouse_sq_ft, COUNT(DISTINCT cp.cp_catalog_page_sk) AS number_of_catalog_pages FROM store s LEFT JOIN warehouse w ON s.s_city = w.w_city LEFT JOIN catalog_page cp ON cp.cp_catalog_page_number BETWEEN 80 AND 90 WHERE s.s_city IN ('Fairview', 'Midway') AND (s.s_closed_date_sk IS NULL OR s.s_closed_date_sk > CAST(to_char(CURRENT_DATE, 'J') AS INTEGER)) GROUP BY s.s_city ORDER BY s.s_city;
SELECT p.p_promo_id, p.p_promo_name, COUNT(cs.cs_order_number) AS total_orders, SUM(cs.cs_net_paid) AS total_revenue, SUM(cs.cs_ext_wholesale_cost) AS total_cost, SUM(cs.cs_net_profit) AS total_profit, AVG(cs.cs_ext_discount_amt) AS average_discount_amount FROM catalog_sales cs JOIN promotion p ON cs.cs_promo_sk = p.p_promo_sk GROUP BY p.p_promo_id, p.p_promo_name ORDER BY total_revenue DESC;
SELECT s_store_name AS store_name, s_state AS store_state, CONCAT(s_city, ', ', s_state) AS store_location, d_year AS sales_year, d_quarter_name AS sales_quarter, SUM(ss_quantity) AS total_quantity_sold, SUM(ss_net_paid) AS total_sales, AVG(ss_net_paid) AS average_sales_per_transaction, SUM(ss_net_paid_inc_tax) AS total_sales_including_tax, SUM(ss_ext_tax) AS total_tax_collected, COUNT(DISTINCT ss_customer_sk) AS unique_customers, COUNT(DISTINCT ss_ticket_number) AS total_transactions, SUM(wr_return_amt) AS total_returns, SUM(wr_fee) AS total_return_fees, AVG(wr_return_ship_cost) AS average_return_shipping_cost, COUNT(DISTINCT wr_refunded_customer_sk) AS unique_customers_returned, COUNT(DISTINCT wr_order_number) AS total_return_transactions, SUM(wr_net_loss) AS total_net_loss_from_returns, r_reason_desc AS most_common_return_reason FROM store_sales JOIN store ON ss_store_sk = s_store_sk JOIN date_dim ON ss_sold_date_sk = d_date_sk LEFT JOIN web_returns ON ss_item_sk = wr_item_sk AND ss_ticket_number = wr_order_number LEFT JOIN reason ON wr_reason_sk = r_reason_sk WHERE s_state IN ('NY', 'CA') AND d_year = 2023 GROUP BY s_store_name, s_state, s_city, d_year, d_quarter_name, r_reason_desc ORDER BY total_sales DESC, total_quantity_sold DESC LIMIT 10;
SELECT hd.hd_demo_sk, COUNT(DISTINCT sr.sr_ticket_number) AS total_store_returns, COUNT(DISTINCT wr.wr_order_number) AS total_web_returns, SUM(sr.sr_return_amt) AS total_store_return_amount, AVG(sr.sr_return_amt) AS avg_store_return_amount, SUM(wr.wr_return_amt) AS total_web_return_amount, AVG(wr.wr_return_amt) AS avg_web_return_amount, SUM(CASE WHEN p.p_channel_radio = 'N' AND p.p_channel_demo = 'N' THEN p.p_cost ELSE 0 END) AS non_radio_demo_promo_cost, AVG(CASE WHEN p.p_channel_radio = 'N' AND p.p_channel_demo = 'N' THEN p.p_response_target ELSE NULL END) AS avg_non_radio_demo_response_target FROM household_demographics hd LEFT JOIN store_returns sr ON hd.hd_demo_sk = sr.sr_hdemo_sk LEFT JOIN web_returns wr ON (hd.hd_demo_sk = wr.wr_refunded_hdemo_sk OR hd.hd_demo_sk = wr.wr_returning_hdemo_sk) LEFT JOIN promotion p ON p.p_promo_sk = sr.sr_reason_sk WHERE hd.hd_demo_sk IN (560, 4858) AND (sr.sr_store_sk IN (8, 10) OR sr.sr_store_sk IS NULL) GROUP BY hd.hd_demo_sk ORDER BY hd.hd_demo_sk;
SELECT cc.cc_division_name, COUNT(DISTINCT cc.cc_call_center_sk) AS num_call_centers, AVG(cc.cc_employees) AS avg_employees, SUM(inv.inv_quantity_on_hand) AS total_inventory, SUM(wr.wr_return_amt_inc_tax) AS total_returns_inc_tax, AVG(wp.wp_link_count) AS avg_link_count_per_page FROM call_center cc JOIN inventory inv ON cc.cc_call_center_sk = inv.inv_warehouse_sk JOIN web_returns wr ON inv.inv_item_sk = wr.wr_item_sk JOIN web_page wp ON wr.wr_web_page_sk = wp.wp_web_page_sk WHERE cc.cc_division IN (1, 3, 5) AND cc.cc_open_date_sk IN (2450952, 2450806, 2451063) AND wr.wr_web_page_sk IN (2, 32, 58, 26, 39) GROUP BY cc.cc_division_name ORDER BY total_returns_inc_tax DESC, avg_link_count_per_page DESC;
SELECT r.r_reason_desc, COUNT(cr.cr_order_number) AS total_returns, SUM(cr.cr_return_quantity) AS total_returned_items, AVG(cr.cr_return_amount) AS avg_return_amount, SUM(cr.cr_return_amount) AS total_return_amount, SUM(cr.cr_return_amt_inc_tax) AS total_return_amount_inc_tax, SUM(cr.cr_fee) AS total_fees, SUM(cr.cr_net_loss) AS total_net_loss, SUM(cs.cs_quantity) AS total_sold_quantity, AVG(cs.cs_sales_price) AS avg_sales_price, SUM(cs.cs_sales_price) AS total_sales, SUM(cs.cs_net_profit) AS total_net_profit FROM catalog_returns cr JOIN reason r ON cr.cr_reason_sk = r.r_reason_sk JOIN catalog_sales cs ON cr.cr_item_sk = cs.cs_item_sk AND cr.cr_order_number = cs.cs_order_number WHERE cr.cr_returned_date_sk IS NOT NULL AND (cr.cr_refunded_addr_sk IN (18593, 5341, 29829) OR r.r_reason_desc IN ('reason 29', 'reason 28', 'reason 31', 'Lost my job', 'Did not get it on time')) GROUP BY r.r_reason_desc ORDER BY total_returns DESC, total_return_amount DESC;
SELECT ib.ib_lower_bound, ib.ib_upper_bound, COUNT(wr.wr_item_sk) AS total_returns, AVG(wr.wr_net_loss) AS avg_net_loss, AVG(wr.wr_return_amt) AS avg_return_amount FROM web_returns wr JOIN customer c ON wr.wr_refunded_customer_sk = c.c_customer_sk JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk WHERE wr.wr_net_loss IS NOT NULL AND ib.ib_lower_bound IN (120001, 160001, 170001, 130001, 190001) AND hd.hd_income_band_sk = 14 AND wr.wr_refunded_customer_sk IN (2008, 38728, 70489, 86208, 44407) GROUP BY ib.ib_lower_bound, ib.ib_upper_bound ORDER BY avg_net_loss DESC;
SELECT p.p_promo_name, COUNT(DISTINCT s.sr_customer_sk) AS num_customers_affected, SUM(s.sr_return_quantity) AS total_returned_quantity, AVG(s.sr_return_amt_inc_tax) AS avg_return_amount_inc_tax, SUM(s.sr_fee) AS total_fees_collected, SUM(s.sr_net_loss) AS total_net_loss, r.r_reason_desc, cd.cd_credit_rating, sm.sm_carrier FROM store_returns s JOIN promotion p ON s.sr_item_sk = p.p_item_sk JOIN reason r ON s.sr_reason_sk = r.r_reason_sk JOIN customer_demographics cd ON s.sr_cdemo_sk = cd.cd_demo_sk JOIN ship_mode sm ON sm.sm_ship_mode_sk = s.sr_item_sk WHERE p.p_start_date_sk >= 2450905 AND (s.sr_return_ship_cost = 482.43 OR s.sr_return_ship_cost = 95.68 OR s.sr_return_ship_cost = 82.62 OR s.sr_return_ship_cost = 37.74 OR s.sr_return_ship_cost = 670.08 OR s.sr_return_ship_cost = 40.56) AND p.p_purpose = 'Unknown' AND r.r_reason_sk = 11 GROUP BY p.p_promo_name, r.r_reason_desc, cd.cd_credit_rating, sm.sm_carrier ORDER BY num_customers_affected DESC, total_net_loss DESC;
SELECT w_state, w_city, ib.ib_income_band_sk AS income_band_sk, p_promo_name, COUNT(DISTINCT w.w_warehouse_sk) AS num_warehouses, SUM(w.w_warehouse_sq_ft) AS total_warehouse_sq_ft, AVG(w.w_warehouse_sq_ft) AS avg_warehouse_sq_ft, SUM(wr_return_amt_inc_tax) AS total_return_amount_inc_tax, COUNT(DISTINCT wr.wr_returned_date_sk) AS num_return_days, AVG(wr_return_amt_inc_tax) AS avg_return_amount_inc_tax FROM warehouse w JOIN web_returns wr ON w.w_warehouse_sk = wr.wr_returning_addr_sk JOIN income_band ib ON ib.ib_income_band_sk = wr.wr_returning_hdemo_sk JOIN promotion p ON p.p_item_sk = wr.wr_item_sk WHERE w_state = 'TN' AND w_city = 'Fairview' AND wr_reason_sk IN (7, 17, 21, 6) AND ib_upper_bound IN (50000, 190000, 80000) AND wr_returning_hdemo_sk IN (4812, 3393, 981, 1249) GROUP BY w_state, w_city, ib.ib_income_band_sk, p_promo_name ORDER BY total_return_amount_inc_tax DESC LIMIT 100;
SELECT s_store_name, i_category, cd_gender, cd_education_status, r_reason_desc, COUNT(DISTINCT wr_item_sk) AS unique_items_returned, SUM(wr_return_quantity) AS total_return_quantity, AVG(wr_return_amt) AS avg_return_amount, AVG(i_wholesale_cost) AS avg_wholesale_cost, COUNT(wr_returned_date_sk) AS total_returns FROM web_returns JOIN item ON wr_item_sk = i_item_sk JOIN store ON s_store_sk = wr_returning_addr_sk JOIN customer_demographics ON cd_demo_sk = wr_returning_cdemo_sk JOIN reason ON r_reason_sk = wr_reason_sk JOIN date_dim ON wr_returned_date_sk = d_date_sk JOIN time_dim ON wr_returned_time_sk = t_time_sk WHERE d_year = 2022 AND s_state = 'CA' AND wr_return_amt > 0 AND i_current_price > i_wholesale_cost AND t_shift = 'third' GROUP BY s_store_name, i_category, cd_gender, cd_education_status, r_reason_desc ORDER BY total_return_quantity DESC, avg_return_amount DESC LIMIT 100;
SELECT ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound, SUM(cr.cr_return_amt_inc_tax) AS total_catalog_return, AVG(cr.cr_fee) AS avg_catalog_fee, COUNT(cr.cr_order_number) AS count_catalog_returns, SUM(wr.wr_return_amt_inc_tax) AS total_web_return, AVG(wr.wr_fee) AS avg_web_fee, COUNT(wr.wr_order_number) AS count_web_returns FROM income_band ib LEFT JOIN catalog_returns cr ON ib.ib_income_band_sk = cr.cr_refunded_cdemo_sk LEFT JOIN web_returns wr ON ib.ib_income_band_sk = wr.wr_refunded_cdemo_sk GROUP BY ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound ORDER BY ib.ib_income_band_sk;
SELECT state, item_category, SUM(total_sales_amount) AS total_sales_amount, SUM(total_return_amount) AS total_return_amount, AVG(avg_net_loss_per_return) AS avg_net_loss_per_return FROM ( SELECT web_site.web_state AS state, i.i_category AS item_category, SUM(ws.ws_sales_price) AS total_sales_amount, SUM(wr.wr_return_amt) AS total_return_amount, AVG(wr.wr_net_loss) AS avg_net_loss_per_return FROM web_sales ws INNER JOIN web_returns wr ON ws.ws_order_number = wr.wr_order_number AND ws.ws_item_sk = wr.wr_item_sk INNER JOIN web_site ON ws.ws_web_site_sk = web_site.web_site_sk INNER JOIN item i ON ws.ws_item_sk = i.i_item_sk WHERE web_site.web_state IN ('TN') GROUP BY web_site.web_state, i.i_category UNION ALL SELECT 'Catalog' AS state, i.i_category AS item_category, 0 AS total_sales_amount, SUM(cr.cr_return_amount) AS total_return_amount, AVG(cr.cr_net_loss) AS avg_net_loss_per_return FROM catalog_returns cr INNER JOIN item i ON cr.cr_item_sk = i.i_item_sk GROUP BY i.i_category ) AS combined_results GROUP BY state, item_category ORDER BY state, item_category;
SELECT cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, COUNT(DISTINCT sr.sr_ticket_number) AS num_returns, SUM(sr.sr_return_amt) AS total_return_amount, AVG(sr.sr_net_loss) AS average_net_loss, COUNT(DISTINCT ss.ss_ticket_number) AS num_sales, SUM(ss.ss_sales_price) AS total_sales_amount, AVG(ss.ss_quantity) AS average_quantity_sold, SUM(ws.ws_net_paid_inc_tax) AS total_web_net_paid_inc_tax, ws.ws_web_site_sk AS website_id FROM customer_demographics cd LEFT JOIN store_returns sr ON cd.cd_demo_sk = sr.sr_cdemo_sk LEFT JOIN store_sales ss ON cd.cd_demo_sk = ss.ss_cdemo_sk LEFT JOIN web_sales ws ON cd.cd_demo_sk = ws.ws_bill_cdemo_sk OR cd.cd_demo_sk = ws.ws_ship_cdemo_sk WHERE cd.cd_dep_count IN ('1', '2') AND cd.cd_marital_status IN ('D', 'S', 'W') AND (sr.sr_return_amt = '225.00' OR sr.sr_return_amt = '3027.92') AND (sr.sr_net_loss = '440.72' OR sr.sr_net_loss = '800.95') AND ss.ss_promo_sk IS NOT NULL AND ws.ws_web_site_sk IS NOT NULL GROUP BY cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, ws.ws_web_site_sk ORDER BY total_return_amount DESC;
SELECT cd.cd_education_status, AVG(cd.cd_purchase_estimate) AS avg_purchase_estimate, SUM(case when c.c_preferred_cust_flag = 'Y' then 1 else 0 end) AS preferred_customer_count, COUNT(DISTINCT c.c_customer_sk) AS unique_customers, SUM(hd.hd_vehicle_count) AS total_vehicles, MIN(p.p_cost) AS min_promo_cost, MAX(p.p_cost) AS max_promo_cost, SUM(inv.inv_quantity_on_hand) AS total_inventory FROM customer_demographics cd JOIN customer c ON cd.cd_demo_sk = c.c_current_cdemo_sk JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk JOIN promotion p ON p.p_start_date_sk BETWEEN 2450688 AND 2450740 JOIN inventory inv ON inv.inv_date_sk = 2450815 WHERE cd.cd_education_status IN ('Secondary', 'Primary', '2 yr Degree', 'Advanced Degree') AND c.c_email_address IN ('Bruce.Goodwin@3mtLAZrvaCRJ9p.org', 'Douglas.Smith@hF9KfOktaH5qz3.edu', 'Ana.Cary@imJui63o9G08Nas.com') AND p.p_promo_sk IN ('260', '238', '124', '179', '203') GROUP BY cd.cd_education_status;
SELECT cc.cc_call_center_id, cc.cc_name, cc.cc_city, cc.cc_state, r.r_reason_desc, COUNT(cr.cr_order_number) AS total_returns, SUM(cr.cr_return_quantity) AS total_returned_items, AVG(cr.cr_return_amount) AS avg_return_amount, SUM(cr.cr_return_tax) AS total_tax, SUM(cr.cr_return_ship_cost) AS total_ship_cost, SUM(cr.cr_net_loss) AS total_net_loss FROM call_center cc JOIN catalog_returns cr ON cc.cc_call_center_sk = cr.cr_call_center_sk JOIN reason r ON cr.cr_reason_sk = r.r_reason_sk WHERE cc.cc_zip = '31904' AND cr.cr_return_amt_inc_tax > 0 AND r.r_reason_desc IN ('Found a better price in a store', 'its is a boy') GROUP BY cc.cc_call_center_id, cc.cc_name, cc.cc_city, cc.cc_state, r.r_reason_desc ORDER BY total_returns DESC, total_returned_items DESC;
SELECT d.d_year AS year, d.d_month_seq AS month_sequence, COUNT(DISTINCT ss.ss_store_sk) AS num_stores, SUM(ss.ss_quantity) AS total_items_sold, SUM(ss.ss_net_paid_inc_tax) AS total_sales_inc_tax, AVG(ss.ss_ext_discount_amt) AS average_discount, SUM(cr.cr_return_amount) AS total_returns, AVG(cr.cr_fee) AS average_return_fee, COUNT(DISTINCT cr.cr_call_center_sk) FILTER (WHERE cc.cc_class = 'small') AS num_small_class_call_centers, COUNT(DISTINCT cr.cr_call_center_sk) FILTER (WHERE cc.cc_class = 'medium') AS num_medium_class_call_centers, COUNT(DISTINCT cr.cr_call_center_sk) FILTER (WHERE cc.cc_class = 'large') AS num_large_class_call_centers FROM store_sales ss JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk LEFT JOIN catalog_returns cr ON ss.ss_ticket_number = cr.cr_order_number LEFT JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk WHERE d.d_month_seq IS NOT NULL AND ss.ss_store_sk IS NOT NULL GROUP BY year, month_sequence ORDER BY year, month_sequence;
