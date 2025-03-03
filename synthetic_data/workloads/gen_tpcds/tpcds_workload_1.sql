SELECT dd.d_year, dd.d_quarter_name, cp.cp_department, COUNT(DISTINCT cs.cs_order_number) AS total_orders, SUM(cs.cs_quantity) AS total_quantity_sold, SUM(cs.cs_net_paid) AS total_net_paid, AVG(cs.cs_net_paid / cs.cs_quantity) AS avg_net_paid_per_item, SUM(cs.cs_net_profit) AS total_net_profit FROM catalog_sales cs JOIN date_dim dd ON cs.cs_sold_date_sk = dd.d_date_sk JOIN catalog_page cp ON cs.cs_catalog_page_sk = cp.cp_catalog_page_sk WHERE dd.d_current_day = 'N' AND dd.d_qoy = '3' AND cs.cs_ship_hdemo_sk IN ('340', '2787', '2515', '487', '576', '6271') AND cp.cp_catalog_page_sk IN ('1948', '1122', '4477', '1780') GROUP BY dd.d_year, dd.d_quarter_name, cp.cp_department ORDER BY dd.d_year, dd.d_quarter_name, cp.cp_department;
SELECT w_state, COUNT(DISTINCT c_customer_sk) AS number_of_customers, AVG(inv_quantity_on_hand) AS average_inventory, SUM(case when c_preferred_cust_flag = 'Y' then 1 else 0 end) AS preferred_customer_count, MAX(wp_link_count) AS max_webpage_link_count, MIN(web_tax_percentage) AS min_tax_percentage FROM customer JOIN warehouse ON c_current_addr_sk = w_warehouse_sk JOIN inventory ON inv_warehouse_sk = w_warehouse_sk JOIN web_page ON wp_customer_sk = c_customer_sk JOIN web_site ON wp_web_page_sk = web_site_sk AND web_class <> 'Unknown' WHERE web_close_date_sk IN ('2446944', '2446978', '2447046') GROUP BY w_state ORDER BY number_of_customers DESC, average_inventory DESC;
SELECT d.d_year, d.d_month_seq, COUNT(DISTINCT cp.cp_catalog_page_sk) AS total_catalog_pages, AVG(w.w_warehouse_sq_ft) AS avg_warehouse_size, SUM(p.p_cost) AS total_promotion_cost, COUNT(DISTINCT ca.ca_state) AS num_states_with_customers, COUNT(DISTINCT w.w_state) AS num_states_with_warehouses, SUM(CASE WHEN p.p_channel_press = 'N' THEN p.p_cost ELSE 0 END) AS total_cost_non_press_channel FROM date_dim d JOIN catalog_page cp ON (d.d_date_sk = cp.cp_start_date_sk OR d.d_date_sk = cp.cp_end_date_sk) JOIN promotion p ON (p.p_start_date_sk = d.d_date_sk OR p.p_end_date_sk = d.d_date_sk) JOIN customer_address ca ON cp.cp_catalog_page_sk = ca.ca_address_sk JOIN warehouse w ON w.w_zip = ca.ca_zip WHERE d.d_fy_quarter_seq IN (41, 35, 15, 54, 14, 9) AND cp.cp_catalog_number IN (27, 41) AND d.d_year = 2023 GROUP BY d.d_year, d.d_month_seq ORDER BY d.d_year, d.d_month_seq;
SELECT s.s_store_id, s.s_store_name, AVG(sr.sr_refunded_cash) AS avg_refunded_cash, SUM(sr.sr_refunded_cash) AS total_refunded_cash, COUNT(sr.sr_ticket_number) AS total_returns, AVG(sr.sr_net_loss) AS avg_net_loss, cd.cd_education_status, cd.cd_marital_status, COUNT(cd.cd_demo_sk) AS demographic_count FROM store_returns sr JOIN store s ON sr.sr_store_sk = s.s_store_sk JOIN customer_demographics cd ON sr.sr_cdemo_sk = cd.cd_demo_sk WHERE s.s_store_sk = 2 AND sr.sr_refunded_cash = 63.85 GROUP BY s.s_store_id, s.s_store_name, cd.cd_education_status, cd.cd_marital_status ORDER BY total_refunded_cash DESC, avg_net_loss DESC;
SELECT cp.cp_department, i.i_category, w.w_state, SUM(cr.cr_return_quantity) AS total_returned_quantity, AVG(cr.cr_return_amount) AS avg_return_amount, SUM(cr.cr_return_amount) AS total_return_amount, COUNT(DISTINCT cr.cr_returned_date_sk) AS count_return_days, SUM(inv.inv_quantity_on_hand) AS total_inventory, AVG(i.i_wholesale_cost) AS avg_wholesale_cost, AVG(i.i_current_price) AS avg_current_price, SUM(sr.sr_return_amt) AS total_store_return_amount, AVG(sr.sr_return_amt) AS avg_store_return_amount, COUNT(DISTINCT sr.sr_customer_sk) AS count_distinct_customers_returning FROM catalog_page cp JOIN catalog_returns cr ON cp.cp_catalog_page_sk = cr.cr_catalog_page_sk JOIN item i ON cr.cr_item_sk = i.i_item_sk JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk JOIN inventory inv ON i.i_item_sk = inv.inv_item_sk AND w.w_warehouse_sk = inv.inv_warehouse_sk LEFT JOIN store_returns sr ON i.i_item_sk = sr.sr_item_sk WHERE cp.cp_department = 'DEPARTMENT' AND w.w_state = 'TN' AND (i.i_product_name = 'prin st' OR i.i_product_name = 'eingprin stable') GROUP BY cp.cp_department, i.i_category, w.w_state ORDER BY total_returned_quantity DESC, avg_return_amount DESC;
SELECT c.c_salutation, SUM(ss.ss_quantity) AS store_sales_quantity, AVG(ss.ss_sales_price) AS store_sales_avg_price, SUM(cs.cs_quantity) AS catalog_sales_quantity, AVG(cs.cs_sales_price) AS catalog_sales_avg_price, SUM(ws.ws_quantity) AS web_sales_quantity, AVG(ws.ws_sales_price) AS web_sales_avg_price, AVG(hd.hd_dep_count) AS avg_household_dep_count, AVG(ib.ib_upper_bound) AS avg_income_upper_bound FROM customer c LEFT JOIN store_sales ss ON c.c_customer_sk = ss.ss_customer_sk LEFT JOIN catalog_sales cs ON c.c_customer_sk = cs.cs_bill_customer_sk LEFT JOIN web_sales ws ON c.c_customer_sk = ws.ws_bill_customer_sk LEFT JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk LEFT JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk WHERE c.c_salutation IN ('Mr.', 'Miss', 'Sir') AND hd.hd_buy_potential IN ('5001-10000', 'Unknown', '501-1000', '0-500', '>10000') AND hd.hd_income_band_sk IN (1, 6, 12, 18) AND (ss.ss_sold_time_sk IN (50436, 48475, 51865) OR ss.ss_sold_time_sk IS NULL) AND (ss.ss_ext_wholesale_cost IN (3684.31, 3037.11, 5884.90, 4962.49, 1522.56, 3630.06) OR ss.ss_ext_wholesale_cost IS NULL) GROUP BY c.c_salutation ORDER BY c.c_salutation;
SELECT cd.cd_education_status, cd.cd_marital_status, AVG(cd.cd_purchase_estimate) AS avg_purchase_estimate, AVG(CASE WHEN cd.cd_credit_rating LIKE 'Good%' THEN 1 WHEN cd.cd_credit_rating LIKE 'Fair%' THEN 2 WHEN cd.cd_credit_rating LIKE 'Poor%' THEN 3 ELSE NULL END) AS avg_credit_rating_score, COUNT(DISTINCT wp.wp_web_page_sk) AS web_page_count, wp.wp_type, AVG(wp.wp_link_count) AS avg_link_count, AVG(wp.wp_image_count) AS avg_image_count FROM customer_demographics cd LEFT JOIN web_page wp ON cd.cd_demo_sk = wp.wp_customer_sk LEFT JOIN time_dim td ON wp.wp_access_date_sk = td.t_time_sk WHERE cd.cd_marital_status IN ('D', 'U', 'S', 'M', 'W') AND td.t_hour > 18 AND (td.t_am_pm = 'PM') GROUP BY cd.cd_education_status, cd.cd_marital_status, wp.wp_type ORDER BY cd.cd_education_status, cd.cd_marital_status, web_page_count DESC;
