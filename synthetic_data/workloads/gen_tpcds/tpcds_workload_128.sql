SELECT cp.cp_department, COUNT(DISTINCT cp.cp_catalog_page_sk) AS catalog_pages, AVG(p.p_cost) AS avg_promo_cost, SUM(sr.sr_return_quantity) AS total_returned_quantity, SUM(sr.sr_return_amt) AS total_returned_amount, SUM(sr.sr_net_loss) AS total_net_loss, COUNT(DISTINCT c.c_customer_sk) AS unique_customers, COUNT(sr.sr_item_sk) AS return_transactions, COUNT(DISTINCT r.r_reason_sk) AS distinct_reasons, EXTRACT(YEAR FROM TO_DATE(t.t_time_id, 'YYYYMMDDHH24MISS')) AS return_year FROM catalog_page cp JOIN promotion p ON cp.cp_start_date_sk = p.p_start_date_sk AND cp.cp_end_date_sk = p.p_end_date_sk JOIN store_returns sr ON p.p_item_sk = sr.sr_item_sk JOIN customer c ON sr.sr_customer_sk = c.c_customer_sk JOIN reason r ON sr.sr_reason_sk = r.r_reason_sk JOIN time_dim t ON sr.sr_return_time_sk = t.t_time_sk WHERE t.t_shift = 'third' AND sr.sr_return_tax IN (41.01, 56.78, 283.72) AND cp.cp_catalog_page_id IN ('AAAAAAAAAGFAAAAA', 'AAAAAAAACAJAAAAA', 'AAAAAAAANMNAAAAA', 'AAAAAAAAHGNAAAAA', 'AAAAAAAANFOAAAAA') AND r.r_reason_id IN ('AAAAAAAAGBAAAAAA', 'AAAAAAAALBAAAAAA', 'AAAAAAAAGAAAAAAA') GROUP BY cp.cp_department, EXTRACT(YEAR FROM TO_DATE(t.t_time_id, 'YYYYMMDDHH24MISS')) ORDER BY cp.cp_department, return_year;
SELECT cc.cc_name AS call_center_name, i.i_brand AS item_brand, sum(ws.ws_sales_price) AS total_sales, avg(ws.ws_sales_price) AS average_sales_price, count(ws.ws_order_number) AS total_orders, sum(wr.wr_return_amt) AS total_returns, avg(wr.wr_return_amt) AS average_return_amount, count(DISTINCT wr.wr_order_number) AS total_return_orders, sum(hd.hd_dep_count) AS total_dependents, sum(hd.hd_vehicle_count) AS total_vehicles FROM call_center cc JOIN web_sales ws ON cc.cc_call_center_sk = ws.ws_warehouse_sk JOIN web_returns wr ON ws.ws_item_sk = wr.wr_item_sk AND ws.ws_order_number = wr.wr_order_number JOIN item i ON ws.ws_item_sk = i.i_item_sk JOIN household_demographics hd ON ws.ws_bill_hdemo_sk = hd.hd_demo_sk WHERE cc.cc_name IN ('North Midwest', 'NY Metro') AND i.i_brand_id IN ('6007005', '10003009', '4001002') AND i.i_wholesale_cost IN (24.96, 1.76, 2.66, 5.22) GROUP BY cc.cc_name, i.i_brand ORDER BY total_sales DESC, total_returns DESC;
SELECT i.i_category, i.i_class, i.i_brand, COUNT(DISTINCT cs.cs_order_number) AS total_orders, SUM(cs.cs_quantity) AS total_quantity_sold, AVG(cs.cs_sales_price) AS avg_sales_price, SUM(cs.cs_net_paid) AS total_net_paid, SUM(wr.wr_return_quantity) AS total_quantity_returned, SUM(wr.wr_return_amt) AS total_return_amt, AVG(wr.wr_fee) AS avg_return_fee, COUNT(DISTINCT c.c_customer_sk) AS total_customers, SUM(CASE WHEN c.c_preferred_cust_flag = 'Y' THEN cs.cs_net_paid ELSE 0 END) AS preferred_customer_sales, COUNT(DISTINCT CASE WHEN c.c_preferred_cust_flag = 'Y' THEN c.c_customer_sk ELSE NULL END) AS preferred_customer_count FROM item i JOIN catalog_sales cs ON i.i_item_sk = cs.cs_item_sk LEFT JOIN web_returns wr ON cs.cs_item_sk = wr.wr_item_sk AND cs.cs_order_number = wr.wr_order_number JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk GROUP BY i.i_category, i.i_class, i.i_brand ORDER BY total_net_paid DESC, total_return_amt DESC, avg_sales_price DESC LIMIT 100;
SELECT ib.ib_lower_bound, ib.ib_upper_bound, cc.cc_state, d.d_year, SUM(cs.cs_net_paid) AS total_sales, AVG(cs.cs_ext_discount_amt) AS average_discount, COUNT(DISTINCT cs.cs_order_number) AS total_orders FROM catalog_sales cs JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk JOIN income_band ib ON cs.cs_bill_customer_sk = ib.ib_income_band_sk JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk WHERE d.d_year = 2003 AND ib.ib_upper_bound IN (40000, 90000, 100000, 20000, 140000, 180000) AND cc.cc_state = 'TN' GROUP BY ib.ib_lower_bound, ib.ib_upper_bound, cc.cc_state, d.d_year ORDER BY ib.ib_lower_bound, total_sales DESC;
SELECT cp.cp_department, hd.hd_income_band_sk, COUNT(DISTINCT sr.sr_ticket_number) AS total_returns, SUM(sr.sr_return_quantity) AS total_returned_items, AVG(sr.sr_return_amt) AS average_return_amount, SUM(sr.sr_net_loss) AS total_net_loss, web.web_class, COUNT(DISTINCT web.web_site_sk) AS total_web_sites FROM catalog_page cp JOIN store_returns sr ON cp.cp_catalog_page_sk = sr.sr_item_sk JOIN household_demographics hd ON sr.sr_hdemo_sk = hd.hd_demo_sk JOIN web_site web ON web.web_company_id = cp.cp_catalog_number WHERE cp.cp_start_date_sk IS NOT NULL AND cp.cp_end_date_sk IS NOT NULL AND sr.sr_returned_date_sk BETWEEN cp.cp_start_date_sk AND cp.cp_end_date_sk AND (sr.sr_reversed_charge = 63.95 OR sr.sr_reversed_charge = 41.39) GROUP BY cp.cp_department, hd.hd_income_band_sk, web.web_class ORDER BY total_returns DESC, total_net_loss DESC;
