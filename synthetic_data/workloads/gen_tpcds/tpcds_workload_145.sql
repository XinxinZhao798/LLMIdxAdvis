SELECT i.i_category, SUM(ss.ss_ext_sales_price) AS total_sales, AVG(i.i_wholesale_cost) AS avg_wholesale_cost, COUNT(DISTINCT ss.ss_item_sk) AS unique_items_sold, COUNT(ss.ss_ticket_number) AS total_transactions FROM store_sales ss JOIN item i ON ss.ss_item_sk = i.i_item_sk JOIN store s ON ss.ss_store_sk = s.s_store_sk WHERE s.s_tax_precentage BETWEEN 0.03 AND 0.11 AND i.i_current_price BETWEEN 30 AND 90 GROUP BY i.i_category ORDER BY total_sales DESC, i.i_category;
SELECT cp.cp_department, cp.cp_catalog_number, ca.ca_state, cd.cd_education_status, COUNT(DISTINCT c.c_customer_sk) AS number_of_customers, SUM(sr.sr_return_quantity) AS total_returned_quantity, AVG(sr.sr_return_amt) AS average_return_amount, SUM(sr.sr_net_loss) AS total_net_loss FROM store_returns sr JOIN customer c ON sr.sr_customer_sk = c.c_customer_sk JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk JOIN catalog_page cp ON cp.cp_catalog_number = ANY('{42, 25, 9}'::integer[]) WHERE cd.cd_education_status = 'College' AND ca.ca_street_number IN ('2', '843', '939', '802', '540') AND sr.sr_returned_date_sk IS NOT NULL GROUP BY cp.cp_department, cp.cp_catalog_number, ca.ca_state, cd.cd_education_status ORDER BY total_net_loss DESC, total_returned_quantity DESC;
SELECT s.s_store_name, COUNT(DISTINCT ss.ss_ticket_number) AS total_sales_transactions, SUM(ss.ss_quantity) AS total_items_sold, AVG(ss.ss_sales_price) AS average_sales_price, SUM(ss.ss_ext_discount_amt) AS total_discount_amount, SUM(ss.ss_net_paid) AS total_net_sales, SUM(ss.ss_net_paid_inc_tax) AS net_sales_including_tax, SUM(ss.ss_net_profit) AS total_net_profit, COUNT(DISTINCT wr.wr_order_number) AS total_returns_transactions, SUM(wr.wr_return_quantity) AS total_items_returned, AVG(wr.wr_return_amt) AS average_return_amount, SUM(wr.wr_fee) AS total_return_fees, SUM(wr.wr_net_loss) AS total_net_loss FROM store s JOIN store_sales ss ON s.s_store_sk = ss.ss_store_sk LEFT JOIN web_returns wr ON ss.ss_item_sk = wr.wr_item_sk AND ss.ss_ticket_number = wr.wr_order_number WHERE s.s_county = 'Williamson County' AND ss.ss_coupon_amt IN (215.60, 1007.22, 1869.51) GROUP BY s.s_store_name ORDER BY s.s_store_name;
SELECT r.r_reason_id, r.r_reason_desc, COUNT(DISTINCT cr.cr_order_number) AS total_returns, SUM(cr.cr_return_quantity) AS total_returned_quantity, AVG(cr.cr_return_quantity) AS avg_returned_quantity, SUM(cr.cr_return_amount) AS total_return_amount, AVG(cr.cr_return_amount) AS avg_return_amount, SUM(cr.cr_return_tax) AS total_return_tax, SUM(cr.cr_fee) AS total_fees, SUM(cr.cr_net_loss) AS total_net_loss, sm.sm_type AS shipping_type, sm.sm_carrier AS carrier, w.w_warehouse_name AS warehouse_name, s.s_store_name AS store_name FROM catalog_returns cr JOIN reason r ON cr.cr_reason_sk = r.r_reason_sk JOIN time_dim t ON cr.cr_returned_time_sk = t.t_time_sk JOIN ship_mode sm ON cr.cr_ship_mode_sk = sm.sm_ship_mode_sk JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk JOIN store s ON cr.cr_returning_addr_sk = s.s_store_sk WHERE t.t_sub_shift = 'night' AND t.t_shift = 'third' AND w.w_warehouse_sq_ft > 900000 AND r.r_reason_id IN ('AAAAAAAAIAAAAAAA', 'AAAAAAAAIBAAAAAA', 'AAAAAAAAGAAAAAAA', 'AAAAAAAAACAAAAAA', 'AAAAAAAAPBAAAAAA', 'AAAAAAAAOBAAAAAA') GROUP BY r.r_reason_id, r.r_reason_desc, sm.sm_type, sm.sm_carrier, w.w_warehouse_name, s.s_store_name ORDER BY total_return_amount DESC, total_returns DESC;
SELECT cd.cd_gender, cd.cd_marital_status, AVG(cd.cd_purchase_estimate) AS avg_purchase_estimate, SUM(ws.ws_net_paid) AS total_web_sales, COUNT(DISTINCT ws.ws_order_number) AS total_orders FROM web_sales ws JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk JOIN web_site wsit ON ws.ws_web_site_sk = wsit.web_site_sk WHERE wsit.web_city IN ('Midway', 'Fairview') AND wsit.web_manager IN ('Lewis Wolf', 'William Carter') GROUP BY cd.cd_gender, cd.cd_marital_status ORDER BY total_web_sales DESC, avg_purchase_estimate DESC;
SELECT c.c_customer_id, COUNT(ws.ws_order_number) AS total_orders, SUM(ws.ws_quantity) AS total_units_sold, AVG(ws.ws_sales_price) AS average_sales_price, SUM(ws.ws_net_paid) AS total_net_paid, SUM(ws.ws_net_profit) AS total_net_profit, sm.sm_type AS shipping_mode, EXTRACT(YEAR FROM d_date) AS sales_year FROM web_sales ws JOIN date_dim d_date ON ws.ws_sold_date_sk = d_date.d_date_sk JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk WHERE d_date.d_year = 2020 GROUP BY c.c_customer_id, sm.sm_type, sales_year ORDER BY total_net_paid DESC, total_net_profit DESC;
SELECT dd.d_year, dd.d_quarter_name, COUNT(DISTINCT sr.sr_ticket_number) AS total_store_returns, SUM(sr.sr_return_amt_inc_tax) AS total_store_return_value, AVG(sr.sr_return_amt_inc_tax) AS avg_store_return_value, COUNT(DISTINCT cr.cr_order_number) AS total_catalog_returns, SUM(cr.cr_return_amt_inc_tax) AS total_catalog_return_value, AVG(cr.cr_return_amt_inc_tax) AS avg_catalog_return_value, SUM(inv.inv_quantity_on_hand) AS total_inventory, AVG(inv.inv_quantity_on_hand) AS avg_inventory, COUNT(DISTINCT p.p_promo_sk) AS total_promotions, SUM(p.p_cost) AS total_promotion_cost, AVG(p.p_cost) AS avg_promotion_cost FROM date_dim dd LEFT JOIN store_returns sr ON dd.d_date_sk = sr.sr_returned_date_sk LEFT JOIN catalog_returns cr ON dd.d_date_sk = cr.cr_returned_date_sk LEFT JOIN inventory inv ON dd.d_date_sk = inv.inv_date_sk LEFT JOIN promotion p ON dd.d_date_sk BETWEEN p.p_start_date_sk AND p.p_end_date_sk WHERE dd.d_current_quarter = 'N' AND dd.d_dow IN ('2', '1', '3') AND dd.d_week_seq IN ('357', '270', '599') AND dd.d_day_name IN ('Friday', 'Wednesday', 'Thursday') AND cr.cr_refunded_cash IN ('41.98', '2827.18', '326.60') AND cr.cr_return_tax IN ('78.35', '1.90', '17.50') AND cr.cr_reason_sk IN ('10', '6', '34') AND inv.inv_date_sk = '2450815' AND inv.inv_quantity_on_hand IN ('527', '833', '192') AND sr.sr_store_credit IN ('65.83', '69.57', '46.64') AND sr.sr_return_amt_inc_tax IN ('1345.99', '37.28', '546.00') AND sr.sr_hdemo_sk IN ('5161', '6269', '797') AND p.p_channel_radio = 'N' AND p.p_channel_press = 'N' GROUP BY dd.d_year, dd.d_quarter_name ORDER BY dd.d_year, dd.d_quarter_name;
SELECT dd.d_year, dd.d_quarter_name, sm.sm_type, COUNT(DISTINCT ws.web_site_sk) AS num_websites, COUNT(DISTINCT cc.cc_call_center_sk) AS num_call_centers, COUNT(DISTINCT st.s_store_sk) AS num_stores, SUM(wr.wr_return_amt) AS total_return_amount, AVG(st.s_number_employees) AS avg_store_employees, AVG(wr.wr_fee) AS avg_return_fee FROM date_dim dd JOIN web_returns wr ON dd.d_date_sk = wr.wr_returned_date_sk JOIN web_site ws ON wr.wr_web_page_sk = ws.web_site_sk JOIN call_center cc ON ws.web_market_manager = cc.cc_manager JOIN store st ON cc.cc_mkt_id = st.s_market_id JOIN ship_mode sm ON sm.sm_ship_mode_sk = wr.wr_item_sk WHERE dd.d_dom = 7 AND dd.d_weekend = 'Y' AND st.s_country = 'United States' AND st.s_number_employees IN (271, 297) AND sm.sm_type IN ('LIBRARY', 'REGULAR', 'TWO DAY', 'OVERNIGHT') AND sm.sm_contract IN ('P7FBIt8yd', 'Xjy3ZPuiDjzHlRx14Z3', '2mM8l', 'Ek') AND ws.web_zip IN ('35709', '31904') AND ws.web_street_number IN ('671', '247', '973', '730') GROUP BY dd.d_year, dd.d_quarter_name, sm.sm_type ORDER BY total_return_amount DESC, avg_store_employees DESC;
SELECT ca_state, SUM(hd_dep_count) AS total_dependents, AVG(hd_vehicle_count) AS avg_vehicles, COUNT(DISTINCT ca_address_sk) AS total_addresses, SUM(CASE WHEN p_channel_email = '1' THEN p_response_target ELSE 0 END) AS email_promo_targets, AVG(inv_quantity_on_hand) AS avg_inventory_on_hand FROM customer_address ca JOIN household_demographics hd ON ca.ca_address_sk = hd.hd_demo_sk JOIN promotion p ON ca.ca_address_sk = p.p_promo_sk JOIN inventory i ON ca.ca_address_sk = i.inv_warehouse_sk GROUP BY ca_state ORDER BY ca_state;
SELECT ca.ca_state AS customer_state, ib.ib_income_band_sk AS income_band, date_dim.d_year AS sale_year, SUM(ss.ss_sales_price) AS total_sales, AVG(ss.ss_sales_price) AS avg_sales_price, COUNT(DISTINCT ss.ss_ticket_number) AS sales_transactions, SUM(wr.wr_return_amt) AS total_returns, AVG(wr.wr_return_amt) AS avg_return_amt, COUNT(DISTINCT wr.wr_order_number) AS return_transactions, (SUM(ss.ss_sales_price) - SUM(wr.wr_return_amt)) AS net_sales FROM store_sales ss LEFT JOIN web_returns wr ON ss.ss_item_sk = wr.wr_item_sk AND ss.ss_customer_sk = wr.wr_refunded_customer_sk INNER JOIN date_dim ON ss.ss_sold_date_sk = date_dim.d_date_sk INNER JOIN customer_address ca ON ss.ss_addr_sk = ca.ca_address_sk INNER JOIN income_band ib ON ss.ss_cdemo_sk = ib.ib_income_band_sk WHERE ca.ca_state IS NOT NULL AND date_dim.d_year >= 2000 GROUP BY ca.ca_state, ib.ib_income_band_sk, date_dim.d_year ORDER BY ca.ca_state, ib.ib_income_band_sk, date_dim.d_year;
SELECT ca.ca_state, COUNT(DISTINCT c.c_customer_sk) AS num_customers, COUNT(wr.wr_order_number) AS num_returns, SUM(wr.wr_return_amt) AS total_return_amount, AVG(wr.wr_return_amt) AS avg_return_amount FROM customer c JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk LEFT JOIN web_returns wr ON c.c_customer_sk = wr.wr_refunded_customer_sk WHERE c.c_customer_sk IN (2939, 1085, 4773) GROUP BY ca.ca_state ORDER BY total_return_amount DESC, num_returns DESC;
SELECT cp.cp_department, EXTRACT(YEAR FROM TO_DATE(cp.cp_end_date_sk::varchar, 'YYYYMMDD')) AS year_ended, hd.hd_income_band_sk, COUNT(DISTINCT sr.sr_customer_sk) AS num_customers_returned, SUM(sr.sr_return_quantity) AS total_returned_quantity, AVG(sr.sr_net_loss) AS average_net_loss, SUM(ss.ss_quantity) AS total_sold_quantity, SUM(ss.ss_net_profit) AS total_net_profit, AVG(c.c_birth_year) AS average_customer_birth_year FROM catalog_page cp JOIN store_returns sr ON cp.cp_catalog_page_sk = sr.sr_reason_sk JOIN store_sales ss ON sr.sr_item_sk = ss.ss_item_sk AND sr.sr_ticket_number = ss.ss_ticket_number JOIN customer c ON sr.sr_customer_sk = c.c_customer_sk JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk WHERE cp.cp_end_date_sk IN ('2451114', '2451084', '2451479') AND hd.hd_dep_count IN (3, 6, 7) AND c.c_birth_month IN (2, 6, 12) GROUP BY cp.cp_department, year_ended, hd.hd_income_band_sk ORDER BY total_net_profit DESC, average_net_loss, num_customers_returned;
SELECT i.i_category, sm.sm_type, w.w_state, SUM(ws.ws_sales_price) AS total_sales, AVG(ws.ws_sales_price) AS avg_sales_price, COUNT(DISTINCT ws.ws_order_number) AS total_orders, SUM(sr.sr_return_amt) AS total_returns, AVG(sr.sr_return_amt) AS avg_return_amt, COUNT(DISTINCT sr.sr_ticket_number) AS total_return_tickets FROM web_sales ws JOIN item i ON ws.ws_item_sk = i.i_item_sk JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk JOIN warehouse w ON ws.ws_warehouse_sk = w.w_warehouse_sk LEFT JOIN store_returns sr ON ws.ws_item_sk = sr.sr_item_sk WHERE sm.sm_code IN ('SEA', 'BIKE', 'AIR', 'SURFACE') AND i.i_class IN ('loose stones', 'swimwear', 'semi-precious', 'maternity', 'camping') AND i.i_manager_id IN ('92', '83') AND w.w_street_name LIKE '%6th%' GROUP BY i.i_category, sm.sm_type, w.w_state ORDER BY total_sales DESC, total_returns DESC;
SELECT cc_state, cc_city, ca_country, COUNT(DISTINCT cc_call_center_sk) AS number_of_call_centers, SUM(cc_employees) AS total_employees, AVG(cc_tax_percentage) AS avg_tax_percentage, SUM(s_number_employees) AS total_store_employees, AVG(s_tax_precentage) AS avg_store_tax, SUM(ws_quantity) AS total_items_sold, SUM(ws_net_paid) AS total_revenue, SUM(ws_net_profit) AS total_profit, AVG(ws_net_profit) AS avg_profit_per_sale, SUM(ws_ext_ship_cost) AS total_shipping_cost FROM call_center JOIN store ON cc_zip = s_zip JOIN web_sales ON ws_ship_addr_sk IN (SELECT ca_address_sk FROM customer_address WHERE ca_zip = cc_zip) JOIN customer_address ON cc_zip = ca_zip WHERE cc_hours IN ('8AM-4PM', '8AM-8AM') AND ws_net_profit NOT IN (-1167.89, -63.88, -192.70, -49.59) AND ca_country = 'United States' AND ca_gmt_offset IN (-8.00, -9.00) GROUP BY cc_state, cc_city, ca_country ORDER BY total_profit DESC;
SELECT ib.ib_lower_bound, ib.ib_upper_bound, COUNT(wr.wr_item_sk) AS total_returns, AVG(wr.wr_net_loss) AS avg_net_loss, AVG(wr.wr_return_amt) AS avg_return_amount FROM web_returns wr JOIN customer c ON wr.wr_refunded_customer_sk = c.c_customer_sk JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk WHERE wr.wr_net_loss IS NOT NULL AND ib.ib_lower_bound IN (120001, 160001, 170001, 130001, 190001) AND hd.hd_income_band_sk = 14 AND wr.wr_refunded_customer_sk IN (2008, 38728, 70489, 86208, 44407) GROUP BY ib.ib_lower_bound, ib.ib_upper_bound ORDER BY avg_net_loss DESC;
SELECT r.r_reason_desc, ca.ca_state, d.d_moy AS month_of_year, COUNT(sr.sr_ticket_number) AS return_count, SUM(sr.sr_return_amt) AS total_return_amount, AVG(sr.sr_return_amt) AS avg_return_amount FROM store_returns sr JOIN reason r ON sr.sr_reason_sk = r.r_reason_sk JOIN date_dim d ON sr.sr_returned_date_sk = d.d_date_sk JOIN customer_address ca ON sr.sr_addr_sk = ca.ca_address_sk WHERE d.d_current_year = 'Y' GROUP BY r.r_reason_desc, ca.ca_state, month_of_year ORDER BY r.r_reason_desc, ca.ca_state, month_of_year;
SELECT sm.sm_code AS shipping_mode, s.s_store_name AS store_name, cc.cc_name AS call_center_name, COUNT(cr.cr_order_number) AS total_returns, SUM(cr.cr_return_amount) AS total_return_amount, AVG(cr.cr_return_quantity) AS avg_return_quantity, COUNT(DISTINCT cr.cr_refunded_customer_sk) AS unique_customers, COUNT(DISTINCT ws.ws_order_number) AS total_web_sales_orders, SUM(ws.ws_net_profit) AS total_web_sales_profit FROM catalog_returns cr JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk JOIN ship_mode sm ON cr.cr_ship_mode_sk = sm.sm_ship_mode_sk JOIN store s ON cc.cc_division = s.s_division_id JOIN web_sales ws ON cr.cr_item_sk = ws.ws_item_sk AND cr.cr_order_number = ws.ws_order_number WHERE cr.cr_returned_date_sk BETWEEN 2450952 AND 2451063 AND sm.sm_code IN ('SEA', 'BIKE', 'AIR', 'SURFACE') AND s.s_hours IN ('8AM-12AM', '8AM-4PM') GROUP BY shipping_mode, store_name, call_center_name ORDER BY total_returns DESC, total_return_amount DESC;
SELECT p.p_promo_name, p.p_channel_dmail, p.p_channel_email, p.p_channel_catalog, p.p_channel_tv, p.p_channel_radio, p.p_channel_press, p.p_channel_event, p.p_channel_demo, SUM(p.p_cost) AS total_promotion_cost, COUNT(p.p_promo_sk) AS number_of_promotions, AVG(cd.cd_dep_count) AS average_number_of_dependents FROM promotion p JOIN web_page wp ON p.p_item_sk = wp.wp_web_page_sk JOIN customer_demographics cd ON wp.wp_customer_sk = cd.cd_demo_sk WHERE wp.wp_creation_date_sk IN ('2450808', '2450809') AND p.p_response_target = 1 AND cd.cd_marital_status IN ('W', 'D', 'U', 'S') GROUP BY p.p_promo_name, p.p_channel_dmail, p.p_channel_email, p.p_channel_catalog, p.p_channel_tv, p.p_channel_radio, p.p_channel_press, p.p_channel_event, p.p_channel_demo ORDER BY total_promotion_cost DESC, number_of_promotions DESC;
SELECT ws2.web_name AS website, ws2.web_market_manager AS market_manager, cd.cd_gender AS customer_gender, SUM(ws.ws_sales_price) AS total_sales, AVG(ws.ws_sales_price) AS average_sales, COUNT(DISTINCT ws.ws_order_number) AS number_of_orders, SUM(ws.ws_quantity) AS total_quantity_sold, COUNT(DISTINCT c.c_customer_sk) AS number_of_customers, ca.ca_state AS customer_state, ca.ca_city AS customer_city FROM web_sales ws JOIN web_site ws2 ON ws.ws_web_site_sk = ws2.web_site_sk JOIN customer c ON ws.ws_ship_customer_sk = c.c_customer_sk JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk WHERE ws.ws_sold_date_sk BETWEEN 2450815 AND 2450815 + 30 AND ws.ws_promo_sk = 212 AND ws2.web_market_manager IN ('Jeffrey Martin', 'William Reyes', 'Kelvin Lynch', 'Frank Cooper', 'Keith Williams', 'John Isaacs') AND ca.ca_gmt_offset BETWEEN -5 AND -3 GROUP BY ws2.web_name, ws2.web_market_manager, cd.cd_gender, ca.ca_state, ca.ca_city ORDER BY total_sales DESC, number_of_orders DESC;
