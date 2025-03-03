SELECT p.p_promo_id AS promotion_id, p.p_promo_name AS promotion_name, p.p_channel_dmail AS channel_direct_mail, p.p_channel_email AS channel_email, p.p_channel_catalog AS channel_catalog, p.p_channel_tv AS channel_tv, p.p_channel_radio AS channel_radio, p.p_channel_press AS channel_press, p.p_channel_event AS channel_event, p.p_channel_demo AS channel_demo, s.s_state AS store_state, SUM(sr.sr_return_amt_inc_tax) AS total_returns_incl_tax, SUM(sr.sr_return_quantity) AS total_returned_quantity, COUNT(sr.sr_ticket_number) AS total_return_transactions, AVG(sr.sr_return_amt) AS avg_return_amount, AVG(sr.sr_return_amt_inc_tax) AS avg_return_amount_incl_tax FROM promotion p JOIN store_returns sr ON p.p_promo_sk = sr.sr_reason_sk JOIN store s ON sr.sr_store_sk = s.s_store_sk JOIN date_dim d ON sr.sr_returned_date_sk = d.d_date_sk WHERE d.d_fy_year = 2003 AND p.p_discount_active = 'Y' GROUP BY p.p_promo_id, p.p_promo_name, p.p_channel_dmail, p.p_channel_email, p.p_channel_catalog, p.p_channel_tv, p.p_channel_radio, p.p_channel_press, p.p_channel_event, p.p_channel_demo, s.s_state ORDER BY total_returns_incl_tax DESC, promotion_id;
SELECT sm.sm_type, sm.sm_carrier, w.web_site_sk, w.web_mkt_class, COUNT(DISTINCT ws.ws_order_number) AS total_orders, SUM(ws.ws_quantity) AS total_quantity, SUM(ws.ws_net_paid) AS total_net_paid, AVG(ws.ws_net_paid_inc_ship_tax) AS avg_net_paid_inc_ship_tax, SUM(ws.ws_net_profit) AS total_net_profit FROM web_sales ws JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk JOIN web_site w ON ws.ws_web_site_sk = w.web_site_sk WHERE ws.ws_net_paid BETWEEN 100 AND 3000 AND sm.sm_code IN ('SEA', 'SURFACE') AND w.web_street_type = 'Road' AND w.web_mkt_class LIKE 'Broad, new groups show car%' GROUP BY ROLLUP(sm.sm_type, sm.sm_carrier, w.web_site_sk, w.web_mkt_class) ORDER BY total_net_profit DESC, total_quantity DESC, avg_net_paid_inc_ship_tax DESC;
SELECT ws.ws_web_site_sk, COUNT(DISTINCT ws.ws_order_number) AS total_orders, SUM(ws.ws_quantity) AS total_quantity_sold, AVG(ws.ws_sales_price) AS average_sales_price, SUM(ws.ws_net_paid) AS total_net_paid, SUM(ws.ws_net_profit) AS total_net_profit, ws_site.web_tax_percentage, cd.cd_gender, cd.cd_marital_status, cd.cd_education_status, COUNT(cd.cd_dep_college_count) AS total_college_dependents FROM web_sales ws JOIN web_site ws_site ON ws.ws_web_site_sk = ws_site.web_site_sk JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk WHERE ws.ws_sales_price BETWEEN 6.61 AND 60.51 AND ws_site.web_tax_percentage IN ('0.07', '0.02') AND ws_site.web_zip IN ('35709', '31904') AND ws.ws_sold_date_sk IS NOT NULL AND ws.ws_sold_time_sk IS NOT NULL GROUP BY ws.ws_web_site_sk, ws_site.web_tax_percentage, cd.cd_gender, cd.cd_marital_status, cd.cd_education_status ORDER BY ws.ws_web_site_sk, cd.cd_gender, cd.cd_marital_status, cd.cd_education_status;
SELECT i.inv_date_sk, COUNT(DISTINCT cr.cr_order_number) AS total_returns, SUM(cr.cr_return_quantity) AS total_returned_quantity, AVG(cr.cr_return_amount) AS average_return_amount, SUM(cr.cr_net_loss) AS total_net_loss, COUNT(DISTINCT p.p_promo_sk) AS total_promotions, SUM(p.p_cost) AS total_promotion_cost, AVG(i.inv_quantity_on_hand) AS average_inventory_quantity FROM inventory i LEFT JOIN catalog_returns cr ON i.inv_item_sk = cr.cr_item_sk LEFT JOIN promotion p ON i.inv_item_sk = p.p_item_sk WHERE i.inv_date_sk BETWEEN 2450705 AND 2450709 AND i.inv_item_sk IN (7891, 13309, 15649, 8698, 9958) AND ( p.p_channel_catalog = 'N' OR p.p_channel_catalog IS NULL ) AND ( cr.cr_returning_cdemo_sk IN (909578, 1587504, 1439824, 941784, 229946) OR cr.cr_returning_cdemo_sk IS NULL ) GROUP BY i.inv_date_sk ORDER BY i.inv_date_sk;
SELECT s.s_state, AVG(cs.cs_net_paid) AS avg_sales, COUNT(sr.sr_ticket_number) AS total_returns, AVG(sr.sr_net_loss) AS avg_net_loss FROM catalog_sales cs JOIN store s ON cs.cs_bill_customer_sk = s.s_store_sk LEFT JOIN store_returns sr ON cs.cs_sold_date_sk = sr.sr_returned_date_sk AND cs.cs_item_sk = sr.sr_item_sk LEFT JOIN reason r ON sr.sr_reason_sk = r.r_reason_sk WHERE r.r_reason_desc = 'Did not get it on time' GROUP BY s.s_state ORDER BY avg_sales DESC, total_returns DESC;
SELECT c.c_customer_id, i.i_product_name, i.i_category, COUNT(cs.cs_order_number) AS total_orders, SUM(cs.cs_quantity) AS total_quantity, AVG(cs.cs_sales_price) AS avg_sales_price, SUM(cs.cs_net_paid) AS total_net_paid, SUM(cs.cs_net_paid_inc_tax) AS total_net_paid_inc_tax, SUM(cs.cs_net_paid_inc_ship) AS total_net_paid_inc_ship, SUM(cs.cs_net_paid_inc_ship_tax) AS total_net_paid_inc_ship_tax, SUM(sr.sr_return_amt) AS total_return_amount, SUM(sr.sr_fee) AS total_return_fee, SUM(sr.sr_net_loss) AS total_net_loss, SUM(wr.wr_return_amt) AS total_web_return_amount, SUM(wr.wr_fee) AS total_web_return_fee, SUM(wr.wr_net_loss) AS total_web_net_loss FROM customer c JOIN catalog_sales cs ON c.c_customer_sk = cs.cs_bill_customer_sk JOIN item i ON cs.cs_item_sk = i.i_item_sk LEFT JOIN store_returns sr ON cs.cs_item_sk = sr.sr_item_sk AND cs.cs_order_number = sr.sr_ticket_number LEFT JOIN web_returns wr ON cs.cs_item_sk = wr.wr_item_sk AND cs.cs_order_number = wr.wr_order_number JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk WHERE c.c_preferred_cust_flag = 'Y' AND d.d_year = 2023 GROUP BY c.c_customer_id, i.i_product_name, i.i_category ORDER BY total_net_paid DESC LIMIT 100;
SELECT hd.hd_dep_count, hd.hd_vehicle_count, ib.ib_lower_bound, ib.ib_upper_bound, COUNT(DISTINCT p.p_promo_sk) AS num_promotions, SUM(p.p_cost) AS total_promo_cost, AVG(p.p_cost) AS avg_promo_cost, COUNT(DISTINCT r.r_reason_sk) AS num_reasons, AVG(hd.hd_vehicle_count) AS avg_vehicle_count, SUM(CASE WHEN p.p_channel_event = 'N' THEN 1 ELSE 0 END) AS non_event_promos, SUM(CASE WHEN p.p_response_target = 1 THEN 1 ELSE 0 END) AS target_response_promos FROM promotion p JOIN household_demographics hd ON p.p_item_sk = hd.hd_demo_sk JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk LEFT JOIN reason r ON r.r_reason_sk = p.p_promo_sk WHERE p.p_channel_event = 'N' AND p.p_response_target = 1 GROUP BY hd.hd_dep_count, hd.hd_vehicle_count, ib.ib_lower_bound, ib.ib_upper_bound ORDER BY total_promo_cost DESC, num_promotions DESC;
SELECT c.c_first_name, c.c_last_name, c.c_email_address, SUM(inv.inv_quantity_on_hand) AS total_inventory, AVG(wr.wr_return_amt_inc_tax) AS avg_return_amount_inc_tax, COUNT(DISTINCT wr.wr_order_number) AS total_returns, td.t_shift, SUM(wr.wr_fee) AS total_return_fees, SUM(wr.wr_net_loss) AS total_net_loss FROM customer c JOIN web_returns wr ON c.c_customer_sk = wr.wr_returning_customer_sk JOIN inventory inv ON wr.wr_item_sk = inv.inv_item_sk JOIN time_dim td ON wr.wr_returned_time_sk = td.t_time_sk WHERE c.c_email_address IN ('Brandi.Miller@JH5mldviNI7xQKVQj.com', 'Steven.Williams@uxeKdX2slbhOxguR.edu', 'Maryalice.Rivers@4b9MXdByVXI.com') AND c.c_birth_day IN (26, 12, 21) AND inv.inv_quantity_on_hand IN (31, 517, 732) AND inv.inv_date_sk = 2450815 AND inv.inv_item_sk IN (12622, 7663, 9094) AND inv.inv_warehouse_sk IN (2, 1) AND wr.wr_returning_cdemo_sk IN (940737, 1276363, 1374880) AND wr.wr_returned_time_sk IN (69044, 3060, 44094) AND wr.wr_reversed_charge IN (22.11, 1530.12, 160.93) AND wr.wr_reason_sk IN (1, 8, 25) GROUP BY c.c_first_name, c.c_last_name, c.c_email_address, td.t_shift ORDER BY total_inventory DESC, avg_return_amount_inc_tax DESC, total_returns DESC;
SELECT ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound, COUNT(cr.cr_order_number) AS total_returns, AVG(cr.cr_return_amount) AS avg_refund_amount, SUM(cr.cr_net_loss) AS total_net_loss FROM catalog_returns cr JOIN customer_demographics cd ON cr.cr_refunded_cdemo_sk = cd.cd_demo_sk JOIN income_band ib ON cd.cd_purchase_estimate BETWEEN ib.ib_lower_bound AND ib.ib_upper_bound JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk AND w.w_street_name IN ('Wilson Elm', 'Ash Laurel', '6th') JOIN time_dim t ON cr.cr_returned_time_sk = t.t_time_sk WHERE t.t_hour BETWEEN 9 AND 17 AND w.w_suite_number IN ('Suite 80', 'Suite 470', 'Suite 0') AND ib.ib_upper_bound IN (130000, 120000, 40000, 200000) GROUP BY ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound ORDER BY total_net_loss DESC;
SELECT dd.d_year, dd.d_quarter_name, SUM(sr.sr_return_quantity) AS total_returned_quantity, AVG(sr.sr_return_amt) AS avg_return_amt, COUNT(DISTINCT sr.sr_customer_sk) AS unique_customers, COUNT(DISTINCT hd.hd_demo_sk) AS unique_households, r.r_reason_desc, COUNT(*) AS return_instances, SUM(sr.sr_net_loss) AS total_net_loss FROM store_returns sr JOIN date_dim dd ON sr.sr_returned_date_sk = dd.d_date_sk LEFT JOIN household_demographics hd ON sr.sr_hdemo_sk = hd.hd_demo_sk LEFT JOIN reason r ON sr.sr_reason_sk = r.r_reason_sk WHERE dd.d_fy_year BETWEEN 1907 AND 1913 GROUP BY dd.d_year, dd.d_quarter_name, r.r_reason_desc ORDER BY dd.d_year, total_returned_quantity DESC, avg_return_amt DESC;
SELECT i.i_category AS product_category, AVG(i.i_current_price) AS avg_item_price, COUNT(DISTINCT w.wr_order_number) AS total_orders, SUM(w.wr_return_quantity) AS total_items_returned, SUM(w.wr_return_amt) AS total_amount_returned, SUM(w.wr_net_loss) AS total_net_loss FROM item i JOIN web_returns w ON i.i_item_sk = w.wr_item_sk JOIN time_dim t ON t.t_time_sk = w.wr_returned_time_sk JOIN web_page wp ON w.wr_web_page_sk = wp.wp_web_page_sk JOIN customer c ON w.wr_refunded_customer_sk = c.c_customer_sk WHERE w.wr_return_quantity > 0 AND i.i_category IS NOT NULL AND c.c_last_review_date_sk = 2452428 AND (w.wr_refunded_cdemo_sk IN (1473865, 1053973, 323984, 999712) OR w.wr_return_quantity IN (92, 41)) GROUP BY i.i_category ORDER BY total_net_loss DESC, total_amount_returned DESC;
SELECT cc.cc_name, cc.cc_city, cc.cc_state, SUM(ss.ss_quantity) AS total_quantity_sold, AVG(ss.ss_sales_price) AS average_sales_price, COUNT(DISTINCT c.c_customer_sk) AS unique_customers, MAX(ss.ss_net_paid_inc_tax) AS max_payment_received, MIN(ss.ss_net_paid_inc_tax) AS min_payment_received FROM call_center cc JOIN store_sales ss ON cc.cc_call_center_sk = ss.ss_store_sk JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk WHERE cc.cc_rec_start_date BETWEEN '1998-01-01' AND '2001-01-01' AND cc.cc_mkt_desc LIKE '%Rich groups catch longer other fears; future,%' GROUP BY cc.cc_name, cc.cc_city, cc.cc_state ORDER BY total_quantity_sold DESC, average_sales_price DESC;
SELECT cp.cp_department, i.i_category, SUM(wr.wr_return_quantity) AS total_returned_quantity, AVG(wr.wr_return_amt) AS avg_return_amount, COUNT(DISTINCT wr.wr_order_number) AS count_distinct_orders, AVG(w.w_warehouse_sq_ft) AS avg_warehouse_sq_ft, SUM(wr.wr_fee) AS total_fees, AVG(i.i_wholesale_cost) AS avg_wholesale_cost, SUM(wr.wr_net_loss) AS total_net_loss FROM web_returns wr JOIN item i ON wr.wr_item_sk = i.i_item_sk JOIN catalog_page cp ON wr.wr_web_page_sk = cp.cp_catalog_page_sk JOIN warehouse w ON i.i_manufact_id = w.w_warehouse_sk WHERE wr.wr_returned_date_sk IS NOT NULL AND cp.cp_description = 'Effects change easy, real types; young, corporate' AND wr.wr_refunded_addr_sk IN ('47678', '14023', '11197', '22228', '47074') GROUP BY cp.cp_department, i.i_category ORDER BY total_returned_quantity DESC, avg_return_amount DESC;
SELECT ca_state, ca_city, SUM(cs_net_paid_inc_tax) AS total_sales, AVG(cs_net_paid_inc_tax) AS avg_sales, COUNT(DISTINCT cs_order_number) AS num_sales_orders, SUM(cr_return_amt_inc_tax) AS total_returns, AVG(cr_return_amt_inc_tax) AS avg_returns, COUNT(DISTINCT cr_order_number) AS num_return_orders, SUM(cr_net_loss) AS total_net_loss FROM customer_address JOIN catalog_sales ON cs_bill_addr_sk = ca_address_sk LEFT JOIN catalog_returns ON cr_order_number = cs_order_number JOIN web_sales ON ws_order_number = cs_order_number JOIN time_dim ON ws_sold_time_sk = t_time_sk JOIN web_page ON ws_web_page_sk = wp_web_page_sk WHERE t_sub_shift = 'night' AND ws_ship_date_sk = 2450935 AND ws_web_page_sk IN (41, 3, 18, 4, 45) AND wp_creation_date_sk IN (2450810, 2450808, 2450812, 2450809) GROUP BY ca_state, ca_city ORDER BY ca_state, ca_city;
SELECT cc.cc_name, cc.cc_city, cc.cc_state, SUM(cr.cr_return_amount) AS total_return_amount, AVG(cr.cr_return_amount) AS avg_return_amount, COUNT(cr.cr_order_number) AS total_returns, SUM(cr.cr_return_quantity) AS total_returned_items, COUNT(DISTINCT cr.cr_returning_customer_sk) AS unique_returning_customers, SUM(case when hd.hd_dep_count IS NOT NULL THEN 1 ELSE 0 END) AS returns_with_dep_count, SUM(case when hd.hd_vehicle_count IS NOT NULL THEN 1 ELSE 0 END) AS returns_with_vehicle_count, COUNT(DISTINCT p.p_promo_sk) AS total_promotions_involved, SUM(p.p_cost) AS total_promotion_cost FROM call_center cc LEFT JOIN catalog_returns cr ON cc.cc_call_center_sk = cr.cr_call_center_sk LEFT JOIN household_demographics hd ON cr.cr_returning_hdemo_sk = hd.hd_demo_sk LEFT JOIN promotion p ON p.p_item_sk = cr.cr_item_sk WHERE cc.cc_company_name IN ('able', 'ought', 'cally', 'pri') AND cc.cc_hours IN ('8AM-4PM', '8AM-8AM') AND p.p_channel_tv = 'N' AND p.p_purpose = 'Unknown' AND cr.cr_refunded_cash IN ('5415.08', '1.89', '288.51', '2.49', '307.01') GROUP BY cc.cc_name, cc.cc_city, cc.cc_state ORDER BY total_return_amount DESC;
SELECT s_state, s_city, p_channel_demo, p_promo_name, COUNT(DISTINCT sr_ticket_number) AS total_returns, SUM(sr_return_quantity) AS total_returned_quantity, AVG(sr_return_amt) AS average_return_amount, SUM(sr_net_loss) AS total_net_loss, COUNT(DISTINCT ss_ticket_number) AS total_sales, SUM(ss_quantity) AS total_sold_quantity, AVG(ss_sales_price) AS average_sales_price, SUM(ss_net_profit) AS total_net_profit FROM store_returns sr JOIN store s ON sr.sr_store_sk = s.s_store_sk JOIN store_sales ss ON sr.sr_item_sk = ss.ss_item_sk AND sr.sr_ticket_number = ss.ss_ticket_number JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk GROUP BY s_state, s_city, p_channel_demo, p_promo_name ORDER BY s_state, s_city, p_channel_demo, p_promo_name;
SELECT i.i_category, i.i_class, i.i_brand, COUNT(DISTINCT cs.cs_order_number) AS total_orders, SUM(cs.cs_quantity) AS total_quantity_sold, AVG(cs.cs_sales_price) AS avg_sales_price, SUM(cs.cs_net_paid) AS total_net_paid, SUM(wr.wr_return_quantity) AS total_quantity_returned, SUM(wr.wr_return_amt) AS total_return_amt, AVG(wr.wr_fee) AS avg_return_fee, COUNT(DISTINCT c.c_customer_sk) AS total_customers, SUM(CASE WHEN c.c_preferred_cust_flag = 'Y' THEN cs.cs_net_paid ELSE 0 END) AS preferred_customer_sales, COUNT(DISTINCT CASE WHEN c.c_preferred_cust_flag = 'Y' THEN c.c_customer_sk ELSE NULL END) AS preferred_customer_count FROM item i JOIN catalog_sales cs ON i.i_item_sk = cs.cs_item_sk LEFT JOIN web_returns wr ON cs.cs_item_sk = wr.wr_item_sk AND cs.cs_order_number = wr.wr_order_number JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk GROUP BY i.i_category, i.i_class, i.i_brand ORDER BY total_net_paid DESC, total_return_amt DESC, avg_sales_price DESC LIMIT 100;
