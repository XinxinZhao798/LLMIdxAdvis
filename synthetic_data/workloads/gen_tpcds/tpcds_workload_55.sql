SELECT w_state, t_shift, sm_type as shipping_type, avg(hd_income_band_sk) as avg_income_band, sum(case when hd_buy_potential = 'High' then 1 else 0 end) as high_buy_potential_count, avg(hd_dep_count) as avg_dependent_count, avg(hd_vehicle_count) as avg_vehicle_count, count(distinct sm_ship_mode_sk) as shipping_mode_count FROM household_demographics hd JOIN warehouse w ON hd.hd_demo_sk = w.w_warehouse_sk JOIN time_dim td ON td.t_time_sk = w.w_warehouse_sk JOIN ship_mode sm ON sm.sm_ship_mode_sk = w.w_warehouse_sk WHERE hd.hd_dep_count IN (2, 3, 6, 9) AND hd.hd_vehicle_count IN (0, 1, 2, 3, 4) AND td.t_shift IS NOT NULL AND sm.sm_type IS NOT NULL GROUP BY w_state, t_shift, sm_type ORDER BY avg_income_band DESC, high_buy_potential_count DESC, avg_vehicle_count DESC;
SELECT cd.cd_education_status, cd.cd_marital_status, ca.ca_state, cd.cd_credit_rating, AVG(cd.cd_purchase_estimate) AS average_purchase_estimate, COUNT(DISTINCT ca.ca_address_sk) AS number_of_addresses, SUM(hd.hd_vehicle_count) AS total_vehicles, AVG(t.t_hour + (t.t_minute / 60.0) + (t.t_second / 3600.0)) AS average_time_of_day FROM customer_demographics cd JOIN customer_address ca ON cd.cd_demo_sk = ca.ca_address_sk JOIN household_demographics hd ON cd.cd_demo_sk = hd.hd_demo_sk JOIN time_dim t ON t.t_time_sk = ca.ca_address_sk WHERE cd.cd_credit_rating IN ('Low Risk', 'High Risk', 'Good') AND t.t_time IN (775, 962) AND t.t_second IN (52, 26, 34) AND ca.ca_address_id IN ('AAAAAAAANJCAAAAA', 'AAAAAAAAFMCAAAAA', 'AAAAAAAAHGOAAAAA', 'AAAAAAAAHEEAAAAA') AND cd.cd_dep_count IN (1, 2) AND hd.hd_dep_count IN (0, 6, 4, 1) AND hd.hd_vehicle_count IN (3, 4) GROUP BY cd.cd_education_status, cd.cd_marital_status, ca.ca_state, cd.cd_credit_rating ORDER BY average_purchase_estimate DESC;
SELECT ca.ca_state, cd.cd_education_status, COUNT(DISTINCT c.c_customer_sk) AS total_customers, SUM(ss.ss_quantity) AS total_sales_quantity, AVG(ss.ss_net_profit) AS avg_net_profit, SUM(sr.sr_return_quantity) AS total_return_quantity, AVG(sr.sr_net_loss) AS avg_net_loss, AVG(inv.inv_quantity_on_hand) AS avg_inventory_on_hand FROM customer c JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk LEFT JOIN store_sales ss ON c.c_customer_sk = ss.ss_customer_sk LEFT JOIN store_returns sr ON c.c_customer_sk = sr.sr_customer_sk LEFT JOIN inventory inv ON inv.inv_warehouse_sk = ca.ca_address_sk WHERE ca.ca_country = 'SERBIA' AND cd.cd_purchase_estimate BETWEEN 3500 AND 10000 AND inv.inv_warehouse_sk IN (1, 2) GROUP BY ca.ca_state, cd.cd_education_status ORDER BY ca.ca_state, cd.cd_education_status;
SELECT i_category, i_class, web_state, web_name, avg_hd_vehicle_count, avg_ib_lower_bound, sum_i_current_price, avg_i_wholesale_cost, count_distinct_items FROM ( SELECT i.i_category, i.i_class, ws.web_state, ws.web_name, AVG(hd.hd_vehicle_count) AS avg_hd_vehicle_count, AVG(ib.ib_lower_bound) AS avg_ib_lower_bound, SUM(i.i_current_price) AS sum_i_current_price, AVG(i.i_wholesale_cost) AS avg_i_wholesale_cost, COUNT(DISTINCT i.i_item_sk) AS count_distinct_items FROM item i JOIN household_demographics hd ON i.i_manager_id = hd.hd_demo_sk JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk JOIN web_site ws ON i.i_manufact_id = ws.web_company_id WHERE i.i_category IN ('Home', 'Men', 'Women') AND i.i_class IN ('toddlers', 'basketball', 'bedding') AND hd.hd_buy_potential IN ('0-500', 'Unknown', '501-1000') AND hd.hd_vehicle_count IN (4, 3, 0) AND ws.web_state = 'TN' AND ws.web_name IN ('site_0', 'site_3', 'site_4') AND ib.ib_lower_bound IN (150001, 160001, 120001) AND ib.ib_upper_bound IN (70000, 200000, 10000) AND ib.ib_income_band_sk IN (6, 11, 18) GROUP BY i.i_category, i.i_class, ws.web_state, ws.web_name ) AS derived_table ORDER BY i_category, i_class, web_state, web_name;
SELECT state, item_category, SUM(total_sales_amount) AS total_sales_amount, SUM(total_return_amount) AS total_return_amount, AVG(avg_net_loss_per_return) AS avg_net_loss_per_return FROM ( SELECT web_site.web_state AS state, i.i_category AS item_category, SUM(ws.ws_sales_price) AS total_sales_amount, SUM(wr.wr_return_amt) AS total_return_amount, AVG(wr.wr_net_loss) AS avg_net_loss_per_return FROM web_sales ws INNER JOIN web_returns wr ON ws.ws_order_number = wr.wr_order_number AND ws.ws_item_sk = wr.wr_item_sk INNER JOIN web_site ON ws.ws_web_site_sk = web_site.web_site_sk INNER JOIN item i ON ws.ws_item_sk = i.i_item_sk WHERE web_site.web_state IN ('TN') GROUP BY web_site.web_state, i.i_category UNION ALL SELECT 'Catalog' AS state, i.i_category AS item_category, 0 AS total_sales_amount, SUM(cr.cr_return_amount) AS total_return_amount, AVG(cr.cr_net_loss) AS avg_net_loss_per_return FROM catalog_returns cr INNER JOIN item i ON cr.cr_item_sk = i.i_item_sk GROUP BY i.i_category ) AS combined_results GROUP BY state, item_category ORDER BY state, item_category;
SELECT dd.d_year, dd.d_month_seq, dd.d_quarter_seq, cc.cc_class, SUM(sr.sr_return_amt) AS total_store_returns, AVG(sr.sr_return_quantity) AS avg_store_return_quantity, COUNT(DISTINCT sr.sr_ticket_number) AS count_store_return_tickets, SUM(wr.wr_return_amt) AS total_web_returns, AVG(wr.wr_return_quantity) AS avg_web_return_quantity, COUNT(DISTINCT wr.wr_order_number) AS count_web_return_orders FROM date_dim dd JOIN store_returns sr ON dd.d_date_sk = sr.sr_returned_date_sk JOIN web_returns wr ON dd.d_date_sk = wr.wr_returned_date_sk JOIN call_center cc ON cc.cc_open_date_sk = dd.d_date_sk WHERE dd.d_year = 2002 AND cc.cc_rec_start_date = '2002-01-01' AND (cc.cc_street_name = 'Center Hill' OR cc.cc_street_name = 'Ash Hill') AND (wr.wr_returned_time_sk IS NOT NULL AND sr.sr_return_time_sk IS NOT NULL) AND (wr.wr_returned_time_sk IN (SELECT t_time_sk FROM time_dim WHERE t_minute IN ('51', '4', '29', '2', '14', '12'))) AND EXISTS (SELECT 1 FROM warehouse w WHERE w.w_warehouse_sk = sr.sr_item_sk AND w.w_county = 'Williamson County' AND w.w_state = 'TN') GROUP BY dd.d_year, dd.d_month_seq, dd.d_quarter_seq, cc.cc_class ORDER BY dd.d_year, dd.d_month_seq, dd.d_quarter_seq, cc.cc_class;
SELECT sm.sm_type AS shipping_type, web.web_site_sk, web.web_name AS website_name, COUNT(DISTINCT ws.ws_order_number) AS total_orders, SUM(ws.ws_net_paid) AS total_revenue, AVG(ws.ws_quantity) AS average_quantity, AVG(ws.ws_ext_discount_amt) AS average_discount, SUM(ws.ws_coupon_amt) AS total_coupon_amount, SUM(ws.ws_net_profit) AS total_profit FROM web_sales ws JOIN web_site web ON ws.ws_web_site_sk = web.web_site_sk JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk WHERE web.web_name IN ('site_3', 'site_4', 'site_1', 'site_0', 'site_2') AND sm.sm_contract IN ('GNJr3g5i7oorKqtX', 'uukTktPYycct8', 'ldhM8IvpzHgdbBgDfI', '2mM8l') AND ws.ws_sold_date_sk BETWEEN 20230101 AND 20231231 GROUP BY sm.sm_type, web.web_site_sk, web.web_name ORDER BY total_revenue DESC;
SELECT s.s_store_name, w.w_warehouse_name, COUNT(ss.ss_ticket_number) AS total_sales_transactions, AVG(ss.ss_net_paid) AS avg_transaction_amount, SUM(ss.ss_net_paid_inc_tax) AS total_revenue_inc_tax, SUM(wr.wr_return_amt_inc_tax) AS total_returns_inc_tax, (SUM(ss.ss_net_paid_inc_tax) - SUM(wr.wr_return_amt_inc_tax)) AS net_revenue_inc_tax, AVG(wr.wr_fee) AS avg_return_fee, SUM(wr.wr_net_loss) AS total_net_loss_from_returns FROM store s JOIN store_sales ss ON s.s_store_sk = ss.ss_store_sk LEFT JOIN web_returns wr ON ss.ss_ticket_number = wr.wr_order_number JOIN warehouse w ON s.s_state = w.w_state GROUP BY s.s_store_name, w.w_warehouse_name ORDER BY net_revenue_inc_tax DESC, s.s_store_name;
SELECT cp.cp_department, COUNT(*) AS total_pages, AVG(wp.wp_link_count) AS average_link_count, SUM(wp.wp_image_count) AS total_image_count, COUNT(DISTINCT hd.hd_demo_sk) AS unique_households, AVG(hd.hd_vehicle_count) AS average_vehicle_count FROM catalog_page cp JOIN web_page wp ON cp.cp_catalog_page_sk = wp.wp_customer_sk JOIN household_demographics hd ON wp.wp_customer_sk = hd.hd_demo_sk WHERE cp.cp_catalog_number IN (29, 27, 21, 36) AND wp.wp_autogen_flag = 'Y' AND wp.wp_url LIKE 'http://www.foo.com%' GROUP BY cp.cp_department ORDER BY total_pages DESC, average_link_count DESC;
SELECT cc.cc_division_name, i.i_manufact_id, i.i_category, AVG(cr.cr_return_amount) AS avg_return_amount, SUM(cr.cr_return_amount) AS total_return_amount, COUNT(DISTINCT cr.cr_order_number) AS total_returned_orders, COUNT(DISTINCT c.c_customer_sk) AS total_customers, SUM(cr.cr_return_quantity) AS total_returned_quantity FROM call_center cc JOIN catalog_returns cr ON cc.cc_call_center_sk = cr.cr_call_center_sk JOIN item i ON cr.cr_item_sk = i.i_item_sk JOIN customer c ON cr.cr_returning_customer_sk = c.c_customer_sk WHERE cc.cc_tax_percentage IN ('0.01', '0.12') AND i.i_manufact_id IN ('347', '497') AND c.c_birth_year IN ('1974', '1946', '1962', '1987', '1964') AND c.c_birth_country IN ('CAPE VERDE', 'POLAND', 'PITCAIRN', 'PAPUA NEW GUINEA', 'BELIZE', 'NIUE') GROUP BY cc.cc_division_name, i.i_manufact_id, i.i_category ORDER BY total_return_amount DESC;
SELECT i_category, cd_gender, cd_marital_status, SUM(ss_quantity) AS total_quantity_sold, AVG(ss_sales_price) AS average_sales_price, COUNT(DISTINCT ss_customer_sk) AS unique_customers, SUM(ws_net_profit) AS total_web_net_profit, AVG(wr_fee) AS average_return_fee FROM store_sales JOIN item ON ss_item_sk = i_item_sk JOIN web_sales ON ws_item_sk = ss_item_sk JOIN web_returns ON wr_item_sk = ws_item_sk JOIN customer_demographics ON (ss_cdemo_sk = cd_demo_sk AND ws_bill_cdemo_sk = cd_demo_sk AND wr_refunded_cdemo_sk = cd_demo_sk) WHERE i_wholesale_cost > 14.32 AND (cd_gender = 'M' OR cd_gender = 'F') AND (cd_marital_status = 'M' OR cd_marital_status = 'U') AND ws_net_paid_inc_tax > 100 AND wr_return_amt > 0 GROUP BY i_category, cd_gender, cd_marital_status ORDER BY total_quantity_sold DESC, average_sales_price DESC;
SELECT ca.ca_city, sm.sm_type AS shipping_type, COUNT(DISTINCT ws.ws_order_number) AS total_web_orders, SUM(ws.ws_quantity) AS total_web_quantity_sold, AVG(ws.ws_sales_price) AS average_web_sales_price, SUM(ws.ws_net_profit) AS total_web_net_profit, COUNT(DISTINCT cs.cs_order_number) AS total_catalog_orders, SUM(cs.cs_quantity) AS total_catalog_quantity_sold, AVG(cs.cs_sales_price) AS average_catalog_sales_price, SUM(cs.cs_net_profit) AS total_catalog_net_profit, COUNT(DISTINCT sr.sr_ticket_number) AS total_store_returns, SUM(sr.sr_return_quantity) AS total_returned_quantity, AVG(sr.sr_return_amt) AS average_return_amount, SUM(sr.sr_net_loss) AS total_net_loss FROM customer_address ca LEFT JOIN web_sales ws ON ca.ca_address_sk = ws.ws_bill_addr_sk LEFT JOIN catalog_sales cs ON ca.ca_address_sk = cs.cs_bill_addr_sk LEFT JOIN store_returns sr ON ca.ca_address_sk = sr.sr_addr_sk LEFT JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk WHERE ca.ca_city IN ('Ruth', 'Tabor', 'Altamont', 'Morgantown', 'Hartland', 'Richville') AND (ws.ws_wholesale_cost IN (9.45, 10.23, 52.95, 12.11, 47.17) OR cs.cs_bill_customer_sk IN (79309, 53472, 7567, 9353, 49484) OR sr.sr_returned_date_sk IN (2452085, 2451229)) GROUP BY ca.ca_city, sm.sm_type ORDER BY ca.ca_city, shipping_type;
SELECT cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, cd.cd_credit_rating, COUNT(DISTINCT ss.ss_customer_sk) AS store_customer_count, SUM(ss.ss_quantity) AS store_quantity_sum, AVG(ss.ss_sales_price) AS store_average_sales_price, SUM(cs.cs_quantity) AS catalog_quantity_sum, AVG(cs.cs_sales_price) AS catalog_average_sales_price, SUM(ws.ws_quantity) AS web_quantity_sum, AVG(ws.ws_sales_price) AS web_average_sales_price, SUM(sr.sr_return_quantity) AS store_return_quantity_sum, SUM(wr.wr_return_quantity) AS web_return_quantity_sum, ib.ib_lower_bound, ib.ib_upper_bound FROM customer_demographics cd JOIN store_sales ss ON cd.cd_demo_sk = ss.ss_cdemo_sk JOIN catalog_sales cs ON cd.cd_demo_sk = cs.cs_bill_cdemo_sk JOIN web_sales ws ON cd.cd_demo_sk = ws.ws_bill_cdemo_sk JOIN store_returns sr ON cd.cd_demo_sk = sr.sr_cdemo_sk JOIN web_returns wr ON cd.cd_demo_sk = wr.wr_refunded_cdemo_sk JOIN income_band ib ON cd.cd_purchase_estimate BETWEEN ib.ib_lower_bound AND ib.ib_upper_bound GROUP BY cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, cd.cd_credit_rating, ib.ib_lower_bound, ib.ib_upper_bound ORDER BY cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, cd.cd_credit_rating;
SELECT i.i_category AS item_category, AVG(i.i_current_price) AS avg_current_price, COUNT(i.i_item_sk) AS total_item_count, AVG(i.i_wholesale_cost) AS avg_wholesale_cost, AVG(cd.cd_purchase_estimate) FILTER (WHERE cd.cd_credit_rating = 'Good') AS avg_good_credit_purchase_estimate, AVG(cd.cd_purchase_estimate) FILTER (WHERE cd.cd_credit_rating = 'High Risk') AS avg_high_risk_credit_purchase_estimate, AVG(cd.cd_purchase_estimate) FILTER (WHERE cd.cd_credit_rating = 'Low Risk') AS avg_low_risk_credit_purchase_estimate FROM item i JOIN promotion p ON i.i_item_sk = p.p_item_sk JOIN customer c ON p.p_start_date_sk <= c.c_first_sales_date_sk AND p.p_end_date_sk >= c.c_first_sales_date_sk JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk WHERE i.i_category IN ('Home', 'Electronics', 'Sports') AND c.c_first_sales_date_sk = '2452263' AND p.p_discount_active = '1' GROUP BY i.i_category ORDER BY avg_current_price DESC;
SELECT ca.ca_state, ca.ca_location_type, COUNT(DISTINCT cs.cs_order_number) AS total_orders, SUM(cs.cs_quantity) AS total_quantity_sold, AVG(cs.cs_sales_price) AS average_sales_price, SUM(cs.cs_net_profit) AS total_net_profit, w.w_street_name, w.w_city FROM catalog_sales cs JOIN customer_address ca ON cs.cs_ship_addr_sk = ca.ca_address_sk JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk WHERE ca.ca_state = 'VA' AND ca.ca_location_type IN ('single family', 'apartment', 'condo') AND cs.cs_net_profit > 0 AND w.w_gmt_offset = -5.00 GROUP BY ca.ca_state, ca.ca_location_type, w.w_street_name, w.w_city ORDER BY total_net_profit DESC;
SELECT ca_state, i_category, sm_type, COUNT(DISTINCT c_customer_sk) AS num_customers, SUM(ss_quantity) AS total_quantity_sold, AVG(ss_sales_price) AS avg_sales_price, SUM(ss_net_profit) AS total_net_profit FROM store_sales JOIN customer ON ss_customer_sk = c_customer_sk JOIN item ON ss_item_sk = i_item_sk JOIN ship_mode ON ss_sold_date_sk = sm_ship_mode_sk JOIN customer_address ON c_current_addr_sk = ca_address_sk WHERE ca_gmt_offset IN (-10.00, -6.00, -5.00) AND i_units IN ('Each', 'Dozen', 'Tsp') AND sm_type IN ('REGULAR', 'OVERNIGHT', 'EXPRESS') AND c_first_sales_date_sk IN (2450027, 2449229, 2451727) GROUP BY ca_state, i_category, sm_type ORDER BY total_net_profit DESC, avg_sales_price DESC;
SELECT s.s_store_name, i.i_category, p.p_channel_details, SUM(cs.cs_net_paid_inc_ship) AS total_sales, SUM(cs.cs_net_profit) AS total_profit, COUNT(DISTINCT cs.cs_order_number) AS total_orders, AVG(cs.cs_quantity) AS average_quantity, SUM(wr.wr_net_loss) AS total_net_loss, COUNT(DISTINCT wr.wr_order_number) AS total_returns, r.r_reason_desc FROM store s JOIN catalog_sales cs ON s.s_store_sk = cs.cs_warehouse_sk JOIN item i ON cs.cs_item_sk = i.i_item_sk LEFT JOIN promotion p ON cs.cs_promo_sk = p.p_promo_sk LEFT JOIN web_returns wr ON cs.cs_item_sk = wr.wr_item_sk AND cs.cs_order_number = wr.wr_order_number LEFT JOIN reason r ON wr.wr_reason_sk = r.r_reason_sk WHERE s.s_country = 'United States' AND ( s.s_store_sk = '8' OR s.s_store_sk = '1' ) AND ( cs.cs_net_paid_inc_ship IN ('6377.67', '3521.76', '158.56', '2257.47', '739.93', '7973.92') ) AND ( r.r_reason_sk IN ('17', '4', '20', '18', '31') OR r.r_reason_sk IS NULL ) AND i.i_class = 'cooking' GROUP BY s.s_store_name, i.i_category, p.p_channel_details, r.r_reason_desc ORDER BY total_sales DESC, total_profit DESC;
SELECT sm.sm_type, sm.sm_carrier, COUNT(DISTINCT wr.wr_item_sk) AS total_items_returned, SUM(wr.wr_return_quantity) AS total_quantity_returned, AVG(wr.wr_return_amt) AS average_return_amount, AVG(wr.wr_fee) AS average_fee, SUM(wr.wr_net_loss) AS total_net_loss, ws.web_name, ws.web_manager, ws.web_mkt_class, COUNT(DISTINCT ws.web_site_sk) AS total_sites FROM web_returns wr JOIN ship_mode sm ON wr.wr_returned_date_sk = sm.sm_ship_mode_sk JOIN web_site ws ON wr.wr_web_page_sk = ws.web_site_sk WHERE ws.web_mkt_id IN (3, 4, 6, 2) AND ws.web_street_name = 'Hickory 3rd' AND wr.wr_returned_date_sk BETWEEN 100 AND 200 GROUP BY sm.sm_type, sm.sm_carrier, ws.web_name, ws.web_manager, ws.web_mkt_class ORDER BY total_net_loss DESC, total_quantity_returned DESC LIMIT 10;
SELECT cc.cc_name, cc.cc_city, st.s_store_name, st.s_city, SUM(ss.ss_net_profit) AS total_net_profit, AVG(ss.ss_sales_price) AS average_sales_price, SUM(ss.ss_quantity) AS total_quantity_sold, COUNT(DISTINCT ss.ss_ticket_number) AS number_of_sales_transactions FROM call_center AS cc JOIN store_sales AS ss ON cc.cc_call_center_sk = ss.ss_store_sk JOIN store AS st ON ss.ss_store_sk = st.s_store_sk WHERE cc.cc_rec_start_date >= '2020-01-01' AND cc.cc_rec_end_date <= '2020-12-31' AND ss.ss_wholesale_cost BETWEEN 40 AND 90 AND (st.s_city = 'Fairview' OR st.s_city = 'Midway') AND cc.cc_employees >= 3 GROUP BY cc.cc_name, cc.cc_city, st.s_store_name, st.s_city HAVING SUM(ss.ss_net_profit) > 0 ORDER BY total_net_profit DESC, average_sales_price DESC;
SELECT ca_state, cd_marital_status, hd_buy_potential, COUNT(DISTINCT c_customer_sk) AS num_customers, AVG(ws_quantity) AS avg_quantity_sold, SUM(ws_net_paid_inc_tax) AS total_paid_inc_tax, SUM(ws_net_profit) AS total_net_profit FROM customer JOIN web_sales ON c_customer_sk = ws_bill_customer_sk JOIN customer_address ON c_current_addr_sk = ca_address_sk JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk JOIN household_demographics ON c_current_hdemo_sk = hd_demo_sk WHERE ca_county IN ('Esmeralda County', 'Clallam County', 'Henderson County', 'Plumas County', 'Wells County') AND hd_buy_potential IN ('>10000', 'Unknown', '0-500', '5001-10000', '1001-5000', '501-1000') AND cd_marital_status IN ('D', 'M', 'U', 'S', 'W') GROUP BY ROLLUP (ca_state, cd_marital_status, hd_buy_potential) ORDER BY ca_state, cd_marital_status, hd_buy_potential;
SELECT sm.sm_type, cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, COUNT(DISTINCT ws.ws_order_number) AS total_web_orders, SUM(ws.ws_quantity) AS total_web_quantity_sold, AVG(ws.ws_sales_price) AS avg_web_sales_price, SUM(cr.cr_return_quantity) AS total_return_quantity, AVG(cr.cr_return_amount) AS avg_return_amount, COUNT(DISTINCT cr.cr_order_number) AS total_returns FROM web_sales ws JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk LEFT JOIN catalog_returns cr ON ws.ws_order_number = cr.cr_order_number AND ws.ws_item_sk = cr.cr_item_sk WHERE sm.sm_type IN ('EXPRESS', 'OVERNIGHT', 'NEXT DAY') GROUP BY sm.sm_type, cd.cd_gender, cd.cd_marital_status, cd.cd_education_status ORDER BY sm.sm_type, cd.cd_gender, cd.cd_marital_status, cd.cd_education_status;
SELECT ca_state, ca_city, COUNT(DISTINCT c_customer_sk) AS number_of_customers, SUM(ss_net_paid) AS total_sales_amount, AVG(ss_quantity) AS average_quantity_sold, SUM(ss_net_profit) AS total_profit, MAX(ib_upper_bound) AS max_income_band_upper_bound, AVG(wr_return_amt) AS average_return_amount FROM customer_address JOIN customer ON c_current_addr_sk = ca_address_sk JOIN store_sales ON ss_customer_sk = c_customer_sk JOIN income_band ON ib_income_band_sk = (SELECT hd_income_band_sk FROM household_demographics WHERE hd_demo_sk = c_current_hdemo_sk) LEFT OUTER JOIN web_returns ON wr_order_number = ss_ticket_number AND wr_item_sk = ss_item_sk WHERE ca_street_type IN ('Dr.', 'Blvd', 'Ln', 'Cir.', 'Boulevard', 'Wy') AND ss_net_paid > 1000 AND ss_quantity < 50 GROUP BY ca_state, ca_city ORDER BY total_sales_amount DESC, average_quantity_sold DESC LIMIT 10;
SELECT st.s_store_name, st.s_store_id, SUM(ws.ws_net_paid) AS total_net_sales, AVG(ws.ws_sales_price) AS avg_sales_price, COUNT(wr.wr_order_number) AS total_returns, AVG(wr.wr_return_amt) AS avg_return_amount, ARRAY_AGG(DISTINCT re.r_reason_desc) AS reasons_for_returns FROM store st LEFT JOIN web_sales ws ON st.s_store_sk = ws.ws_warehouse_sk LEFT JOIN web_returns wr ON ws.ws_order_number = wr.wr_order_number LEFT JOIN reason re ON wr.wr_reason_sk = re.r_reason_sk WHERE st.s_division_id = 1 AND st.s_tax_precentage BETWEEN 0.01 AND 0.06 GROUP BY st.s_store_name, st.s_store_id ORDER BY total_net_sales DESC, avg_sales_price DESC, total_returns DESC, avg_return_amount DESC;
SELECT c.c_last_name, c.c_first_name, c.c_email_address, SUM(ss.ss_net_paid) AS total_sales, AVG(ss.ss_quantity) AS avg_quantity_sold, COUNT(DISTINCT ss.ss_ticket_number) AS number_of_transactions, SUM(wr.wr_fee) AS total_return_fees, AVG(wr.wr_return_quantity) AS avg_return_quantity, COUNT(DISTINCT wr.wr_order_number) AS number_of_returns, r.r_reason_desc AS most_common_return_reason FROM store_sales ss JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk LEFT JOIN web_returns wr ON wr.wr_returning_customer_sk = c.c_customer_sk LEFT JOIN reason r ON wr.wr_reason_sk = r.r_reason_sk WHERE c.c_birth_day IN (12, 23, 14, 10, 22, 11) AND r.r_reason_desc IN ('Wrong size', 'unauthoized purchase', 'reason 32') GROUP BY c.c_last_name, c.c_first_name, c.c_email_address, r.r_reason_desc ORDER BY total_sales DESC, total_return_fees DESC;
SELECT cd.cd_gender, cd.cd_marital_status, td.t_shift, COUNT(DISTINCT ss.ss_ticket_number) AS total_sales_transactions, SUM(ss.ss_quantity) AS total_units_sold, SUM(ss.ss_net_paid) AS total_revenue, AVG(ss.ss_net_paid) AS average_revenue_per_transaction, SUM(CASE WHEN p.p_channel_dmail = 'Y' THEN 1 ELSE 0 END) AS total_dmail_promotions, SUM(CASE WHEN p.p_channel_email = 'Y' THEN 1 ELSE 0 END) AS total_email_promotions, SUM(CASE WHEN p.p_channel_tv = 'Y' THEN 1 ELSE 0 END) AS total_tv_promotions FROM store_sales ss JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk JOIN time_dim td ON ss.ss_sold_time_sk = td.t_time_sk LEFT JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk WHERE ss.ss_hdemo_sk IN ('4855', '5486') GROUP BY cd.cd_gender, cd.cd_marital_status, td.t_shift ORDER BY total_revenue DESC, total_units_sold DESC;
SELECT s_state, s_city, COUNT(DISTINCT s_store_sk) AS num_stores, SUM(inv_quantity_on_hand) AS total_inventory, AVG(cd_purchase_estimate) AS avg_purchase_estimate, COUNT(DISTINCT wp_web_page_sk) AS num_web_pages, SUM(wp_link_count) AS total_link_count, COUNT(CASE WHEN cd_credit_rating = 'High Risk' THEN 1 END) AS high_risk_customers, COUNT(CASE WHEN cd_credit_rating = 'Low Risk' THEN 1 END) AS low_risk_customers, AVG(cd_dep_count) AS avg_dep_count, SUM(cd_dep_employed_count) AS total_dep_employed_count, AVG(s_number_employees) AS avg_store_employees, AVG(s_floor_space) AS avg_store_floor_space FROM store LEFT JOIN inventory ON s_store_sk = inv_warehouse_sk LEFT JOIN customer_demographics ON s_market_id = cd_demo_sk LEFT JOIN web_page ON s_store_sk = wp_customer_sk WHERE s_rec_end_date IS NULL AND wp_char_count IN (1147, 1711, 6577) AND inv_quantity_on_hand IN (505, 375, 593, 141, 402, 949) AND s_suite_number IN ('Suite D', 'Suite 80', 'Suite 190', 'Suite 100') AND s_division_name = 'Unknown' AND cd_dep_employed_count = 0 AND cd_credit_rating IN ('High Risk', 'Low Risk', 'Good', 'Unknown') GROUP BY s_state, s_city ORDER BY s_state, s_city;
SELECT p.p_promo_name, p.p_channel_details, cp.cp_department, w.w_state, AVG(ws_net_profit) AS avg_web_sales_profit, AVG(wr_net_loss) AS avg_web_returns_loss, SUM(ws_quantity) AS total_quantity_sold, COUNT(DISTINCT ws_web_page_sk) AS count_unique_pages_sold, COUNT(DISTINCT wr_web_page_sk) AS count_unique_pages_returned FROM promotion p JOIN web_sales ws ON p.p_promo_sk = ws.ws_promo_sk JOIN catalog_page cp ON ws.ws_web_page_sk = cp.cp_catalog_page_sk JOIN warehouse w ON ws.ws_warehouse_sk = w.w_warehouse_sk LEFT JOIN web_returns wr ON ws.ws_item_sk = wr.wr_item_sk AND ws.ws_order_number = wr.wr_order_number WHERE cp.cp_start_date_sk BETWEEN '2450906' AND '2451420' AND cp.cp_end_date_sk BETWEEN '2451419' AND '2451664' AND (wr.wr_returned_date_sk IS NULL OR wr.wr_returned_date_sk BETWEEN ws_sold_date_sk AND ws_sold_date_sk + 30) GROUP BY p.p_promo_name, p.p_channel_details, cp.cp_department, w.w_state ORDER BY avg_web_sales_profit DESC, avg_web_returns_loss DESC;
