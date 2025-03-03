SELECT d_year, i_category, s_store_name, SUM(ss_quantity) AS total_quantity_sold, AVG(ss_sales_price) AS avg_sales_price, SUM(ss_net_profit) AS total_net_profit, COUNT(DISTINCT ss_customer_sk) AS unique_customers, AVG(hd_dep_count) AS avg_household_dep_count, AVG(hd_vehicle_count) AS avg_household_vehicle_count FROM store_sales JOIN date_dim ON ss_sold_date_sk = d_date_sk JOIN item ON ss_item_sk = i_item_sk JOIN store ON ss_store_sk = s_store_sk JOIN household_demographics ON ss_hdemo_sk = hd_demo_sk WHERE d_year = 2001 AND i_category_id IN ('3', '7', '4', '6') AND hd_income_band_sk IN ('7', '3', '9', '15', '20', '18') GROUP BY d_year, i_category, s_store_name ORDER BY total_net_profit DESC, avg_sales_price DESC LIMIT 100;
SELECT i_category, i_class, COUNT(DISTINCT i_item_sk) AS num_items, AVG(i_current_price) AS avg_price, SUM(inv_quantity_on_hand) AS total_inventory, COUNT(DISTINCT wr_order_number) AS num_returns, SUM(wr_return_quantity) AS total_returned_quantity, SUM(wr_return_amt) AS total_return_amount, cd_gender, AVG(cd_purchase_estimate) AS avg_purchase_estimate, SUM(CASE WHEN cd_gender = 'M' THEN 1 ELSE 0 END) AS male_customers, SUM(CASE WHEN cd_gender = 'F' THEN 1 ELSE 0 END) AS female_customers, web_name, SUM(wr_return_amt_inc_tax) AS total_return_amount_incl_tax FROM item JOIN inventory ON i_item_sk = inv_item_sk JOIN web_returns ON i_item_sk = wr_item_sk JOIN customer_demographics ON wr_returning_cdemo_sk = cd_demo_sk JOIN web_site ON wr_web_page_sk = web_site_sk WHERE inv_date_sk = 2450815 AND i_rec_start_date >= '1997-08-16' AND (i_rec_end_date IS NULL OR i_rec_end_date > CURRENT_DATE) AND web_rec_start_date BETWEEN '1999-08-17' AND '2001-08-16' AND cd_dep_employed_count = 0 AND wr_returning_customer_sk IN (77230, 88571, 67431) GROUP BY i_category, i_class, cd_gender, web_name ORDER BY total_return_amount DESC, avg_price DESC, total_inventory DESC;
SELECT i.inv_date_sk, COUNT(DISTINCT cr.cr_order_number) AS total_returns, SUM(cr.cr_return_quantity) AS total_returned_quantity, AVG(cr.cr_return_amount) AS average_return_amount, SUM(cr.cr_net_loss) AS total_net_loss, COUNT(DISTINCT p.p_promo_sk) AS total_promotions, SUM(p.p_cost) AS total_promotion_cost, AVG(i.inv_quantity_on_hand) AS average_inventory_quantity FROM inventory i LEFT JOIN catalog_returns cr ON i.inv_item_sk = cr.cr_item_sk LEFT JOIN promotion p ON i.inv_item_sk = p.p_item_sk WHERE i.inv_date_sk BETWEEN 2450705 AND 2450709 AND i.inv_item_sk IN (7891, 13309, 15649, 8698, 9958) AND ( p.p_channel_catalog = 'N' OR p.p_channel_catalog IS NULL ) AND ( cr.cr_returning_cdemo_sk IN (909578, 1587504, 1439824, 941784, 229946) OR cr.cr_returning_cdemo_sk IS NULL ) GROUP BY i.inv_date_sk ORDER BY i.inv_date_sk;
SELECT i_category, i_class, COUNT(DISTINCT i_item_sk) AS item_count, AVG(i_current_price) AS avg_current_price, SUM(sr_return_quantity) AS total_return_quantity, SUM(sr_return_amt) AS total_return_amount, AVG(sr_return_amt) AS avg_return_amount, w_state, ca_state, sm_type, COUNT(DISTINCT sr_ticket_number) AS total_returns FROM store_returns JOIN item ON sr_item_sk = i_item_sk JOIN warehouse ON sr_store_sk = w_warehouse_sk JOIN customer_address ON sr_addr_sk = ca_address_sk JOIN ship_mode ON sr_return_time_sk::text LIKE sm_ship_mode_id WHERE sr_returned_date_sk IS NOT NULL AND i_rec_start_date <= CURRENT_DATE AND (i_rec_end_date IS NULL OR i_rec_end_date > CURRENT_DATE) AND w_gmt_offset = '-5.00' AND w_zip = '35709' AND i_manufact IN ('oughtoughtese', 'eingbarought', 'eseation') AND sr_return_time_sk IN (37755, 53252) GROUP BY i_category, i_class, w_state, ca_state, sm_type ORDER BY total_return_amount DESC, total_return_quantity DESC;
SELECT i.i_category, i.i_class, i.i_brand, COUNT(DISTINCT cs.cs_order_number) AS total_orders, SUM(cs.cs_quantity) AS total_quantity_sold, AVG(cs.cs_sales_price) AS avg_sales_price, SUM(cs.cs_net_paid) AS total_net_paid, SUM(wr.wr_return_quantity) AS total_quantity_returned, SUM(wr.wr_return_amt) AS total_return_amt, AVG(wr.wr_fee) AS avg_return_fee, COUNT(DISTINCT c.c_customer_sk) AS total_customers, SUM(CASE WHEN c.c_preferred_cust_flag = 'Y' THEN cs.cs_net_paid ELSE 0 END) AS preferred_customer_sales, COUNT(DISTINCT CASE WHEN c.c_preferred_cust_flag = 'Y' THEN c.c_customer_sk ELSE NULL END) AS preferred_customer_count FROM item i JOIN catalog_sales cs ON i.i_item_sk = cs.cs_item_sk LEFT JOIN web_returns wr ON cs.cs_item_sk = wr.wr_item_sk AND cs.cs_order_number = wr.wr_order_number JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk GROUP BY i.i_category, i.i_class, i.i_brand ORDER BY total_net_paid DESC, total_return_amt DESC, avg_sales_price DESC LIMIT 100;
SELECT web.web_name AS website_name, item.i_category AS product_category, COUNT(DISTINCT sr.sr_ticket_number) AS total_returns, SUM(sr.sr_return_quantity) AS total_returned_quantity, AVG(sr.sr_return_amt) AS average_return_amount, SUM(sr.sr_return_amt) AS total_return_amount, SUM(sr.sr_fee) AS total_fees, SUM(sr.sr_net_loss) AS total_net_loss, td.t_shift AS return_shift FROM store_returns sr JOIN item ON sr.sr_item_sk = item.i_item_sk JOIN web_site web ON sr.sr_reason_sk = web.web_site_sk JOIN time_dim td ON sr.sr_return_time_sk = td.t_time_sk WHERE web.web_site_sk IN ('15', '11', '4', '20') AND item.i_current_price IN ('7.20', '1.29', '90.17', '5.18') AND td.t_shift = 'third' AND sr.sr_hdemo_sk = 3371 AND sr.sr_reversed_charge IN ('481.87', '4.35') GROUP BY web.web_name, item.i_category, td.t_shift ORDER BY total_return_amount DESC;
SELECT cp_department, COUNT(DISTINCT cs_order_number) AS total_orders, SUM(cs_quantity) AS total_quantity_sold, AVG(cs_sales_price) AS average_sales_price, SUM(cs_net_paid) AS total_net_paid, SUM(cs_net_profit) AS total_net_profit, COUNT(DISTINCT ss_ticket_number) AS total_store_sales_tickets, SUM(ss_quantity) AS total_store_quantity_sold, AVG(ss_sales_price) AS average_store_sales_price, SUM(ss_net_paid_inc_tax) AS total_store_net_paid_inc_tax FROM catalog_sales JOIN catalog_page ON cs_catalog_page_sk = cp_catalog_page_sk JOIN store_sales ON catalog_sales.cs_item_sk = store_sales.ss_item_sk JOIN store ON store_sales.ss_store_sk = s_store_sk JOIN customer ON store_sales.ss_customer_sk = c_customer_sk WHERE c_birth_country IN ('MOLDOVA, REPUBLIC OF', 'TOGO', 'IRAQ', 'BURUNDI') AND cp_department IS NOT NULL AND cp_start_date_sk IS NOT NULL AND cp_end_date_sk IS NOT NULL AND (cp_end_date_sk - cp_start_date_sk) > 0 AND s_market_id IS NOT NULL GROUP BY cp_department ORDER BY total_net_profit DESC, total_orders DESC LIMIT 10;
SELECT cc.cc_call_center_id, cc.cc_name, cc.cc_class, ca.ca_street_type, COUNT(distinct ss.ss_ticket_number) AS total_sales_transactions, SUM(ss.ss_quantity) AS total_quantity_sold, SUM(ss.ss_net_paid) AS total_net_paid, AVG(ss.ss_sales_price) AS avg_sales_price, SUM(ss.ss_net_profit) AS total_net_profit, COUNT(distinct ss.ss_customer_sk) AS unique_customers_served FROM store_sales ss JOIN customer_address ca ON ss.ss_addr_sk = ca.ca_address_sk JOIN call_center cc ON cc.cc_class IN ('small', 'medium', 'large') LEFT JOIN reason r ON r.r_reason_desc = 'reason 31' WHERE ca.ca_street_type IN ('Pkwy', 'Court') AND r.r_reason_sk IS NULL GROUP BY cc.cc_call_center_id, cc.cc_name, cc.cc_class, ca.ca_street_type ORDER BY total_net_profit DESC, total_sales_transactions DESC;
SELECT ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound, td.t_am_pm, AVG(ws.ws_sales_price) AS avg_sales_price, SUM(ws.ws_quantity) AS total_sales_quantity, SUM(wr.wr_return_quantity) AS total_return_quantity, SUM(wr.wr_net_loss) AS total_net_loss FROM web_sales ws JOIN household_demographics hd ON ws.ws_bill_hdemo_sk = hd.hd_demo_sk JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk JOIN time_dim td ON ws.ws_sold_time_sk = td.t_time_sk LEFT JOIN web_returns wr ON ws.ws_order_number = wr.wr_order_number AND td.t_time_sk = wr.wr_returned_time_sk WHERE td.t_am_pm = 'AM' GROUP BY ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound, td.t_am_pm ORDER BY ib.ib_income_band_sk, td.t_am_pm;
SELECT hd.hd_income_band_sk, SUM(sr.sr_return_quantity) AS total_returned_quantity, AVG(sr.sr_return_amt) AS average_return_amount, COUNT(DISTINCT sr.sr_customer_sk) AS unique_customers_returned, SUM(CASE WHEN p.p_channel_email = 'Y' THEN sr.sr_return_quantity ELSE 0 END) AS email_promo_returned_quantity, SUM(sr.sr_net_loss) AS total_net_loss FROM store_returns sr JOIN household_demographics hd ON sr.sr_hdemo_sk = hd.hd_demo_sk JOIN promotion p ON sr.sr_item_sk = p.p_item_sk JOIN inventory i ON sr.sr_item_sk = i.inv_item_sk AND i.inv_warehouse_sk = 1 WHERE hd.hd_demo_sk IN (1588, 4700) AND sr.sr_refunded_cash IN (10.38, 1818.70) GROUP BY hd.hd_income_band_sk ORDER BY total_net_loss DESC;
SELECT ca.ca_state, COUNT(DISTINCT c.c_customer_sk) AS total_customers, AVG(s.s_floor_space) AS average_store_floor_space, SUM(s.s_number_employees) AS total_employees, COUNT(DISTINCT w.web_site_sk) AS total_websites, AVG(w.web_tax_percentage) AS average_web_tax_percentage FROM customer_address ca JOIN customer c ON ca.ca_address_sk = c.c_current_addr_sk JOIN store s ON ca.ca_state = s.s_state JOIN web_site w ON w.web_state = ca.ca_state WHERE c.c_preferred_cust_flag = 'Y' AND c.c_birth_year BETWEEN 1933 AND 1975 AND s.s_company_id = 1 AND w.web_open_date_sk IN ('2450730', '2450747') GROUP BY ca.ca_state ORDER BY total_customers DESC;
SELECT dd.d_year, dd.d_quarter_name, SUM(cs.cs_net_paid_inc_tax) AS total_revenue, AVG(cs.cs_net_paid_inc_tax) AS avg_revenue_per_sale, COUNT(cs.cs_order_number) AS total_orders, AVG(cd.cd_purchase_estimate) AS avg_customer_purchase_estimate, COUNT(DISTINCT c.c_customer_sk) AS total_customers, AVG(i.inv_quantity_on_hand) AS avg_inventory_quantity, COUNT(DISTINCT w.web_site_sk) AS total_web_sites FROM date_dim dd JOIN catalog_sales cs ON dd.d_date_sk = cs.cs_sold_date_sk JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk JOIN inventory i ON cs.cs_sold_date_sk = i.inv_date_sk JOIN web_site w ON w.web_zip = '35709' OR w.web_zip = '31904' WHERE dd.d_year = 2000 AND cd.cd_gender = 'M' AND cd.cd_dep_college_count = 0 AND cs.cs_item_sk IN ('34', '4', '13', '54') AND i.inv_date_sk = 2450815 GROUP BY dd.d_year, dd.d_quarter_name ORDER BY total_revenue DESC, avg_revenue_per_sale DESC;
SELECT cc.cc_division_name, COUNT(DISTINCT cc.cc_call_center_sk) AS num_call_centers, AVG(cc.cc_employees) AS avg_employees, SUM(inv.inv_quantity_on_hand) AS total_inventory, SUM(wr.wr_return_amt_inc_tax) AS total_returns_inc_tax, AVG(wp.wp_link_count) AS avg_link_count_per_page FROM call_center cc JOIN inventory inv ON cc.cc_call_center_sk = inv.inv_warehouse_sk JOIN web_returns wr ON inv.inv_item_sk = wr.wr_item_sk JOIN web_page wp ON wr.wr_web_page_sk = wp.wp_web_page_sk WHERE cc.cc_division IN (1, 3, 5) AND cc.cc_open_date_sk IN (2450952, 2450806, 2451063) AND wr.wr_web_page_sk IN (2, 32, 58, 26, 39) GROUP BY cc.cc_division_name ORDER BY total_returns_inc_tax DESC, avg_link_count_per_page DESC;
SELECT c.c_birth_country, sm.sm_type AS shipping_type, COUNT(DISTINCT ws.ws_order_number) AS total_orders, SUM(ws.ws_quantity) AS total_quantity, AVG(ws.ws_sales_price) AS average_sales_price, SUM(ws.ws_net_paid) AS total_net_paid, SUM(ws.ws_ext_tax) AS total_tax_collected, SUM(ws.ws_coupon_amt) AS total_coupon_amount, SUM(ws.ws_net_profit) AS total_net_profit FROM web_sales ws JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk GROUP BY c.c_birth_country, sm.sm_type ORDER BY c.c_birth_country, sm.sm_type;
SELECT cp.cp_department, COUNT(DISTINCT ss.ss_item_sk) AS num_products_sold, SUM(ss.ss_quantity) AS total_quantity_sold, SUM(ss.ss_net_paid_inc_tax) AS total_sales, AVG(ss.ss_sales_price) AS average_sales_price FROM store_sales ss JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk JOIN store s ON ss.ss_store_sk = s.s_store_sk JOIN catalog_page cp ON ss.ss_item_sk = cp.cp_catalog_page_sk JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk WHERE s.s_floor_space IN (6995995, 9078805) AND s.s_market_desc IN ('Mysterious employe', 'Little expectations include yet forward meetings.', 'Events develop i', 'Architects coul') AND p.p_discount_active = '1' AND cd.cd_dep_count IN (1, 2) AND cd.cd_marital_status IN ('D', 'U', 'S', 'M', 'W') AND ss.ss_ext_discount_amt IN (24.03, 205.34) GROUP BY cp.cp_department ORDER BY total_sales DESC;
SELECT ib.ib_income_band_sk, COUNT(DISTINCT wp.wp_web_page_sk) AS total_web_pages, AVG(wp.wp_char_count) AS avg_char_count, SUM(wp.wp_link_count) AS total_link_count, AVG(wp.wp_image_count) AS avg_image_count, SUM(wr.wr_return_quantity) AS total_return_quantity, SUM(wr.wr_return_amt) AS total_return_amount, AVG(wr.wr_fee) AS avg_return_fee, SUM(wr.wr_net_loss) AS total_net_loss FROM income_band ib LEFT JOIN web_page wp ON wp.wp_customer_sk = ib.ib_income_band_sk LEFT JOIN web_returns wr ON wr.wr_web_page_sk = wp.wp_web_page_sk WHERE wp.wp_rec_start_date BETWEEN '1997-09-03' AND '2001-09-03' AND wp.wp_char_count > 4000 AND wr.wr_return_ship_cost BETWEEN 45.88 AND 361.10 GROUP BY ib.ib_income_band_sk ORDER BY ib.ib_income_band_sk;
SELECT i.i_category, i.i_brand, COUNT(DISTINCT cr.cr_order_number) AS total_returns, SUM(cr.cr_return_quantity) AS total_returned_quantity, AVG(cr.cr_return_amount) AS avg_return_amount, SUM(cr.cr_return_amount) AS total_return_amount, SUM(cr.cr_return_amt_inc_tax) AS total_return_amount_inc_tax, SUM(cr.cr_fee) AS total_fees, SUM(cr.cr_net_loss) AS total_net_loss FROM catalog_returns cr JOIN item i ON cr.cr_item_sk = i.i_item_sk JOIN web_page wp ON cr.cr_catalog_page_sk = wp.wp_web_page_sk WHERE i.i_brand_id IN ('10003002', '8008007', '7015003', '9001006', '10011007', '10010015') AND wp.wp_url = 'http://www.foo.com' AND wp.wp_customer_sk IN ('98633', '80555') AND cr.cr_ship_mode_sk IN ('10', '18', '12', '2', '6', '8') GROUP BY i.i_category, i.i_brand ORDER BY total_returns DESC, total_returned_quantity DESC;
SELECT c.c_customer_id, p.p_promo_name, SUM(cs.cs_net_profit) AS total_catalog_net_profit, AVG(cs.cs_sales_price) AS avg_catalog_sales_price, COUNT(DISTINCT cs.cs_order_number) AS num_of_catalog_orders, SUM(ws.ws_net_profit) AS total_web_net_profit, AVG(ws.ws_sales_price) AS avg_web_sales_price, COUNT(DISTINCT ws.ws_order_number) AS num_of_web_orders FROM customer c INNER JOIN catalog_sales cs ON c.c_customer_sk = cs.cs_bill_customer_sk INNER JOIN web_sales ws ON c.c_customer_sk = ws.ws_bill_customer_sk INNER JOIN promotion p ON (cs.cs_promo_sk = p.p_promo_sk AND ws.ws_promo_sk = p.p_promo_sk) WHERE c.c_preferred_cust_flag = 'Y' AND (cs.cs_sold_date_sk = 2450827 OR cs.cs_sold_date_sk = 2450822) AND (p.p_channel_demo = 'N') AND (ws.ws_web_page_sk IN (SELECT wp_web_page_sk FROM web_page WHERE wp_customer_sk IN (1898, 16769))) GROUP BY c.c_customer_id, p.p_promo_name ORDER BY total_catalog_net_profit DESC, total_web_net_profit DESC;
SELECT cp.cp_department, COUNT(ss.ss_ticket_number) AS total_sales_transactions, SUM(ss.ss_sales_price) AS total_sales_amount, AVG(ss.ss_ext_discount_amt) AS average_discount_amount, SUM(ss.ss_quantity) AS total_items_sold, SUM(ss.ss_coupon_amt) AS total_coupon_amount_used FROM catalog_page cp JOIN store_sales ss ON cp.cp_catalog_page_sk = ss.ss_sold_date_sk WHERE cp.cp_catalog_number BETWEEN 25 AND 41 AND ss.ss_sold_date_sk BETWEEN 20020101 AND 20021231 AND ss.ss_ext_list_price IN (2602.80, 627.44, 6715.50, 6951.00, 6762.70, 4044.30) AND ss.ss_coupon_amt IN (393.68, 57.05) GROUP BY cp.cp_department ORDER BY total_sales_amount DESC;
SELECT c.c_customer_id, ca.ca_state, i.i_category, i.i_brand, SUM(i.i_current_price) AS total_revenue, AVG(i.i_wholesale_cost) AS average_wholesale_cost, COUNT(DISTINCT w.w_warehouse_sk) AS number_of_warehouses, COUNT(DISTINCT wp.wp_web_page_sk) AS number_of_web_pages FROM customer AS c JOIN customer_address AS ca ON c.c_current_addr_sk = ca.ca_address_sk JOIN item AS i ON i.i_manufact_id = c.c_customer_sk LEFT JOIN warehouse AS w ON w.w_state = ca.ca_state LEFT JOIN web_page AS wp ON wp.wp_customer_sk = c.c_customer_sk WHERE i.i_brand = 'amalgunivamalg #14' AND i.i_product_name IN ('eingprioughtable', 'eingationese', 'n stoughtation', 'antiationese', 'n stableeseese', 'anticallycally') AND ca.ca_country = 'United States' AND w.w_country = ca.ca_country GROUP BY c.c_customer_id, ca.ca_state, i.i_category, i.i_brand ORDER BY total_revenue DESC;
SELECT s_state, EXTRACT(YEAR FROM s_rec_start_date) AS year_opened, COUNT(*) AS store_count, SUM(ss_net_profit) AS total_net_profit, AVG(hd_dep_count) AS avg_dependency_count, SUM(sr_return_amt) AS total_return_amount, AVG(sr_return_amt) AS avg_return_amount, SUM(sr_net_loss) AS total_net_loss FROM store JOIN store_sales ON s_store_sk = ss_store_sk JOIN household_demographics ON ss_hdemo_sk = hd_demo_sk JOIN store_returns ON s_store_sk = sr_store_sk WHERE s_state IN ('CA', 'TX', 'FL') AND s_closed_date_sk IS NULL AND ss_sold_date_sk BETWEEN 2451189 AND 2451489 AND sr_return_tax > 0 AND hd_buy_potential IN ('>10000', '5001-10000', '1001-5000') GROUP BY s_state, year_opened ORDER BY total_net_profit DESC, total_return_amount DESC;
SELECT cc.cc_call_center_id, cc.cc_name, cc.cc_city, cc.cc_state, SUM(ss.ss_net_paid) AS total_sales, AVG(ss.ss_ext_discount_amt) AS avg_discount_amount, COUNT(DISTINCT ss.ss_ticket_number) AS total_tickets, COUNT(DISTINCT p.p_promo_sk) AS total_promotions FROM call_center cc JOIN store_sales ss ON cc.cc_call_center_sk = ss.ss_store_sk JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk WHERE p.p_channel_dmail = 'Y' AND ss.ss_sold_date_sk BETWEEN p.p_start_date_sk AND p.p_end_date_sk GROUP BY cc.cc_call_center_id, cc.cc_name, cc.cc_city, cc.cc_state ORDER BY total_sales DESC, avg_discount_amount DESC;
SELECT i.i_category, i.i_brand, COUNT(DISTINCT ss.ss_ticket_number) AS total_sales_transactions, SUM(ss.ss_quantity) AS total_quantity_sold, AVG(ss.ss_sales_price) AS average_sales_price, AVG(ss.ss_ext_discount_amt) AS average_discount_amount, SUM(ss.ss_net_paid) AS total_net_sales, SUM(ss.ss_net_paid_inc_tax) AS total_net_sales_including_tax, SUM(ss.ss_net_profit) AS total_net_profit, COUNT(DISTINCT p.p_promo_sk) AS number_of_promotions FROM store_sales ss JOIN item i ON ss.ss_item_sk = i.i_item_sk JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk WHERE p.p_discount_active = 'Y' AND p.p_start_date_sk IS NOT NULL AND p.p_end_date_sk IS NOT NULL GROUP BY i.i_category, i.i_brand ORDER BY total_net_sales DESC, i.i_category, i.i_brand;
SELECT w.web_class AS website_category, ca.ca_state AS customer_state, COUNT(ws.ws_order_number) AS total_orders, SUM(ws.ws_net_paid_inc_ship_tax) AS total_sales, AVG(ws.ws_ext_discount_amt) AS avg_discount_amount, AVG(ws.ws_net_profit) AS avg_net_profit FROM web_sales ws JOIN web_site w ON ws.ws_web_site_sk = w.web_site_sk JOIN customer_address ca ON ws.ws_ship_addr_sk = ca.ca_address_sk WHERE ws.ws_net_paid_inc_ship BETWEEN 500 AND 9500 GROUP BY ROLLUP(website_category, customer_state) ORDER BY total_sales DESC, website_category, customer_state;
SELECT s.s_store_name, s.s_city, s.s_state, SUM(ss.ss_quantity) AS total_quantity_sold, AVG(ss.ss_sales_price) AS average_sales_price, COUNT(DISTINCT ss.ss_ticket_number) AS number_of_sales_transactions, SUM(ss.ss_net_profit) AS total_net_profit FROM store_sales ss JOIN store s ON ss.ss_store_sk = s.s_store_sk JOIN warehouse w ON s.s_zip = w.w_zip JOIN ship_mode sm ON w.w_country = sm.sm_carrier WHERE ss.ss_sold_date_sk BETWEEN 2451189 AND 2451200 AND ss.ss_quantity > 50 GROUP BY s.s_store_name, s.s_city, s.s_state ORDER BY total_net_profit DESC, total_quantity_sold DESC LIMIT 10;
SELECT cp.cp_department, i.i_category, COUNT(cr.cr_order_number) AS total_returns, SUM(cr.cr_return_amount) AS total_return_amount, AVG(cr.cr_return_amount) AS avg_return_amount, SUM(cr.cr_return_quantity) AS total_return_quantity, r.r_reason_desc, COUNT(DISTINCT cr.cr_refunded_customer_sk) AS unique_customers_refunded, COUNT(DISTINCT cr.cr_returning_customer_sk) AS unique_customers_returning, SUM(cr.cr_net_loss) AS total_net_loss FROM catalog_returns cr JOIN catalog_page cp ON cr.cr_catalog_page_sk = cp.cp_catalog_page_sk JOIN item i ON cr.cr_item_sk = i.i_item_sk JOIN reason r ON cr.cr_reason_sk = r.r_reason_sk WHERE cp.cp_end_date_sk IN ('2451087', '2451239', '2450904', '2450844') GROUP BY cp.cp_department, i.i_category, r.r_reason_desc ORDER BY total_return_amount DESC, total_returns DESC LIMIT 100;
SELECT d_year, SUM(cs_net_paid) AS total_sales, AVG(cs_quantity) AS average_quantity, COUNT(DISTINCT cs_order_number) AS total_orders, hd_dep_count, hd_vehicle_count, p_channel_dmail, p_channel_demo FROM catalog_sales JOIN date_dim ON (catalog_sales.cs_sold_date_sk = date_dim.d_date_sk) JOIN household_demographics ON (catalog_sales.cs_bill_hdemo_sk = household_demographics.hd_demo_sk) JOIN promotion ON (catalog_sales.cs_promo_sk = promotion.p_promo_sk) WHERE d_year = 1999 AND hd_dep_count >= 2 AND hd_vehicle_count >= 1 AND (p_channel_dmail = 'Y' OR p_channel_demo = 'N') GROUP BY d_year, hd_dep_count, hd_vehicle_count, p_channel_dmail, p_channel_demo ORDER BY total_sales DESC;
SELECT cp.cp_department, ca.ca_city, ca.ca_state, cd.cd_education_status, td.t_shift, SUM(cs.cs_quantity) AS total_quantity_sold, AVG(cs.cs_sales_price) AS average_sales_price, COUNT(DISTINCT cs.cs_order_number) AS total_orders, SUM(cs.cs_net_profit) AS total_net_profit FROM catalog_sales cs JOIN catalog_page cp ON cs.cs_catalog_page_sk = cp.cp_catalog_page_sk JOIN customer_address ca ON cs.cs_ship_addr_sk = ca.ca_address_sk JOIN customer_demographics cd ON cs.cs_ship_cdemo_sk = cd.cd_demo_sk JOIN time_dim td ON cs.cs_sold_time_sk = td.t_time_sk WHERE cp.cp_start_date_sk IN (2451145, 2451271, 2451088, 2450845, 2451360) AND cp.cp_type IN ('bi-annual', 'quarterly') AND td.t_hour IN (1, 0) AND cd.cd_dep_college_count = 0 GROUP BY cp.cp_department, ca.ca_city, ca.ca_state, cd.cd_education_status, td.t_shift ORDER BY total_net_profit DESC, total_orders DESC;
SELECT d.d_year AS year, d.d_quarter_name AS quarter, w.w_warehouse_name AS warehouse_name, ib.ib_income_band_sk AS income_band, SUM(inv.inv_quantity_on_hand) AS total_quantity_sold, AVG(inv.inv_quantity_on_hand) AS average_quantity_per_transaction, COUNT(DISTINCT inv.inv_item_sk) AS distinct_item_count, COUNT(*) AS transaction_count FROM inventory inv JOIN date_dim d ON inv.inv_date_sk = d.d_date_sk JOIN warehouse w ON inv.inv_warehouse_sk = w.w_warehouse_sk JOIN income_band ib ON ib.ib_income_band_sk BETWEEN 5 AND 15 WHERE d.d_dom = 25 AND w.w_warehouse_sq_ft IN (977787, 294242, 621234, 138504) AND inv.inv_quantity_on_hand IN (781, 841, 802, 251) AND ib.ib_lower_bound >= 90001 GROUP BY year, quarter, warehouse_name, income_band ORDER BY year, quarter, warehouse_name, income_band;
