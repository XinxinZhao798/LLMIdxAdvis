SELECT w_country, cr_returned_date_sk AS return_date_sk, i_category, COUNT(DISTINCT cr_order_number) AS total_returns, SUM(cr_return_quantity) AS total_returned_quantity, AVG(cr_return_amount) AS avg_return_amount, SUM(cr_net_loss) AS total_net_loss FROM catalog_returns cr JOIN item i ON cr.cr_item_sk = i.i_item_sk JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk JOIN promotion p ON i.i_item_sk = p.p_item_sk AND p.p_discount_active = 'N' WHERE cr.cr_returning_hdemo_sk IN (7008, 2246, 3148, 584, 6843) GROUP BY w_country, return_date_sk, i_category ORDER BY total_net_loss DESC, total_returns DESC;
SELECT i.i_item_id, i.i_product_name, i.i_category, COUNT(DISTINCT p.p_promo_sk) AS number_of_promotions, SUM(p.p_cost) AS total_promotion_cost, AVG(i.i_wholesale_cost) AS average_wholesale_cost, s.s_state, s.s_store_name, COUNT(DISTINCT s.s_store_sk) AS number_of_stores, AVG(s.s_tax_precentage) AS average_tax_percentage FROM promotion p JOIN item i ON p.p_item_sk = i.i_item_sk JOIN store s ON s.s_state IN ('AK', 'LA', 'MA', 'IA', 'CO', 'NY') WHERE p.p_start_date_sk BETWEEN '2450133' AND '2450769' AND p.p_end_date_sk BETWEEN '2450150' AND '2450824' AND i.i_product_name IN ('ationeseationable', 'antioughtpriable') AND s.s_gmt_offset = '-5.00' AND s.s_store_id IN ('AAAAAAAAHAAAAAAA', 'AAAAAAAABAAAAAAA', 'AAAAAAAAIAAAAAAA') GROUP BY i.i_item_id, i.i_product_name, i.i_category, s.s_state, s.s_store_name ORDER BY i.i_category, s.s_state, total_promotion_cost DESC;
SELECT cc.cc_state, AVG(cd.hd_dep_count) AS avg_dependent_count, AVG(cd.hd_vehicle_count) AS avg_vehicle_count, SUM(cs.cs_quantity) AS total_quantity_sold, SUM(cs.cs_sales_price) AS total_sales, AVG(cs.cs_sales_price) AS average_sales_price, AVG(cs.cs_ext_discount_amt) AS average_discount_amount, COUNT(DISTINCT cs.cs_order_number) AS total_transactions FROM catalog_sales cs JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk LEFT JOIN household_demographics cd ON cs.cs_ship_hdemo_sk = cd.hd_demo_sk WHERE cs.cs_sold_date_sk IS NOT NULL AND cc.cc_state IS NOT NULL GROUP BY cc.cc_state ORDER BY total_sales DESC LIMIT 5;
SELECT ssm.sm_code AS shipping_mode, AVG(ws.ws_ext_ship_cost) AS avg_shipping_cost, SUM(ws.ws_net_paid_inc_tax) AS total_net_sales, SUM(sr.sr_return_amt_inc_tax) AS total_return_amount, AVG(cr.cr_return_amount) AS avg_return_amount, COUNT(DISTINCT ws.ws_order_number) AS total_web_orders, COUNT(DISTINCT ss.ss_ticket_number) AS total_store_sales_transactions, COUNT(DISTINCT sr.sr_ticket_number) AS total_store_returns_transactions, COUNT(DISTINCT cr.cr_order_number) AS total_catalog_returns_transactions, (SUM(ws.ws_net_paid_inc_tax) - SUM(sr.sr_return_amt_inc_tax) - SUM(cr.cr_return_amt_inc_tax)) AS net_revenue FROM ship_mode AS ssm LEFT JOIN web_sales AS ws ON ssm.sm_ship_mode_sk = ws.ws_ship_mode_sk LEFT JOIN store_sales AS ss ON ws.ws_item_sk = ss.ss_item_sk LEFT JOIN store_returns AS sr ON ss.ss_item_sk = sr.sr_item_sk AND ss.ss_customer_sk = sr.sr_customer_sk LEFT JOIN catalog_returns AS cr ON cr.cr_item_sk = ws.ws_item_sk AND cr.cr_returning_customer_sk = ws.ws_bill_customer_sk GROUP BY ssm.sm_code ORDER BY net_revenue DESC;
SELECT dd.d_year AS year, dd.d_month_seq AS month, p.p_channel_dmail AS channel_direct_mail, p.p_channel_email AS channel_email, p.p_channel_catalog AS channel_catalog, p.p_channel_tv AS channel_tv, p.p_channel_radio AS channel_radio, p.p_channel_press AS channel_press, p.p_channel_event AS channel_event, p.p_channel_demo AS channel_demo, COUNT(DISTINCT ss.ss_ticket_number) AS total_sales_transactions, SUM(ss.ss_quantity) AS total_quantity_sold, SUM(ss.ss_ext_sales_price) AS total_sales_revenue, SUM(ss.ss_ext_discount_amt) AS total_discount_amount, SUM(ss.ss_net_paid) AS total_net_paid, SUM(ss.ss_net_profit) AS total_net_profit FROM promotion p JOIN store_sales ss ON p.p_promo_sk = ss.ss_promo_sk JOIN date_dim dd ON ss.ss_sold_date_sk = dd.d_date_sk WHERE p.p_cost > 1000.00 AND ss.ss_sales_price > 50.00 GROUP BY dd.d_year, dd.d_month_seq, p.p_channel_dmail, p.p_channel_email, p.p_channel_catalog, p.p_channel_tv, p.p_channel_radio, p.p_channel_press, p.p_channel_event, p.p_channel_demo ORDER BY dd.d_year DESC, dd.d_month_seq, total_sales_revenue DESC;
SELECT c.c_customer_id, sm.sm_type as shipping_type, count(cs_order_number) as total_orders, sum(cs_quantity) as total_quantity, avg(cs_net_paid) as average_net_paid, sum(cs_net_profit) as total_net_profit, date_part('year', d.d_date) as sale_year, d.d_quarter_name as sale_quarter, ib.ib_lower_bound as income_band_lower_bound, ib.ib_upper_bound as income_band_upper_bound FROM catalog_sales cs JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk JOIN ship_mode sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk JOIN income_band ib ON c.c_current_hdemo_sk = ib.ib_income_band_sk WHERE d.d_year = 2023 AND sm.sm_code = 'SEA' AND ib.ib_lower_bound >= 30001 AND ib.ib_upper_bound <= 80001 GROUP BY c.c_customer_id, shipping_type, sale_year, sale_quarter, income_band_lower_bound, income_band_upper_bound ORDER BY total_net_profit DESC, total_orders DESC;
SELECT i_category, w_state, COUNT(DISTINCT ws_order_number) AS web_sales_orders, SUM(ws_net_paid) AS total_web_sales_revenue, AVG(ws_quantity) AS avg_web_sales_quantity, SUM(sr_return_amt) AS total_store_returns, AVG(sr_return_quantity) AS avg_store_return_quantity, COUNT(DISTINCT sr_ticket_number) AS store_return_tickets, SUM(cr_return_amount) AS total_catalog_returns, AVG(cr_return_quantity) AS avg_catalog_return_quantity, COUNT(DISTINCT cr_order_number) AS catalog_return_orders FROM web_sales ws JOIN item i ON ws.ws_item_sk = i.i_item_sk JOIN warehouse w ON ws.ws_warehouse_sk = w.w_warehouse_sk LEFT JOIN store_returns sr ON ws.ws_item_sk = sr.sr_item_sk AND ws.ws_order_number = sr.sr_ticket_number LEFT JOIN catalog_returns cr ON ws.ws_item_sk = cr.cr_item_sk AND ws.ws_order_number = cr.cr_order_number WHERE ws.ws_sold_date_sk BETWEEN 20000101 AND 20001231 AND ws.ws_ext_list_price IN ('3366.00', '12.38', '298.41') AND EXISTS ( SELECT 1 FROM inventory WHERE ws.ws_item_sk = inv_item_sk AND inv_warehouse_sk = ws.ws_warehouse_sk AND inv_date_sk BETWEEN 20000101 AND 20001231 AND inv_quantity_on_hand > 0 ) GROUP BY i_category, w_state ORDER BY i_category, w_state;
SELECT cc_state, cc_city, ca_country, COUNT(DISTINCT cc_call_center_sk) AS number_of_call_centers, SUM(cc_employees) AS total_employees, AVG(cc_tax_percentage) AS avg_tax_percentage, SUM(s_number_employees) AS total_store_employees, AVG(s_tax_precentage) AS avg_store_tax, SUM(ws_quantity) AS total_items_sold, SUM(ws_net_paid) AS total_revenue, SUM(ws_net_profit) AS total_profit, AVG(ws_net_profit) AS avg_profit_per_sale, SUM(ws_ext_ship_cost) AS total_shipping_cost FROM call_center JOIN store ON cc_zip = s_zip JOIN web_sales ON ws_ship_addr_sk IN (SELECT ca_address_sk FROM customer_address WHERE ca_zip = cc_zip) JOIN customer_address ON cc_zip = ca_zip WHERE cc_hours IN ('8AM-4PM', '8AM-8AM') AND ws_net_profit NOT IN (-1167.89, -63.88, -192.70, -49.59) AND ca_country = 'United States' AND ca_gmt_offset IN (-8.00, -9.00) GROUP BY cc_state, cc_city, ca_country ORDER BY total_profit DESC;
SELECT ca.ca_city, ca.ca_state, COUNT(DISTINCT cc.cc_call_center_id) AS num_call_centers, SUM(cc.cc_employees) AS total_employees, AVG(hd.hd_dep_count) AS avg_household_dep_count, SUM(sr.sr_return_amt) AS total_return_amount, SUM(sr.sr_return_quantity) AS total_returned_items, COUNT(DISTINCT sr.sr_ticket_number) AS num_return_transactions, AVG(sr.sr_fee) AS avg_return_fee FROM call_center cc JOIN customer_address ca ON cc.cc_city = ca.ca_city AND cc.cc_state = ca.ca_state JOIN household_demographics hd ON hd.hd_income_band_sk BETWEEN 9 AND 15 JOIN store_returns sr ON sr.sr_addr_sk = ca.ca_address_sk JOIN ship_mode sm ON sm.sm_contract IN ('A5BYO1qH8HGTTN', 'Xjy3ZPuiDjzHlRx14Z3', '2mM8l', '6Hzzp4JkzjqD8MGXLCDa') WHERE ca.ca_city IN ('Lewisburg', 'Wright', 'Valley View', 'Argyle', 'Plainview', 'Andover') AND sm.sm_type = 'REGULAR' AND ca.ca_gmt_offset IN (-6.00, -9.00, -5.00, -10.00) AND (hd.hd_dep_count IN (0, 3, 7, 8, 9) OR hd.hd_dep_count IS NULL) GROUP BY ca.ca_city, ca.ca_state ORDER BY total_return_amount DESC, total_employees DESC, num_return_transactions DESC;
SELECT i.i_category, i.i_brand, COUNT(DISTINCT cr.cr_order_number) AS total_returns, SUM(cr.cr_return_quantity) AS total_returned_quantity, AVG(cr.cr_return_amount) AS avg_return_amount, SUM(cr.cr_return_amount) AS total_return_amount, SUM(cr.cr_return_amt_inc_tax) AS total_return_amount_inc_tax, SUM(cr.cr_fee) AS total_fees, SUM(cr.cr_net_loss) AS total_net_loss FROM catalog_returns cr JOIN item i ON cr.cr_item_sk = i.i_item_sk JOIN web_page wp ON cr.cr_catalog_page_sk = wp.wp_web_page_sk WHERE i.i_brand_id IN ('10003002', '8008007', '7015003', '9001006', '10011007', '10010015') AND wp.wp_url = 'http://www.foo.com' AND wp.wp_customer_sk IN ('98633', '80555') AND cr.cr_ship_mode_sk IN ('10', '18', '12', '2', '6', '8') GROUP BY i.i_category, i.i_brand ORDER BY total_returns DESC, total_returned_quantity DESC;
SELECT ca.ca_state as customer_state, dd.d_month_seq as month_sequence, dd.d_year as year, SUM(ss.ss_ext_sales_price) as total_sales, AVG(ss.ss_sales_price) as average_sale_price, SUM(ss.ss_ext_discount_amt) as total_discounts, SUM(ss.ss_coupon_amt) as total_coupons, SUM(ss.ss_ext_tax) as total_tax, COUNT(DISTINCT ss.ss_ticket_number) as total_transactions FROM store_sales ss JOIN customer_address ca ON ss.ss_addr_sk = ca.ca_address_sk JOIN date_dim dd ON ss.ss_sold_date_sk = dd.d_date_sk WHERE dd.d_month_seq IS NOT NULL AND ca.ca_state IS NOT NULL GROUP BY customer_state, month_sequence, year ORDER BY customer_state, month_sequence, year;
SELECT ca.ca_state, cd.cd_education_status, COUNT(DISTINCT c.c_customer_sk) AS total_customers, SUM(ss.ss_quantity) AS total_sales_quantity, AVG(ss.ss_net_profit) AS avg_net_profit, SUM(sr.sr_return_quantity) AS total_return_quantity, AVG(sr.sr_net_loss) AS avg_net_loss, AVG(inv.inv_quantity_on_hand) AS avg_inventory_on_hand FROM customer c JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk LEFT JOIN store_sales ss ON c.c_customer_sk = ss.ss_customer_sk LEFT JOIN store_returns sr ON c.c_customer_sk = sr.sr_customer_sk LEFT JOIN inventory inv ON inv.inv_warehouse_sk = ca.ca_address_sk WHERE ca.ca_country = 'SERBIA' AND cd.cd_purchase_estimate BETWEEN 3500 AND 10000 AND inv.inv_warehouse_sk IN (1, 2) GROUP BY ca.ca_state, cd.cd_education_status ORDER BY ca.ca_state, cd.cd_education_status;
SELECT cp_department, cd_gender, cd_marital_status, cd_education_status, COUNT(DISTINCT sr_ticket_number) AS total_returns, SUM(sr_return_quantity) AS total_returned_quantity, AVG(sr_return_amt) AS average_return_amount, SUM(sr_return_amt_inc_tax) AS total_return_amount_inc_tax, SUM(sr_fee) AS total_fees, SUM(sr_net_loss) AS total_net_loss FROM catalog_page JOIN store_returns ON cp_catalog_page_sk = sr_returned_date_sk JOIN customer_demographics ON cd_demo_sk = sr_cdemo_sk WHERE cp_department = 'DEPARTMENT' AND (cp_start_date_sk = 2451665 OR cp_start_date_sk = 2451360) GROUP BY cp_department, cd_gender, cd_marital_status, cd_education_status ORDER BY total_returned_quantity DESC;
SELECT ws.ws_web_site_sk, web.web_name, web.web_class, cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, SUM(ws.ws_quantity) as total_quantity_sold, AVG(ws.ws_sales_price) as average_sales_price, COUNT(DISTINCT ws.ws_order_number) as total_orders, SUM(ws.ws_net_paid) as total_net_paid, SUM(ws.ws_net_paid_inc_tax) as total_net_paid_inc_tax, SUM(ws.ws_net_profit) as total_net_profit FROM web_sales ws JOIN web_site web ON ws.ws_web_site_sk = web.web_site_sk JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk JOIN promotion p ON ws.ws_promo_sk = p.p_promo_sk AND p.p_response_target = '1' WHERE p.p_start_date_sk IN (2451635, 2451362, 2451818, 2451605, 2451420, 2451665) GROUP BY ws.ws_web_site_sk, web.web_name, web.web_class, cd.cd_gender, cd.cd_marital_status, cd.cd_education_status ORDER BY total_net_profit DESC, web.web_name, cd.cd_gender, cd.cd_marital_status, cd.cd_education_status;
SELECT cp.cp_department, i.i_category, i.i_brand, sm.sm_carrier, s.s_store_name, s.s_company_name, COUNT(DISTINCT inv.inv_item_sk) AS num_items, SUM(inv.inv_quantity_on_hand) AS total_quantity, AVG(i.i_current_price) AS avg_current_price, MAX(i.i_wholesale_cost) AS max_wholesale_cost, MIN(s.s_number_employees) AS min_num_employees, AVG(s.s_tax_precentage) AS avg_tax_percentage FROM catalog_page cp JOIN item i ON cp.cp_catalog_page_sk = i.i_item_sk JOIN inventory inv ON i.i_item_sk = inv.inv_item_sk JOIN ship_mode sm ON sm.sm_ship_mode_sk = inv.inv_warehouse_sk JOIN store s ON s.s_store_sk = inv.inv_warehouse_sk WHERE i.i_brand = 'exportibrand #7' AND s.s_number_employees = 271 AND sm.sm_carrier IN ('BOXBUNDLES', 'ALLIANCE', 'PRIVATECARRIER', 'ORIENTAL', 'UPS') AND inv.inv_warehouse_sk IN (1, 2) GROUP BY cp.cp_department, i.i_category, i.i_brand, sm.sm_carrier, s.s_store_name, s.s_company_name ORDER BY total_quantity DESC, avg_current_price DESC;
SELECT cp.cp_department, COUNT(DISTINCT ss.ss_ticket_number) AS total_sales_transactions, SUM(ss.ss_quantity) AS total_sales_quantity, SUM(ss.ss_net_paid) AS total_sales_amount, COUNT(DISTINCT sr.sr_ticket_number) AS total_return_transactions, SUM(sr.sr_return_quantity) AS total_return_quantity, SUM(sr.sr_net_loss) AS total_return_amount, AVG(hd.hd_dep_count) AS avg_dependents, AVG(hd.hd_vehicle_count) AS avg_vehicles FROM catalog_page cp LEFT JOIN store_sales ss ON cp.cp_catalog_page_sk = ss.ss_sold_date_sk LEFT JOIN store_returns sr ON cp.cp_catalog_page_sk = sr.sr_returned_date_sk LEFT JOIN time_dim td ON ss.ss_sold_time_sk = td.t_time_sk LEFT JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk WHERE cp.cp_start_date_sk IN ('2451450', '2451545', '2451115', '2450997', '2450935', '2451330') GROUP BY cp.cp_department ORDER BY cp.cp_department;
SELECT COALESCE(customer_sales.cd_gender, customer_returns.cd_gender) AS cd_gender, SUM(total_sales) AS total_sales_amount, AVG(average_sales) AS average_sales_amount, COUNT(DISTINCT customer_sales.c_customer_sk) AS number_of_customers, SUM(total_returns) AS total_returns_amount, AVG(average_returns) AS average_returns_amount, COUNT(DISTINCT customer_returns.c_customer_sk) AS number_of_returning_customers FROM ( SELECT c_customer_sk, cd_gender, ss_sold_date_sk, SUM(ss_sales_price) AS total_sales, AVG(ss_sales_price) AS average_sales FROM customer JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk JOIN store_sales ON ss_customer_sk = c_customer_sk JOIN date_dim ON ss_sold_date_sk = d_date_sk WHERE d_year = 2023 AND cd_gender IN ('M', 'F') GROUP BY c_customer_sk, cd_gender, ss_sold_date_sk ) AS customer_sales FULL OUTER JOIN ( SELECT c_customer_sk, cd_gender, sr_returned_date_sk, SUM(sr_return_amt) AS total_returns, AVG(sr_return_amt) AS average_returns FROM customer JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk JOIN store_returns ON sr_customer_sk = c_customer_sk JOIN date_dim ON sr_returned_date_sk = d_date_sk WHERE d_year = 2023 AND cd_gender IN ('M', 'F') GROUP BY c_customer_sk, cd_gender, sr_returned_date_sk ) AS customer_returns ON customer_sales.c_customer_sk = customer_returns.c_customer_sk GROUP BY COALESCE(customer_sales.cd_gender, customer_returns.cd_gender);
SELECT reason.r_reason_desc AS Return_Reason, COUNT(DISTINCT web_returns.wr_order_number) AS Total_Returns, SUM(web_returns.wr_return_amt) AS Total_Return_Amount, AVG(web_returns.wr_return_amt) AS Average_Return_Amount, promotion.p_promo_name AS Promotion_Name, COUNT(DISTINCT promotion.p_promo_sk) AS Total_Promotions_Affected, ship_mode.sm_type AS Shipping_Type, COUNT(DISTINCT ship_mode.sm_ship_mode_sk) AS Total_Shipping_Modes_Used FROM web_returns JOIN reason ON web_returns.wr_reason_sk = reason.r_reason_sk LEFT JOIN promotion ON web_returns.wr_item_sk = promotion.p_item_sk JOIN web_page ON web_returns.wr_web_page_sk = web_page.wp_web_page_sk JOIN ship_mode ON web_returns.wr_order_number = ship_mode.sm_ship_mode_sk WHERE web_returns.wr_return_amt > 0 AND reason.r_reason_desc IN ('No service location in my area', 'Did not like the warranty', 'Stopped working') AND web_page.wp_link_count BETWEEN 15 AND 24 GROUP BY Return_Reason, Promotion_Name, Shipping_Type ORDER BY Total_Returns DESC, Total_Return_Amount DESC;
SELECT cc.cc_name, ca.ca_state, sum(ss.ss_quantity) AS total_quantity_sold, avg(ss.ss_sales_price) AS average_sales_price, count(DISTINCT sr.sr_ticket_number) AS total_returns, sum(sr.sr_return_amt) AS total_return_amount, sum(sr.sr_fee) AS total_return_fees, sum(ws.ws_net_paid_inc_ship_tax) AS total_web_sales_incl_ship_tax, sum(ws.ws_net_profit) AS total_web_profit FROM call_center cc JOIN store_sales ss ON cc.cc_call_center_sk = ss.ss_store_sk JOIN store_returns sr ON ss.ss_ticket_number = sr.sr_ticket_number JOIN web_sales ws ON cc.cc_call_center_sk = ws.ws_warehouse_sk JOIN customer_address ca ON ss.ss_addr_sk = ca.ca_address_sk WHERE cc.cc_company IN ('1', '2', '3') AND sr.sr_return_ship_cost IN (174.24, 2574.09, 3006.72) AND ca.ca_state IN ('CA', 'TX', 'NY') GROUP BY cc.cc_name, ca.ca_state ORDER BY total_return_amount DESC, total_web_profit DESC LIMIT 100;
SELECT ws_order_number, COUNT(DISTINCT ws_item_sk) AS item_count, SUM(ws_quantity) AS total_quantity, AVG(ws_sales_price) AS avg_sales_price, SUM(ws_net_paid) AS total_net_paid, SUM(ws_net_paid_inc_tax) AS total_net_paid_inc_tax, SUM(ws_net_paid_inc_ship) AS total_net_paid_inc_ship, SUM(ws_net_profit) AS total_net_profit, MIN(ws_ext_ship_cost) AS min_shipping_cost, MAX(ws_ext_ship_cost) AS max_shipping_cost FROM web_sales JOIN catalog_sales ON ws_item_sk = cs_item_sk AND ws_order_number = cs_order_number JOIN store_sales ON ws_item_sk = ss_item_sk AND ws_order_number = ss_ticket_number JOIN web_page ON ws_web_page_sk = wp_web_page_sk JOIN inventory ON ws_item_sk = inv_item_sk WHERE ws_sales_price BETWEEN 100 AND 200 AND cs_sales_price BETWEEN 100 AND 200 AND ss_sales_price BETWEEN 100 AND 200 AND ws_ext_ship_cost BETWEEN 10 AND 1360 AND wp_type = 'Product Review' GROUP BY ws_order_number HAVING COUNT(DISTINCT ws_item_sk) > 1 ORDER BY total_net_profit DESC;
SELECT w.w_warehouse_name, cp.cp_department, cd.cd_education_status, hd.hd_buy_potential, ib.ib_lower_bound, ib.ib_upper_bound, COUNT(*) AS number_of_returns, SUM(cr.cr_return_amount) AS total_return_amount, AVG(cr.cr_return_quantity) AS average_return_quantity, SUM(cr.cr_return_amt_inc_tax) AS total_return_amount_inc_tax, SUM(cr.cr_fee) AS total_fees, SUM(cr.cr_return_ship_cost) AS total_ship_cost, SUM(cr.cr_net_loss) AS total_net_loss FROM catalog_returns cr JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk JOIN catalog_page cp ON cr.cr_catalog_page_sk = cp.cp_catalog_page_sk JOIN customer_demographics cd ON cr.cr_refunded_cdemo_sk = cd.cd_demo_sk JOIN household_demographics hd ON cr.cr_refunded_hdemo_sk = hd.hd_demo_sk JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk WHERE cr.cr_returned_date_sk BETWEEN 2450810 AND 2450820 AND cp.cp_catalog_number BETWEEN 100 AND 200 AND cr.cr_order_number IN (5410, 3479, 2, 4547, 2428, 2527) AND w.w_suite_number IN ('Suite 80', 'Suite 0', 'Suite P', 'Suite 470') AND cr.cr_refunded_hdemo_sk IN (5152, 662, 6967) AND cd.cd_credit_rating = 'Excellent' GROUP BY w.w_warehouse_name, cp.cp_department, cd.cd_education_status, hd.hd_buy_potential, ib.ib_lower_bound, ib.ib_upper_bound ORDER BY total_return_amount DESC, w.w_warehouse_name, cp.cp_department;
SELECT cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, cd.cd_credit_rating, SUM(ss.ss_quantity) AS total_quantity_sold, AVG(ss.ss_sales_price) AS average_sales_price, COUNT(DISTINCT ss.ss_ticket_number) AS total_tickets, SUM(ss.ss_net_profit) AS total_net_profit FROM store_sales ss JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk JOIN ship_mode sm ON sm.sm_ship_mode_sk = ss.ss_promo_sk JOIN income_band ib ON ib.ib_income_band_sk = cd.cd_demo_sk WHERE sm.sm_contract IN ('ldhM8IvpzHgdbBgDfI', 'qENFQ', '6Hzzp4JkzjqD8MGXLCDa', 'uukTktPYycct8') AND t.t_hour IN (1, 0) AND ib.ib_upper_bound <= 10000 AND ib.ib_income_band_sk IN (18, 2, 4, 16, 13, 9) AND cd.cd_credit_rating IN ('High Risk', 'Low Risk', 'Good', 'Unknown') AND cd.cd_marital_status IN ('D', 'M', 'W', 'U') GROUP BY cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, cd.cd_credit_rating ORDER BY total_net_profit DESC, total_tickets DESC;
