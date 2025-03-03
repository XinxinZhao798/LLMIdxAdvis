SELECT p.p_promo_name AS promotion_name, i.ib_lower_bound AS income_band_lower_bound, i.ib_upper_bound AS income_band_upper_bound, COUNT(DISTINCT c.cd_demo_sk) AS number_of_customers, SUM(ss.ss_quantity) AS total_quantity_sold, AVG(ss.ss_sales_price) AS average_sales_price, SUM(ss.ss_net_paid) AS total_net_paid, SUM(ws.ws_net_paid_inc_tax) AS web_total_net_paid_inc_tax, COUNT(DISTINCT cp.cp_catalog_page_sk) AS number_of_catalog_pages_used, COUNT(DISTINCT inv.inv_item_sk) AS number_of_items_sold FROM store_sales ss JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk JOIN customer_demographics c ON ss.ss_cdemo_sk = c.cd_demo_sk JOIN income_band i ON c.cd_purchase_estimate BETWEEN i.ib_lower_bound AND i.ib_upper_bound JOIN web_sales ws ON ss.ss_item_sk = ws.ws_item_sk AND ss.ss_customer_sk = ws.ws_bill_customer_sk JOIN catalog_page cp ON ws.ws_web_page_sk = cp.cp_catalog_page_sk JOIN inventory inv ON ws.ws_item_sk = inv.inv_item_sk WHERE p.p_discount_active = 'Y' AND ss.ss_sold_date_sk BETWEEN 2451271 AND 2451575 AND cp.cp_start_date_sk BETWEEN 2451088 AND 2451420 AND inv.inv_quantity_on_hand > 0 GROUP BY promotion_name, income_band_lower_bound, income_band_upper_bound ORDER BY total_net_paid DESC, number_of_customers DESC;
SELECT w_city, cp_department, AVG(cs_quantity) AS average_quantity, SUM(cs_quantity) AS total_quantity, AVG(cs_sales_price) AS average_sales_price, SUM(cs_sales_price) AS total_sales, COUNT(DISTINCT cs_order_number) AS total_orders, SUM(cs_net_profit) AS total_net_profit FROM catalog_sales JOIN catalog_page ON catalog_sales.cs_catalog_page_sk = catalog_page.cp_catalog_page_sk JOIN warehouse ON catalog_sales.cs_warehouse_sk = warehouse.w_warehouse_sk WHERE w_city = 'Fairview' AND cp_department = 'DEPARTMENT' AND cp_description IN ( 'New resources might go from a proposals. Urgently', 'Only nuclear policies understand so basic courts.', 'Years withdraw most various, corresponding areas.', 'Facilities know changes. Now difficult changes go' ) GROUP BY w_city, cp_department ORDER BY total_net_profit DESC;
SELECT dd.d_year AS year, dd.d_quarter_name AS quarter, SUM(cs.cs_net_profit) AS total_sales_net_profit, SUM(sr.sr_net_loss) AS total_returns_net_loss, AVG(cd.cd_purchase_estimate) AS avg_customer_purchase_estimate, COUNT(DISTINCT cs.cs_order_number) AS total_sales_orders, COUNT(DISTINCT sr.sr_ticket_number) AS total_return_tickets, COUNT(DISTINCT s.s_store_sk) AS total_stores, COUNT(DISTINCT inv.inv_warehouse_sk) AS total_warehouses FROM date_dim dd LEFT JOIN catalog_sales cs ON dd.d_date_sk = cs.cs_sold_date_sk LEFT JOIN store_returns sr ON dd.d_date_sk = sr.sr_returned_date_sk LEFT JOIN customer_demographics cd ON (cs.cs_bill_cdemo_sk = cd.cd_demo_sk OR sr.sr_cdemo_sk = cd.cd_demo_sk) LEFT JOIN store s ON sr.sr_store_sk = s.s_store_sk LEFT JOIN inventory inv ON dd.d_date_sk = inv.inv_date_sk WHERE dd.d_fy_year = 2003 AND dd.d_fy_quarter_seq = 1 AND cd.cd_credit_rating = 'Low Risk' AND s.s_manager = 'William Ward' GROUP BY year, quarter ORDER BY year, quarter;
SELECT c.c_first_name, c.c_last_name, ca.ca_state, w.w_warehouse_name, SUM(i.inv_quantity_on_hand) AS total_inventory, AVG(cc.cc_tax_percentage) AS average_tax_percentage, COUNT(DISTINCT cc.cc_call_center_sk) AS number_of_call_centers FROM customer c JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk JOIN inventory i ON ca.ca_address_sk = i.inv_warehouse_sk JOIN warehouse w ON i.inv_warehouse_sk = w.w_warehouse_sk JOIN call_center cc ON w.w_state = cc.cc_state WHERE ca.ca_state IN ('MA', 'FL') AND w.w_warehouse_id IN ('AAAAAAAADAAAAAAA', 'AAAAAAAAFAAAAAAA', 'AAAAAAAABAAAAAAA') AND cc.cc_tax_percentage IN (0.01, 0.05, 0.11, 0.12) GROUP BY c.c_first_name, c.c_last_name, ca.ca_state, w.w_warehouse_name ORDER BY total_inventory DESC, average_tax_percentage, number_of_call_centers DESC;
SELECT cd.cd_gender, ib.ib_lower_bound AS income_lower_bound, ib.ib_upper_bound AS income_upper_bound, sm.sm_type AS shipping_type, COUNT(sr.sr_return_amt) AS total_returns, SUM(sr.sr_return_amt) AS total_value_of_returns, AVG(sr.sr_return_amt) AS average_return_value, SUM(sr.sr_return_quantity) AS total_quantity_returned FROM store_returns sr JOIN customer_demographics cd ON sr.sr_cdemo_sk = cd.cd_demo_sk JOIN income_band ib ON cd.cd_purchase_estimate BETWEEN ib.ib_lower_bound AND ib.ib_upper_bound JOIN ship_mode sm ON sm.sm_ship_mode_sk = sr.sr_item_sk WHERE sm.sm_type IN ('OVERNIGHT') AND cd.cd_gender IN ('M', 'F') GROUP BY cd.cd_gender, income_lower_bound, income_upper_bound, shipping_type ORDER BY total_value_of_returns DESC, total_returns DESC;
SELECT dd.d_year, dd.d_quarter_name, cp.cp_department, COUNT(DISTINCT cs.cs_order_number) AS total_orders, SUM(cs.cs_quantity) AS total_quantity_sold, SUM(cs.cs_net_paid) AS total_net_paid, AVG(cs.cs_net_paid / cs.cs_quantity) AS avg_net_paid_per_item, SUM(cs.cs_net_profit) AS total_net_profit FROM catalog_sales cs JOIN date_dim dd ON cs.cs_sold_date_sk = dd.d_date_sk JOIN catalog_page cp ON cs.cs_catalog_page_sk = cp.cp_catalog_page_sk WHERE dd.d_current_day = 'N' AND dd.d_qoy = '3' AND cs.cs_ship_hdemo_sk IN ('340', '2787', '2515', '487', '576', '6271') AND cp.cp_catalog_page_sk IN ('1948', '1122', '4477', '1780') GROUP BY dd.d_year, dd.d_quarter_name, cp.cp_department ORDER BY dd.d_year, dd.d_quarter_name, cp.cp_department;
SELECT s.s_store_name, s.s_city, s.s_state, i.i_category, i.i_brand, SUM(inv.inv_quantity_on_hand) AS total_inventory, AVG(i.i_current_price) AS average_price, COUNT(DISTINCT c.c_customer_sk) AS unique_customers, SUM(CASE WHEN c.c_preferred_cust_flag = 'Y' THEN 1 ELSE 0 END) AS preferred_customers_count FROM store s JOIN inventory inv ON s.s_store_sk = inv.inv_warehouse_sk JOIN item i ON inv.inv_item_sk = i.i_item_sk JOIN customer c ON s.s_store_sk = c.c_current_addr_sk WHERE s.s_state IN ('CA', 'TX', 'NY') AND c.c_last_review_date_sk BETWEEN 2452306 AND 2452404 AND i.i_rec_start_date <= CURRENT_DATE AND (i.i_rec_end_date IS NULL OR i.i_rec_end_date > CURRENT_DATE) GROUP BY s.s_store_name, s.s_city, s.s_state, i.i_category, i.i_brand ORDER BY total_inventory DESC, s.s_store_name, i.i_category, i.i_brand;
SELECT dd.d_year, dd.d_quarter_name, COUNT(DISTINCT sr.sr_ticket_number) AS total_store_returns, SUM(sr.sr_return_amt_inc_tax) AS total_store_return_value, AVG(sr.sr_return_amt_inc_tax) AS avg_store_return_value, COUNT(DISTINCT cr.cr_order_number) AS total_catalog_returns, SUM(cr.cr_return_amt_inc_tax) AS total_catalog_return_value, AVG(cr.cr_return_amt_inc_tax) AS avg_catalog_return_value, SUM(inv.inv_quantity_on_hand) AS total_inventory, AVG(inv.inv_quantity_on_hand) AS avg_inventory, COUNT(DISTINCT p.p_promo_sk) AS total_promotions, SUM(p.p_cost) AS total_promotion_cost, AVG(p.p_cost) AS avg_promotion_cost FROM date_dim dd LEFT JOIN store_returns sr ON dd.d_date_sk = sr.sr_returned_date_sk LEFT JOIN catalog_returns cr ON dd.d_date_sk = cr.cr_returned_date_sk LEFT JOIN inventory inv ON dd.d_date_sk = inv.inv_date_sk LEFT JOIN promotion p ON dd.d_date_sk BETWEEN p.p_start_date_sk AND p.p_end_date_sk WHERE dd.d_current_quarter = 'N' AND dd.d_dow IN ('2', '1', '3') AND dd.d_week_seq IN ('357', '270', '599') AND dd.d_day_name IN ('Friday', 'Wednesday', 'Thursday') AND cr.cr_refunded_cash IN ('41.98', '2827.18', '326.60') AND cr.cr_return_tax IN ('78.35', '1.90', '17.50') AND cr.cr_reason_sk IN ('10', '6', '34') AND inv.inv_date_sk = '2450815' AND inv.inv_quantity_on_hand IN ('527', '833', '192') AND sr.sr_store_credit IN ('65.83', '69.57', '46.64') AND sr.sr_return_amt_inc_tax IN ('1345.99', '37.28', '546.00') AND sr.sr_hdemo_sk IN ('5161', '6269', '797') AND p.p_channel_radio = 'N' AND p.p_channel_press = 'N' GROUP BY dd.d_year, dd.d_quarter_name ORDER BY dd.d_year, dd.d_quarter_name;
SELECT dd.d_year, dd.d_quarter_name, ib.ib_lower_bound, ib.ib_upper_bound, SUM(ws.ws_quantity) AS total_quantity, AVG(ws.ws_sales_price) AS average_sales_price, COUNT(DISTINCT ws.ws_order_number) AS total_orders, SUM(ws.ws_net_profit) AS total_net_profit FROM web_sales ws JOIN date_dim dd ON ws.ws_sold_date_sk = dd.d_date_sk JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk JOIN income_band ib ON cd.cd_purchase_estimate BETWEEN ib.ib_lower_bound AND ib.ib_upper_bound JOIN web_page wp ON ws.ws_web_page_sk = wp.wp_web_page_sk JOIN time_dim td ON ws.ws_sold_time_sk = td.t_time_sk WHERE wp.wp_type = 'welcome' AND wp.wp_autogen_flag = 'N' AND dd.d_quarter_seq IN (SELECT DISTINCT d_quarter_seq FROM date_dim WHERE d_year = 2023) AND td.t_hour BETWEEN 8 AND 20 GROUP BY dd.d_year, dd.d_quarter_name, ib.ib_lower_bound, ib.ib_upper_bound ORDER BY dd.d_year, dd.d_quarter_name, ib.ib_lower_bound, ib.ib_upper_bound;
SELECT d.d_year, d.d_quarter_name, COUNT(DISTINCT c.c_customer_sk) AS total_customers, SUM(inv.inv_quantity_on_hand) AS total_inventory, AVG(wp.wp_link_count) AS avg_link_count, SUM(CASE WHEN c.c_preferred_cust_flag = 'Y' THEN 1 ELSE 0 END) AS preferred_customers_count, SUM(CASE WHEN d.d_holiday = 'Y' THEN 1 ELSE 0 END) AS holiday_count FROM date_dim d JOIN customer c ON c.c_first_sales_date_sk = d.d_date_sk JOIN inventory inv ON inv.inv_date_sk = d.d_date_sk JOIN web_page wp ON wp.wp_access_date_sk = d.d_date_sk WHERE d.d_year = 2021 GROUP BY d.d_year, d.d_quarter_name ORDER BY d.d_year, d.d_quarter_name;
SELECT w_state, w_city, p_promo_name, p_channel_details, COUNT(ss_ticket_number) AS ticket_count, SUM(ss_quantity) AS total_quantity_sold, AVG(ss_sales_price) AS average_sales_price, SUM(ss_net_paid) AS total_net_paid, SUM(ss_net_profit) AS total_net_profit FROM store_sales JOIN warehouse ON ss_addr_sk = w_warehouse_sk JOIN promotion ON ss_promo_sk = p_promo_sk JOIN time_dim ON ss_sold_time_sk = t_time_sk JOIN household_demographics ON ss_hdemo_sk = hd_demo_sk WHERE w_country = 'United States' AND t_am_pm = 'PM' AND hd_buy_potential = 'Unknown' AND p_discount_active = 'Y' GROUP BY w_state, w_city, p_promo_name, p_channel_details ORDER BY total_net_profit DESC, total_net_paid DESC LIMIT 10;
SELECT dd.d_year, COUNT(DISTINCT wr.wr_order_number) AS num_returns, SUM(wr.wr_return_quantity) AS total_returned_qty, AVG(wr.wr_return_amt) AS avg_return_amt, SUM(wr.wr_fee) AS total_fees, SUM(wr.wr_return_ship_cost) AS total_ship_cost, SUM(wr.wr_net_loss) AS total_net_loss, cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, i.i_category, i.i_brand, wh.w_warehouse_name, wh.w_city FROM web_returns wr JOIN date_dim dd ON wr.wr_returned_date_sk = dd.d_date_sk JOIN customer_demographics cd ON wr.wr_returning_cdemo_sk = cd.cd_demo_sk JOIN item i ON wr.wr_item_sk = i.i_item_sk JOIN warehouse wh ON i.i_item_sk = wh.w_warehouse_sk WHERE dd.d_year = 2000 AND (wr.wr_reversed_charge = 23.38 OR wr.wr_reversed_charge = 11.02) AND wr.wr_web_page_sk IN (18, 32, 58) AND (dd.d_quarter_seq = 27 OR dd.d_quarter_seq = 20) AND dd.d_month_seq = 131 AND wh.w_warehouse_sq_ft IN (621234, 294242) AND wh.w_street_name IN ('6th', 'Wilson Elm') GROUP BY dd.d_year, cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, i.i_category, i.i_brand, wh.w_warehouse_name, wh.w_city ORDER BY total_net_loss DESC, avg_return_amt DESC LIMIT 100;
SELECT w_state, sm_type, EXTRACT(YEAR FROM wp_rec_start_date) AS year, EXTRACT(QUARTER FROM wp_rec_start_date) AS quarter, SUM(cs_quantity) AS total_quantity, AVG(cs_sales_price) AS average_sales_price, COUNT(DISTINCT cs_order_number) AS total_orders, SUM(cs_net_paid) AS total_net_paid, SUM(cs_net_profit) AS total_net_profit FROM catalog_sales JOIN warehouse ON cs_warehouse_sk = w_warehouse_sk JOIN ship_mode ON cs_ship_mode_sk = sm_ship_mode_sk JOIN web_page ON cs_catalog_page_sk = wp_web_page_sk JOIN time_dim ON cs_sold_time_sk = t_time_sk JOIN inventory ON cs_warehouse_sk = inv_warehouse_sk AND cs_item_sk = inv_item_sk WHERE t_time_sk IN (1701, 993, 898, 4227, 3566, 3142) AND sm_carrier IN ('GERMA', 'DHL', 'ORIENTAL', 'PRIVATECARRIER') AND inv_date_sk = 2450815 GROUP BY w_state, sm_type, year, quarter ORDER BY total_net_profit DESC, total_net_paid DESC, total_orders DESC;
SELECT ws.ws_web_site_sk, ws.ws_web_page_sk, COUNT(DISTINCT ws.ws_order_number) AS total_orders, SUM(ws.ws_quantity) AS total_quantity_sold, AVG(ws.ws_sales_price) AS average_sales_price, SUM(ws.ws_net_paid) AS total_net_paid, SUM(ws.ws_net_profit) AS total_net_profit, w.w_warehouse_name, w.w_county, cd.cd_gender, cd.cd_education_status, cd.cd_credit_rating, COUNT(DISTINCT cd.cd_demo_sk) AS unique_customers FROM web_sales ws JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk JOIN warehouse w ON ws.ws_warehouse_sk = w.w_warehouse_sk WHERE ws.ws_web_page_sk IN ('8', '48', '14', '26', '5') AND w.w_street_name IN ('Ash Laurel', '6th', 'Wilson Elm', 'View First') AND w.w_county = 'Williamson County' AND cd.cd_credit_rating IN ('High Risk', 'Low Risk', 'Good', 'Unknown') GROUP BY ws.ws_web_site_sk, ws.ws_web_page_sk, w.w_warehouse_name, w.w_county, cd.cd_gender, cd.cd_education_status, cd.cd_credit_rating ORDER BY total_net_profit DESC, total_net_paid DESC;
SELECT dd.d_year, dd.d_quarter_name, ca.ca_state, ca.ca_country, SUM(cs.cs_quantity) AS total_quantity_sold, AVG(cs.cs_sales_price) AS average_sales_price, COUNT(DISTINCT cs.cs_order_number) AS total_orders, SUM(cs.cs_net_paid_inc_ship_tax) AS total_revenue, SUM(cs.cs_net_profit) AS total_profit FROM catalog_sales cs JOIN date_dim dd ON cs.cs_sold_date_sk = dd.d_date_sk JOIN customer_address ca ON cs.cs_bill_addr_sk = ca.ca_address_sk JOIN store s ON cs.cs_warehouse_sk = s.s_store_sk WHERE dd.d_year = 2002 AND ca.ca_country = 'United States' AND s.s_division_id = 1 AND ( dd.d_week_seq IN (54, 685, 542) OR dd.d_quarter_seq IN (43, 26, 39) ) AND ( cs.cs_item_sk IN (58, 10, 49) OR cs.cs_warehouse_sk IN (3, 2, 4) ) AND cs.cs_net_paid_inc_ship_tax IN (2242.98, 10093.84, 2662.12) GROUP BY dd.d_year, dd.d_quarter_name, ca.ca_state, ca.ca_country ORDER BY total_revenue DESC, total_profit DESC LIMIT 100;
SELECT i_category, i_class, ca_state, cd_gender, cd_education_status, SUM(cr_return_amount) AS total_return_amount, AVG(cr_return_amount) AS avg_return_amount, COUNT(*) AS return_count, SUM(ss_net_profit) AS total_store_sales_profit, AVG(ss_net_profit) AS avg_store_sales_profit, COUNT(DISTINCT ss_ticket_number) AS store_sales_count, SUM(ws_net_profit) AS total_web_sales_profit, AVG(ws_net_profit) AS avg_web_sales_profit, COUNT(DISTINCT ws_order_number) AS web_sales_count FROM catalog_returns JOIN item ON cr_item_sk = i_item_sk JOIN customer_address ON cr_returning_addr_sk = ca_address_sk JOIN customer_demographics ON cr_returning_cdemo_sk = cd_demo_sk LEFT JOIN store_sales ON cr_item_sk = ss_item_sk AND cr_returned_date_sk = ss_sold_date_sk LEFT JOIN web_sales ON cr_item_sk = ws_item_sk AND cr_returned_date_sk = ws_sold_date_sk GROUP BY i_category, i_class, ca_state, cd_gender, cd_education_status ORDER BY total_return_amount DESC, total_store_sales_profit DESC, total_web_sales_profit DESC LIMIT 100;
SELECT w_state, cd_education_status, SUM(cr_return_amount) AS total_return_amount, AVG(cr_return_quantity) AS avg_return_quantity, COUNT(DISTINCT cr_order_number) AS total_orders_returned, SUM(inv_quantity_on_hand) AS total_inventory_on_hand FROM catalog_returns JOIN customer_demographics ON cr_returning_cdemo_sk = cd_demo_sk JOIN warehouse ON cr_warehouse_sk = w_warehouse_sk JOIN inventory ON (catalog_returns.cr_warehouse_sk = inventory.inv_warehouse_sk AND catalog_returns.cr_item_sk = inventory.inv_item_sk) JOIN web_page ON cr_catalog_page_sk = wp_web_page_sk WHERE w_street_type IN ('Drive', 'Dr.', 'Avenue', 'Parkway') AND cd_dep_count IN (1, 2) AND cd_education_status IN ('Secondary', 'Unknown') AND wp_max_ad_count = 2 AND wp_autogen_flag = 'Y' GROUP BY w_state, cd_education_status ORDER BY total_return_amount DESC, avg_return_quantity DESC, total_orders_returned DESC, total_inventory_on_hand DESC;
SELECT dd.d_year, dd.d_quarter_name, cc.cc_division_name, SUM(wp.wp_char_count) AS total_char_count, AVG(wp.wp_link_count) AS average_link_count, COUNT(*) AS num_web_pages_accessed, COUNT(DISTINCT cc.cc_call_center_sk) AS num_call_centers_involved, COUNT(DISTINCT r.r_reason_sk) AS num_distinct_reasons FROM date_dim AS dd JOIN web_page AS wp ON dd.d_date_sk = wp.wp_access_date_sk JOIN call_center AS cc ON wp.wp_customer_sk = cc.cc_call_center_sk LEFT JOIN reason AS r ON r.r_reason_sk = wp.wp_customer_sk WHERE dd.d_year = 2022 AND dd.d_quarter_name IN ('Q1', 'Q2', 'Q3', 'Q4') AND r.r_reason_sk IN ('15', '31', '3', '32', '5') GROUP BY dd.d_year, dd.d_quarter_name, cc.cc_division_name ORDER BY dd.d_year, dd.d_quarter_name, cc.cc_division_name;
SELECT cc_state, ca_location_type, COUNT(DISTINCT ws_order_number) AS total_orders, SUM(ws_quantity) AS total_quantity_sold, AVG(ws_sales_price) AS avg_sales_price, SUM(ws_net_paid) AS total_net_paid, SUM(ws_net_profit) AS total_net_profit FROM web_sales ws JOIN store s ON ws.ws_bill_addr_sk = s.s_store_sk JOIN call_center cc ON cc.cc_call_center_sk = ws.ws_ship_mode_sk JOIN customer_address ca ON ws.ws_bill_addr_sk = ca.ca_address_sk JOIN household_demographics hd ON ws.ws_bill_hdemo_sk = hd.hd_demo_sk WHERE ws.ws_item_sk IN (70, 58, 77) AND hd.hd_dep_count BETWEEN 1 AND 9 AND ca.ca_location_type IN ('single family', 'apartment', 'condo') AND ca.ca_city IN ('Ferguson', 'Holiday Hills') GROUP BY cc_state, ca_location_type ORDER BY total_net_profit DESC, total_net_paid DESC;
