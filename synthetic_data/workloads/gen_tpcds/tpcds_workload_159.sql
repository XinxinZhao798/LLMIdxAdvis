SELECT cc.cc_name, cc.cc_class, cc.cc_employees, cc.cc_city, COUNT(*) AS num_promotions, AVG(cd.cd_purchase_estimate) AS avg_purchase_estimate, SUM(CASE WHEN cd.cd_marital_status = 'D' THEN 1 ELSE 0 END) AS divorced_customer_count, SUM(CASE WHEN p.p_channel_email = 'N' THEN p.p_cost ELSE 0 END) AS total_promotion_cost_non_email FROM call_center cc JOIN promotion p ON cc.cc_call_center_sk = p.p_item_sk JOIN customer c ON cc.cc_call_center_sk = c.c_current_addr_sk JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk WHERE cc.cc_company = '2' AND cd.cd_dep_college_count = 0 AND p.p_promo_name LIKE '%pri%' OR p.p_promo_name LIKE '%eing%' GROUP BY cc.cc_name, cc.cc_class, cc.cc_employees, cc.cc_city HAVING COUNT(*) > 5 ORDER BY avg_purchase_estimate DESC;
SELECT c.c_customer_id, c.c_first_name, c.c_last_name, c.c_email_address, SUM(inv.inv_quantity_on_hand) AS total_inventory, AVG(sr_return_amt) AS avg_return_amount, COUNT(DISTINCT sr.sr_ticket_number) AS num_of_returns, COUNT(DISTINCT sm.sm_ship_mode_id) AS num_of_shipping_modes_used FROM customer c JOIN store_returns sr ON c.c_customer_sk = sr.sr_customer_sk JOIN inventory inv ON sr.sr_item_sk = inv.inv_item_sk JOIN ship_mode sm ON sm.sm_type = 'NEXT DAY' OR sm.sm_type = 'TWO DAY' WHERE c.c_email_address IN ('Bruce.Ratliff@FDMnSp6ETps.org', 'Louis.Luna@LrZBOvDJ842PiFOfe.edu', 'Anthony.Wilson@BebfByYiKCcg.com') AND c.c_current_hdemo_sk IN ('3673', '5606') GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name, c.c_email_address ORDER BY c.c_last_name, c.c_first_name;
SELECT age_group, hd_buy_potential, AVG(ss_net_paid) AS avg_sales, SUM(ss_quantity) AS total_quantity_sold, COUNT(DISTINCT ss_customer_sk) AS unique_customers FROM customer c JOIN store_sales ss ON c.c_customer_sk = ss.ss_customer_sk JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk CROSS JOIN (SELECT CASE WHEN c_birth_year BETWEEN 1946 AND 1964 THEN 'Baby Boomers' WHEN c_birth_year BETWEEN 1965 AND 1980 THEN 'Generation X' WHEN c_birth_year BETWEEN 1981 AND 1996 THEN 'Millennials' WHEN c_birth_year >= 1997 THEN 'Generation Z' ELSE 'Unknown' END AS age_group, c_customer_sk FROM customer) AS cust_age_group WHERE cust_age_group.c_customer_sk = c.c_customer_sk GROUP BY age_group, hd_buy_potential ORDER BY age_group, hd_buy_potential;
SELECT ws.web_name, ws.web_market_manager, ws.web_class, ws.web_city, COUNT(DISTINCT wp.wp_web_page_sk) AS total_pages, SUM(wp.wp_image_count) AS total_images, SUM(wp.wp_link_count) AS total_links, AVG(wp.wp_char_count) AS avg_char_count, SUM(sr.sr_return_quantity) AS total_returned_quantity, SUM(sr.sr_return_amt) AS total_return_amount, AVG(sr.sr_return_amt_inc_tax) AS avg_return_amount_inc_tax, COUNT(DISTINCT sr.sr_customer_sk) AS distinct_returning_customers, dd.d_year, dd.d_quarter_name, SUM(CASE WHEN dd.d_holiday = 'Y' THEN 1 ELSE 0 END) AS holiday_count, SUM(CASE WHEN dd.d_weekend = 'Y' THEN 1 ELSE 0 END) AS weekend_count FROM web_site ws JOIN web_page wp ON ws.web_site_sk = wp.wp_web_page_sk JOIN date_dim dd ON wp.wp_access_date_sk = dd.d_date_sk LEFT JOIN store_returns sr ON dd.d_date_sk = sr.sr_returned_date_sk WHERE dd.d_year IN (2020, 2021) AND ws.web_market_manager IN ('Gilbert Chapman', 'Jeffrey Campbell', 'Keith Frazier') AND ws.web_close_date_sk IS NULL GROUP BY ws.web_name, ws.web_market_manager, ws.web_class, ws.web_city, dd.d_year, dd.d_quarter_name ORDER BY ws.web_market_manager, ws.web_name, dd.d_year, dd.d_quarter_name;
SELECT cr_returned_date_sk AS return_date, SUM(cr_return_quantity) AS total_catalog_return_quantity, SUM(cr_return_amount) AS total_catalog_return_amount, AVG(cr_return_amount) AS avg_catalog_return_amount, COUNT(DISTINCT cr_refunded_customer_sk) AS unique_catalog_customers, SUM(sr_return_quantity) AS total_store_return_quantity, SUM(sr_return_amt) AS total_store_return_amount, AVG(sr_return_amt) AS avg_store_return_amount, COUNT(DISTINCT sr_customer_sk) AS unique_store_customers, SUM(wr_return_quantity) AS total_web_return_quantity, SUM(wr_return_amt) AS total_web_return_amount, AVG(wr_return_amt) AS avg_web_return_amount, COUNT(DISTINCT wr_returning_customer_sk) AS unique_web_customers FROM catalog_returns JOIN store_returns ON cr_item_sk = sr_item_sk AND cr_order_number = sr_ticket_number JOIN web_returns ON cr_item_sk = wr_item_sk AND cr_order_number = wr_order_number WHERE cr_returned_date_sk IS NOT NULL AND sr_returned_date_sk IS NOT NULL AND wr_returned_date_sk IS NOT NULL GROUP BY cr_returned_date_sk ORDER BY cr_returned_date_sk;
SELECT p.p_promo_id, p.p_promo_name, COUNT(ws.ws_order_number) AS total_orders, SUM(ws.ws_quantity) AS total_quantity_sold, AVG(ws.ws_sales_price) AS average_sales_price, SUM(ws.ws_net_profit) AS total_net_profit FROM web_sales ws INNER JOIN promotion p ON ws.ws_promo_sk = p.p_promo_sk INNER JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk INNER JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk INNER JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk WHERE p.p_channel_press = 'N' AND hd.hd_vehicle_count IN (1, 2) AND ib.ib_income_band_sk IN (20, 8) AND p.p_purpose <> 'Unknown' GROUP BY p.p_promo_id, p.p_promo_name ORDER BY total_net_profit DESC, total_quantity_sold DESC;
SELECT c.c_first_name, c.c_last_name, ca.ca_city, ca.ca_state, ca.ca_country, SUM(cs.cs_sales_price) AS total_sales, AVG(cs.cs_sales_price) AS average_sale_amount, COUNT(cs.cs_order_number) AS number_of_orders, SUM(cr.cr_return_amount) AS total_returns, AVG(cr.cr_return_amount) AS average_return_amount, COUNT(DISTINCT cr.cr_order_number) AS number_of_returns, SUM(cr.cr_net_loss) AS total_net_loss FROM customer c JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk JOIN catalog_sales cs ON c.c_customer_sk = cs.cs_bill_customer_sk LEFT JOIN catalog_returns cr ON cs.cs_order_number = cr.cr_order_number AND cs.cs_item_sk = cr.cr_item_sk WHERE ca.ca_country = 'United States' AND ca.ca_gmt_offset IN ('-10.00', '-6.00', '-5.00') AND cs.cs_ext_list_price > 0 GROUP BY c.c_first_name, c.c_last_name, ca.ca_city, ca.ca_state, ca.ca_country HAVING SUM(cs.cs_sales_price) > 0 ORDER BY total_sales DESC, total_returns DESC LIMIT 100;
SELECT i_category, d_year, d_quarter_name, SUM(ss_quantity) AS total_quantity_sold, AVG(ss_sales_price) AS average_sales_price, COUNT(DISTINCT ss_customer_sk) AS unique_customers, SUM(sr_return_quantity) AS total_quantity_returned, SUM(sr_return_amt) AS total_return_amount, SUM(ws_net_paid_inc_ship_tax) AS total_web_sales_inc_ship_tax, AVG(ws_quantity) AS average_web_sales_quantity, COUNT(DISTINCT ws_bill_customer_sk) AS unique_web_customers FROM item JOIN store_sales ON ss_item_sk = i_item_sk JOIN date_dim ON ss_sold_date_sk = d_date_sk JOIN store_returns ON sr_item_sk = ss_item_sk AND sr_returned_date_sk = ss_sold_date_sk JOIN web_sales ON ws_item_sk = ss_item_sk AND ws_sold_date_sk = ss_sold_date_sk WHERE d_year = 2022 AND i_category IN ('Electronics', 'Clothing', 'Home Goods') AND ss_list_price BETWEEN 50 AND 150 AND ws_net_paid_inc_tax > 100 GROUP BY i_category, d_year, d_quarter_name ORDER BY total_quantity_sold DESC, total_web_sales_inc_ship_tax DESC LIMIT 100;
SELECT s.s_store_name, s.s_city, s.s_state, ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound, COUNT(DISTINCT ws.ws_order_number) AS total_orders, SUM(ws.ws_quantity) AS total_quantity_sold, SUM(ws.ws_net_paid) AS total_net_paid, AVG(ws.ws_net_profit) AS average_net_profit, COUNT(DISTINCT cr.cr_order_number) AS total_returns, SUM(cr.cr_return_amount) AS total_return_amount, AVG(cd.cd_purchase_estimate) AS average_purchase_estimate, COUNT(DISTINCT wp.wp_web_page_sk) AS total_web_page_visits FROM store s JOIN web_sales ws ON s.s_store_sk = ws.ws_ship_addr_sk JOIN income_band ib ON ws.ws_bill_customer_sk = ib.ib_income_band_sk JOIN catalog_returns cr ON ws.ws_item_sk = cr.cr_item_sk AND ws.ws_order_number = cr.cr_order_number JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk JOIN web_page wp ON ws.ws_web_page_sk = wp.wp_web_page_sk JOIN date_dim dd ON ws.ws_sold_date_sk = dd.d_date_sk WHERE ws.ws_ext_ship_cost IN (176.54, 380.00, 2131.08) AND ws.ws_ext_wholesale_cost IN (1606.13, 264.04, 476.93) AND ib.ib_income_band_sk IN (6, 20, 17) AND ib.ib_upper_bound IN (30000, 50000, 70000) AND s.s_city IN ('Fairview', 'Midway') AND s.s_market_manager IN ('Thomas Benton', 'Dustin Kelly', 'Dean Morrison') AND s.s_suite_number IN ('Suite 410', 'Suite 190', 'Suite 100') AND cr.cr_ship_mode_sk IN (5, 14, 16) AND cr.cr_item_sk IN (13561, 12757, 9220) AND cr.cr_returning_addr_sk IN (8108, 14295, 7472) AND dd.d_following_holiday IN ('N', 'Y') AND dd.d_dow IN (6, 2, 4) AND dd.d_current_year = 'N' AND wp.wp_access_date_sk IN (2452580, 2452611, 2452576) AND wp.wp_image_count IN (3, 7, 4) AND cd.cd_purchase_estimate IN (500, 2000, 3000) AND cd.cd_education_status IN ('4 yr Degree', 'Secondary', '2 yr Degree') AND cd.cd_dep_count IN (2, 1) GROUP BY s.s_store_name, s.s_city, s.s_state, ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound ORDER BY total_net_paid DESC, average_net_profit DESC, total_web_page_visits DESC LIMIT 100;
SELECT dd.d_year, cc.cc_country, SUM(ss.ss_quantity) AS total_quantity_sold, AVG(ss.ss_sales_price) AS avg_sales_price, COUNT(DISTINCT wp.wp_web_page_sk) AS webpage_count, SUM(ss.ss_net_paid) - SUM(ss.ss_net_paid_inc_tax) AS total_tax_collected FROM store_sales ss JOIN date_dim dd ON ss.ss_sold_date_sk = dd.d_date_sk JOIN call_center cc ON cc.cc_call_center_sk = ss.ss_store_sk LEFT JOIN web_page wp ON dd.d_date_sk = wp.wp_access_date_sk WHERE dd.d_current_week = 'N' AND cc.cc_country = 'United States' AND cc.cc_call_center_sk IN ('3', '1', '5') AND wp.wp_image_count IN ('1', '2', '4', '5', '6', '7') GROUP BY dd.d_year, cc.cc_country ORDER BY dd.d_year, total_quantity_sold DESC;
SELECT p.p_promo_id, p.p_promo_name, COUNT(cs.cs_order_number) AS total_orders, SUM(cs.cs_net_paid) AS total_revenue, SUM(cs.cs_ext_wholesale_cost) AS total_cost, SUM(cs.cs_net_profit) AS total_profit, AVG(cs.cs_ext_discount_amt) AS average_discount_amount FROM catalog_sales cs JOIN promotion p ON cs.cs_promo_sk = p.p_promo_sk GROUP BY p.p_promo_id, p.p_promo_name ORDER BY total_revenue DESC;
SELECT wp_type AS web_page_type, ca_country AS customer_country, COUNT(DISTINCT wp_web_page_sk) AS num_web_pages, AVG(wp_char_count) AS avg_char_count, SUM(wp_link_count) AS total_link_count, SUM(wp_image_count) AS total_image_count FROM web_page JOIN customer_address ON wp_customer_sk = ca_address_sk JOIN reason ON wp_web_page_sk = r_reason_sk WHERE ca_county IN ('Worcester County', 'Tooele County', 'Page County', 'Wabaunsee County') AND r_reason_desc IN ('reason 27', 'unauthorized purchase', 'Did not get it on time', 'Gift exchange') AND r_reason_sk IN (26, 15, 5) GROUP BY web_page_type, customer_country ORDER BY avg_char_count DESC, total_link_count DESC;
SELECT w_state, p_promo_id, p_discount_active, COUNT(DISTINCT cr_order_number) AS total_returns, SUM(cr_return_amount) AS total_return_amount, AVG(cr_return_amount) AS avg_return_amount, SUM(cr_return_quantity) AS total_returned_quantity, COUNT(DISTINCT sr_ticket_number) AS total_store_returns, SUM(sr_return_amt) AS total_store_return_amount, AVG(sr_return_amt) AS avg_store_return_amount, SUM(sr_return_quantity) AS total_store_returned_quantity FROM catalog_returns JOIN warehouse ON cr_warehouse_sk = w_warehouse_sk JOIN promotion ON cr_catalog_page_sk = p_promo_sk JOIN store_returns ON cr_item_sk = sr_item_sk AND cr_order_number = sr_ticket_number WHERE w_state = 'TN' AND p_promo_id = 'AAAAAAAAMKAAAAAA' AND p_discount_active = 'N' GROUP BY w_state, p_promo_id, p_discount_active ORDER BY total_return_amount DESC;
SELECT s.s_store_sk, s.s_store_name, s.s_city, s.s_state, dd.d_quarter_name, COUNT(DISTINCT ss.ss_ticket_number) AS total_sales_transactions, SUM(ss.ss_quantity) AS total_units_sold, SUM(ss.ss_net_paid) AS total_revenue, SUM(ss.ss_net_profit) AS total_profit, COUNT(DISTINCT sr.sr_ticket_number) AS total_return_transactions, SUM(sr.sr_return_quantity) AS total_units_returned, SUM(sr.sr_return_amt) AS total_return_amount, SUM(sr.sr_net_loss) AS total_return_loss, AVG(cd.cd_dep_count) AS avg_customer_dependants, AVG(hd.hd_income_band_sk) AS avg_customer_income_band, r.r_reason_desc AS most_common_return_reason FROM store_sales ss JOIN store s ON ss.ss_store_sk = s.s_store_sk JOIN date_dim dd ON ss.ss_sold_date_sk = dd.d_date_sk LEFT JOIN store_returns sr ON ss.ss_ticket_number = sr.sr_ticket_number AND ss.ss_item_sk = sr.sr_item_sk LEFT JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk LEFT JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk LEFT JOIN reason r ON sr.sr_reason_sk = r.r_reason_sk WHERE dd.d_quarter_name IS NOT NULL GROUP BY s.s_store_sk, s.s_store_name, s.s_city, s.s_state, dd.d_quarter_name, r.r_reason_desc ORDER BY s.s_store_sk, dd.d_quarter_name;
SELECT item.i_category, item.i_class, reason.r_reason_desc, COUNT(DISTINCT catalog_returns.cr_order_number) AS total_catalog_returns, SUM(catalog_returns.cr_return_amount) AS total_catalog_return_amount, AVG(catalog_returns.cr_return_amount) AS avg_catalog_return_amount, SUM(catalog_returns.cr_return_tax) AS total_catalog_return_tax, COUNT(DISTINCT store_returns.sr_ticket_number) AS total_store_returns, SUM(store_returns.sr_return_amt) AS total_store_return_amount, AVG(store_returns.sr_return_amt) AS avg_store_return_amount, SUM(store_returns.sr_return_tax) AS total_store_return_tax FROM catalog_returns JOIN item ON catalog_returns.cr_item_sk = item.i_item_sk JOIN reason ON catalog_returns.cr_reason_sk = reason.r_reason_sk JOIN store_returns ON catalog_returns.cr_item_sk = store_returns.sr_item_sk WHERE item.i_category IN ('Children', 'Men', 'Shoes', 'Women', 'Home', 'Sports') AND item.i_class IN ('rings', 'camping', 'wallpaper') AND (catalog_returns.cr_returned_date_sk BETWEEN 88 AND 4202 OR store_returns.sr_returned_date_sk BETWEEN 88 AND 4202) GROUP BY item.i_category, item.i_class, reason.r_reason_desc ORDER BY item.i_category, item.i_class, reason.r_reason_desc;
SELECT c.c_birth_year, c.c_birth_country, c.c_preferred_cust_flag, s.s_store_id, s.s_store_name, s.s_city, s.s_state, s.s_market_desc, COUNT(ws.ws_order_number) AS total_orders, SUM(ws.ws_quantity) AS total_quantity_sold, AVG(ws.ws_sales_price) AS average_sales_price, SUM(ws.ws_net_paid) AS total_net_paid, SUM(ws.ws_net_paid_inc_tax) AS total_net_paid_inc_tax, SUM(ws.ws_net_profit) AS total_net_profit FROM web_sales ws INNER JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk INNER JOIN store s ON ws.ws_ship_addr_sk = s.s_store_sk GROUP BY c.c_birth_year, c.c_birth_country, c.c_preferred_cust_flag, s.s_store_id, s.s_store_name, s.s_city, s.s_state, s.s_market_desc ORDER BY total_net_paid DESC, s.s_state, c.c_birth_year;
