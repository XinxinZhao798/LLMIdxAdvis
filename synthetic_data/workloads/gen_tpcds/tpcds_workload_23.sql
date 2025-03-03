SELECT ca.ca_state, sm.sm_type, ws.ws_web_site_sk, COUNT(DISTINCT ws.ws_order_number) AS total_orders, SUM(ws.ws_quantity) AS total_quantity, AVG(ws.ws_sales_price) AS average_sales_price, SUM(ws.ws_net_paid) AS total_net_paid, SUM(ws.ws_net_profit) AS total_net_profit FROM web_sales ws JOIN customer_address ca ON ws.ws_ship_addr_sk = ca.ca_address_sk JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk JOIN date_dim dd ON ws.ws_sold_date_sk = dd.d_date_sk WHERE ca.ca_state IN ('CT', 'SD') AND sm.sm_type = 'OVERNIGHT' AND ws.ws_web_site_sk IN (SELECT web_site_sk FROM web_site WHERE web_market_manager = 'John Doe') AND dd.d_year = 2023 AND dd.d_moy BETWEEN 1 AND 6 GROUP BY ca.ca_state, sm.sm_type, ws.ws_web_site_sk ORDER BY total_net_profit DESC;
SELECT w_state, w_city, ib.ib_income_band_sk AS income_band_sk, p_promo_name, COUNT(DISTINCT w.w_warehouse_sk) AS num_warehouses, SUM(w.w_warehouse_sq_ft) AS total_warehouse_sq_ft, AVG(w.w_warehouse_sq_ft) AS avg_warehouse_sq_ft, SUM(wr_return_amt_inc_tax) AS total_return_amount_inc_tax, COUNT(DISTINCT wr.wr_returned_date_sk) AS num_return_days, AVG(wr_return_amt_inc_tax) AS avg_return_amount_inc_tax FROM warehouse w JOIN web_returns wr ON w.w_warehouse_sk = wr.wr_returning_addr_sk JOIN income_band ib ON ib.ib_income_band_sk = wr.wr_returning_hdemo_sk JOIN promotion p ON p.p_item_sk = wr.wr_item_sk WHERE w_state = 'TN' AND w_city = 'Fairview' AND wr_reason_sk IN (7, 17, 21, 6) AND ib_upper_bound IN (50000, 190000, 80000) AND wr_returning_hdemo_sk IN (4812, 3393, 981, 1249) GROUP BY w_state, w_city, ib.ib_income_band_sk, p_promo_name ORDER BY total_return_amount_inc_tax DESC LIMIT 100;
SELECT cc.cc_call_center_id AS call_center, cc.cc_name AS call_center_name, cc.cc_manager AS manager, SUM(i.i_current_price) AS total_sales, AVG(i.i_wholesale_cost) AS average_wholesale_cost, COUNT(DISTINCT cd.cd_demo_sk) AS unique_customer_demographics, AVG(cd.cd_purchase_estimate) AS average_purchase_estimate, COUNT(DISTINCT t.t_time_sk) AS count_time_sk_events, ib.ib_lower_bound, ib.ib_upper_bound, COUNT(*) FILTER (WHERE t.t_am_pm = 'AM') AS am_shifts, COUNT(*) FILTER (WHERE t.t_sub_shift = 'night') AS night_sub_shifts FROM call_center cc JOIN catalog_page cp ON cc.cc_call_center_id = cp.cp_catalog_page_id JOIN item i ON cp.cp_catalog_page_sk = i.i_item_sk JOIN customer_demographics cd ON i.i_manager_id = cd.cd_demo_sk JOIN time_dim t ON t.t_time_sk = cd.cd_demo_sk JOIN income_band ib ON cd.cd_purchase_estimate BETWEEN ib.ib_lower_bound AND ib.ib_upper_bound JOIN date_dim dd_cc ON cc.cc_open_date_sk = dd_cc.d_date_sk JOIN date_dim dd_cp ON cp.cp_start_date_sk = dd_cp.d_date_sk WHERE dd_cc.d_date <= CURRENT_DATE AND (cc.cc_rec_end_date IS NULL OR cc.cc_rec_end_date > CURRENT_DATE) AND dd_cp.d_date <= CURRENT_DATE AND (cp.cp_end_date_sk IS NULL OR dd_cp.d_date > CURRENT_DATE) GROUP BY cc.cc_call_center_id, cc.cc_name, cc.cc_manager, ib.ib_lower_bound, ib.ib_upper_bound ORDER BY total_sales DESC;
SELECT s.s_state, cd.cd_gender, COUNT(DISTINCT s.s_store_sk) AS total_stores, AVG(s.s_floor_space) AS avg_floor_space, SUM(ss.ss_net_paid) AS total_sales, AVG(ss.ss_ext_discount_amt) AS avg_discount_amount FROM store_sales ss JOIN customer_demographics cd ON cd.cd_demo_sk = ss.ss_cdemo_sk JOIN store s ON s.s_store_sk = ss.ss_store_sk WHERE ss.ss_ext_sales_price > 0 AND cd.cd_gender IN ('M', 'F') AND s.s_state IS NOT NULL GROUP BY s.s_state, cd.cd_gender ORDER BY s.s_state, cd.cd_gender, total_sales DESC;
SELECT cc_state, cc_city, ca_country, COUNT(DISTINCT cc_call_center_sk) AS number_of_call_centers, SUM(cc_employees) AS total_employees, AVG(cc_tax_percentage) AS avg_tax_percentage, SUM(s_number_employees) AS total_store_employees, AVG(s_tax_precentage) AS avg_store_tax, SUM(ws_quantity) AS total_items_sold, SUM(ws_net_paid) AS total_revenue, SUM(ws_net_profit) AS total_profit, AVG(ws_net_profit) AS avg_profit_per_sale, SUM(ws_ext_ship_cost) AS total_shipping_cost FROM call_center JOIN store ON cc_zip = s_zip JOIN web_sales ON ws_ship_addr_sk IN (SELECT ca_address_sk FROM customer_address WHERE ca_zip = cc_zip) JOIN customer_address ON cc_zip = ca_zip WHERE cc_hours IN ('8AM-4PM', '8AM-8AM') AND ws_net_profit NOT IN (-1167.89, -63.88, -192.70, -49.59) AND ca_country = 'United States' AND ca_gmt_offset IN (-8.00, -9.00) GROUP BY cc_state, cc_city, ca_country ORDER BY total_profit DESC;
SELECT r.r_reason_desc, COUNT(DISTINCT sr.sr_ticket_number) AS num_store_returns, SUM(sr.sr_refunded_cash) AS total_store_refunded, AVG(sr.sr_return_amt_inc_tax) AS avg_store_return, COUNT(DISTINCT cr.cr_order_number) AS num_catalog_returns, SUM(cr.cr_refunded_cash) AS total_catalog_refunded, AVG(cr.cr_return_amt_inc_tax) AS avg_catalog_return FROM store_returns sr FULL OUTER JOIN catalog_returns cr ON sr.sr_reason_sk = cr.cr_reason_sk JOIN reason r ON r.r_reason_sk = sr.sr_reason_sk OR r.r_reason_sk = cr.cr_reason_sk LEFT JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk WHERE (sr.sr_customer_sk IN (67809, 3762, 6067) OR cr.cr_returning_hdemo_sk IN (6684, 3972, 3528, 1943, 4100, 4193)) AND (r.r_reason_id IN ('AAAAAAAANBAAAAAA', 'AAAAAAAADCAAAAAA', 'AAAAAAAAACAAAAAA', 'AAAAAAAAIAAAAAAA', 'AAAAAAAAFBAAAAAA', 'AAAAAAAAOBAAAAAA')) AND w.w_street_number = '651' AND w.w_county = 'Williamson County' GROUP BY r.r_reason_desc ORDER BY total_store_refunded DESC, total_catalog_refunded DESC;
