SELECT r.r_reason_desc, ca.ca_state, d.d_moy AS month_of_year, COUNT(sr.sr_ticket_number) AS return_count, SUM(sr.sr_return_amt) AS total_return_amount, AVG(sr.sr_return_amt) AS avg_return_amount FROM store_returns sr JOIN reason r ON sr.sr_reason_sk = r.r_reason_sk JOIN date_dim d ON sr.sr_returned_date_sk = d.d_date_sk JOIN customer_address ca ON sr.sr_addr_sk = ca.ca_address_sk WHERE d.d_current_year = 'Y' GROUP BY r.r_reason_desc, ca.ca_state, month_of_year ORDER BY r.r_reason_desc, ca.ca_state, month_of_year;
SELECT ca.ca_state, ca.ca_city, COUNT(DISTINCT c.c_customer_sk) AS total_customers, SUM(ws.ws_quantity) AS total_items_sold, AVG(ws.ws_net_paid) AS average_net_paid_per_sale, SUM(ws.ws_net_profit) AS total_net_profit, COUNT(DISTINCT ws.ws_promo_sk) AS distinct_promotions_used FROM customer_address ca JOIN customer c ON c.c_current_addr_sk = ca.ca_address_sk JOIN web_sales ws ON ws.ws_bill_customer_sk = c.c_customer_sk JOIN promotion p ON ws.ws_promo_sk = p.p_promo_sk WHERE ca.ca_country = 'United States' AND p.p_channel_details IN ('Signs hear moreover nations. There perfect', 'Regional schemes would devise even loc') AND p.p_response_target = 1 AND ws.ws_sales_price > 0 GROUP BY ca.ca_state, ca.ca_city ORDER BY total_net_profit DESC, ca.ca_state, ca.ca_city;
SELECT ca_state, cp_department, SUM(ss_quantity) AS total_quantity_sold, AVG(ss_sales_price) AS average_sales_price, COUNT(DISTINCT ss_customer_sk) AS unique_customers, SUM(ss_net_paid) AS total_net_paid, SUM(ss_net_paid_inc_tax) AS total_net_paid_inc_tax, SUM(ss_net_profit) AS total_net_profit FROM store_sales JOIN customer_address ON ss_addr_sk = ca_address_sk JOIN catalog_page ON ss_promo_sk = cp_catalog_page_sk WHERE ss_sold_date_sk = 2450815 AND cp_description IN ( 'Only nuclear policies understand so basic courts.', 'Just local products used to note well; areas note', 'Women apply in vain in the minutes. Officials can', 'Traditional, clear years used to cover regardless' ) AND ss_cdemo_sk IN ( SELECT cd_demo_sk FROM customer_demographics WHERE cd_dep_count IN ('1', '2') ) GROUP BY ca_state, cp_department ORDER BY total_net_profit DESC, total_quantity_sold DESC;
SELECT h.hd_income_band_sk, p.p_promo_name, p.p_channel_dmail, p.p_channel_email, p.p_channel_tv, COUNT(DISTINCT s.ss_ticket_number) AS total_sales_transactions, SUM(s.ss_quantity) AS total_units_sold, SUM(s.ss_net_paid) AS total_revenue, AVG(s.ss_sales_price) AS average_sales_price, r.r_reason_desc, COUNT(DISTINCT sr.sr_ticket_number) AS total_return_transactions, SUM(sr.sr_return_quantity) AS total_units_returned, SUM(sr.sr_net_loss) AS total_loss_from_returns FROM store_sales s LEFT JOIN promotion p ON s.ss_promo_sk = p.p_promo_sk LEFT JOIN household_demographics h ON s.ss_hdemo_sk = h.hd_demo_sk LEFT JOIN store_returns sr ON s.ss_ticket_number = sr.sr_ticket_number AND s.ss_item_sk = sr.sr_item_sk LEFT JOIN reason r ON sr.sr_reason_sk = r.r_reason_sk WHERE s.ss_item_sk IN (13423, 9310) GROUP BY h.hd_income_band_sk, p.p_promo_name, p.p_channel_dmail, p.p_channel_email, p.p_channel_tv, r.r_reason_desc ORDER BY total_revenue DESC;
SELECT c.c_birth_country, sm.sm_type AS shipping_type, COUNT(DISTINCT ws.ws_order_number) AS total_orders, SUM(ws.ws_quantity) AS total_quantity, AVG(ws.ws_sales_price) AS average_sales_price, SUM(ws.ws_net_paid) AS total_net_paid, SUM(ws.ws_ext_tax) AS total_tax_collected, SUM(ws.ws_coupon_amt) AS total_coupon_amount, SUM(ws.ws_net_profit) AS total_net_profit FROM web_sales ws JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk GROUP BY c.c_birth_country, sm.sm_type ORDER BY c.c_birth_country, sm.sm_type;
SELECT r.r_reason_desc, COUNT(cr.cr_order_number) AS total_returns, SUM(cr.cr_return_quantity) AS total_returned_items, AVG(cr.cr_return_amount) AS avg_return_amount, SUM(cr.cr_return_amount) AS total_return_amount, SUM(cr.cr_return_amt_inc_tax) AS total_return_amount_inc_tax, SUM(cr.cr_fee) AS total_fees, SUM(cr.cr_net_loss) AS total_net_loss, SUM(cs.cs_quantity) AS total_sold_quantity, AVG(cs.cs_sales_price) AS avg_sales_price, SUM(cs.cs_sales_price) AS total_sales, SUM(cs.cs_net_profit) AS total_net_profit FROM catalog_returns cr JOIN reason r ON cr.cr_reason_sk = r.r_reason_sk JOIN catalog_sales cs ON cr.cr_item_sk = cs.cs_item_sk AND cr.cr_order_number = cs.cs_order_number WHERE cr.cr_returned_date_sk IS NOT NULL AND (cr.cr_refunded_addr_sk IN (18593, 5341, 29829) OR r.r_reason_desc IN ('reason 29', 'reason 28', 'reason 31', 'Lost my job', 'Did not get it on time')) GROUP BY r.r_reason_desc ORDER BY total_returns DESC, total_return_amount DESC;
SELECT d_year, SUM(cs_net_paid) AS total_sales, AVG(cs_quantity) AS average_quantity, COUNT(DISTINCT cs_order_number) AS total_orders, hd_dep_count, hd_vehicle_count, p_channel_dmail, p_channel_demo FROM catalog_sales JOIN date_dim ON (catalog_sales.cs_sold_date_sk = date_dim.d_date_sk) JOIN household_demographics ON (catalog_sales.cs_bill_hdemo_sk = household_demographics.hd_demo_sk) JOIN promotion ON (catalog_sales.cs_promo_sk = promotion.p_promo_sk) WHERE d_year = 1999 AND hd_dep_count >= 2 AND hd_vehicle_count >= 1 AND (p_channel_dmail = 'Y' OR p_channel_demo = 'N') GROUP BY d_year, hd_dep_count, hd_vehicle_count, p_channel_dmail, p_channel_demo ORDER BY total_sales DESC;
SELECT age_group, hd_buy_potential, AVG(ss_net_paid) AS avg_sales, SUM(ss_quantity) AS total_quantity_sold, COUNT(DISTINCT ss_customer_sk) AS unique_customers FROM customer c JOIN store_sales ss ON c.c_customer_sk = ss.ss_customer_sk JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk CROSS JOIN (SELECT CASE WHEN c_birth_year BETWEEN 1946 AND 1964 THEN 'Baby Boomers' WHEN c_birth_year BETWEEN 1965 AND 1980 THEN 'Generation X' WHEN c_birth_year BETWEEN 1981 AND 1996 THEN 'Millennials' WHEN c_birth_year >= 1997 THEN 'Generation Z' ELSE 'Unknown' END AS age_group, c_customer_sk FROM customer) AS cust_age_group WHERE cust_age_group.c_customer_sk = c.c_customer_sk GROUP BY age_group, hd_buy_potential ORDER BY age_group, hd_buy_potential;
SELECT c.c_customer_id, c.c_first_name, c.c_last_name, SUM(cs.cs_net_paid) AS total_sales, SUM(cr.cr_return_amount) AS total_returns, (SUM(cs.cs_net_paid) - SUM(cr.cr_return_amount)) AS net_profit, AVG(cs.cs_sales_price) AS average_sales_price, COUNT(DISTINCT cs.cs_order_number) AS number_of_orders, COUNT(DISTINCT cr.cr_order_number) AS number_of_returns FROM customer c LEFT JOIN catalog_sales cs ON c.c_customer_sk = cs.cs_bill_customer_sk LEFT JOIN catalog_returns cr ON cs.cs_order_number = cr.cr_order_number GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name HAVING COUNT(DISTINCT cs.cs_order_number) > 0 AND COUNT(DISTINCT cr.cr_order_number) > 0 ORDER BY net_profit DESC, total_sales DESC LIMIT 100;
SELECT cc.cc_country, cc.cc_open_date_sk, i.i_category, COUNT(cs.cs_order_number) AS total_orders, SUM(cs.cs_quantity) AS total_quantity_sold, AVG(cs.cs_sales_price) AS average_sales_price, SUM(cs.cs_net_paid) AS total_net_paid, SUM(cs.cs_net_paid_inc_tax) - SUM(cs.cs_net_paid) AS total_tax_collected, SUM(cs.cs_net_profit) AS total_net_profit, COUNT(DISTINCT wr.wr_order_number) AS total_returns, SUM(wr.wr_return_quantity) AS total_returned_quantity, AVG(wr.wr_return_amt) AS average_return_amount, SUM(wr.wr_net_loss) AS total_net_loss FROM call_center cc JOIN catalog_sales cs ON cc.cc_call_center_sk = cs.cs_call_center_sk JOIN item i ON cs.cs_item_sk = i.i_item_sk LEFT JOIN web_returns wr ON cs.cs_item_sk = wr.wr_item_sk AND cs.cs_order_number = wr.wr_order_number WHERE cc.cc_country = 'United States' AND cc.cc_open_date_sk IN ('2450952', '2450806', '2451063') GROUP BY ROLLUP(cc.cc_country, cc.cc_open_date_sk, i.i_category) ORDER BY cc.cc_country, cc.cc_open_date_sk, i.i_category;
SELECT dd.d_year, dd.d_quarter_name, i.i_category, COUNT(sr.sr_ticket_number) AS total_returns, SUM(sr.sr_return_quantity) AS total_returned_items, AVG(sr.sr_return_amt) AS average_return_amount, SUM(sr.sr_return_amt_inc_tax) AS total_return_amount_inc_tax, SUM(sr.sr_fee) AS total_fees, SUM(sr.sr_net_loss) AS total_net_loss FROM store_returns sr JOIN date_dim dd ON sr.sr_returned_date_sk = dd.d_date_sk JOIN item i ON sr.sr_item_sk = i.i_item_sk JOIN customer_demographics cd ON sr.sr_cdemo_sk = cd.cd_demo_sk JOIN time_dim td ON sr.sr_return_time_sk = td.t_time_sk WHERE (i.i_brand_id IN ('8007010', '6006007', '9004004', '9010002') OR i.i_container = 'Unknown') AND dd.d_quarter_name IN ('1907Q4', '1912Q3', '1913Q3') AND td.t_time_sk = '4464' AND td.t_shift = 'third' GROUP BY dd.d_year, dd.d_quarter_name, i.i_category ORDER BY dd.d_year, dd.d_quarter_name, total_returned_items DESC;
SELECT cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, cd.cd_purchase_estimate, cd.cd_credit_rating, AVG(cd.cd_dep_count) AS avg_dependents, AVG(cd.cd_dep_employed_count) AS avg_employed_dependents, AVG(cd.cd_dep_college_count) AS avg_college_dependents, COUNT(DISTINCT sr.sr_customer_sk) AS num_returning_customers, SUM(sr.sr_return_quantity) AS total_returned_quantity, SUM(sr.sr_return_amt) AS total_returned_amount, SUM(sr.sr_return_amt_inc_tax) AS total_returned_amount_inc_tax, AVG(sr.sr_return_amt) AS avg_return_amount, AVG(sr.sr_return_amt_inc_tax) AS avg_return_amount_inc_tax, MAX(sr.sr_return_amt_inc_tax) AS max_return_amount_inc_tax, MIN(sr.sr_return_amt_inc_tax) AS min_return_amount_inc_tax, td.t_shift, COUNT(DISTINCT wp.wp_web_page_sk) AS num_web_pages, SUM(wp.wp_char_count) AS total_char_count FROM customer_demographics cd JOIN store_returns sr ON cd.cd_demo_sk = sr.sr_cdemo_sk JOIN time_dim td ON sr.sr_return_time_sk = td.t_time_sk LEFT JOIN web_page wp ON cd.cd_demo_sk = wp.wp_customer_sk WHERE cd.cd_gender = 'M' AND sr.sr_return_amt_inc_tax BETWEEN 8.31 AND 5055.81 AND wp.wp_url LIKE 'http://www.foo.com%' AND wp.wp_char_count IN (5676, 3034) GROUP BY cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, cd.cd_purchase_estimate, cd.cd_credit_rating, td.t_shift ORDER BY total_returned_amount_inc_tax DESC, avg_dependents DESC LIMIT 100;
SELECT s.s_store_name, s.s_city, s.s_state, ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound, COUNT(DISTINCT ws.ws_order_number) AS total_orders, SUM(ws.ws_quantity) AS total_quantity_sold, SUM(ws.ws_net_paid) AS total_net_paid, AVG(ws.ws_net_profit) AS average_net_profit, COUNT(DISTINCT cr.cr_order_number) AS total_returns, SUM(cr.cr_return_amount) AS total_return_amount, AVG(cd.cd_purchase_estimate) AS average_purchase_estimate, COUNT(DISTINCT wp.wp_web_page_sk) AS total_web_page_visits FROM store s JOIN web_sales ws ON s.s_store_sk = ws.ws_ship_addr_sk JOIN income_band ib ON ws.ws_bill_customer_sk = ib.ib_income_band_sk JOIN catalog_returns cr ON ws.ws_item_sk = cr.cr_item_sk AND ws.ws_order_number = cr.cr_order_number JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk JOIN web_page wp ON ws.ws_web_page_sk = wp.wp_web_page_sk JOIN date_dim dd ON ws.ws_sold_date_sk = dd.d_date_sk WHERE ws.ws_ext_ship_cost IN (176.54, 380.00, 2131.08) AND ws.ws_ext_wholesale_cost IN (1606.13, 264.04, 476.93) AND ib.ib_income_band_sk IN (6, 20, 17) AND ib.ib_upper_bound IN (30000, 50000, 70000) AND s.s_city IN ('Fairview', 'Midway') AND s.s_market_manager IN ('Thomas Benton', 'Dustin Kelly', 'Dean Morrison') AND s.s_suite_number IN ('Suite 410', 'Suite 190', 'Suite 100') AND cr.cr_ship_mode_sk IN (5, 14, 16) AND cr.cr_item_sk IN (13561, 12757, 9220) AND cr.cr_returning_addr_sk IN (8108, 14295, 7472) AND dd.d_following_holiday IN ('N', 'Y') AND dd.d_dow IN (6, 2, 4) AND dd.d_current_year = 'N' AND wp.wp_access_date_sk IN (2452580, 2452611, 2452576) AND wp.wp_image_count IN (3, 7, 4) AND cd.cd_purchase_estimate IN (500, 2000, 3000) AND cd.cd_education_status IN ('4 yr Degree', 'Secondary', '2 yr Degree') AND cd.cd_dep_count IN (2, 1) GROUP BY s.s_store_name, s.s_city, s.s_state, ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound ORDER BY total_net_paid DESC, average_net_profit DESC, total_web_page_visits DESC LIMIT 100;
SELECT w_state, w_city, p_promo_name, p_channel_details, COUNT(ss_ticket_number) AS ticket_count, SUM(ss_quantity) AS total_quantity_sold, AVG(ss_sales_price) AS average_sales_price, SUM(ss_net_paid) AS total_net_paid, SUM(ss_net_profit) AS total_net_profit FROM store_sales JOIN warehouse ON ss_addr_sk = w_warehouse_sk JOIN promotion ON ss_promo_sk = p_promo_sk JOIN time_dim ON ss_sold_time_sk = t_time_sk JOIN household_demographics ON ss_hdemo_sk = hd_demo_sk WHERE w_country = 'United States' AND t_am_pm = 'PM' AND hd_buy_potential = 'Unknown' AND p_discount_active = 'Y' GROUP BY w_state, w_city, p_promo_name, p_channel_details ORDER BY total_net_profit DESC, total_net_paid DESC LIMIT 10;
SELECT s.s_store_sk, s.s_store_name, s.s_city, s.s_state, dd.d_quarter_name, COUNT(DISTINCT ss.ss_ticket_number) AS total_sales_transactions, SUM(ss.ss_quantity) AS total_units_sold, SUM(ss.ss_net_paid) AS total_revenue, SUM(ss.ss_net_profit) AS total_profit, COUNT(DISTINCT sr.sr_ticket_number) AS total_return_transactions, SUM(sr.sr_return_quantity) AS total_units_returned, SUM(sr.sr_return_amt) AS total_return_amount, SUM(sr.sr_net_loss) AS total_return_loss, AVG(cd.cd_dep_count) AS avg_customer_dependants, AVG(hd.hd_income_band_sk) AS avg_customer_income_band, r.r_reason_desc AS most_common_return_reason FROM store_sales ss JOIN store s ON ss.ss_store_sk = s.s_store_sk JOIN date_dim dd ON ss.ss_sold_date_sk = dd.d_date_sk LEFT JOIN store_returns sr ON ss.ss_ticket_number = sr.sr_ticket_number AND ss.ss_item_sk = sr.sr_item_sk LEFT JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk LEFT JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk LEFT JOIN reason r ON sr.sr_reason_sk = r.r_reason_sk WHERE dd.d_quarter_name IS NOT NULL GROUP BY s.s_store_sk, s.s_store_name, s.s_city, s.s_state, dd.d_quarter_name, r.r_reason_desc ORDER BY s.s_store_sk, dd.d_quarter_name;
SELECT d_year, d_quarter_name, sm_type AS shipping_type, COUNT(DISTINCT ss_ticket_number) AS num_sales_transactions, SUM(ss_quantity) AS total_sold_quantity, AVG(ss_sales_price) AS average_sales_price, SUM(ss_net_profit) AS total_sales_net_profit, COUNT(DISTINCT sr_ticket_number) AS num_returns_transactions, SUM(sr_return_quantity) AS total_returned_quantity, AVG(sr_return_amt) AS average_return_amount, SUM(sr_net_loss) AS total_returns_net_loss, AVG(hd_dep_count) AS average_dependency_count, AVG(hd_vehicle_count) AS average_vehicle_count, AVG(ib_lower_bound) AS average_income_lower_bound, AVG(ib_upper_bound) AS average_income_upper_bound FROM store_sales JOIN date_dim ON ss_sold_date_sk = d_date_sk JOIN store_returns ON sr_item_sk = ss_item_sk AND sr_returned_date_sk = ss_sold_date_sk JOIN ship_mode ON sm_ship_mode_sk = ss_sold_date_sk JOIN household_demographics ON ss_hdemo_sk = hd_demo_sk JOIN income_band ON hd_income_band_sk = ib_income_band_sk WHERE d_moy IN (2, 4, 6, 8, 12) AND sm_code IN ('SEA', 'BIKE', 'AIR', 'SURFACE') AND sm_carrier IN ('PRIVATECARRIER', 'DIAMOND') GROUP BY d_year, d_quarter_name, shipping_type ORDER BY d_year, d_quarter_name, shipping_type;
SELECT i.i_category, i.i_brand, w.w_state, COUNT(DISTINCT cr.cr_order_number) as total_returns, SUM(cr.cr_return_amount) as total_return_amount, AVG(cr.cr_return_amount) as avg_return_amount, SUM(cr.cr_return_quantity) as total_return_quantity, AVG(cr.cr_return_quantity) as avg_return_quantity, COUNT(DISTINCT wr.wr_order_number) as total_web_returns, SUM(wr.wr_return_amt) as total_web_return_amount, AVG(wr.wr_return_amt) as avg_web_return_amount, SUM(wr.wr_return_quantity) as total_web_return_quantity, AVG(wr.wr_return_quantity) as avg_web_return_quantity, SUM(cr.cr_refunded_cash + wr.wr_refunded_cash) as total_refunded_cash, SUM(cr.cr_return_ship_cost + wr.wr_return_ship_cost) as total_shipping_cost FROM catalog_returns cr JOIN item i ON cr.cr_item_sk = i.i_item_sk JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk LEFT JOIN web_returns wr ON cr.cr_item_sk = wr.wr_item_sk AND cr.cr_order_number = wr.wr_order_number GROUP BY i.i_category, i.i_brand, w.w_state ORDER BY total_returns DESC, total_return_amount DESC, total_web_returns DESC, total_web_return_amount DESC;
SELECT s.s_store_name, s.s_number_employees, AVG(ss.ss_sales_price) AS average_sale_amount, AVG(sr.sr_return_amt) AS average_return_amount, SUM(inv.inv_quantity_on_hand) AS total_inventory, COUNT(DISTINCT ss.ss_ticket_number) AS total_sales_transactions, COUNT(DISTINCT sr.sr_ticket_number) AS total_return_transactions FROM store s LEFT JOIN store_sales ss ON s.s_store_sk = ss.ss_store_sk LEFT JOIN store_returns sr ON s.s_store_sk = sr.sr_store_sk AND ss.ss_item_sk = sr.sr_item_sk LEFT JOIN inventory inv ON ss.ss_item_sk = inv.inv_item_sk AND s.s_store_sk = inv.inv_warehouse_sk WHERE (ss.ss_sold_date_sk IS NOT NULL OR sr.sr_returned_date_sk IS NOT NULL) AND (ss.ss_item_sk IN (14547, 403, 14095, 8557) OR sr.sr_item_sk IN (14547, 403, 14095, 8557)) AND EXISTS ( SELECT 1 FROM household_demographics hd WHERE (ss.ss_hdemo_sk = hd.hd_demo_sk OR sr.sr_hdemo_sk = hd.hd_demo_sk) AND hd.hd_dep_count = 1 ) GROUP BY s.s_store_name, s.s_number_employees ORDER BY s.s_store_name;
SELECT cu.c_salutation, wh.w_state, COUNT(DISTINCT cs.cs_order_number) AS total_sales_transactions, SUM(cs.cs_net_paid_inc_tax) AS total_sales_amount, AVG(cs.cs_ext_discount_amt) AS average_discount, COUNT(DISTINCT sr.sr_ticket_number) AS total_return_transactions, SUM(sr.sr_return_amt_inc_tax) AS total_return_amount FROM customer cu LEFT JOIN catalog_sales cs ON cu.c_customer_sk = cs.cs_ship_customer_sk LEFT JOIN store_returns sr ON cu.c_customer_sk = sr.sr_customer_sk LEFT JOIN warehouse wh ON (cs.cs_warehouse_sk = wh.w_warehouse_sk OR sr.sr_store_sk = wh.w_warehouse_sk) LEFT JOIN promotion p ON cs.cs_promo_sk = p.p_promo_sk WHERE (cs.cs_sold_date_sk IN ('2450819', '2450822', '2450817') OR sr.sr_returned_date_sk IN ('2450819', '2450822', '2450817')) AND (cu.c_salutation IN ('Dr.', 'Mr.', 'Sir', 'Ms.', 'Mrs.', 'Miss')) AND (wh.w_city = 'Fairview') AND (wh.w_suite_number IN ('Suite 80', 'Suite 0', 'Suite P', 'Suite 470')) AND (cu.c_last_review_date_sk IN ('2452425', '2452326', '2452389')) AND (sr.sr_reversed_charge IN ('44.04', '12.34') OR sr.sr_reversed_charge IS NULL) GROUP BY cu.c_salutation, wh.w_state ORDER BY total_sales_amount DESC, total_return_amount ASC;
SELECT ca.ca_location_type, COUNT(DISTINCT p.p_promo_sk) AS num_promotions, SUM(p.p_cost) AS total_promotion_cost, SUM(CASE WHEN p.p_channel_dmail = '1' THEN 1 ELSE 0 END) AS dmail_promotions, SUM(CASE WHEN p.p_channel_email = '1' THEN 1 ELSE 0 END) AS email_promotions, SUM(CASE WHEN p.p_channel_catalog = '1' THEN 1 ELSE 0 END) AS catalog_promotions, SUM(CASE WHEN p.p_channel_tv = '1' THEN 1 ELSE 0 END) AS tv_promotions, SUM(CASE WHEN p.p_channel_radio = '1' THEN 1 ELSE 0 END) AS radio_promotions, SUM(CASE WHEN p.p_channel_press = '1' THEN 1 ELSE 0 END) AS press_promotions, SUM(CASE WHEN p.p_channel_event = '1' THEN 1 ELSE 0 END) AS event_promotions, SUM(CASE WHEN p.p_channel_demo = '1' THEN 1 ELSE 0 END) AS demo_promotions, AVG(p.p_cost) AS avg_promotion_cost_per_channel FROM promotion p JOIN customer_address ca ON p.p_item_sk = ca.ca_address_sk WHERE ca.ca_location_type IN ('single family', 'apartment', 'condo') AND ca.ca_street_type LIKE '%Way%' AND p.p_cost >= 1000.00 AND p.p_promo_id IN ('AAAAAAAAEGAAAAAA', 'AAAAAAAAGJAAAAAA', 'AAAAAAAAHFAAAAAA', 'AAAAAAAAPBBAAAAA') GROUP BY ca.ca_location_type ORDER BY total_promotion_cost DESC;
SELECT c.c_customer_id, c.c_first_name, c.c_last_name, c.c_email_address, SUM(cs.cs_net_paid) AS total_sales, AVG(cs.cs_ext_discount_amt) AS avg_discount, COUNT(cs.cs_item_sk) AS items_sold, SUM(sr.sr_return_amt) AS total_returns, COUNT(DISTINCT p.p_promo_sk) AS distinct_promotions_used FROM customer c LEFT JOIN catalog_sales cs ON c.c_customer_sk = cs.cs_bill_customer_sk LEFT JOIN store_returns sr ON c.c_customer_sk = sr.sr_customer_sk LEFT JOIN promotion p ON cs.cs_promo_sk = p.p_promo_sk WHERE c.c_salutation = 'Mr.' AND c.c_email_address IN ('Karen.Phifer@QY.edu', 'Allen.Turner@4.com', 'Larry.Olivas@7r7DYaK8.org', 'Shelly.Yang@LQxk.edu', 'Michelle.Sonnier@UFxKCExi4F.edu', 'John.Howard@2FPvikS8CVIG.edu') AND p.p_discount_active = 'N' AND cs.cs_ext_list_price IN (2280.36, 12094.39, 702.72, 3046.89, 8066.16) AND cs.cs_net_profit IN (-3051.02, -1521.74, -449.68) AND sr.sr_reversed_charge IN (41.31, 103.80, 2.35, 10.21) AND sr.sr_return_ship_cost IN (1284.78, 122.50) GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name, c.c_email_address ORDER BY total_sales DESC, avg_discount;
SELECT d_year, d_quarter_name, p_promo_name, COUNT(DISTINCT sr_ticket_number) AS total_returns, SUM(sr_return_quantity) AS total_returned_quantity, AVG(sr_return_amt) AS avg_return_amount, SUM(sr_return_amt_inc_tax) AS total_return_amount_inc_tax, SUM(sr_net_loss) AS total_net_loss, COUNT(DISTINCT sr_customer_sk) AS distinct_customers_returning, COUNT(DISTINCT sr_item_sk) AS distinct_items_returned FROM store_returns sr JOIN date_dim ON sr.sr_returned_date_sk = date_dim.d_date_sk JOIN promotion ON sr.sr_returned_date_sk BETWEEN promotion.p_start_date_sk AND promotion.p_end_date_sk WHERE d_year = 2000 AND promotion.p_channel_radio = 'N' AND promotion.p_discount_active = 'Y' GROUP BY d_year, d_quarter_name, p_promo_name ORDER BY d_year, d_quarter_name, p_promo_name;
SELECT p.p_promo_name, COUNT(ss.ss_ticket_number) AS total_sales_transactions, AVG(ss.ss_sales_price) AS avg_sales_price, SUM(ss.ss_ext_discount_amt) AS total_discount_amount, SUM(ss.ss_coupon_amt) AS total_coupon_discount, SUM(ss.ss_net_paid) AS total_net_paid, SUM(ss.ss_net_paid_inc_tax) AS total_net_paid_including_tax, SUM(ss.ss_net_profit) AS total_net_profit FROM store_sales ss JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk WHERE p.p_discount_active = 'Y' AND ss.ss_sold_date_sk BETWEEN p.p_start_date_sk AND p.p_end_date_sk GROUP BY p.p_promo_name ORDER BY total_net_profit DESC, total_sales_transactions DESC;
SELECT hd.hd_demo_sk, COUNT(DISTINCT ws.ws_order_number) AS total_orders, AVG(ws.ws_quantity) AS average_quantity, SUM(ws.ws_net_paid) AS total_net_paid, AVG(ws.ws_net_profit) AS average_net_profit, COUNT(DISTINCT CASE WHEN p.p_channel_press = 'N' THEN ws.ws_order_number END) AS non_press_promo_orders FROM household_demographics hd JOIN web_sales ws ON hd.hd_demo_sk = ws.ws_bill_hdemo_sk JOIN promotion p ON ws.ws_promo_sk = p.p_promo_sk JOIN time_dim t ON ws.ws_sold_time_sk = t.t_time_sk WHERE hd.hd_income_band_sk IS NOT NULL AND p.p_promo_name IS NOT NULL AND t.t_am_pm IS NOT NULL AND ws.ws_net_paid > 0 AND ws.ws_sales_price BETWEEN 1000 AND 4000 GROUP BY hd.hd_demo_sk HAVING COUNT(DISTINCT ws.ws_order_number) > 5 ORDER BY total_net_paid DESC, total_orders DESC LIMIT 10;
SELECT ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound, sm.sm_type, sm.sm_carrier, COUNT(i.i_item_sk) AS total_items_sold, AVG(i.i_current_price) AS average_selling_price, AVG(i.i_wholesale_cost) AS average_wholesale_cost FROM item i JOIN ship_mode sm ON i.i_container = sm.sm_code JOIN income_band ib ON i.i_manager_id = ib.ib_income_band_sk WHERE i.i_product_name = 'antin steing' AND ib.ib_income_band_sk IN (13, 18, 17, 3, 11, 16) AND sm.sm_contract IN ('uukTktPYycct8', '6Hzzp4JkzjqD8MGXLCDa', 'Xjy3ZPuiDjzHlRx14Z3', 'A5BYO1qH8HGTTN') AND i.i_item_id = 'AAAAAAAAMFLAAAAA' AND sm.sm_code IN ('SEA', 'BIKE', 'AIR', 'SURFACE') GROUP BY ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound, sm.sm_type, sm.sm_carrier ORDER BY average_selling_price DESC, total_items_sold DESC;
SELECT s.s_store_name, SUM(inv.inv_quantity_on_hand) AS Total_Inventory, AVG(inv.inv_quantity_on_hand) AS Average_Inventory, COUNT(DISTINCT inv.inv_item_sk) AS Unique_Items, COUNT(DISTINCT ca.ca_address_sk) AS Number_of_Customers, SUM(CASE WHEN cd.cd_credit_rating = 'High Risk' THEN cd.cd_purchase_estimate ELSE 0 END) AS High_Risk_Estimated_Purchases, AVG(cd.cd_purchase_estimate) AS Avg_Customer_Purchase_Estimate, SUM(cd.cd_dep_count) AS Total_Dependents, COUNT(DISTINCT sm.sm_ship_mode_sk) AS Shipping_Modes_Used FROM store s JOIN inventory inv ON s.s_store_sk = inv.inv_warehouse_sk JOIN customer_address ca ON ca.ca_city = s.s_city AND ca.ca_state = s.s_state JOIN customer_demographics cd ON ca.ca_address_sk = cd.cd_demo_sk JOIN ship_mode sm ON sm.sm_type = 'AIR' WHERE s.s_market_desc = 'Mysterious employe' AND inv.inv_quantity_on_hand IN (794, 3, 631, 744, 849) AND inv.inv_item_sk IN (10984, 6848, 7628) GROUP BY s.s_store_name ORDER BY Total_Inventory DESC, Number_of_Customers DESC LIMIT 100;
SELECT i.i_category, SUM(ss.ss_quantity) AS total_quantity_sold, AVG(ss.ss_sales_price) AS average_sales_price, COUNT(DISTINCT ss.ss_customer_sk) AS unique_customers, SUM(wr.wr_return_quantity) AS total_quantity_returned, SUM(wr.wr_return_amt) AS total_return_amount, AVG(inv.inv_quantity_on_hand) AS average_inventory_on_hand FROM item i LEFT JOIN store_sales ss ON ss.ss_item_sk = i.i_item_sk LEFT JOIN web_returns wr ON wr.wr_item_sk = i.i_item_sk LEFT JOIN inventory inv ON inv.inv_item_sk = i.i_item_sk WHERE i.i_category IN ('Electronics', 'Clothing', 'Furniture') AND ss.ss_sold_date_sk BETWEEN 2451453 AND 2451553 AND wr.wr_returned_date_sk BETWEEN 2451453 AND 2451553 AND inv.inv_date_sk BETWEEN 2451453 AND 2451553 GROUP BY i.i_category ORDER BY total_quantity_sold DESC;
SELECT s.s_store_name, SUM(ss.ss_quantity) AS total_quantity_sold, AVG(ss.ss_sales_price) AS average_sales_price, SUM(ss.ss_net_paid) AS total_net_paid, SUM(ss.ss_net_paid_inc_tax) AS total_net_paid_inc_tax, AVG(ss.ss_net_profit) AS average_net_profit, COUNT(DISTINCT p.p_promo_sk) AS number_of_promotions_run, SUM(CASE WHEN p.p_channel_tv = 'N' THEN ss.ss_quantity ELSE 0 END) AS quantity_sold_with_no_tv_promo FROM store_sales ss JOIN store s ON ss.ss_store_sk = s.s_store_sk JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk JOIN call_center cc ON s.s_market_id = cc.cc_mkt_id JOIN inventory i ON ss.ss_item_sk = i.inv_item_sk AND i.inv_date_sk = ss.ss_sold_date_sk WHERE ss.ss_sold_time_sk IN (63444, 44081, 71662, 70433) AND i.inv_item_sk IN (15889, 8930) AND i.inv_date_sk = 2450815 AND p.p_cost = 1000.00 AND cc.cc_sq_ft IN (795, 2268, 3514, 1138, 649) AND cc.cc_open_date_sk IN (2450806, 2450952) GROUP BY s.s_store_name ORDER BY total_net_paid DESC;
SELECT c.c_first_name, c.c_last_name, cd.cd_gender, cd.cd_education_status, hd.hd_buy_potential, hd.hd_vehicle_count, COUNT(sr.sr_item_sk) AS total_returns, SUM(sr.sr_return_amt_inc_tax) AS total_return_value, AVG(sr.sr_return_amt_inc_tax) AS avg_return_value, ib.ib_lower_bound, ib.ib_upper_bound, w.w_warehouse_name, w.w_city, w.w_state, ws.web_name, ws.web_manager, COUNT(wr.wr_item_sk) AS total_web_returns, SUM(wr.wr_return_amt_inc_tax) AS total_web_return_value, AVG(wr.wr_return_amt_inc_tax) AS avg_web_return_value FROM customer c JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk JOIN store_returns sr ON c.c_customer_sk = sr.sr_customer_sk JOIN warehouse w ON sr.sr_store_sk = w.w_warehouse_sk JOIN web_returns wr ON c.c_customer_sk = wr.wr_returning_customer_sk JOIN web_site ws ON wr.wr_web_page_sk = ws.web_site_sk WHERE cd.cd_credit_rating = 'Good' AND hd.hd_dep_count BETWEEN 1 AND 3 AND ib.ib_lower_bound >= 50000 AND sr.sr_return_amt > 0 AND wr.wr_return_amt > 0 AND ws.web_county = 'Williamson County' GROUP BY c.c_first_name, c.c_last_name, cd.cd_gender, cd.cd_education_status, hd.hd_buy_potential, hd.hd_vehicle_count, ib.ib_lower_bound, ib.ib_upper_bound, w.w_warehouse_name, w.w_city, w.w_state, ws.web_name, ws.web_manager ORDER BY total_return_value DESC, total_web_return_value DESC LIMIT 100;
SELECT p.p_promo_name, d_return.d_year AS return_year, d_return.d_quarter_name, COUNT(DISTINCT cr.cr_order_number) AS total_returns, SUM(cr.cr_return_quantity) AS total_returned_quantity, SUM(cr.cr_return_amount) AS total_returned_amount, AVG(cr.cr_return_amount) AS avg_return_amount, SUM(cr.cr_net_loss) AS total_net_loss FROM catalog_returns cr JOIN date_dim d_return ON cr.cr_returned_date_sk = d_return.d_date_sk JOIN promotion p ON cr.cr_item_sk = p.p_item_sk JOIN date_dim d_start ON p.p_start_date_sk = d_start.d_date_sk JOIN date_dim d_end ON p.p_end_date_sk = d_end.d_date_sk WHERE cr.cr_call_center_sk IN ('2', '4') AND cr.cr_reason_sk IN ('11', '25') AND d_return.d_current_week = 'N' AND p.p_channel_tv = 'N' AND p.p_channel_radio = 'N' AND d_return.d_date BETWEEN d_start.d_date AND d_end.d_date GROUP BY p.p_promo_name, return_year, d_return.d_quarter_name ORDER BY total_returned_amount DESC, total_returns DESC, return_year, d_return.d_quarter_name;
