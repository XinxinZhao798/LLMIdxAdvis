SELECT sm.sm_type, sm.sm_carrier, COUNT(DISTINCT wr.wr_item_sk) AS total_items_returned, SUM(wr.wr_return_quantity) AS total_quantity_returned, AVG(wr.wr_return_amt) AS average_return_amount, AVG(wr.wr_fee) AS average_fee, SUM(wr.wr_net_loss) AS total_net_loss, ws.web_name, ws.web_manager, ws.web_mkt_class, COUNT(DISTINCT ws.web_site_sk) AS total_sites FROM web_returns wr JOIN ship_mode sm ON wr.wr_returned_date_sk = sm.sm_ship_mode_sk JOIN web_site ws ON wr.wr_web_page_sk = ws.web_site_sk WHERE ws.web_mkt_id IN (3, 4, 6, 2) AND ws.web_street_name = 'Hickory 3rd' AND wr.wr_returned_date_sk BETWEEN 100 AND 200 GROUP BY sm.sm_type, sm.sm_carrier, ws.web_name, ws.web_manager, ws.web_mkt_class ORDER BY total_net_loss DESC, total_quantity_returned DESC LIMIT 10;
SELECT cd.cd_gender, cd.cd_education_status, cd.cd_credit_rating, ib.ib_income_band_sk, sm.sm_type, COUNT(*) AS number_of_sales, SUM(ws.ws_quantity) AS total_quantity_sold, AVG(ws.ws_sales_price) AS average_sales_price, SUM(ws.ws_net_paid) AS total_net_paid, SUM(ws.ws_net_profit) AS total_net_profit, SUM(CASE WHEN ws.ws_sales_price > ws.ws_wholesale_cost THEN 1 ELSE 0 END) AS profitable_sales_count FROM web_sales ws JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk JOIN income_band ib ON cd.cd_purchase_estimate BETWEEN ib.ib_lower_bound AND ib.ib_upper_bound JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk WHERE cd.cd_credit_rating = 'High Risk' AND ib.ib_upper_bound IN (60000, 160000, 180000, 200000) AND sm.sm_ship_mode_id IN ('AAAAAAAAGAAAAAAA', 'AAAAAAAAABAAAAAA', 'AAAAAAAAKAAAAAAA', 'AAAAAAAALAAAAAAA', 'AAAAAAAAJAAAAAAA') GROUP BY cd.cd_gender, cd.cd_education_status, cd.cd_credit_rating, ib.ib_income_band_sk, sm.sm_type ORDER BY total_net_profit DESC, total_net_paid DESC;
SELECT dd.d_year, dd.d_quarter_name, COUNT(DISTINCT cr.cr_order_number) AS catalog_return_orders, SUM(cr.cr_return_quantity) AS total_catalog_returned_qty, AVG(cr.cr_return_amount) AS avg_catalog_return_amount, SUM(cr.cr_net_loss) AS total_catalog_net_loss, COUNT(DISTINCT wr.wr_order_number) AS web_return_orders, SUM(wr.wr_return_quantity) AS total_web_returned_qty, AVG(wr.wr_return_amt) AS avg_web_return_amount, SUM(wr.wr_net_loss) AS total_web_net_loss, COUNT(DISTINCT h.hd_demo_sk) AS unique_households_affected, SUM(CASE WHEN i.i_rec_end_date = '2001-10-26' THEN cr.cr_return_quantity ELSE 0 END) AS qty_items_end_date_oct26 FROM date_dim dd LEFT JOIN catalog_returns cr ON dd.d_date_sk = cr.cr_returned_date_sk LEFT JOIN web_returns wr ON dd.d_date_sk = wr.wr_returned_date_sk LEFT JOIN item i ON cr.cr_item_sk = i.i_item_sk OR wr.wr_item_sk = i.i_item_sk LEFT JOIN household_demographics h ON cr.cr_returning_hdemo_sk = h.hd_demo_sk OR wr.wr_returning_hdemo_sk = h.hd_demo_sk WHERE dd.d_date IS NOT NULL AND (cr.cr_return_amount > 0 OR wr.wr_return_amt > 0) AND (cr.cr_reason_sk = 28 OR wr.wr_reason_sk = 28) GROUP BY dd.d_year, dd.d_quarter_name ORDER BY dd.d_year, dd.d_quarter_name;
SELECT i_category, i_brand, COUNT(DISTINCT i_item_sk) AS num_items, SUM(i_current_price) AS total_current_price, AVG(i_wholesale_cost) AS average_wholesale_cost, MAX(wp_link_count) AS max_link_count, MIN(wp_char_count) AS min_char_count, AVG(t_hour) AS average_hour_of_day FROM item JOIN web_page ON i_item_sk = wp_customer_sk JOIN time_dim ON wp_access_date_sk = t_time_sk WHERE i_container <> 'Unknown' AND i_brand_id IN ('9001011', '9016005', '6015001', '9005009', '9016001') AND wp_link_count IN ('17', '25', '6', '4', '18', '19') GROUP BY i_category, i_brand ORDER BY total_current_price DESC, average_wholesale_cost DESC LIMIT 100;
SELECT ws_web.web_site_sk, ws_web.web_name, ws_web.web_state, SUM(ws.ws_net_profit) AS total_net_profit, AVG(ws.ws_net_paid_inc_tax) AS average_net_paid_inc_tax, COUNT(DISTINCT ws_c.c_customer_sk) AS unique_customers, COUNT(DISTINCT ws_p.p_promo_sk) AS promotion_count, SUM(ws.ws_quantity) AS total_quantity_sold, SUM(ws.ws_ext_sales_price) AS total_sales, SUM(ws.ws_ext_wholesale_cost) AS total_wholesale_cost, SUM(ws.ws_ext_discount_amt) AS total_discount_amount FROM web_sales ws INNER JOIN web_site ws_web ON ws.ws_web_site_sk = ws_web.web_site_sk LEFT JOIN customer ws_c ON ws.ws_bill_customer_sk = ws_c.c_customer_sk LEFT JOIN promotion ws_p ON ws.ws_promo_sk = ws_p.p_promo_sk WHERE ws_web.web_state = 'TN' AND ws_p.p_cost > 1000.00 GROUP BY ws_web.web_site_sk, ws_web.web_name, ws_web.web_state ORDER BY total_net_profit DESC;
SELECT s_state, s_city, AVG(s_number_employees) AS avg_number_employees, SUM(s_floor_space) AS total_floor_space, COUNT(*) AS store_count FROM store WHERE s_gmt_offset = '-5.00' AND s_rec_end_date IS NULL GROUP BY s_state, s_city ORDER BY s_state, s_city;
SELECT sm.sm_type AS shipping_type, w.w_city AS warehouse_city, r.r_reason_desc AS return_reason, COUNT(*) AS total_returns, SUM(cr.cr_return_quantity) AS total_returned_quantity, AVG(cr.cr_return_amount) AS average_return_amount, SUM(cr.cr_return_amt_inc_tax) AS total_return_amount_inc_tax, AVG(cr.cr_fee) AS average_fee, SUM(cr.cr_net_loss) AS total_net_loss FROM catalog_returns cr JOIN reason r ON cr.cr_reason_sk = r.r_reason_sk JOIN ship_mode sm ON cr.cr_ship_mode_sk = sm.sm_ship_mode_sk JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk GROUP BY shipping_type, warehouse_city, return_reason ORDER BY total_returns DESC, total_returned_quantity DESC;
SELECT i.i_category, i.i_brand, sm.sm_type, COUNT(DISTINCT wr.wr_order_number) AS total_returns, SUM(wr.wr_return_quantity) AS total_returned_quantity, AVG(wr.wr_return_amt) AS avg_return_amount, SUM(wr.wr_return_amt) AS total_return_amount, SUM(wr.wr_fee) AS total_fees, SUM(wr.wr_net_loss) AS total_net_loss FROM web_returns wr JOIN item i ON wr.wr_item_sk = i.i_item_sk JOIN ship_mode sm ON wr.wr_returned_date_sk = sm.sm_ship_mode_sk WHERE i.i_item_id IN ('AAAAAAAAEKBBAAAA', 'AAAAAAAACAAAAAAA', 'AAAAAAAAGCCAAAAA', 'AAAAAAAAKMEAAAAA') AND wr.wr_return_tax IN (29.73, 18.36, 50.38, 6.84) AND wr.wr_fee IN (85.54, 18.90, 40.73, 20.86, 73.81) AND sm.sm_ship_mode_sk IN (13, 7, 6, 16, 10) AND sm.sm_type IN ('TWO DAY', 'OVERNIGHT') GROUP BY i.i_category, i.i_brand, sm.sm_type ORDER BY total_net_loss DESC, total_returned_quantity DESC;
SELECT c.c_customer_id, c.c_first_name, c.c_last_name, dd.d_year, SUM(ws.ws_ext_sales_price) AS total_sales, AVG(ws.ws_ext_sales_price) AS avg_sales, COUNT(*) AS number_of_sales, SUM(cr.cr_return_amount) AS total_returns, AVG(cr.cr_return_amount) AS avg_returns, COUNT(DISTINCT cr.cr_order_number) AS number_of_returns FROM web_sales ws JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk JOIN date_dim dd ON ws.ws_sold_date_sk = dd.d_date_sk LEFT JOIN catalog_returns cr ON cr.cr_returned_date_sk = dd.d_date_sk AND cr.cr_refunded_customer_sk = c.c_customer_sk WHERE dd.d_year = 2001 GROUP BY c.c_customer_id, c.c_first_name, c.c_last_name, dd.d_year ORDER BY total_sales DESC, total_returns DESC LIMIT 100;
SELECT cc.cc_name AS call_center_name, cc.cc_city AS city, cc.cc_state AS state, AVG(cd.cd_purchase_estimate) AS avg_purchase_estimate, SUM(cr.cr_return_amount) AS total_return_amount, SUM(cr.cr_return_quantity) AS total_returned_items, COUNT(DISTINCT cr.cr_returned_date_sk) AS days_with_returns, SUM(cr.cr_return_amt_inc_tax - cr.cr_return_amount) AS total_tax_collected, COUNT(DISTINCT cr.cr_refunded_customer_sk) AS unique_customers_refunded, COUNT(DISTINCT cr.cr_returning_customer_sk) AS unique_customers_returning, SUM(CASE WHEN cd.cd_marital_status = 'U' THEN 1 ELSE 0 END) AS unmarried_customers, SUM(CASE WHEN cd.cd_marital_status = 'D' THEN 1 ELSE 0 END) AS divorced_customers, SUM(CASE WHEN cd.cd_marital_status = 'W' THEN 1 ELSE 0 END) AS widowed_customers FROM call_center cc JOIN catalog_returns cr ON cc.cc_call_center_sk = cr.cr_call_center_sk JOIN customer_demographics cd ON cd.cd_demo_sk = cr.cr_refunded_cdemo_sk OR cd.cd_demo_sk = cr.cr_returning_cdemo_sk WHERE cc_rec_end_date IS NULL GROUP BY call_center_name, city, state ORDER BY total_return_amount DESC LIMIT 100;
SELECT sm.sm_type, w.w_state, COUNT(DISTINCT cr.cr_order_number) AS total_returns, SUM(cr.cr_return_amount) AS total_return_amount, AVG(cr.cr_return_amount) AS average_return_amount, SUM(cr.cr_net_loss) AS total_net_loss, SUM(cs.cs_sales_price) AS total_sales, AVG(cs.cs_sales_price) AS average_sales_price, SUM(cs.cs_net_profit) AS total_net_profit, SUM(i.inv_quantity_on_hand) AS total_inventory_on_hand FROM catalog_returns cr JOIN ship_mode sm ON cr.cr_ship_mode_sk = sm.sm_ship_mode_sk JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk JOIN catalog_sales cs ON cr.cr_item_sk = cs.cs_item_sk AND cr.cr_order_number = cs.cs_order_number JOIN inventory i ON cr.cr_item_sk = i.inv_item_sk AND w.w_warehouse_sk = i.inv_warehouse_sk WHERE cr.cr_returning_customer_sk IN ('98306', '44541', '85') GROUP BY sm.sm_type, w.w_state ORDER BY total_net_loss DESC;
SELECT sm.sm_type AS shipping_mode, COUNT(DISTINCT sr.sr_ticket_number) AS total_returns, AVG(sr.sr_return_quantity) AS average_returned_quantity, SUM(sr.sr_return_amt) AS total_return_amount, SUM(sr.sr_return_amt_inc_tax) AS total_return_amount_inc_tax, SUM(CASE WHEN p.p_discount_active = 'Y' THEN 1 ELSE 0 END) AS promotions_with_discount, AVG(p.p_cost) AS average_promotion_cost, COUNT(DISTINCT p.p_promo_sk) AS number_of_promotions_used FROM store_returns sr JOIN promotion p ON sr.sr_item_sk = p.p_item_sk JOIN ship_mode sm ON sm.sm_type IN ('TWO DAY', 'OVERNIGHT', 'EXPRESS') JOIN time_dim t ON sr.sr_return_time_sk = t.t_time_sk WHERE sr.sr_addr_sk::text IN ('38052', '30541', '12047', '37071', '23460', '3442') AND t.t_second::text IN ('51', '12', '16', '37', '57') GROUP BY sm.sm_type ORDER BY total_return_amount DESC;
