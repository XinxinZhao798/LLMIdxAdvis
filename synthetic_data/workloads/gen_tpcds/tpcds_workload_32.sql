SELECT hd.hd_dep_count AS number_of_dependents, hd.hd_vehicle_count AS number_of_vehicles, ca.ca_location_type AS customer_location_type, ca.ca_street_type AS street_type, t.t_am_pm AS return_time_period, COUNT(DISTINCT cr.cr_order_number) AS total_returned_orders, SUM(cr.cr_return_quantity) AS total_returned_quantity, AVG(cr.cr_return_amount) AS average_return_amount, SUM(cr.cr_net_loss) AS total_net_loss FROM catalog_returns cr JOIN household_demographics hd ON cr.cr_returning_hdemo_sk = hd.hd_demo_sk JOIN customer_address ca ON cr.cr_returning_addr_sk = ca.ca_address_sk JOIN time_dim t ON cr.cr_returned_time_sk = t.t_time_sk WHERE ca.ca_location_type IN ('single family', 'apartment', 'condo') AND ca.ca_street_type IN ('Boulevard', 'Ct.', 'Avenue', 'Way', 'Parkway', 'ST') AND t.t_am_pm = 'AM' GROUP BY hd.hd_dep_count, hd.hd_vehicle_count, ca.ca_location_type, ca.ca_street_type, t.t_am_pm ORDER BY total_net_loss DESC, average_return_amount DESC;
SELECT i.i_category, i.i_brand, t.t_shift, COUNT(DISTINCT ss.ss_ticket_number) AS total_sales_transactions, SUM(ss.ss_quantity) AS total_quantities_sold, AVG(ss.ss_sales_price) AS average_selling_price, SUM(ss.ss_net_paid) AS total_net_paid, SUM(ss.ss_net_paid_inc_tax) - SUM(ss.ss_net_paid) AS total_tax_collected, SUM(ss.ss_net_profit) AS total_net_profit FROM store_sales ss JOIN item i ON ss.ss_item_sk = i.i_item_sk JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk WHERE ss.ss_sold_date_sk IN (2451375, 2451147, 2451762, 2451572, 2452439, 2452222) AND ss.ss_sales_price BETWEEN 4.90 AND 95.65 GROUP BY i.i_category, i.i_brand, t.t_shift ORDER BY total_net_profit DESC, i.i_category, i.i_brand, t.t_shift;
SELECT p.p_promo_id, p.p_promo_name, COUNT(ws.ws_order_number) AS total_orders, SUM(ws.ws_quantity) AS total_quantity_sold, AVG(ws.ws_sales_price) AS average_sales_price, SUM(ws.ws_net_profit) AS total_net_profit FROM web_sales ws INNER JOIN promotion p ON ws.ws_promo_sk = p.p_promo_sk INNER JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk INNER JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk INNER JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk WHERE p.p_channel_press = 'N' AND hd.hd_vehicle_count IN (1, 2) AND ib.ib_income_band_sk IN (20, 8) AND p.p_purpose <> 'Unknown' GROUP BY p.p_promo_id, p.p_promo_name ORDER BY total_net_profit DESC, total_quantity_sold DESC;
SELECT site.web_name AS website_name, COUNT(DISTINCT ss.ss_ticket_number) AS store_sales_transactions, COUNT(DISTINCT ws.ws_order_number) AS web_sales_transactions, SUM(ss.ss_net_paid_inc_tax) AS total_store_sales, SUM(ws.ws_net_paid_inc_ship_tax) AS total_web_sales, AVG(ss.ss_quantity) AS avg_store_quantity_sold, AVG(ws.ws_quantity) AS avg_web_quantity_sold, cp.cp_department AS department, SUM(CASE WHEN ss.ss_hdemo_sk IN (1437, 496, 6460, 2527, 4508, 4026) THEN ss.ss_net_profit ELSE 0 END) AS store_profit_from_selected_hdemo, SUM(CASE WHEN ws.ws_web_site_sk IN (SELECT web_site_sk FROM web_site WHERE web_company_id IN (3, 5, 2)) THEN ws.ws_net_profit ELSE 0 END) AS web_profit_from_selected_companies FROM store_sales ss FULL OUTER JOIN web_sales ws ON ss.ss_item_sk = ws.ws_item_sk AND ss.ss_sold_date_sk = ws.ws_sold_date_sk LEFT JOIN catalog_page cp ON ws.ws_web_page_sk = cp.cp_catalog_page_sk LEFT JOIN web_site site ON ws.ws_web_site_sk = site.web_site_sk WHERE (cp.cp_catalog_page_sk IN (10, 2795, 1844, 4860) OR cp.cp_catalog_page_sk IS NULL) GROUP BY site.web_name, cp.cp_department ORDER BY total_store_sales DESC, total_web_sales DESC;
SELECT d.d_year, d.d_quarter_name, sum(ws_net_paid) AS total_sales, avg(ws_quantity) AS average_quantity_sold, count(distinct ws_order_number) AS total_orders, count(distinct ws_item_sk) AS unique_items_sold, sum(ws_net_profit) AS total_profit FROM web_sales ws INNER JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk INNER JOIN item i ON ws.ws_item_sk = i.i_item_sk INNER JOIN call_center cc ON cc.cc_division_name LIKE 'pri%' AND cc.cc_country = 'United States' WHERE d.d_year = 2000 AND i.i_rec_start_date BETWEEN '1999-10-28' AND '2001-10-27' AND i.i_manufact = 'ationationable' AND ws.ws_bill_cdemo_sk IN ('371058', '1268921') GROUP BY d.d_year, d.d_quarter_name ORDER BY total_sales DESC, d.d_quarter_name;
SELECT cu.c_salutation, wh.w_state, COUNT(DISTINCT cs.cs_order_number) AS total_sales_transactions, SUM(cs.cs_net_paid_inc_tax) AS total_sales_amount, AVG(cs.cs_ext_discount_amt) AS average_discount, COUNT(DISTINCT sr.sr_ticket_number) AS total_return_transactions, SUM(sr.sr_return_amt_inc_tax) AS total_return_amount FROM customer cu LEFT JOIN catalog_sales cs ON cu.c_customer_sk = cs.cs_ship_customer_sk LEFT JOIN store_returns sr ON cu.c_customer_sk = sr.sr_customer_sk LEFT JOIN warehouse wh ON (cs.cs_warehouse_sk = wh.w_warehouse_sk OR sr.sr_store_sk = wh.w_warehouse_sk) LEFT JOIN promotion p ON cs.cs_promo_sk = p.p_promo_sk WHERE (cs.cs_sold_date_sk IN ('2450819', '2450822', '2450817') OR sr.sr_returned_date_sk IN ('2450819', '2450822', '2450817')) AND (cu.c_salutation IN ('Dr.', 'Mr.', 'Sir', 'Ms.', 'Mrs.', 'Miss')) AND (wh.w_city = 'Fairview') AND (wh.w_suite_number IN ('Suite 80', 'Suite 0', 'Suite P', 'Suite 470')) AND (cu.c_last_review_date_sk IN ('2452425', '2452326', '2452389')) AND (sr.sr_reversed_charge IN ('44.04', '12.34') OR sr.sr_reversed_charge IS NULL) GROUP BY cu.c_salutation, wh.w_state ORDER BY total_sales_amount DESC, total_return_amount ASC;
SELECT cc.cc_name, COUNT(ws.ws_order_number) AS total_online_orders, SUM(ws.ws_quantity) AS total_items_sold, SUM(ws.ws_net_paid) AS total_revenue, SUM(ws.ws_net_profit) AS total_profit, AVG(ws.ws_quantity) AS avg_items_per_order, SUM(sr.sr_return_quantity) AS total_items_returned, SUM(sr.sr_return_amt) AS total_return_amount, AVG(sr.sr_return_quantity) AS avg_items_returned_per_order, SUM(wr.wr_return_quantity) AS web_total_items_returned, SUM(wr.wr_return_amt) AS web_total_return_amount, AVG(wr.wr_return_quantity) AS web_avg_items_returned_per_order, COUNT(DISTINCT sm.sm_ship_mode_sk) AS distinct_shipping_modes_used, SUM(promo.p_cost) AS total_promotional_cost FROM call_center cc LEFT JOIN web_sales ws ON cc.cc_call_center_sk = ws.ws_web_page_sk LEFT JOIN store_returns sr ON ws.ws_order_number = sr.sr_ticket_number LEFT JOIN web_returns wr ON ws.ws_order_number = wr.wr_order_number LEFT JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk LEFT JOIN promotion promo ON ws.ws_promo_sk = promo.p_promo_sk WHERE cc.cc_rec_end_date IS NULL OR cc.cc_rec_end_date > CURRENT_DATE GROUP BY cc.cc_name ORDER BY total_revenue DESC;
SELECT cc.cc_name AS "Call Center Name", cc.cc_city AS "City", cc.cc_state AS "State", COUNT(cr.cr_order_number) AS "Total Returns Processed", AVG(cr.cr_return_amount) AS "Average Return Amount", SUM(cr.cr_net_loss) AS "Total Net Loss", w.w_warehouse_name AS "Warehouse Name", w.w_warehouse_sq_ft AS "Warehouse Square Feet", wn.AvgNetLossPerWarehouseSqFt AS "Avg. Net Loss per Warehouse Sq Ft" FROM catalog_returns cr JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk JOIN (SELECT cr_warehouse_sk, AVG(cr_net_loss) AS AvgNetLossPerWarehouseSqFt FROM catalog_returns GROUP BY cr_warehouse_sk) wn ON wn.cr_warehouse_sk = w.w_warehouse_sk WHERE cc.cc_state = 'TN' AND w.w_country = 'United States' GROUP BY cc.cc_call_center_sk, cc.cc_name, cc.cc_city, cc.cc_state, w.w_warehouse_name, w.w_warehouse_sq_ft, wn.AvgNetLossPerWarehouseSqFt ORDER BY "Total Net Loss" DESC, "Average Return Amount" DESC;
SELECT d_year, d_quarter_name, sm_type, ca_state, COUNT(DISTINCT cs_order_number) AS total_orders, SUM(cs_quantity) AS total_quantity_sold, SUM(cs_net_paid) AS total_net_paid, AVG(cs_net_paid_inc_tax) AS avg_net_paid_inc_tax, SUM(cs_net_profit) AS total_net_profit FROM catalog_sales JOIN date_dim ON (cs_sold_date_sk = d_date_sk) JOIN ship_mode ON (cs_ship_mode_sk = sm_ship_mode_sk) JOIN customer_address ON (cs_ship_addr_sk = ca_address_sk) JOIN promotion ON (cs_promo_sk = p_promo_sk) JOIN catalog_page ON (cs_catalog_page_sk = cp_catalog_page_sk) WHERE ca_state IN ('CA', 'TN') AND sm_type IN ('NEXT DAY', 'TWO DAY', 'LIBRARY') AND d_year = 2023 AND p_channel_event = 'N' AND cp_department = 'DEPARTMENT' GROUP BY d_year, d_quarter_name, sm_type, ca_state ORDER BY d_year, d_quarter_name, sm_type, ca_state;
SELECT s.s_store_name, s.s_city, s.s_state, SUM(i.inv_quantity_on_hand) AS total_quantity_on_hand, AVG(i.inv_quantity_on_hand) AS avg_quantity_on_hand, COUNT(DISTINCT i.inv_item_sk) AS unique_items_count, COUNT(DISTINCT i.inv_warehouse_sk) AS warehouse_count, SUM(wp.wp_link_count) AS total_webpage_links, AVG(wp.wp_image_count) AS avg_webpage_images FROM inventory i JOIN store s ON i.inv_warehouse_sk = s.s_store_sk JOIN web_page wp ON s.s_market_id = wp.wp_customer_sk WHERE i.inv_date_sk = 2450815 AND i.inv_quantity_on_hand IN (499, 291, 296, 643, 586) AND s.s_state IN ('IL', 'KY', 'OR', 'VA', 'FL', 'AL', 'OK', 'IA', 'TX') AND wp.wp_type = 'product' GROUP BY s.s_store_name, s.s_city, s.s_state ORDER BY total_quantity_on_hand DESC, avg_quantity_on_hand DESC;
SELECT ib.ib_lower_bound, ib.ib_upper_bound, sm.sm_type, COUNT(DISTINCT cp.cp_catalog_page_sk) AS total_catalog_pages, MIN(cp.cp_catalog_number) AS min_catalog_number, MAX(cp.cp_catalog_number) AS max_catalog_number, COUNT(DISTINCT sm.sm_ship_mode_sk) AS total_ship_modes FROM income_band ib CROSS JOIN ship_mode sm LEFT JOIN catalog_page cp ON cp.cp_department = 'Books' WHERE sm.sm_type IN ('LIBRARY', 'REGULAR') GROUP BY ib.ib_lower_bound, ib.ib_upper_bound, sm.sm_type ORDER BY ib.ib_lower_bound, sm.sm_type;
SELECT p.p_purpose, COUNT(DISTINCT p.p_promo_sk) AS num_promotions, AVG(p.p_cost) AS avg_promo_cost, SUM(CASE WHEN p.p_channel_dmail = 'Y' THEN 1 ELSE 0 END) AS dmail_channel_count, SUM(CASE WHEN p.p_channel_email = 'Y' THEN 1 ELSE 0 END) AS email_channel_count, COUNT(DISTINCT CASE WHEN cd.cd_purchase_estimate > 10000 THEN cd.cd_demo_sk END) AS high_value_customers, COUNT(DISTINCT CASE WHEN cd.cd_gender = 'M' THEN cd.cd_demo_sk END) AS male_customers, COUNT(DISTINCT CASE WHEN cd.cd_gender = 'F' THEN cd.cd_demo_sk END) AS female_customers, COUNT(DISTINCT CASE WHEN cd.cd_marital_status = 'S' THEN cd.cd_demo_sk END) AS single_customers, COUNT(DISTINCT CASE WHEN cd.cd_marital_status = 'M' THEN cd.cd_demo_sk END) AS married_customers FROM promotion p LEFT JOIN customer_demographics cd ON p.p_promo_sk = cd.cd_demo_sk WHERE p.p_discount_active = 'Y' GROUP BY p.p_purpose ORDER BY avg_promo_cost DESC, num_promotions DESC;
SELECT cc.cc_name, SUM(cs.cs_quantity) AS total_quantity_sold, AVG(cs.cs_sales_price) AS average_sales_price, COUNT(DISTINCT c.c_customer_sk) AS unique_customers, AVG(cs.cs_net_profit) AS average_net_profit FROM call_center cc JOIN catalog_sales cs ON cc.cc_call_center_sk = cs.cs_call_center_sk JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk JOIN store s ON cc.cc_division = s.s_division_id JOIN web_page wp ON c.c_customer_sk = wp.wp_customer_sk WHERE s.s_rec_end_date IN ('2001-03-12', '2000-03-12', '1999-03-13') AND s.s_floor_space IN (8954883, 9078805, 9341467, 5285950) AND c.c_birth_country = 'LESOTHO' AND c.c_customer_id IN ('AAAAAAAAKJFAAAAA', 'AAAAAAAALPMAAAAA', 'AAAAAAAAHPBBAAAA', 'AAAAAAAAHHFAAAAA', 'AAAAAAAAMCKAAAAA', 'AAAAAAAAKKABAAAA') AND wp.wp_url = 'http://www.foo.com' GROUP BY cc.cc_name;
SELECT i_category, i_brand, COUNT(DISTINCT i_item_sk) AS num_items, AVG(i_current_price) AS avg_price, SUM(i_wholesale_cost) AS total_wholesale_cost, COUNT(DISTINCT c_customer_sk) AS num_customers, AVG(hd_dep_count) AS avg_hh_dep_count, AVG(hd_vehicle_count) AS avg_hh_vehicle_count, AVG(income_band.ib_lower_bound + income_band.ib_upper_bound)/2 AS avg_income_band_mid_point FROM item JOIN customer ON i_manager_id = c_customer_sk JOIN household_demographics ON c_current_hdemo_sk = hd_demo_sk JOIN income_band ON hd_income_band_sk = income_band.ib_income_band_sk WHERE i_rec_start_date <= CURRENT_DATE AND (i_rec_end_date IS NULL OR i_rec_end_date > CURRENT_DATE) AND (i_wholesale_cost IN (64.92, 7.17, 78.12, 2.36)) AND (i_manufact IN ('barpriable', 'callyoughtought', 'oughteseation', 'oughtbaranti', 'oughtn st', 'eseeseeing')) AND (income_band.ib_income_band_sk IN (9, 19)) AND (household_demographics.hd_income_band_sk IN (4, 18)) GROUP BY i_category, i_brand ORDER BY avg_price DESC, total_wholesale_cost DESC;
SELECT ca.ca_state AS customer_state, COUNT(DISTINCT cs.cs_order_number) AS total_orders, SUM(cs.cs_quantity) AS total_quantity_sold, AVG(cs.cs_sales_price) AS average_sale_price, SUM(cr.cr_return_quantity) AS total_quantity_returned, SUM(cr.cr_return_amount) AS total_return_amount, AVG(cr.cr_return_amount) AS average_return_amount, COUNT(DISTINCT p.p_promo_sk) AS total_promotions_used, COUNT(DISTINCT w.w_warehouse_sk) AS total_warehouses_used FROM customer_address ca JOIN customer c ON ca.ca_address_sk = c.c_current_addr_sk JOIN catalog_sales cs ON c.c_customer_sk = cs.cs_bill_customer_sk JOIN catalog_returns cr ON cs.cs_order_number = cr.cr_order_number JOIN promotion p ON cs.cs_promo_sk = p.p_promo_sk JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk WHERE ca.ca_state IS NOT NULL AND p.p_channel_radio = 'N' AND (p.p_promo_name LIKE '%bar%' OR p.p_promo_name LIKE '%anti%') AND w.w_warehouse_id IN ('AAAAAAAABAAAAAAA', 'AAAAAAAADAAAAAAA', 'AAAAAAAAEAAAAAAA', 'AAAAAAAAFAAAAAAA', 'AAAAAAAACAAAAAAA') AND cs.cs_catalog_page_sk IN ( SELECT cp_catalog_page_sk FROM catalog_page WHERE cp_catalog_page_number IN (29, 24, 40) ) GROUP BY ca.ca_state ORDER BY total_return_amount DESC, average_sale_price DESC LIMIT 100;
SELECT s.s_store_name, COUNT(DISTINCT ss.ss_ticket_number) AS total_sales_transactions, SUM(ss.ss_quantity) AS total_items_sold, AVG(ss.ss_sales_price) AS average_sales_price, SUM(ss.ss_ext_discount_amt) AS total_discount_amount, SUM(ss.ss_net_paid) AS total_net_sales, SUM(ss.ss_net_paid_inc_tax) AS net_sales_including_tax, SUM(ss.ss_net_profit) AS total_net_profit, COUNT(DISTINCT wr.wr_order_number) AS total_returns_transactions, SUM(wr.wr_return_quantity) AS total_items_returned, AVG(wr.wr_return_amt) AS average_return_amount, SUM(wr.wr_fee) AS total_return_fees, SUM(wr.wr_net_loss) AS total_net_loss FROM store s JOIN store_sales ss ON s.s_store_sk = ss.ss_store_sk LEFT JOIN web_returns wr ON ss.ss_item_sk = wr.wr_item_sk AND ss.ss_ticket_number = wr.wr_order_number WHERE s.s_county = 'Williamson County' AND ss.ss_coupon_amt IN (215.60, 1007.22, 1869.51) GROUP BY s.s_store_name ORDER BY s.s_store_name;
SELECT cd.cd_gender, cd.cd_marital_status, td.t_shift, COUNT(DISTINCT ss.ss_ticket_number) AS total_sales_transactions, SUM(ss.ss_quantity) AS total_units_sold, SUM(ss.ss_net_paid) AS total_revenue, AVG(ss.ss_net_paid) AS average_revenue_per_transaction, SUM(CASE WHEN p.p_channel_dmail = 'Y' THEN 1 ELSE 0 END) AS total_dmail_promotions, SUM(CASE WHEN p.p_channel_email = 'Y' THEN 1 ELSE 0 END) AS total_email_promotions, SUM(CASE WHEN p.p_channel_tv = 'Y' THEN 1 ELSE 0 END) AS total_tv_promotions FROM store_sales ss JOIN customer_demographics cd ON ss.ss_cdemo_sk = cd.cd_demo_sk JOIN time_dim td ON ss.ss_sold_time_sk = td.t_time_sk LEFT JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk WHERE ss.ss_hdemo_sk IN ('4855', '5486') GROUP BY cd.cd_gender, cd.cd_marital_status, td.t_shift ORDER BY total_revenue DESC, total_units_sold DESC;
SELECT i_category, ca_state, t_shift, COUNT(DISTINCT ws_order_number) AS total_orders, SUM(ws_quantity) AS total_quantity, AVG(ws_net_paid) AS average_net_paid, SUM(ws_net_profit) AS total_profit FROM web_sales JOIN item ON ws_item_sk = i_item_sk JOIN customer_address ON ws_bill_addr_sk = ca_address_sk JOIN time_dim ON ws_sold_time_sk = t_time_sk WHERE i_container = 'Unknown' AND ca_street_name IN ('Davis Hill', 'Center Ash', 'Ridge Forest', 'Lincoln Highland') AND t_am_pm = 'AM' AND t_shift = 'third' GROUP BY i_category, ca_state, t_shift ORDER BY total_profit DESC, total_orders DESC;
SELECT i.inv_item_sk, AVG(i.inv_quantity_on_hand) AS avg_quantity_on_hand, AVG(ws.ws_net_profit) AS avg_net_profit, SUM(ws.ws_net_paid_inc_ship_tax) AS total_sales, w.w_warehouse_name, COUNT(DISTINCT ws.ws_order_number) AS orders_count FROM inventory i JOIN warehouse w ON i.inv_warehouse_sk = w.w_warehouse_sk JOIN web_sales ws ON i.inv_item_sk = ws.ws_item_sk AND i.inv_warehouse_sk = ws.ws_warehouse_sk JOIN time_dim td ON ws.ws_sold_time_sk = td.t_time_sk WHERE i.inv_date_sk = '2450815' AND td.t_am_pm = 'AM' AND w.w_city = 'Fairview' AND w.w_warehouse_id = 'AAAAAAAAFAAAAAAA' GROUP BY i.inv_item_sk, w.w_warehouse_name ORDER BY avg_quantity_on_hand DESC, avg_net_profit DESC;
SELECT cc.cc_call_center_id, cc.cc_name, cc.cc_city, cc.cc_state, SUM(ss.ss_net_paid_inc_tax) AS total_sales_including_tax, AVG(ss.ss_sales_price) AS average_sales_price, COUNT(DISTINCT ss.ss_customer_sk) AS unique_customer_count, COUNT(DISTINCT CASE WHEN c.c_preferred_cust_flag = 'Y' THEN ss.ss_customer_sk END) AS preferred_customer_count, SUM(sr.sr_return_amt_inc_tax) AS total_returns_including_tax, COUNT(DISTINCT sr.sr_customer_sk) AS total_return_customers FROM call_center cc LEFT JOIN store_sales ss ON cc.cc_call_center_sk = ss.ss_store_sk LEFT JOIN store_returns sr ON ss.ss_ticket_number = sr.sr_ticket_number AND ss.ss_item_sk = sr.sr_item_sk LEFT JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk WHERE cc.cc_rec_start_date > '1998-01-01' AND cc.cc_sq_ft = '1138' GROUP BY cc.cc_call_center_id, cc.cc_name, cc.cc_city, cc.cc_state ORDER BY total_sales_including_tax DESC;
SELECT c.c_first_name, c.c_last_name, ca.ca_state, w.w_warehouse_name, SUM(i.inv_quantity_on_hand) AS total_inventory, AVG(cc.cc_tax_percentage) AS average_tax_percentage, COUNT(DISTINCT cc.cc_call_center_sk) AS number_of_call_centers FROM customer c JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk JOIN inventory i ON ca.ca_address_sk = i.inv_warehouse_sk JOIN warehouse w ON i.inv_warehouse_sk = w.w_warehouse_sk JOIN call_center cc ON w.w_state = cc.cc_state WHERE ca.ca_state IN ('MA', 'FL') AND w.w_warehouse_id IN ('AAAAAAAADAAAAAAA', 'AAAAAAAAFAAAAAAA', 'AAAAAAAABAAAAAAA') AND cc.cc_tax_percentage IN (0.01, 0.05, 0.11, 0.12) GROUP BY c.c_first_name, c.c_last_name, ca.ca_state, w.w_warehouse_name ORDER BY total_inventory DESC, average_tax_percentage, number_of_call_centers DESC;
SELECT dd.d_year, dd.d_quarter_name, ca.ca_state, ca.ca_city, COUNT(DISTINCT sr.sr_customer_sk) AS number_of_returning_customers, SUM(sr.sr_return_quantity) AS total_returned_quantity, AVG(sr.sr_return_amt_inc_tax) AS avg_return_amount_inc_tax, SUM(sr.sr_fee) AS total_fees_collected, SUM(sr.sr_net_loss) AS total_net_loss FROM store_returns sr INNER JOIN date_dim dd ON sr.sr_returned_date_sk = dd.d_date_sk INNER JOIN customer_address ca ON sr.sr_addr_sk = ca.ca_address_sk INNER JOIN household_demographics hd ON sr.sr_hdemo_sk = hd.hd_demo_sk WHERE dd.d_year = 2022 AND hd.hd_buy_potential = '>10000' AND dd.d_quarter_seq = 52 GROUP BY dd.d_year, dd.d_quarter_name, ca.ca_state, ca.ca_city ORDER BY total_net_loss DESC, avg_return_amount_inc_tax DESC LIMIT 10;
