SELECT sm.sm_type, w.w_state, COUNT(DISTINCT cr.cr_order_number) AS total_returns, SUM(cr.cr_return_amount) AS total_return_amount, AVG(cr.cr_return_amount) AS average_return_amount, SUM(cr.cr_net_loss) AS total_net_loss, SUM(cs.cs_sales_price) AS total_sales, AVG(cs.cs_sales_price) AS average_sales_price, SUM(cs.cs_net_profit) AS total_net_profit, SUM(i.inv_quantity_on_hand) AS total_inventory_on_hand FROM catalog_returns cr JOIN ship_mode sm ON cr.cr_ship_mode_sk = sm.sm_ship_mode_sk JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk JOIN catalog_sales cs ON cr.cr_item_sk = cs.cs_item_sk AND cr.cr_order_number = cs.cs_order_number JOIN inventory i ON cr.cr_item_sk = i.inv_item_sk AND w.w_warehouse_sk = i.inv_warehouse_sk WHERE cr.cr_returning_customer_sk IN ('98306', '44541', '85') GROUP BY sm.sm_type, w.w_state ORDER BY total_net_loss DESC;
SELECT w.w_warehouse_name, w.w_warehouse_sq_ft, w.w_city, w.w_state, ib.ib_lower_bound, ib.ib_upper_bound, AVG(cs.cs_sales_price) AS avg_sales_price, AVG(cs.cs_ext_discount_amt) AS avg_discount_amount, SUM(cs.cs_quantity) AS total_quantity_sold, COUNT(DISTINCT cs.cs_order_number) AS total_orders, COUNT(DISTINCT p.p_promo_sk) AS total_promotions_applied FROM catalog_sales cs JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk JOIN promotion p ON cs.cs_promo_sk = p.p_promo_sk JOIN income_band ib ON cs.cs_bill_customer_sk = ib.ib_income_band_sk WHERE d.d_year = 2021 AND w.w_county = 'Williamson County' AND p.p_discount_active = 'Y' AND p.p_response_target > 50 AND cs.cs_sales_price IS NOT NULL AND cs.cs_ext_discount_amt IS NOT NULL GROUP BY w.w_warehouse_name, w.w_warehouse_sq_ft, w.w_city, w.w_state, ib.ib_lower_bound, ib.ib_upper_bound ORDER BY avg_sales_price DESC, avg_discount_amount DESC;
SELECT s.s_store_name, s.s_city, s.s_state, SUM(ss.ss_quantity) AS total_quantity_sold, AVG(ss.ss_sales_price) AS average_sales_price, COUNT(DISTINCT ss.ss_ticket_number) AS number_of_sales_transactions, SUM(ss.ss_net_profit) AS total_net_profit FROM store_sales ss JOIN store s ON ss.ss_store_sk = s.s_store_sk JOIN warehouse w ON s.s_zip = w.w_zip JOIN ship_mode sm ON w.w_country = sm.sm_carrier WHERE ss.ss_sold_date_sk BETWEEN 2451189 AND 2451200 AND ss.ss_quantity > 50 GROUP BY s.s_store_name, s.s_city, s.s_state ORDER BY total_net_profit DESC, total_quantity_sold DESC LIMIT 10;
SELECT sm.sm_type AS ship_mode_type, p.p_promo_name AS promotion_name, r.r_reason_desc AS return_reason, COUNT(DISTINCT cr.cr_order_number) AS total_returns, SUM(cr.cr_return_amount) AS total_return_amount, AVG(cr.cr_return_amount) AS avg_return_amount, SUM(cr.cr_net_loss) AS total_net_loss, COUNT(DISTINCT cs.cs_order_number) AS total_sales_orders, SUM(cs.cs_sales_price) AS total_sales_amount, AVG(cs.cs_sales_price) AS avg_sales_price, (SUM(cr.cr_return_amount) / NULLIF(SUM(cs.cs_sales_price), 0)) * 100 AS return_rate_percentage FROM catalog_returns cr JOIN reason r ON cr.cr_reason_sk = r.r_reason_sk JOIN ship_mode sm ON cr.cr_ship_mode_sk = sm.sm_ship_mode_sk JOIN catalog_sales cs ON cr.cr_order_number = cs.cs_order_number JOIN promotion p ON cs.cs_promo_sk = p.p_promo_sk GROUP BY sm.sm_type, p.p_promo_name, r.r_reason_desc ORDER BY total_returns DESC, total_net_loss DESC LIMIT 10;
SELECT c.c_first_name, c.c_last_name, cs_total_sales, ws_total_sales, (cs_total_net_sales + ws_total_net_sales) AS total_combined_net_sales FROM customer c JOIN (SELECT cs_bill_customer_sk, SUM(cs_net_paid) AS cs_total_sales FROM catalog_sales GROUP BY cs_bill_customer_sk) cs_sales ON c.c_customer_sk = cs_sales.cs_bill_customer_sk JOIN (SELECT ws_bill_customer_sk, SUM(ws_net_paid) AS ws_total_sales FROM web_sales GROUP BY ws_bill_customer_sk) ws_sales ON c.c_customer_sk = ws_sales.ws_bill_customer_sk JOIN (SELECT cs_bill_customer_sk, SUM(cs_net_paid_inc_ship_tax) AS cs_total_net_sales FROM catalog_sales GROUP BY cs_bill_customer_sk) total_cs_sales ON c.c_customer_sk = total_cs_sales.cs_bill_customer_sk JOIN (SELECT ws_bill_customer_sk, SUM(ws_net_paid_inc_ship_tax) AS ws_total_net_sales FROM web_sales GROUP BY ws_bill_customer_sk) total_ws_sales ON c.c_customer_sk = total_ws_sales.ws_bill_customer_sk WHERE c.c_birth_country IN ('BRAZIL', 'ROMANIA', 'ICELAND') AND EXISTS (SELECT 1 FROM call_center WHERE cc_call_center_sk = cs_sales.cs_bill_customer_sk AND cc_company_name LIKE 'pri%') AND EXISTS (SELECT 1 FROM web_site WHERE web_site_sk = ws_sales.ws_bill_customer_sk AND web_street_type IN ('Road', 'Way', 'Dr.', 'Cir.', 'Parkway') AND web_street_number IN ('292', '409', '887', '805')) ORDER BY total_combined_net_sales DESC LIMIT 100;
SELECT i.i_category AS item_category, AVG(i.i_current_price) AS avg_current_price, COUNT(i.i_item_sk) AS total_item_count, AVG(i.i_wholesale_cost) AS avg_wholesale_cost, AVG(cd.cd_purchase_estimate) FILTER (WHERE cd.cd_credit_rating = 'Good') AS avg_good_credit_purchase_estimate, AVG(cd.cd_purchase_estimate) FILTER (WHERE cd.cd_credit_rating = 'High Risk') AS avg_high_risk_credit_purchase_estimate, AVG(cd.cd_purchase_estimate) FILTER (WHERE cd.cd_credit_rating = 'Low Risk') AS avg_low_risk_credit_purchase_estimate FROM item i JOIN promotion p ON i.i_item_sk = p.p_item_sk JOIN customer c ON p.p_start_date_sk <= c.c_first_sales_date_sk AND p.p_end_date_sk >= c.c_first_sales_date_sk JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk WHERE i.i_category IN ('Home', 'Electronics', 'Sports') AND c.c_first_sales_date_sk = '2452263' AND p.p_discount_active = '1' GROUP BY i.i_category ORDER BY avg_current_price DESC;
SELECT s.s_store_name, s.s_city, s.s_state, p.p_promo_name, p.p_channel_details, SUM(wr.wr_return_amt) AS total_refund_amount, AVG(wr.wr_fee) AS average_fee, COUNT(DISTINCT wr.wr_returned_date_sk) AS unique_return_days, COUNT(*) AS total_returns, cd.cd_gender, cd.cd_education_status, COUNT(DISTINCT cd.cd_demo_sk) AS unique_customers FROM web_returns wr JOIN store s ON wr.wr_returning_addr_sk = s.s_store_sk JOIN promotion p ON wr.wr_item_sk = p.p_item_sk JOIN customer_demographics cd ON wr.wr_returning_cdemo_sk = cd.cd_demo_sk WHERE s.s_tax_precentage = '0.01' AND s.s_gmt_offset = '-5.00' AND p.p_discount_active = 'N' AND wr.wr_refunded_cdemo_sk IN ('991117', '972552', '90047') AND wr.wr_returning_addr_sk IN ('33543', '41829') GROUP BY s.s_store_name, s.s_city, s.s_state, p.p_promo_name, p.p_channel_details, cd.cd_gender, cd.cd_education_status ORDER BY total_refund_amount DESC, unique_return_days DESC;
SELECT s.s_store_name, count(distinct ss.ss_ticket_number) as total_sales_transactions, sum(ss.ss_quantity) as total_items_sold, sum(ss.ss_net_paid_inc_tax) as total_sales_revenue, sum(cr.cr_return_quantity) as total_items_returned, sum(cr.cr_return_amt_inc_tax) as total_returned_revenue, sum(inv.inv_quantity_on_hand) as total_inventory_quantity FROM store_sales ss JOIN store s ON ss.ss_store_sk = s.s_store_sk LEFT JOIN catalog_returns cr ON ss.ss_item_sk = cr.cr_item_sk AND ss.ss_ticket_number = cr.cr_order_number LEFT JOIN inventory inv ON ss.ss_item_sk = inv.inv_item_sk WHERE s.s_country = 'United States' AND (inv.inv_item_sk = 12400 OR inv.inv_item_sk = 10369 OR inv.inv_item_sk = 8875) AND (ss.ss_ext_list_price = 5535.38 OR ss.ss_ext_list_price = 6147.90 OR ss.ss_ext_list_price = 8470.00 OR ss.ss_ext_list_price = 4720.95 OR ss.ss_ext_list_price = 5696.87 OR ss.ss_ext_list_price = 37.40) AND (cr.cr_return_tax = 123.73 OR cr.cr_return_tax = 44.47 OR cr.cr_return_tax = 115.68 OR cr.cr_return_tax = 4.37) GROUP BY s.s_store_name;
SELECT i_category, i_class, COUNT(DISTINCT cr_order_number) AS total_returns, SUM(cr_return_quantity) AS total_returned_quantity, AVG(cr_return_amount) AS avg_return_amount, SUM(cr_net_loss) AS total_net_loss, COUNT(DISTINCT ws_order_number) AS total_sales_orders, SUM(ws_quantity) AS total_sold_quantity, AVG(ws_sales_price) AS avg_sales_price, SUM(ws_net_profit) AS total_net_profit FROM catalog_returns JOIN item ON catalog_returns.cr_item_sk = item.i_item_sk JOIN web_sales ON item.i_item_sk = web_sales.ws_item_sk JOIN customer ON web_sales.ws_bill_customer_sk = customer.c_customer_sk JOIN income_band ON customer.c_current_hdemo_sk = income_band.ib_income_band_sk WHERE cr_returned_date_sk BETWEEN 20000101 AND 20001231 AND ws_sold_date_sk BETWEEN 20000101 AND 20001231 AND ib_income_band_sk IN (5, 8) AND cr_net_loss > 100 GROUP BY i_category, i_class ORDER BY total_net_loss DESC, total_net_profit DESC;
SELECT ws.web_site_id, ws.web_name, ws.web_manager, ws.web_gmt_offset, COUNT(DISTINCT cs_order_number) AS total_orders, SUM(cs_net_paid) AS total_revenue, AVG(cs_net_profit) AS average_profit, SUM(cr_return_amount) AS total_returns, AVG(cr_return_quantity) AS average_return_quantity, COUNT(DISTINCT cr_returned_date_sk) AS return_days_count, SUM(cd_purchase_estimate) AS total_purchase_estimate, AVG(cd_dep_count) AS average_dependents, COUNT(DISTINCT wp_web_page_sk) AS total_web_pages_accessed, SUM(wp_image_count) AS total_images_counted FROM web_site ws LEFT JOIN catalog_sales cs ON ws.web_site_sk = cs.cs_warehouse_sk LEFT JOIN catalog_returns cr ON cs.cs_order_number = cr.cr_order_number AND cs.cs_item_sk = cr.cr_item_sk LEFT JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk LEFT JOIN web_page wp ON ws.web_site_sk = wp.wp_customer_sk WHERE ws.web_site_id IN ('AAAAAAAAKAAAAAAA', 'AAAAAAAAKBAAAAAA', 'AAAAAAAANAAAAAAA') AND ws.web_manager IN ('John Thomas', 'Charles Castillo', 'Jimmy Pope') AND ws.web_gmt_offset = '-5.00' AND cr.cr_ship_mode_sk IN ('2', '3', '12') AND cr.cr_refunded_hdemo_sk IN ('5787', '111', '6091') AND cr.cr_returning_customer_sk IN ('39980', '67407', '42477') AND cr.cr_returning_addr_sk IN ('22557', '8862', '28393') AND cd.cd_credit_rating IN ('Good', 'Unknown', 'Low Risk') AND cd.cd_purchase_estimate IN ('3500', '2500', '5500') AND cd.cd_dep_employed_count = '0' AND cd.cd_marital_status IN ('U', 'S', 'W') AND wp.wp_access_date_sk IN ('2452555', '2452619', '2452568') AND wp.wp_url = 'http://www.foo.com' AND wp.wp_image_count IN ('2', '3', '5') GROUP BY ws.web_site_id, ws.web_name, ws.web_manager, ws.web_gmt_offset ORDER BY total_revenue DESC, average_profit DESC;
SELECT i.i_category AS category, ca.ca_state AS customer_state, EXTRACT(MONTH FROM (DATE '1970-01-01' + c.c_first_sales_date_sk * INTERVAL '1 day')) AS sale_month, COUNT(DISTINCT s.s_store_sk) AS num_stores, SUM(i.i_current_price) AS total_sales_amount, AVG(i.i_wholesale_cost) AS avg_wholesale_cost, COUNT(i.i_item_sk) AS items_sold, SUM(sr.sr_return_amt) AS total_return_amount, AVG(sr.sr_return_amt) AS avg_return_amount, COUNT(sr.sr_item_sk) AS items_returned FROM store s JOIN customer c ON s.s_store_sk = c.c_current_addr_sk JOIN item i ON s.s_store_sk = i.i_manufact_id JOIN store_returns sr ON i.i_item_sk = sr.sr_item_sk JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk WHERE ca.ca_state IN ('TN', 'DE', 'VA', 'CO') AND i.i_category_id IS NOT NULL AND c.c_first_sales_date_sk IS NOT NULL AND (c.c_birth_month = 1 OR c.c_birth_month IS NULL) AND sr.sr_returned_date_sk IS NOT NULL GROUP BY category, customer_state, sale_month ORDER BY total_sales_amount DESC, avg_wholesale_cost DESC, total_return_amount DESC LIMIT 100;
SELECT ca_state, sm_type, hd_income_band_sk, COUNT(*) AS total_returns, AVG(cr_return_amount) AS avg_return_amount, SUM(cr_return_amount) AS sum_return_amount, MAX(cr_return_amount) AS max_return_amount, MIN(cr_return_amount) AS min_return_amount, AVG(cr_fee) AS avg_fee, SUM(cr_fee) AS sum_fee FROM catalog_returns JOIN customer_address ON catalog_returns.cr_returning_addr_sk = customer_address.ca_address_sk JOIN household_demographics ON catalog_returns.cr_returning_hdemo_sk = household_demographics.hd_demo_sk JOIN ship_mode ON catalog_returns.cr_ship_mode_sk = ship_mode.sm_ship_mode_sk WHERE cr_return_tax > 200 AND cr_order_number IN (4607, 1986, 3937, 3931) AND hd_income_band_sk IN (4, 10) AND sm_contract IN ('6Hzzp4JkzjqD8MGXLCDa', 'Xjy3ZPuiDjzHlRx14Z3', 'O9V6oF8RJnLMmZYd1', 'I3uCelXtjP', 'OrDuVy2H', 'qENFQ') AND sm_carrier IN ('BOXBUNDLES', 'ZOUROS', 'DHL', 'MSC', 'GREAT EASTERN', 'AIRBORNE') GROUP BY ca_state, sm_type, hd_income_band_sk ORDER BY ca_state, sm_type, hd_income_band_sk;
SELECT w_state, t_shift, sm_type as shipping_type, avg(hd_income_band_sk) as avg_income_band, sum(case when hd_buy_potential = 'High' then 1 else 0 end) as high_buy_potential_count, avg(hd_dep_count) as avg_dependent_count, avg(hd_vehicle_count) as avg_vehicle_count, count(distinct sm_ship_mode_sk) as shipping_mode_count FROM household_demographics hd JOIN warehouse w ON hd.hd_demo_sk = w.w_warehouse_sk JOIN time_dim td ON td.t_time_sk = w.w_warehouse_sk JOIN ship_mode sm ON sm.sm_ship_mode_sk = w.w_warehouse_sk WHERE hd.hd_dep_count IN (2, 3, 6, 9) AND hd.hd_vehicle_count IN (0, 1, 2, 3, 4) AND td.t_shift IS NOT NULL AND sm.sm_type IS NOT NULL GROUP BY w_state, t_shift, sm_type ORDER BY avg_income_band DESC, high_buy_potential_count DESC, avg_vehicle_count DESC;
SELECT cc.cc_call_center_id, cc.cc_name, cc.cc_class, SUM(ss.ss_quantity) AS total_quantity_sold, AVG(ss.ss_sales_price) AS average_sales_price, COUNT(DISTINCT c.c_customer_sk) AS unique_customers, COUNT(DISTINCT cp.cp_catalog_page_sk) AS catalog_pages_used, SUM(ss.ss_net_paid) AS total_net_paid, SUM(ss.ss_net_paid_inc_tax) AS total_net_paid_including_tax, SUM(ss.ss_net_profit) AS total_net_profit, AVG(t.t_hour) AS average_hour_of_sale FROM call_center cc JOIN store_sales ss ON cc.cc_call_center_sk = ss.ss_store_sk JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk JOIN catalog_page cp ON c.c_current_cdemo_sk = cp.cp_catalog_page_sk JOIN time_dim t ON ss.ss_sold_time_sk = t.t_time_sk WHERE (cc.cc_rec_start_date IS NULL OR cc.cc_rec_start_date <= CURRENT_DATE) AND (cc.cc_rec_end_date IS NULL OR cc.cc_rec_end_date >= CURRENT_DATE) AND t.t_second IN ('16', '11') AND ss.ss_hdemo_sk IN ('1989', '6188') AND c.c_current_hdemo_sk IN ('3971', '3131', '4808', '7162', '6897', '2935') AND cc.cc_call_center_sk = 5 GROUP BY cc.cc_call_center_id, cc.cc_name, cc.cc_class ORDER BY total_net_profit DESC, average_sales_price DESC;
SELECT w_state, p_promo_id, p_discount_active, COUNT(DISTINCT cr_order_number) AS total_returns, SUM(cr_return_amount) AS total_return_amount, AVG(cr_return_amount) AS avg_return_amount, SUM(cr_return_quantity) AS total_returned_quantity, COUNT(DISTINCT sr_ticket_number) AS total_store_returns, SUM(sr_return_amt) AS total_store_return_amount, AVG(sr_return_amt) AS avg_store_return_amount, SUM(sr_return_quantity) AS total_store_returned_quantity FROM catalog_returns JOIN warehouse ON cr_warehouse_sk = w_warehouse_sk JOIN promotion ON cr_catalog_page_sk = p_promo_sk JOIN store_returns ON cr_item_sk = sr_item_sk AND cr_order_number = sr_ticket_number WHERE w_state = 'TN' AND p_promo_id = 'AAAAAAAAMKAAAAAA' AND p_discount_active = 'N' GROUP BY w_state, p_promo_id, p_discount_active ORDER BY total_return_amount DESC;
