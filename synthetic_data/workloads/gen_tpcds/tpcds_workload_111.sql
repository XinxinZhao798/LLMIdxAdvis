SELECT cd.cd_education_status, ib.ib_lower_bound, ib.ib_upper_bound, sm.sm_type, AVG(cd.cd_purchase_estimate) AS average_purchase_estimate, COUNT(cd.cd_demo_sk) AS customer_count, AVG(w.web_tax_percentage) AS average_tax_percentage FROM customer_demographics cd JOIN income_band ib ON cd.cd_purchase_estimate BETWEEN ib.ib_lower_bound AND ib.ib_upper_bound JOIN ship_mode sm ON sm.sm_contract = 'qENFQ' AND sm.sm_type IN ('EXPRESS', 'LIBRARY', 'OVERNIGHT', 'TWO DAY') JOIN web_site w ON w.web_class IN ('B2C', 'B2B', 'Small Business', 'Enterprise') AND w.web_tax_percentage IS NOT NULL WHERE cd.cd_education_status IN ('College', 'Secondary', '2 yr Degree', 'Primary') AND cd.cd_purchase_estimate IN (1000, 2500, 7000, 3000) AND sm.sm_type IN ('EXPRESS', 'LIBRARY', 'OVERNIGHT', 'TWO DAY') GROUP BY cd.cd_education_status, ib.ib_lower_bound, ib.ib_upper_bound, sm.sm_type ORDER BY cd.cd_education_status, ib.ib_lower_bound, sm.sm_type;
SELECT ws.ws_web_site_sk, web.web_name, web.web_class, COUNT(DISTINCT ws.ws_order_number) AS total_orders, SUM(ws.ws_quantity) AS total_quantity_sold, SUM(ws.ws_net_paid) AS total_net_paid, SUM(ws.ws_net_paid_inc_tax) AS total_net_paid_inc_tax, AVG(ws.ws_sales_price) AS average_sales_price, SUM(ws.ws_coupon_amt) AS total_coupon_amt_used, sm.sm_type AS shipping_type, sm.sm_carrier AS shipping_carrier, COUNT(DISTINCT ws.ws_warehouse_sk) AS total_warehouses_used, t.t_shift AS time_shift, COUNT(DISTINCT ws.ws_ship_mode_sk) AS total_ship_modes_used FROM web_sales ws JOIN web_site web ON ws.ws_web_site_sk = web.web_site_sk JOIN time_dim t ON ws.ws_sold_time_sk = t.t_time_sk JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk WHERE web.web_country = 'United States' AND ws.ws_coupon_amt IN (1426.08, 70.99, 196.19) AND t.t_minute IN (33, 5, 49, 22, 42, 10) AND ws.ws_web_site_sk IN (4, 3, 28, 16, 7, 26) GROUP BY ws.ws_web_site_sk, web.web_name, web.web_class, sm.sm_type, sm.sm_carrier, t.t_shift ORDER BY total_net_paid DESC;
SELECT cp.cp_department, ib.ib_income_band_sk, COUNT(DISTINCT cr.cr_order_number) AS total_returns, SUM(cr.cr_return_quantity) AS total_returned_quantity, AVG(cr.cr_return_amount) AS avg_return_amount, SUM(cr.cr_net_loss) AS total_net_loss, COUNT(DISTINCT sr.sr_ticket_number) AS total_store_returns, SUM(sr.sr_return_amt_inc_tax) AS total_store_return_value, AVG(sr.sr_fee) AS avg_store_return_fee, SUM(wp.wp_image_count) AS total_web_images FROM catalog_page cp JOIN catalog_returns cr ON cp.cp_catalog_page_sk = cr.cr_catalog_page_sk JOIN store_returns sr ON cr.cr_item_sk = sr.sr_item_sk JOIN web_page wp ON cp.cp_catalog_page_sk = wp.wp_web_page_sk JOIN income_band ib ON ib.ib_lower_bound <= cr.cr_return_amount AND ib.ib_upper_bound >= cr.cr_return_amount WHERE cp.cp_start_date_sk BETWEEN 2450965 AND 2451180 AND cr.cr_returned_time_sk IN (68597, 54816, 8520, 49710) AND sr.sr_returned_date_sk BETWEEN 2451108 AND 2452339 AND sr.sr_return_ship_cost = 3.94 GROUP BY cp.cp_department, ib.ib_income_band_sk ORDER BY total_net_loss DESC, total_store_return_value DESC;
SELECT i.i_category, i.i_brand, COUNT(DISTINCT cs_order_number) AS total_orders, SUM(cs_quantity) AS total_quantity_sold, AVG(cs_sales_price) AS average_sales_price, SUM(cs_net_paid) AS total_net_paid, SUM(cs_net_profit) AS total_net_profit, AVG(hd_dep_count) AS average_dependency_count, AVG(hd_vehicle_count) AS average_vehicle_count FROM catalog_sales cs JOIN item i ON cs.cs_item_sk = i.i_item_sk JOIN household_demographics hd ON cs.cs_ship_hdemo_sk = hd.hd_demo_sk WHERE i.i_category = 'Men' AND (i.i_color = 'lawn' OR i.i_color = 'peach' OR i.i_color = 'red') AND cs.cs_catalog_page_sk IN (118, 44) AND hd.hd_demo_sk IN (714, 1213, 4049, 4231, 2781, 3780) GROUP BY i.i_category, i.i_brand ORDER BY total_net_profit DESC, total_orders DESC;
SELECT c.c_first_name, c.c_last_name, SUM(ss.ss_net_paid) AS total_sales, AVG(ss.ss_quantity) AS average_quantity, COUNT(DISTINCT ss.ss_ticket_number) AS total_transactions, i.i_category, s.s_store_name, sm.sm_type FROM store_sales ss JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk JOIN item i ON ss.ss_item_sk = i.i_item_sk JOIN store s ON ss.ss_store_sk = s.s_store_sk JOIN ship_mode sm ON sm.sm_ship_mode_sk = ss.ss_sold_date_sk WHERE c.c_customer_sk IN (179, 972, 3529, 2285, 1595) AND i.i_units = 'Tsp' AND s.s_division_name = 'Unknown' AND ss.ss_sold_date_sk BETWEEN 20000101 AND 20001231 GROUP BY c.c_first_name, c.c_last_name, i.i_category, s.s_store_name, sm.sm_type ORDER BY total_sales DESC, c.c_last_name ASC, c.c_first_name ASC;
SELECT cc_division_name, cc_market_manager, SUM(ws_net_profit) AS total_profit, AVG(ws_quantity) AS average_quantity_sold, COUNT(DISTINCT ws_order_number) AS total_orders, SUM(wr_net_loss) AS total_net_loss, COUNT(DISTINCT wr_order_number) AS total_returns FROM call_center JOIN web_sales ON cc_call_center_sk = ws_warehouse_sk JOIN web_returns ON ws_order_number = wr_order_number WHERE ws_sold_date_sk BETWEEN 2000 AND 3000 AND ws_ship_mode_sk IN (1, 2) AND wr_reason_sk IN (12, 35, 30, 1, 29) AND cc_market_manager IN ('Julius Durham', 'Matthew Clifton', 'Gary Colburn', 'Julius Tran') GROUP BY cc_division_name, cc_market_manager ORDER BY total_profit DESC, total_net_loss ASC;
SELECT cp_department, cd_gender, cd_marital_status, cd_education_status, COUNT(DISTINCT sr_ticket_number) AS total_returns, SUM(sr_return_quantity) AS total_returned_quantity, AVG(sr_return_amt) AS average_return_amount, SUM(sr_return_amt_inc_tax) AS total_return_amount_inc_tax, SUM(sr_fee) AS total_fees, SUM(sr_net_loss) AS total_net_loss FROM catalog_page JOIN store_returns ON cp_catalog_page_sk = sr_returned_date_sk JOIN customer_demographics ON cd_demo_sk = sr_cdemo_sk WHERE cp_department = 'DEPARTMENT' AND (cp_start_date_sk = 2451665 OR cp_start_date_sk = 2451360) GROUP BY cp_department, cd_gender, cd_marital_status, cd_education_status ORDER BY total_returned_quantity DESC;
SELECT w_state, w_city, p_promo_name, COUNT(DISTINCT wr_order_number) AS total_returns, SUM(wr_return_quantity) AS total_returned_quantity, AVG(wr_return_amt) AS avg_return_amount, SUM(wr_return_amt_inc_tax) AS total_return_amount_inc_tax, SUM(wr_fee) AS total_fees, SUM(wr_net_loss) AS total_net_loss FROM warehouse JOIN web_returns ON w_warehouse_sk = wr_returning_addr_sk JOIN promotion ON p_promo_sk = wr_web_page_sk WHERE w_street_name = 'Ash Laurel' AND p_channel_catalog = 'N' AND p_channel_press = 'N' AND wr_account_credit IN ('618.25', '63.54', '2191.76', '19.59', '469.21', '464.73') GROUP BY w_state, w_city, p_promo_name ORDER BY total_net_loss DESC, w_state, w_city;
SELECT cc.cc_name AS call_center_name, i.i_category AS item_category, SUM(ws.ws_quantity) AS total_quantity_sold, AVG(ws.ws_sales_price) AS average_sales_price, COUNT(DISTINCT ws.ws_order_number) AS total_orders, SUM(ws.ws_net_profit) AS total_net_profit FROM web_sales ws JOIN call_center cc ON ws.ws_bill_customer_sk = cc.cc_call_center_sk JOIN item i ON ws.ws_item_sk = i.i_item_sk JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk JOIN time_dim t ON ws.ws_sold_time_sk = t.t_time_sk JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk WHERE cc.cc_manager IN ('Bob Belcher', 'Felipe Perkins', 'Larry Mccray', 'Mark Hightower') AND i.i_container = 'Unknown' AND ws.ws_ship_hdemo_sk IN (6862, 4638, 2050, 5884, 1108) AND d.d_year = 2023 AND t.t_am_pm = 'PM' GROUP BY call_center_name, item_category ORDER BY total_net_profit DESC;
SELECT w_state, AVG(w_warehouse_sq_ft) AS avg_warehouse_sq_ft, SUM(inv_quantity_on_hand) AS total_inventory_on_hand, AVG(sr_return_amt) AS avg_return_amt, SUM(sr_net_loss) AS total_net_loss FROM warehouse w JOIN inventory i ON w.w_warehouse_sk = i.inv_warehouse_sk JOIN store_returns sr ON i.inv_item_sk = sr.sr_item_sk GROUP BY w_state ORDER BY w_state;
SELECT cp.cp_department, COUNT(ss.ss_ticket_number) AS total_sales_transactions, SUM(ss.ss_sales_price) AS total_sales_amount, AVG(ss.ss_ext_discount_amt) AS average_discount_amount, SUM(ss.ss_quantity) AS total_items_sold, SUM(ss.ss_coupon_amt) AS total_coupon_amount_used FROM catalog_page cp JOIN store_sales ss ON cp.cp_catalog_page_sk = ss.ss_sold_date_sk WHERE cp.cp_catalog_number BETWEEN 25 AND 41 AND ss.ss_sold_date_sk BETWEEN 20020101 AND 20021231 AND ss.ss_ext_list_price IN (2602.80, 627.44, 6715.50, 6951.00, 6762.70, 4044.30) AND ss.ss_coupon_amt IN (393.68, 57.05) GROUP BY cp.cp_department ORDER BY total_sales_amount DESC;
SELECT ss_item_sk, ss_store_sk, AVG(ss_sales_price) AS avg_sales_price, SUM(ss_quantity) AS total_quantity_sold, SUM(ss_net_paid) AS total_net_paid, SUM(ss_net_profit) AS total_net_profit, AVG(ss_ext_discount_amt) AS avg_discount_amount, COUNT(DISTINCT ss_customer_sk) AS unique_customer_count FROM store_sales GROUP BY ss_item_sk, ss_store_sk ORDER BY total_net_profit DESC;
SELECT cp.cp_department, i.i_category, i.i_brand, sm.sm_type, COUNT(DISTINCT cp.cp_catalog_page_sk) AS num_catalog_pages, COUNT(DISTINCT i.i_item_sk) AS num_items, AVG(i.i_current_price) AS avg_current_price, SUM(i.i_wholesale_cost) AS total_wholesale_cost, COUNT(DISTINCT t.t_time_sk) AS num_time_records, COUNT(DISTINCT sm.sm_ship_mode_sk) AS num_ship_modes FROM catalog_page cp JOIN item i ON cp.cp_catalog_page_sk = i.i_item_sk JOIN time_dim t ON cp.cp_start_date_sk = t.t_time_sk OR cp.cp_end_date_sk = t.t_time_sk JOIN ship_mode sm ON sm.sm_carrier = i.i_manufact WHERE i.i_category IN ('Shoes', 'Jewelry', 'Sports', 'Home', 'Electronics') GROUP BY cp.cp_department, i.i_category, i.i_brand, sm.sm_type ORDER BY num_catalog_pages DESC, num_items DESC;
SELECT i_category, i_class, COUNT(DISTINCT ss_ticket_number) AS total_sales_transactions, SUM(ss_sales_price) AS total_sales_revenue, AVG(ss_sales_price) AS avg_sales_price, SUM(cr_return_amount) AS total_return_revenue, AVG(cr_return_amount) AS avg_return_amount, SUM(sr_return_amt) AS total_store_return_revenue, AVG(sr_return_amt) AS avg_store_return_amount, (SUM(ss_sales_price) - SUM(cr_return_amount) - SUM(sr_return_amt)) AS net_revenue, SUM(inv_quantity_on_hand) AS total_inventory_quantity, COUNT(DISTINCT inv_warehouse_sk) AS num_warehouses_stocking FROM item LEFT JOIN store_sales ON store_sales.ss_item_sk = item.i_item_sk LEFT JOIN catalog_returns ON catalog_returns.cr_item_sk = item.i_item_sk LEFT JOIN store_returns ON store_returns.sr_item_sk = item.i_item_sk LEFT JOIN inventory ON inventory.inv_item_sk = item.i_item_sk WHERE i_manufact = 'oughtought' AND (inventory.inv_item_sk = 14212 OR inventory.inv_item_sk = 6826) AND inventory.inv_date_sk = 2450815 AND store_sales.ss_list_price = 145.48 GROUP BY i_category, i_class ORDER BY net_revenue DESC;
SELECT ca.ca_state, COUNT(DISTINCT ca.ca_address_sk) AS num_customers, AVG(inv.inv_quantity_on_hand) AS avg_inventory_quantity, t.t_shift, COUNT(DISTINCT inv.inv_warehouse_sk) AS num_warehouses FROM customer_address ca JOIN inventory inv ON ca.ca_address_sk = inv.inv_warehouse_sk JOIN time_dim t ON inv.inv_date_sk = t.t_time_sk WHERE t.t_shift IN ('Morning', 'Afternoon', 'Evening') GROUP BY ca.ca_state, t.t_shift ORDER BY ca.ca_state, t.t_shift;
SELECT s.s_store_name, SUM(ss.ss_quantity) AS total_quantity_sold, AVG(ss.ss_sales_price) AS average_sales_price, SUM(ss.ss_net_profit) AS total_store_profit, w.w_warehouse_name, sm.sm_type, COUNT(DISTINCT ws.ws_order_number) AS total_web_orders, SUM(ws.ws_net_profit) AS total_web_profit, SUM(wr.wr_return_quantity) AS total_return_quantity, SUM(wr.wr_net_loss) AS total_return_loss FROM store s LEFT JOIN store_sales ss ON s.s_store_sk = ss.ss_store_sk LEFT JOIN web_sales ws ON ws.ws_item_sk = ss.ss_item_sk LEFT JOIN web_returns wr ON ws.ws_item_sk = wr.wr_item_sk AND ws.ws_order_number = wr.wr_order_number LEFT JOIN warehouse w ON ws.ws_warehouse_sk = w.w_warehouse_sk LEFT JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk WHERE s.s_market_desc IN ('Little expectations include yet forward meetings.', 'Mysterious employe', 'Events develop i', 'Architects coul') AND w.w_warehouse_id IN ('AAAAAAAADAAAAAAA', 'AAAAAAAACAAAAAAA', 'AAAAAAAAEAAAAAAA', 'AAAAAAAAFAAAAAAA') GROUP BY s.s_store_name, w.w_warehouse_name, sm.sm_type ORDER BY total_quantity_sold DESC, total_web_profit DESC, total_return_loss ASC;
SELECT d.d_year AS year, d.d_quarter_name AS quarter, w.w_warehouse_name AS warehouse_name, ib.ib_income_band_sk AS income_band, SUM(inv.inv_quantity_on_hand) AS total_quantity_sold, AVG(inv.inv_quantity_on_hand) AS average_quantity_per_transaction, COUNT(DISTINCT inv.inv_item_sk) AS distinct_item_count, COUNT(*) AS transaction_count FROM inventory inv JOIN date_dim d ON inv.inv_date_sk = d.d_date_sk JOIN warehouse w ON inv.inv_warehouse_sk = w.w_warehouse_sk JOIN income_band ib ON ib.ib_income_band_sk BETWEEN 5 AND 15 WHERE d.d_dom = 25 AND w.w_warehouse_sq_ft IN (977787, 294242, 621234, 138504) AND inv.inv_quantity_on_hand IN (781, 841, 802, 251) AND ib.ib_lower_bound >= 90001 GROUP BY year, quarter, warehouse_name, income_band ORDER BY year, quarter, warehouse_name, income_band;
SELECT dd.d_year, dd.d_quarter_name, COUNT(DISTINCT c.c_customer_sk) AS total_customers, SUM(inv.inv_quantity_on_hand) AS total_inventory, AVG(cc.cc_employees) AS average_employees, SUM(CASE WHEN ws.web_country = 'United States' THEN 1 ELSE 0 END) AS total_us_websites FROM date_dim dd JOIN inventory inv ON dd.d_date_sk = inv.inv_date_sk JOIN customer c ON dd.d_date_sk = c.c_first_sales_date_sk JOIN call_center cc ON dd.d_date_sk = cc.cc_open_date_sk JOIN web_site ws ON dd.d_date_sk = ws.web_open_date_sk WHERE dd.d_year = 2022 AND inv.inv_warehouse_sk = 1 AND ws.web_county = 'Williamson County' AND ws.web_street_name IN ('Hickory 3rd', 'Broadway South', 'Cedar North', 'Railroad', 'Lake') AND dd.d_last_dom IN ('2419096', '2418790', '2417026', '2416844', '2419340', '2415871') AND dd.d_week_seq IN ('499', '115') AND c.c_salutation IN ('Mr.', 'Ms.', 'Mrs.') AND c.c_birth_day = 5 GROUP BY dd.d_year, dd.d_quarter_name ORDER BY dd.d_year, dd.d_quarter_name;
SELECT ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound, AVG(sr.sr_return_amt) AS avg_return_amount, AVG(sr.sr_return_quantity) AS avg_return_quantity, COUNT(sr.sr_ticket_number) AS total_returns FROM income_band ib JOIN store_returns sr ON sr.sr_cdemo_sk = ib.ib_income_band_sk JOIN inventory i ON sr.sr_item_sk = i.inv_item_sk GROUP BY ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound ORDER BY ib.ib_income_band_sk;
SELECT c.cp_department AS department, i.i_category AS category, COUNT(DISTINCT c.cp_catalog_page_sk) AS num_catalog_pages, COUNT(DISTINCT i.i_item_sk) AS num_items, AVG(i.i_current_price) AS avg_current_price, SUM(i.i_wholesale_cost * i.i_units::int) AS total_wholesale_cost, w.web_name AS website_name, COUNT(DISTINCT w.web_site_sk) AS num_websites, AVG(w.web_tax_percentage) AS avg_tax_percentage FROM catalog_page c JOIN item i ON c.cp_catalog_page_sk = i.i_item_sk JOIN web_site w ON c.cp_department = w.web_class WHERE i.i_category IN ('Shoes', 'Home') AND i.i_rec_start_date <= CURRENT_DATE AND (i.i_rec_end_date IS NULL OR i.i_rec_end_date > CURRENT_DATE) AND w.web_rec_start_date <= CURRENT_DATE AND (w.web_rec_end_date IS NULL OR w.web_rec_end_date > CURRENT_DATE) GROUP BY c.cp_department, i.i_category, w.web_name ORDER BY department, category, website_name;
SELECT i.i_category, SUM(ss.ss_quantity) AS total_quantity_sold, AVG(ss.ss_sales_price) AS average_sales_price, COUNT(DISTINCT ss.ss_customer_sk) AS unique_customers, SUM(wr.wr_return_quantity) AS total_quantity_returned, SUM(wr.wr_return_amt) AS total_return_amount, AVG(inv.inv_quantity_on_hand) AS average_inventory_on_hand FROM item i LEFT JOIN store_sales ss ON ss.ss_item_sk = i.i_item_sk LEFT JOIN web_returns wr ON wr.wr_item_sk = i.i_item_sk LEFT JOIN inventory inv ON inv.inv_item_sk = i.i_item_sk WHERE i.i_category IN ('Electronics', 'Clothing', 'Furniture') AND ss.ss_sold_date_sk BETWEEN 2451453 AND 2451553 AND wr.wr_returned_date_sk BETWEEN 2451453 AND 2451553 AND inv.inv_date_sk BETWEEN 2451453 AND 2451553 GROUP BY i.i_category ORDER BY total_quantity_sold DESC;
SELECT i.i_category, i.i_color, COUNT(DISTINCT cr.cr_item_sk) AS num_returns, AVG(cr.cr_return_amount) AS avg_return_amount, SUM(cr.cr_return_amount) AS total_return_amount, SUM(cr.cr_return_quantity) AS total_returned_quantity, cc.cc_name AS call_center, w.w_warehouse_name AS warehouse, COUNT(DISTINCT cp.cp_catalog_page_sk) AS num_catalog_pages, COUNT(DISTINCT wp.wp_web_page_sk) AS num_web_pages FROM catalog_returns cr JOIN item i ON cr.cr_item_sk = i.i_item_sk JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk JOIN catalog_page cp ON cr.cr_catalog_page_sk = cp.cp_catalog_page_sk JOIN web_page wp ON cp.cp_start_date_sk = wp.wp_creation_date_sk WHERE i.i_color IN ('linen', 'midnight', 'powder', 'tan') AND cp.cp_catalog_number IN (46, 18, 2) AND w.w_gmt_offset = -5.00 GROUP BY i.i_category, i.i_color, cc.cc_name, w.w_warehouse_name ORDER BY total_return_amount DESC;
SELECT ib.ib_lower_bound, ib.ib_upper_bound, cc.cc_state, d.d_year, SUM(cs.cs_net_paid) AS total_sales, AVG(cs.cs_ext_discount_amt) AS average_discount, COUNT(DISTINCT cs.cs_order_number) AS total_orders FROM catalog_sales cs JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk JOIN income_band ib ON cs.cs_bill_customer_sk = ib.ib_income_band_sk JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk WHERE d.d_year = 2003 AND ib.ib_upper_bound IN (40000, 90000, 100000, 20000, 140000, 180000) AND cc.cc_state = 'TN' GROUP BY ib.ib_lower_bound, ib.ib_upper_bound, cc.cc_state, d.d_year ORDER BY ib.ib_lower_bound, total_sales DESC;
SELECT ca_state, SUM(cs_quantity) AS total_quantity, AVG(cs_sales_price) AS avg_sales_price, COUNT(DISTINCT cs_order_number) AS total_orders, SUM(wr_return_amt_inc_tax) AS total_return_amount_inc_tax, COUNT(DISTINCT wr_order_number) AS total_return_orders FROM catalog_sales JOIN customer_address ON cs_ship_addr_sk = ca_address_sk JOIN warehouse ON cs_warehouse_sk = w_warehouse_sk JOIN web_returns ON cs_item_sk = wr_item_sk AND cs_order_number = wr_order_number JOIN time_dim ON cs_sold_time_sk = t_time_sk JOIN reason ON wr_reason_sk = r_reason_sk WHERE t_am_pm = 'AM' AND r_reason_id IN ('AAAAAAAAMBAAAAAA', 'AAAAAAAAPAAAAAAA', 'AAAAAAAAFBAAAAAA', 'AAAAAAAALAAAAAAA') AND cs_bill_addr_sk IN ('23752', '34909', '20802', '37622', '45921') AND ca_state IN ('IL', 'KY', 'OR', 'VA', 'FL', 'AL', 'OK', 'IA', 'TX') GROUP BY ca_state ORDER BY total_quantity DESC, total_return_amount_inc_tax DESC;
SELECT ca_state, COUNT(DISTINCT c_customer_sk) AS total_customers, SUM(wr_return_amt_inc_tax) AS total_refunds, AVG(wr_return_quantity) AS avg_return_quantity, COUNT(DISTINCT wr_order_number) AS total_return_orders, s_store_name, s_city, s_state FROM customer_address JOIN customer ON customer.c_current_addr_sk = customer_address.ca_address_sk JOIN web_returns ON customer_address.ca_address_sk = web_returns.wr_refunded_addr_sk JOIN store ON customer_address.ca_state = store.s_state WHERE customer.c_preferred_cust_flag = 'Y' AND web_returns.wr_returned_date_sk BETWEEN '20210101' AND '20211231' GROUP BY ca_state, s_store_name, s_city, s_state ORDER BY total_refunds DESC, avg_return_quantity DESC LIMIT 100;
SELECT s.s_store_name, s.s_floor_space, s.s_number_employees, s.s_city, s.s_state, dd.d_year, dd.d_quarter_name, SUM(i.inv_quantity_on_hand) AS total_inventory, AVG(i.inv_quantity_on_hand) AS average_inventory, COUNT(DISTINCT i.inv_item_sk) AS unique_items_count, COUNT(DISTINCT i.inv_warehouse_sk) AS unique_warehouses_count FROM inventory i JOIN store s ON i.inv_warehouse_sk = s.s_store_sk JOIN date_dim dd ON i.inv_date_sk = dd.d_date_sk WHERE dd.d_current_month = 'N' AND s.s_store_name LIKE ANY (ARRAY['%eing%', '%ought%', '%bar%', '%ation%', '%anti%', '%able%']) GROUP BY s.s_store_name, s.s_floor_space, s.s_number_employees, s.s_city, s.s_state, dd.d_year, dd.d_quarter_name ORDER BY s.s_state, s.s_city, dd.d_year, dd.d_quarter_name;
