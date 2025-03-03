SELECT sm.sm_carrier, COUNT(DISTINCT cs.cs_order_number) AS total_orders, SUM(cs.cs_quantity) AS total_quantity_sold, AVG(cs.cs_sales_price) AS average_sales_price, SUM(cs.cs_net_profit) AS total_profit, COUNT(DISTINCT sr.sr_ticket_number) AS total_returns, SUM(sr.sr_return_quantity) AS total_quantity_returned, AVG(sr.sr_return_amt) AS average_return_amount, SUM(sr.sr_net_loss) AS total_loss, COUNT(DISTINCT ss.ss_ticket_number) AS total_store_sales, SUM(ss.ss_quantity) AS total_store_quantity_sold, AVG(ss.ss_sales_price) AS average_store_sales_price, SUM(ss.ss_net_profit) AS total_store_profit FROM ship_mode sm LEFT JOIN catalog_sales cs ON sm.sm_ship_mode_sk = cs.cs_ship_mode_sk LEFT JOIN store_returns sr ON sr.sr_store_sk = cs.cs_bill_customer_sk LEFT JOIN store_sales ss ON ss.ss_store_sk = sr.sr_store_sk WHERE sm.sm_carrier IN ('UPS', 'BARIAN') AND sm.sm_ship_mode_id IN ('AAAAAAAAOAAAAAAA', 'AAAAAAAADAAAAAAA', 'AAAAAAAAFAAAAAAA', 'AAAAAAAACAAAAAAA') AND cs.cs_bill_hdemo_sk = 3987 AND sr.sr_return_time_sk IN (60750, 41614, 39692, 44726) AND EXISTS (SELECT 1 FROM web_site WHERE web_zip IN ('35709', '31904') AND web_site_sk = cs.cs_warehouse_sk) GROUP BY sm.sm_carrier ORDER BY total_profit DESC, total_loss ASC;
SELECT dd.d_year, dd.d_quarter_name, ca.ca_state, ca.ca_city, COUNT(DISTINCT sr.sr_customer_sk) AS number_of_returning_customers, SUM(sr.sr_return_quantity) AS total_returned_quantity, AVG(sr.sr_return_amt_inc_tax) AS avg_return_amount_inc_tax, SUM(sr.sr_fee) AS total_fees_collected, SUM(sr.sr_net_loss) AS total_net_loss FROM store_returns sr INNER JOIN date_dim dd ON sr.sr_returned_date_sk = dd.d_date_sk INNER JOIN customer_address ca ON sr.sr_addr_sk = ca.ca_address_sk INNER JOIN household_demographics hd ON sr.sr_hdemo_sk = hd.hd_demo_sk WHERE dd.d_year = 2022 AND hd.hd_buy_potential = '>10000' AND dd.d_quarter_seq = 52 GROUP BY dd.d_year, dd.d_quarter_name, ca.ca_state, ca.ca_city ORDER BY total_net_loss DESC, avg_return_amount_inc_tax DESC LIMIT 10;
SELECT cp_department, COUNT(DISTINCT cs_order_number) AS total_orders, SUM(cs_quantity) AS total_quantity_sold, AVG(cs_sales_price) AS average_sales_price, SUM(cs_net_paid) AS total_net_paid, SUM(cs_net_profit) AS total_net_profit, COUNT(DISTINCT ss_ticket_number) AS total_store_sales_tickets, SUM(ss_quantity) AS total_store_quantity_sold, AVG(ss_sales_price) AS average_store_sales_price, SUM(ss_net_paid_inc_tax) AS total_store_net_paid_inc_tax FROM catalog_sales JOIN catalog_page ON cs_catalog_page_sk = cp_catalog_page_sk JOIN store_sales ON catalog_sales.cs_item_sk = store_sales.ss_item_sk JOIN store ON store_sales.ss_store_sk = s_store_sk JOIN customer ON store_sales.ss_customer_sk = c_customer_sk WHERE c_birth_country IN ('MOLDOVA, REPUBLIC OF', 'TOGO', 'IRAQ', 'BURUNDI') AND cp_department IS NOT NULL AND cp_start_date_sk IS NOT NULL AND cp_end_date_sk IS NOT NULL AND (cp_end_date_sk - cp_start_date_sk) > 0 AND s_market_id IS NOT NULL GROUP BY cp_department ORDER BY total_net_profit DESC, total_orders DESC LIMIT 10;
SELECT ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound, COUNT(DISTINCT cs.cs_order_number) AS total_orders, SUM(cs.cs_quantity) AS total_quantity_sold, AVG(cs.cs_sales_price) AS average_sales_price, SUM(cs.cs_net_profit) AS total_net_profit, AVG(hd.hd_dep_count) AS average_dependency_count, AVG(hd.hd_vehicle_count) AS average_vehicle_count, SUM(ws.ws_net_paid_inc_ship) AS total_web_net_paid_inc_ship, AVG(ws.ws_net_paid_inc_ship) AS average_web_net_paid_inc_ship, SUM(ws.ws_quantity) AS total_web_quantity_sold, COUNT(DISTINCT ws.ws_order_number) AS total_web_orders, s.s_country, s.s_tax_precentage, MAX(t.t_time) AS max_time_of_purchase, MIN(t.t_time) AS min_time_of_purchase FROM income_band ib LEFT JOIN household_demographics hd ON ib.ib_income_band_sk = hd.hd_income_band_sk LEFT JOIN catalog_sales cs ON hd.hd_demo_sk = cs.cs_bill_hdemo_sk LEFT JOIN web_sales ws ON hd.hd_demo_sk = ws.ws_bill_hdemo_sk LEFT JOIN store s ON s.s_store_sk = cs.cs_warehouse_sk LEFT JOIN time_dim t ON t.t_time_sk = cs.cs_sold_time_sk WHERE s.s_country = 'United States' AND t.t_am_pm = 'AM' AND s.s_tax_precentage IN (0.08, 0.01) AND ws.ws_net_paid_inc_ship IN (1475.10, 4030.95, 1226.89, 21728.07) AND t.t_second = 36 GROUP BY ib.ib_income_band_sk, s.s_country, s.s_tax_precentage ORDER BY total_net_profit DESC, total_web_net_paid_inc_ship DESC;
SELECT cp.cp_department, i.i_category, COUNT(cr.cr_order_number) AS total_returns, SUM(cr.cr_return_amount) AS total_return_amount, AVG(cr.cr_return_amount) AS avg_return_amount, SUM(cr.cr_return_quantity) AS total_return_quantity, r.r_reason_desc, COUNT(DISTINCT cr.cr_refunded_customer_sk) AS unique_customers_refunded, COUNT(DISTINCT cr.cr_returning_customer_sk) AS unique_customers_returning, SUM(cr.cr_net_loss) AS total_net_loss FROM catalog_returns cr JOIN catalog_page cp ON cr.cr_catalog_page_sk = cp.cp_catalog_page_sk JOIN item i ON cr.cr_item_sk = i.i_item_sk JOIN reason r ON cr.cr_reason_sk = r.r_reason_sk WHERE cp.cp_end_date_sk IN ('2451087', '2451239', '2450904', '2450844') GROUP BY cp.cp_department, i.i_category, r.r_reason_desc ORDER BY total_return_amount DESC, total_returns DESC LIMIT 100;
SELECT dd.d_year, cc.cc_country, SUM(ss.ss_quantity) AS total_quantity_sold, AVG(ss.ss_sales_price) AS avg_sales_price, COUNT(DISTINCT wp.wp_web_page_sk) AS webpage_count, SUM(ss.ss_net_paid) - SUM(ss.ss_net_paid_inc_tax) AS total_tax_collected FROM store_sales ss JOIN date_dim dd ON ss.ss_sold_date_sk = dd.d_date_sk JOIN call_center cc ON cc.cc_call_center_sk = ss.ss_store_sk LEFT JOIN web_page wp ON dd.d_date_sk = wp.wp_access_date_sk WHERE dd.d_current_week = 'N' AND cc.cc_country = 'United States' AND cc.cc_call_center_sk IN ('3', '1', '5') AND wp.wp_image_count IN ('1', '2', '4', '5', '6', '7') GROUP BY dd.d_year, cc.cc_country ORDER BY dd.d_year, total_quantity_sold DESC;
SELECT i.i_category AS item_category, s.s_state AS store_state, COUNT(DISTINCT ss.ss_ticket_number) AS total_sales, AVG(ss.ss_net_paid_inc_tax) AS avg_sale_amount, COUNT(DISTINCT sr.sr_ticket_number) AS total_returns, SUM(sr.sr_return_amt_inc_tax) AS total_return_amount, AVG(sr.sr_return_amt_inc_tax) AS avg_return_amount, COUNT(DISTINCT wp.wp_web_page_sk) AS total_web_pages, SUM(wp.wp_image_count) AS total_images, AVG(wp.wp_image_count) AS avg_images_per_page FROM store_sales ss JOIN item i ON ss.ss_item_sk = i.i_item_sk JOIN store s ON ss.ss_store_sk = s.s_store_sk LEFT JOIN store_returns sr ON ss.ss_ticket_number = sr.sr_ticket_number LEFT JOIN web_page wp ON ss.ss_customer_sk = wp.wp_customer_sk WHERE s.s_state IN ('CA', 'TX', 'NY') AND i.i_category IN ('Electronics', 'Home Appliances', 'Books') AND ss.ss_sold_date_sk BETWEEN 20020101 AND 20021231 AND (wp.wp_image_count IS NULL OR wp.wp_image_count >= 3) GROUP BY item_category, store_state ORDER BY total_sales DESC, total_return_amount DESC;
SELECT i.i_category, i.i_brand, COUNT(DISTINCT i.i_item_sk) AS num_items, SUM(i.i_current_price) AS total_current_price, AVG(i.i_wholesale_cost) AS avg_wholesale_cost, COUNT(DISTINCT c.c_customer_sk) AS num_customers, AVG(c.c_birth_year) AS avg_customer_birth_year, r.r_reason_desc, COUNT(*) AS num_return_reasons FROM item i JOIN customer c ON i.i_manager_id = c.c_current_cdemo_sk LEFT JOIN reason r ON r.r_reason_desc IN ('Package was damaged', 'Did not like the make', 'Parts missing') WHERE i.i_rec_start_date >= '2020-01-01' AND (i.i_rec_end_date IS NULL OR i.i_rec_end_date > CURRENT_DATE) GROUP BY i.i_category, i.i_brand, r.r_reason_desc ORDER BY i.i_category, i.i_brand, r.r_reason_desc;
SELECT cc.cc_call_center_id, cc.cc_name, cc.cc_manager, cc.cc_county, SUM(cs.cs_quantity) AS total_quantity_sold, AVG(cs.cs_sales_price) AS average_sales_price, SUM(cs.cs_net_paid_inc_tax) AS total_net_sales_inc_tax, COUNT(*) AS total_sales_transactions, SUM(wr.wr_return_quantity) AS total_quantity_returned, SUM(wr.wr_net_loss) AS total_net_loss FROM call_center cc JOIN catalog_sales cs ON cc.cc_call_center_sk = cs.cs_call_center_sk LEFT JOIN web_returns wr ON cs.cs_item_sk = wr.wr_item_sk AND cs.cs_order_number = wr.wr_order_number WHERE cc.cc_manager IN ('Bob Belcher', 'Felipe Perkins', 'Larry Mccray', 'Mark Hightower') AND (wr.wr_net_loss = 420.16 OR wr.wr_net_loss = 722.98 OR wr.wr_net_loss IS NULL) AND cc.cc_county = 'Williamson County' AND (cs.cs_net_paid_inc_ship_tax IN (916.29, 1861.60, 1365.77, 6061.91, 2472.55) OR wr.wr_returned_time_sk IN (8001, 30891, 54739, 78943, 77408, 21386)) GROUP BY cc.cc_call_center_id, cc.cc_name, cc.cc_manager, cc.cc_county ORDER BY total_net_sales_inc_tax DESC, total_net_loss ASC;
SELECT dd.d_year, dd.d_quarter_name, SUM(cs.cs_net_paid_inc_ship) AS total_revenue, AVG(cs.cs_quantity) AS average_quantity_sold, COUNT(DISTINCT cs.cs_order_number) AS total_orders, SUM(CASE WHEN cd.cd_gender = 'F' THEN cs.cs_net_paid_inc_ship ELSE 0 END) AS female_total_revenue, SUM(CASE WHEN cd.cd_gender = 'M' THEN cs.cs_net_paid_inc_ship ELSE 0 END) AS male_total_revenue, COUNT(DISTINCT CASE WHEN ib.ib_upper_bound <= 50000 THEN cs.cs_bill_customer_sk END) AS customers_low_income, COUNT(DISTINCT CASE WHEN ib.ib_upper_bound > 50000 AND ib.ib_upper_bound <= 150000 THEN cs.cs_bill_customer_sk END) AS customers_mid_income, COUNT(DISTINCT CASE WHEN ib.ib_upper_bound > 150000 THEN cs.cs_bill_customer_sk END) AS customers_high_income, COUNT(DISTINCT sm.sm_ship_mode_sk) AS shipping_modes_used, COUNT(DISTINCT w.w_warehouse_sk) AS warehouses_used, COUNT(DISTINCT p.p_promo_sk) AS promotions_run FROM catalog_sales cs JOIN date_dim dd ON cs.cs_sold_date_sk = dd.d_date_sk JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk JOIN promotion p ON cs.cs_promo_sk = p.p_promo_sk LEFT JOIN income_band ib ON cd.cd_purchase_estimate BETWEEN ib.ib_lower_bound AND ib.ib_upper_bound WHERE dd.d_year IN (2020, 2021) GROUP BY dd.d_year, dd.d_quarter_name ORDER BY dd.d_year, dd.d_quarter_name;
SELECT sm.sm_type AS shipping_type, COUNT(DISTINCT cr.cr_order_number) AS total_return_transactions, SUM(cr.cr_return_amt_inc_tax) AS total_return_amount, AVG(cr.cr_return_amount) AS average_return_amount, COUNT(DISTINCT wr.wr_order_number) AS total_web_return_transactions, SUM(wr.wr_return_amt_inc_tax) AS total_web_return_amount, AVG(wr.wr_return_amt) AS average_web_return_amount FROM ship_mode sm LEFT JOIN catalog_returns cr ON sm.sm_ship_mode_sk = cr.cr_ship_mode_sk LEFT JOIN web_returns wr ON cr.cr_catalog_page_sk = wr.wr_web_page_sk LEFT JOIN web_site ws ON wr.wr_web_page_sk = ws.web_site_sk WHERE wr.wr_refunded_customer_sk IN ('49270', '61504', '79520') OR ws.web_city IN ('Fairview', 'Midway') GROUP BY sm.sm_type ORDER BY total_return_amount DESC, total_web_return_amount DESC;
SELECT s_store_name, sm_type, COUNT(DISTINCT ss_ticket_number) AS total_sales_transactions, SUM(ss_quantity) AS total_units_sold, SUM(ss_net_paid) AS total_revenue, AVG(ss_net_profit) AS average_profit_per_sale, SUM(wr_return_quantity) AS total_units_returned, SUM(wr_net_loss) AS total_loss_from_returns, (SUM(ss_net_paid) - SUM(wr_net_loss)) AS net_revenue_after_returns FROM store_sales ss JOIN store s ON ss.ss_store_sk = s.s_store_sk JOIN ship_mode sm ON ss.ss_store_sk = sm.sm_ship_mode_sk LEFT JOIN web_returns wr ON ss.ss_item_sk = wr.wr_item_sk AND ss.ss_ticket_number = wr.wr_order_number WHERE ss_addr_sk IN ('39848', '37282') AND s_store_sk IN (5, 8, 1, 3, 6, 12) AND wr_returning_hdemo_sk IN (772, 5914) AND sm_ship_mode_sk IN (19, 20, 9) AND sm_carrier IN ('USPS', 'DHL', 'UPS') GROUP BY s_store_name, sm_type ORDER BY total_sales_transactions DESC;
SELECT w_country, cr_returned_date_sk AS return_date_sk, i_category, COUNT(DISTINCT cr_order_number) AS total_returns, SUM(cr_return_quantity) AS total_returned_quantity, AVG(cr_return_amount) AS avg_return_amount, SUM(cr_net_loss) AS total_net_loss FROM catalog_returns cr JOIN item i ON cr.cr_item_sk = i.i_item_sk JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk JOIN promotion p ON i.i_item_sk = p.p_item_sk AND p.p_discount_active = 'N' WHERE cr.cr_returning_hdemo_sk IN (7008, 2246, 3148, 584, 6843) GROUP BY w_country, return_date_sk, i_category ORDER BY total_net_loss DESC, total_returns DESC;
SELECT cc.cc_name, cc.cc_class, COUNT(DISTINCT sr.sr_ticket_number) AS total_returns, SUM(sr.sr_return_quantity) AS total_returned_quantity, AVG(sr.sr_return_amt) AS avg_return_amount, SUM(ss.ss_quantity) AS total_sold_quantity, AVG(ss.ss_sales_price) AS avg_sales_price, SUM(ss.ss_net_profit) AS total_net_profit, cd.cd_gender, cd.cd_marital_status, COUNT(DISTINCT ss.ss_customer_sk) AS unique_customers FROM call_center cc JOIN store_returns sr ON cc.cc_call_center_sk = sr.sr_store_sk JOIN store_sales ss ON sr.sr_item_sk = ss.ss_item_sk AND sr.sr_ticket_number = ss.ss_ticket_number JOIN customer_demographics cd ON sr.sr_cdemo_sk = cd.cd_demo_sk WHERE cc.cc_class IN ('large', 'medium', 'small') AND cc.cc_call_center_sk IN (3, 2, 6) AND sr.sr_cdemo_sk IN (864476, 1163495, 1520527) AND sr.sr_return_amt IN (314.00, 13.08, 1010.36) AND cd.cd_gender IN ('F', 'M') AND cd.cd_marital_status IN ('W', 'U', 'D') AND ss.ss_list_price IN (33.74, 25.41, 32.01) AND ss.ss_coupon_amt IN (31.24, 6.48, 7.15) GROUP BY cc.cc_name, cc.cc_class, cd.cd_gender, cd.cd_marital_status ORDER BY total_net_profit DESC;
SELECT ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound, COUNT(DISTINCT cr.cr_returning_customer_sk) AS total_returning_customers_catalog, COUNT(DISTINCT wr.wr_returning_customer_sk) AS total_returning_customers_web, SUM(cr.cr_return_quantity) AS total_return_quantity_catalog, SUM(wr.wr_return_quantity) AS total_return_quantity_web, AVG(cr.cr_return_amount) AS avg_return_amount_catalog, AVG(wr.wr_return_amt) AS avg_return_amount_web, SUM(cr.cr_net_loss) AS total_net_loss_catalog, SUM(wr.wr_net_loss) AS total_net_loss_web FROM income_band ib LEFT JOIN household_demographics hd ON ib.ib_income_band_sk = hd.hd_income_band_sk LEFT JOIN catalog_returns cr ON hd.hd_demo_sk = cr.cr_returning_hdemo_sk LEFT JOIN web_returns wr ON hd.hd_demo_sk = wr.wr_returning_hdemo_sk LEFT JOIN promotion p ON p.p_start_date_sk = '2450215' AND p.p_channel_dmail = 'N' AND (cr.cr_item_sk = p.p_item_sk OR wr.wr_item_sk = p.p_item_sk) WHERE (cr.cr_returned_date_sk IS NOT NULL OR wr.wr_returned_date_sk IS NOT NULL) GROUP BY ib.ib_income_band_sk ORDER BY ib.ib_lower_bound;
SELECT hd.hd_buy_potential, AVG(ss.ss_sales_price) AS avg_sales_price, SUM(ss.ss_quantity) AS total_quantity_sold, COUNT(DISTINCT ss.ss_customer_sk) AS unique_customers, SUM(sr.sr_return_amt_inc_tax) AS total_return_amount_incl_tax, COUNT(DISTINCT sr.sr_customer_sk) AS unique_customers_returned FROM store_sales ss LEFT JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk LEFT JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk LEFT JOIN store_returns sr ON ss.ss_customer_sk = sr.sr_customer_sk AND ss.ss_item_sk = sr.sr_item_sk GROUP BY hd.hd_buy_potential ORDER BY total_return_amount_incl_tax DESC;
SELECT w_state, w_city, ib.ib_income_band_sk AS income_band_sk, p_promo_name, COUNT(DISTINCT w.w_warehouse_sk) AS num_warehouses, SUM(w.w_warehouse_sq_ft) AS total_warehouse_sq_ft, AVG(w.w_warehouse_sq_ft) AS avg_warehouse_sq_ft, SUM(wr_return_amt_inc_tax) AS total_return_amount_inc_tax, COUNT(DISTINCT wr.wr_returned_date_sk) AS num_return_days, AVG(wr_return_amt_inc_tax) AS avg_return_amount_inc_tax FROM warehouse w JOIN web_returns wr ON w.w_warehouse_sk = wr.wr_returning_addr_sk JOIN income_band ib ON ib.ib_income_band_sk = wr.wr_returning_hdemo_sk JOIN promotion p ON p.p_item_sk = wr.wr_item_sk WHERE w_state = 'TN' AND w_city = 'Fairview' AND wr_reason_sk IN (7, 17, 21, 6) AND ib_upper_bound IN (50000, 190000, 80000) AND wr_returning_hdemo_sk IN (4812, 3393, 981, 1249) GROUP BY w_state, w_city, ib.ib_income_band_sk, p_promo_name ORDER BY total_return_amount_inc_tax DESC LIMIT 100;
SELECT ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound, COUNT(DISTINCT hd.hd_demo_sk) AS household_count, AVG(hd.hd_vehicle_count) AS avg_vehicle_count, SUM(CASE WHEN cp.cp_department = 'DEPARTMENT' THEN 1 ELSE 0 END) AS department_page_count, sm.sm_carrier, COUNT(DISTINCT sm.sm_ship_mode_sk) AS ship_mode_count FROM household_demographics hd JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk LEFT JOIN catalog_page cp ON cp.cp_catalog_number = hd.hd_income_band_sk AND cp.cp_catalog_page_number IN (100, 52, 68) LEFT JOIN ship_mode sm ON sm.sm_ship_mode_sk = hd.hd_vehicle_count AND sm.sm_carrier IN ('ORIENTAL', 'GREAT EASTERN', 'USPS') WHERE hd.hd_income_band_sk IN (7, 19, 4) AND hd.hd_dep_count IN (0, 4, 1) AND hd.hd_demo_sk IN (390, 179, 2543) AND ib.ib_upper_bound IN (130000, 160000, 20000) AND ib.ib_lower_bound IN (130001, 10001, 140001) AND sm.sm_contract IN ('qENFQ', 'I3uCelXtjP', 'GNJr3g5i7oorKqtX') GROUP BY ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound, sm.sm_carrier ORDER BY ib.ib_upper_bound DESC, household_count DESC;
SELECT i_category, i_class, w_warehouse_name, w_city, w_state, EXTRACT(YEAR FROM i_rec_start_date) AS year_introduced, SUM(cs_sales_price) AS total_sales, AVG(cs_sales_price) AS avg_sales_price, COUNT(DISTINCT cs_order_number) AS total_orders, SUM(inv_quantity_on_hand) AS total_inventory FROM item JOIN catalog_sales ON cs_item_sk = i_item_sk JOIN warehouse ON cs_warehouse_sk = w_warehouse_sk JOIN inventory ON inv_item_sk = i_item_sk AND inv_warehouse_sk = w_warehouse_sk JOIN time_dim ON cs_sold_time_sk = t_time_sk WHERE w_warehouse_name = 'Central' AND t_shift = 'third' AND cs_ship_mode_sk IN ('12', '20', '5') AND t_time IN ('1847', '2034', '2419', '4815', '2779') AND i_rec_start_date >= '2000-01-01' GROUP BY i_category, i_class, w_warehouse_name, w_city, w_state, year_introduced ORDER BY total_sales DESC, total_orders DESC LIMIT 100;
SELECT hd.hd_buy_potential, COUNT(DISTINCT ss.ss_ticket_number) AS total_sales_transactions, SUM(ss.ss_quantity) AS total_items_sold, AVG(ss.ss_sales_price) AS avg_item_sales_price, SUM(wr.wr_return_quantity) AS total_items_returned, AVG(wr.wr_return_amt) AS avg_return_amount, SUM(sr.sr_return_quantity) AS total_store_returned_items, AVG(sr.sr_return_amt) AS avg_store_return_amount, (SUM(ss.ss_net_profit) - SUM(wr.wr_net_loss) - SUM(sr.sr_net_loss)) AS net_profit_after_returns FROM store_sales ss JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk LEFT JOIN web_returns wr ON ss.ss_item_sk = wr.wr_item_sk AND ss.ss_customer_sk = wr.wr_refunded_customer_sk LEFT JOIN store_returns sr ON ss.ss_item_sk = sr.sr_item_sk AND ss.ss_customer_sk = sr.sr_customer_sk WHERE hd.hd_buy_potential = '>10000' AND ss.ss_store_sk IN (1, 2, 7) AND wr.wr_refunded_customer_sk IN (48471, 57503, 93352) AND wr.wr_refunded_hdemo_sk IN (1649, 5785) AND sr.sr_reason_sk = 5 AND sr.sr_return_amt = 10.56 GROUP BY hd.hd_buy_potential;
SELECT w_state, ca_state, s_state, web_state, COUNT(DISTINCT c.c_customer_sk) AS num_customers, COUNT(DISTINCT w.w_warehouse_sk) AS num_warehouses, COUNT(DISTINCT s.s_store_sk) AS num_stores, COUNT(DISTINCT web.web_site_sk) AS num_websites, SUM(ss_quantity) AS total_quantity_sold, SUM(ss_net_paid) AS total_net_paid, AVG(ss_net_profit) AS avg_net_profit, SUM(ss_net_paid_inc_tax) AS total_net_paid_inc_tax FROM store_sales ss JOIN store s ON ss.ss_store_sk = s.s_store_sk JOIN web_site web ON s.s_market_id = web.web_mkt_id JOIN warehouse w ON w.w_state = s.s_state JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk WHERE s.s_manager IN ('David Thomas', 'Scott Smith', 'William Ward', 'Brett Yates', 'Robert Thompson', 'Edwin Adams') AND web.web_city IN ('Fairview', 'Midway') AND s.s_market_id IN ('8', '6', '4', '2') GROUP BY ROLLUP(w_state, ca_state, s_state, web_state) ORDER BY w_state, ca_state, s_state, web_state;
SELECT cc_state, COUNT(DISTINCT cc_call_center_sk) AS num_call_centers, AVG(cc_employees) AS avg_employees, SUM(cc_sq_ft) AS total_square_footage, ca.ca_state AS customer_state, COUNT(DISTINCT ca.ca_address_sk) AS num_customer_addresses, AVG(ca.ca_gmt_offset) AS avg_customer_gmt_offset, sm.sm_type AS ship_mode_type, COUNT(DISTINCT sm.sm_ship_mode_sk) AS num_ship_modes, MAX(sm.sm_contract) AS longest_ship_contract FROM call_center cc JOIN customer_address ca ON cc_state = ca.ca_state JOIN ship_mode sm ON TRUE WHERE cc_street_type = 'Way' AND ca.ca_gmt_offset IN ('-9.00', '-6.00', '-10.00', '-5.00', '-7.00') AND sm.sm_ship_mode_id = 'AAAAAAAAJAAAAAAA' GROUP BY cc_state, ca.ca_state, sm.sm_type ORDER BY cc_state, ca.ca_state, sm.sm_type;
SELECT p.p_promo_name, p.p_start_date_sk, p.p_end_date_sk, p.p_purpose, COUNT(DISTINCT cc.cc_call_center_sk) AS number_of_call_centers_involved, SUM(inv.inv_quantity_on_hand) AS total_inventory, SUM(wr.wr_return_quantity) AS total_returns, AVG(wr.wr_return_amt_inc_tax) AS avg_return_amount_inc_tax, SUM(wr.wr_fee) AS total_fees, SUM(wr.wr_net_loss) AS total_net_loss FROM promotion p LEFT JOIN inventory inv ON p.p_item_sk = inv.inv_item_sk LEFT JOIN web_returns wr ON p.p_item_sk = wr.wr_item_sk LEFT JOIN call_center cc ON wr.wr_returned_date_sk BETWEEN cc.cc_open_date_sk AND cc.cc_closed_date_sk WHERE p.p_purpose <> 'Unknown' AND p.p_end_date_sk <= 2450916 GROUP BY p.p_promo_name, p.p_start_date_sk, p.p_end_date_sk, p.p_purpose ORDER BY total_returns DESC, avg_return_amount_inc_tax DESC LIMIT 100;
SELECT s.s_city, COUNT(DISTINCT s.s_store_sk) AS number_of_stores, SUM(s.s_number_employees) AS total_employees, SUM(s.s_floor_space) AS total_floor_space, AVG(w.w_warehouse_sq_ft) AS avg_warehouse_sq_ft, COUNT(DISTINCT cp.cp_catalog_page_sk) AS number_of_catalog_pages FROM store s LEFT JOIN warehouse w ON s.s_city = w.w_city LEFT JOIN catalog_page cp ON cp.cp_catalog_page_number BETWEEN 80 AND 90 WHERE s.s_city IN ('Fairview', 'Midway') AND (s.s_closed_date_sk IS NULL OR s.s_closed_date_sk > CAST(to_char(CURRENT_DATE, 'J') AS INTEGER)) GROUP BY s.s_city ORDER BY s.s_city;
SELECT c.c_first_name, c.c_last_name, c.c_email_address, SUM(inv.inv_quantity_on_hand) AS total_inventory, AVG(wr.wr_return_amt_inc_tax) AS avg_return_amount_inc_tax, COUNT(DISTINCT wr.wr_order_number) AS total_returns, td.t_shift, SUM(wr.wr_fee) AS total_return_fees, SUM(wr.wr_net_loss) AS total_net_loss FROM customer c JOIN web_returns wr ON c.c_customer_sk = wr.wr_returning_customer_sk JOIN inventory inv ON wr.wr_item_sk = inv.inv_item_sk JOIN time_dim td ON wr.wr_returned_time_sk = td.t_time_sk WHERE c.c_email_address IN ('Brandi.Miller@JH5mldviNI7xQKVQj.com', 'Steven.Williams@uxeKdX2slbhOxguR.edu', 'Maryalice.Rivers@4b9MXdByVXI.com') AND c.c_birth_day IN (26, 12, 21) AND inv.inv_quantity_on_hand IN (31, 517, 732) AND inv.inv_date_sk = 2450815 AND inv.inv_item_sk IN (12622, 7663, 9094) AND inv.inv_warehouse_sk IN (2, 1) AND wr.wr_returning_cdemo_sk IN (940737, 1276363, 1374880) AND wr.wr_returned_time_sk IN (69044, 3060, 44094) AND wr.wr_reversed_charge IN (22.11, 1530.12, 160.93) AND wr.wr_reason_sk IN (1, 8, 25) GROUP BY c.c_first_name, c.c_last_name, c.c_email_address, td.t_shift ORDER BY total_inventory DESC, avg_return_amount_inc_tax DESC, total_returns DESC;
SELECT c.c_customer_id, i.i_product_name, i.i_category, COUNT(cs.cs_order_number) AS total_orders, SUM(cs.cs_quantity) AS total_quantity, AVG(cs.cs_sales_price) AS avg_sales_price, SUM(cs.cs_net_paid) AS total_net_paid, SUM(cs.cs_net_paid_inc_tax) AS total_net_paid_inc_tax, SUM(cs.cs_net_paid_inc_ship) AS total_net_paid_inc_ship, SUM(cs.cs_net_paid_inc_ship_tax) AS total_net_paid_inc_ship_tax, SUM(sr.sr_return_amt) AS total_return_amount, SUM(sr.sr_fee) AS total_return_fee, SUM(sr.sr_net_loss) AS total_net_loss, SUM(wr.wr_return_amt) AS total_web_return_amount, SUM(wr.wr_fee) AS total_web_return_fee, SUM(wr.wr_net_loss) AS total_web_net_loss FROM customer c JOIN catalog_sales cs ON c.c_customer_sk = cs.cs_bill_customer_sk JOIN item i ON cs.cs_item_sk = i.i_item_sk LEFT JOIN store_returns sr ON cs.cs_item_sk = sr.sr_item_sk AND cs.cs_order_number = sr.sr_ticket_number LEFT JOIN web_returns wr ON cs.cs_item_sk = wr.wr_item_sk AND cs.cs_order_number = wr.wr_order_number JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk WHERE c.c_preferred_cust_flag = 'Y' AND d.d_year = 2023 GROUP BY c.c_customer_id, i.i_product_name, i.i_category ORDER BY total_net_paid DESC LIMIT 100;
SELECT s_state, s_city, p_channel_demo, p_promo_name, COUNT(DISTINCT sr_ticket_number) AS total_returns, SUM(sr_return_quantity) AS total_returned_quantity, AVG(sr_return_amt) AS average_return_amount, SUM(sr_net_loss) AS total_net_loss, COUNT(DISTINCT ss_ticket_number) AS total_sales, SUM(ss_quantity) AS total_sold_quantity, AVG(ss_sales_price) AS average_sales_price, SUM(ss_net_profit) AS total_net_profit FROM store_returns sr JOIN store s ON sr.sr_store_sk = s.s_store_sk JOIN store_sales ss ON sr.sr_item_sk = ss.ss_item_sk AND sr.sr_ticket_number = ss.ss_ticket_number JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk GROUP BY s_state, s_city, p_channel_demo, p_promo_name ORDER BY s_state, s_city, p_channel_demo, p_promo_name;
