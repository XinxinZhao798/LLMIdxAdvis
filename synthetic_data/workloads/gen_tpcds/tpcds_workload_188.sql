SELECT sm.sm_type AS ship_mode_type, p.p_promo_name AS promotion_name, r.r_reason_desc AS return_reason, COUNT(DISTINCT cr.cr_order_number) AS total_returns, SUM(cr.cr_return_amount) AS total_return_amount, AVG(cr.cr_return_amount) AS avg_return_amount, SUM(cr.cr_net_loss) AS total_net_loss, COUNT(DISTINCT cs.cs_order_number) AS total_sales_orders, SUM(cs.cs_sales_price) AS total_sales_amount, AVG(cs.cs_sales_price) AS avg_sales_price, (SUM(cr.cr_return_amount) / NULLIF(SUM(cs.cs_sales_price), 0)) * 100 AS return_rate_percentage FROM catalog_returns cr JOIN reason r ON cr.cr_reason_sk = r.r_reason_sk JOIN ship_mode sm ON cr.cr_ship_mode_sk = sm.sm_ship_mode_sk JOIN catalog_sales cs ON cr.cr_order_number = cs.cs_order_number JOIN promotion p ON cs.cs_promo_sk = p.p_promo_sk GROUP BY sm.sm_type, p.p_promo_name, r.r_reason_desc ORDER BY total_returns DESC, total_net_loss DESC LIMIT 10;
SELECT ca_state, SUM(hd_dep_count) AS total_dependents, AVG(hd_vehicle_count) AS avg_vehicles, COUNT(DISTINCT ca_address_sk) AS total_addresses, SUM(CASE WHEN p_channel_email = '1' THEN p_response_target ELSE 0 END) AS email_promo_targets, AVG(inv_quantity_on_hand) AS avg_inventory_on_hand FROM customer_address ca JOIN household_demographics hd ON ca.ca_address_sk = hd.hd_demo_sk JOIN promotion p ON ca.ca_address_sk = p.p_promo_sk JOIN inventory i ON ca.ca_address_sk = i.inv_warehouse_sk GROUP BY ca_state ORDER BY ca_state;
SELECT reason.r_reason_desc AS Return_Reason, COUNT(DISTINCT web_returns.wr_order_number) AS Total_Returns, SUM(web_returns.wr_return_amt) AS Total_Return_Amount, AVG(web_returns.wr_return_amt) AS Average_Return_Amount, promotion.p_promo_name AS Promotion_Name, COUNT(DISTINCT promotion.p_promo_sk) AS Total_Promotions_Affected, ship_mode.sm_type AS Shipping_Type, COUNT(DISTINCT ship_mode.sm_ship_mode_sk) AS Total_Shipping_Modes_Used FROM web_returns JOIN reason ON web_returns.wr_reason_sk = reason.r_reason_sk LEFT JOIN promotion ON web_returns.wr_item_sk = promotion.p_item_sk JOIN web_page ON web_returns.wr_web_page_sk = web_page.wp_web_page_sk JOIN ship_mode ON web_returns.wr_order_number = ship_mode.sm_ship_mode_sk WHERE web_returns.wr_return_amt > 0 AND reason.r_reason_desc IN ('No service location in my area', 'Did not like the warranty', 'Stopped working') AND web_page.wp_link_count BETWEEN 15 AND 24 GROUP BY Return_Reason, Promotion_Name, Shipping_Type ORDER BY Total_Returns DESC, Total_Return_Amount DESC;
SELECT d_year, SUM(sr_return_amt) AS total_return_amount, AVG(sr_return_quantity) AS avg_return_quantity, COUNT(DISTINCT sr_customer_sk) AS unique_customers_returning, COUNT(DISTINCT p_promo_sk) AS distinct_promotions, SUM(inv_quantity_on_hand) AS total_inventory_quantity, COUNT(DISTINCT cp_catalog_page_sk) AS num_catalog_pages FROM store_returns JOIN date_dim ON store_returns.sr_returned_date_sk = date_dim.d_date_sk JOIN promotion ON store_returns.sr_item_sk = promotion.p_item_sk JOIN inventory ON store_returns.sr_item_sk = inventory.inv_item_sk JOIN catalog_page ON promotion.p_item_sk = catalog_page.cp_catalog_page_sk WHERE d_fy_year IN ('1900', '1901', '1902', '1904', '1910', '1912') AND p_channel_tv = 'N' AND sr_return_time_sk IN ('42714', '34148', '59678') AND inv_item_sk IN ('9572', '12640', '8512', '13724') AND inv_warehouse_sk IN ('1', '2') GROUP BY d_year ORDER BY d_year;
SELECT ca_state, ca_country, AVG(wp_char_count) AS average_character_count, SUM(wp_link_count) AS total_link_count, COUNT(wp_web_page_sk) AS total_pages, AVG(ib_lower_bound) AS average_income_lower_bound, AVG(ib_upper_bound) AS average_income_upper_bound, COUNT(DISTINCT ib_income_band_sk) AS distinct_income_band_count FROM web_page JOIN customer_address ON wp_customer_sk = ca_address_sk JOIN income_band ON ca_address_id::integer = ib_income_band_sk WHERE wp_type = 'product' AND ca_country = 'United States' AND ib_lower_bound >= 70001 AND (ib_income_band_sk IN (3, 8, 1, 10, 13, 9) OR wp_autogen_flag = 'Y') GROUP BY ca_state, ca_country ORDER BY ca_state, ca_country;
SELECT ca_state, cd_gender, cd_marital_status, cd_education_status, AVG(cd_purchase_estimate) AS avg_purchase_estimate, COUNT(DISTINCT ss_customer_sk) AS unique_customers, SUM(ss_quantity) AS total_quantity_sold, SUM(ss_net_paid) AS total_net_paid, SUM(ss_net_profit) AS total_net_profit FROM store_sales JOIN customer_address ON store_sales.ss_addr_sk = customer_address.ca_address_sk JOIN customer_demographics ON store_sales.ss_cdemo_sk = customer_demographics.cd_demo_sk WHERE ca_zip IN ('22562', '41934', '39101', '43301', '36549') GROUP BY ca_state, cd_gender, cd_marital_status, cd_education_status ORDER BY ca_state, cd_gender, cd_marital_status, cd_education_status;
SELECT cs.cc_state AS call_center_state, ws.web_state AS web_site_state, cs.cc_name AS call_center_name, ws.web_name AS web_site_name, COUNT(DISTINCT cs.cc_call_center_sk) AS number_of_call_centers, COUNT(DISTINCT ws.web_site_sk) AS number_of_web_sites, AVG(cs.cc_employees) AS average_employees_per_call_center, AVG(cs.cc_sq_ft) AS average_square_footage_per_call_center, SUM(cd.cd_purchase_estimate) AS total_purchase_estimate, AVG(cd.cd_dep_count) AS average_dependents_per_customer FROM call_center cs JOIN web_site ws ON cs.cc_state = ws.web_state JOIN customer_demographics cd ON (cs.cc_mkt_id = ws.web_mkt_id) WHERE cs.cc_state = 'TN' AND ws.web_state = 'TN' AND (cd.cd_demo_sk = '19181' OR cd.cd_demo_sk = '20612') AND (cd.cd_marital_status = 'M' OR cd.cd_marital_status = 'U') AND ( cs.cc_rec_start_date <= CURRENT_DATE AND (cs.cc_rec_end_date IS NULL OR cs.cc_rec_end_date >= CURRENT_DATE) AND ws.web_rec_start_date <= CURRENT_DATE AND (ws.web_rec_end_date IS NULL OR ws.web_rec_end_date >= CURRENT_DATE) ) GROUP BY cs.cc_state, ws.web_state, cs.cc_name, ws.web_name ORDER BY number_of_call_centers DESC, number_of_web_sites DESC;
SELECT cp_department, SUM(ws_quantity) AS total_quantity_sold, AVG(ws_sales_price) AS average_sales_price, COUNT(DISTINCT ws_bill_customer_sk) AS unique_customers, COUNT(DISTINCT ws_web_page_sk) AS page_views, SUM(ws_net_paid) AS total_net_paid, SUM(ws_net_profit) AS total_net_profit FROM web_sales JOIN catalog_page ON web_sales.ws_web_page_sk = catalog_page.cp_catalog_page_sk WHERE catalog_page.cp_catalog_number IN (20, 25, 19) AND catalog_page.cp_department = 'DEPARTMENT' GROUP BY cp_department ORDER BY total_net_profit DESC;
