SELECT i_category, i_brand, sum(i_current_price) as total_sales, avg(i_current_price) as avg_price, count(i_item_sk) as item_count, sum(inv_quantity_on_hand) as total_inventory, sum(wr_return_amt_inc_tax) as total_returns, avg(wr_fee) as avg_return_fee, count(distinct wp_web_page_sk) as page_count, sum(case when wp_autogen_flag = 'Y' then 1 else 0 end) as autogen_page_count FROM item LEFT JOIN inventory ON i_item_sk = inv_item_sk LEFT JOIN web_returns ON i_item_sk = wr_item_sk LEFT JOIN web_page ON wr_web_page_sk = wp_web_page_sk LEFT JOIN promotion ON i_item_sk = p_item_sk WHERE i_rec_end_date IS NULL AND (i_category = 'Electronics' OR i_category = 'Home Goods') AND wp_url = 'http://www.foo.com' AND p_discount_active = 'Y' GROUP BY i_category, i_brand ORDER BY total_sales DESC, total_inventory DESC;
SELECT sm.sm_type, COUNT(DISTINCT ws.ws_order_number) AS total_orders, SUM(ws.ws_quantity) AS total_quantity_sold, AVG(ws.ws_wholesale_cost) AS avg_wholesale_cost, AVG(ws.ws_sales_price) AS avg_sales_price, SUM(ws.ws_net_profit) AS total_net_profit FROM web_sales ws JOIN ship_mode sm ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk JOIN warehouse w ON ws.ws_warehouse_sk = w.w_warehouse_sk WHERE w.w_zip = '35709' AND ws.ws_web_site_sk IN (30, 17, 4, 15, 14, 2) AND sm.sm_ship_mode_sk IN (4, 9, 13, 10, 8, 20) GROUP BY sm.sm_type ORDER BY total_net_profit DESC;
SELECT td.t_shift, sum(ws.ws_quantity) AS total_quantity_sold, avg(ws.ws_sales_price) AS average_sales_price, count(distinct ws.ws_order_number) AS total_orders, count(distinct hd.hd_demo_sk) AS unique_customers, sum(ws.ws_net_profit) AS total_net_profit FROM web_sales ws JOIN time_dim td ON ws.ws_sold_time_sk = td.t_time_sk JOIN household_demographics hd ON ws.ws_bill_hdemo_sk = hd.hd_demo_sk WHERE ws.ws_sold_date_sk IS NOT NULL AND ws.ws_warehouse_sk IN (1, 2) AND hd.hd_demo_sk IN (821, 42, 4135, 4677, 808) GROUP BY ROLLUP(td.t_shift) ORDER BY total_net_profit DESC, td.t_shift;
SELECT i.i_category, AVG(ss.ss_quantity) AS avg_quantity_sold, AVG(ss.ss_sales_price) AS avg_sales_price, AVG(ss.ss_ext_discount_amt) AS avg_discount_amount, COUNT(DISTINCT ss.ss_ticket_number) AS total_sales_tickets, COUNT(DISTINCT hd.hd_demo_sk) AS total_high_income_household FROM store_sales ss JOIN item i ON ss.ss_item_sk = i.i_item_sk JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk WHERE ib.ib_lower_bound > ( SELECT AVG(ib_inner.ib_lower_bound) FROM income_band ib_inner ) AND ss.ss_net_paid > 2000 AND hd.hd_vehicle_count BETWEEN 2 AND 4 GROUP BY ROLLUP(i.i_category) ORDER BY i.i_category, avg_sales_price DESC;
SELECT i.i_category, i.i_brand, COUNT(DISTINCT ss.ss_ticket_number) AS total_sales_tickets, SUM(ss.ss_quantity) AS total_items_sold, AVG(ss.ss_sales_price) AS avg_sales_price, SUM(ss.ss_net_profit) AS total_sales_profit, COUNT(DISTINCT sr.sr_ticket_number) AS total_return_tickets, SUM(sr.sr_return_quantity) AS total_items_returned, AVG(sr.sr_return_amt) AS avg_return_amount, SUM(sr.sr_net_loss) AS total_return_loss, AVG(hd.hd_dep_count) AS avg_dependency_count, AVG(hd.hd_vehicle_count) AS avg_vehicle_count FROM item i JOIN store_sales ss ON i.i_item_sk = ss.ss_item_sk LEFT JOIN store_returns sr ON i.i_item_sk = sr.sr_item_sk AND ss.ss_ticket_number = sr.sr_ticket_number LEFT JOIN household_demographics hd ON ss.ss_hdemo_sk = hd.hd_demo_sk WHERE i.i_brand IN ('corpunivamalg #17', 'namelessnameless #4', 'brandmaxi #10', 'exportimaxi #7') AND i.i_size IN ('large', 'N/A') AND ss.ss_hdemo_sk IN (4195, 6112, 6478, 517, 450, 4114) AND ss.ss_net_paid BETWEEN 34.68 AND 1485.96 GROUP BY i.i_category, i.i_brand ORDER BY total_sales_profit DESC, total_return_loss ASC;
SELECT d_year, d_quarter_name, cc_name, SUM(cs_quantity) AS total_quantity_sold, SUM(cs_net_paid) AS total_net_paid, AVG(cs_net_profit) AS average_net_profit, COUNT(DISTINCT cs_order_number) AS number_of_orders, SUM(ws_quantity) AS total_web_quantity_sold, SUM(ws_net_paid) AS total_web_net_paid, AVG(ws_net_profit) AS average_web_net_profit, COUNT(DISTINCT ws_order_number) AS number_of_web_orders, SUM(cr_return_quantity) AS total_return_quantity, SUM(cr_return_amount) AS total_return_amount, AVG(cr_net_loss) AS average_net_loss, COUNT(DISTINCT cr_order_number) AS number_of_returns FROM date_dim JOIN catalog_sales ON cs_sold_date_sk = d_date_sk JOIN web_sales ON ws_sold_date_sk = d_date_sk JOIN catalog_returns ON cr_returned_date_sk = d_date_sk JOIN call_center ON cs_call_center_sk = cc_call_center_sk WHERE d_fy_year IN ('1910', '1903', '1905', '1900') AND (cs_net_paid_inc_ship_tax IN ('289.42', '1479.37') OR ws_net_paid_inc_ship_tax IN ('3079.90', '243.98', '3911.52')) GROUP BY d_year, d_quarter_name, cc_name ORDER BY d_year, d_quarter_name, cc_name;
SELECT cd.cd_credit_rating, wp.wp_type, AVG(ws.ws_sales_price) AS avg_sales_amount, SUM(ws.ws_ext_ship_cost) AS total_shipping_cost, AVG(ws.ws_quantity) AS avg_items_per_order, SUM(wr.wr_return_amt) AS total_return_amount, SUM(wr.wr_return_amt_inc_tax) AS total_return_amount_inc_tax FROM web_sales ws JOIN customer_demographics cd ON ws.ws_bill_cdemo_sk = cd.cd_demo_sk JOIN web_page wp ON ws.ws_web_page_sk = wp.wp_web_page_sk LEFT JOIN web_returns wr ON ws.ws_order_number = wr.wr_order_number WHERE cd.cd_credit_rating IN ('Unknown', 'Good', 'High Risk') AND wp.wp_url = 'http://www.foo.com' AND ws.ws_ship_customer_sk IN ('68344', '31854', '75904', '57654') AND ws.ws_ext_ship_cost = 1302.64 AND wp.wp_creation_date_sk IN ('2450810', '2450815', '2450813') AND wr.wr_refunded_customer_sk IN ('21890', '47305', '48588', '57226', '74434') AND wr.wr_order_number IN ('3277', '3156') GROUP BY cd.cd_credit_rating, wp.wp_type ORDER BY total_shipping_cost DESC, avg_sales_amount DESC;
SELECT dd.d_year, dd.d_quarter_name, SUM(ss.ss_quantity) AS total_quantity_sold, AVG(ss.ss_sales_price) AS average_sales_price, SUM(ss.ss_net_paid) AS total_net_paid, COUNT(DISTINCT ca.ca_city) AS number_of_cities, COUNT(DISTINCT ws.web_site_sk) AS number_of_websites, SUM(cr.cr_return_quantity) AS total_return_quantity, AVG(cr.cr_return_amount) AS average_return_amount, SUM(cr.cr_net_loss) AS total_net_loss FROM store_sales ss JOIN date_dim dd ON ss.ss_sold_date_sk = dd.d_date_sk JOIN customer_address ca ON ss.ss_addr_sk = ca.ca_address_sk JOIN web_site ws ON ws.web_open_date_sk = dd.d_date_sk LEFT JOIN catalog_returns cr ON cr.cr_returned_date_sk = dd.d_date_sk WHERE dd.d_year IN (2001, 2002) AND ca.ca_street_number = '789' AND ws.web_city IN ('Fairview', 'Midway') AND dd.d_quarter_seq IN (20, 49, 51) AND cr.cr_reason_sk IS NOT NULL AND EXISTS (SELECT 1 FROM reason WHERE cr_reason_sk = r_reason_sk AND r_reason_desc IN ('Gift exchange', 'Found a better price in a store', 'Not the product that was ordred')) GROUP BY dd.d_year, dd.d_quarter_name ORDER BY dd.d_year, dd.d_quarter_name;
SELECT cc.cc_name AS call_center_name, w.w_warehouse_name AS warehouse_name, s.s_state AS state, SUM(cs.cs_quantity) AS total_items_sold, AVG(cs.cs_sales_price) AS average_sales_price, COUNT(DISTINCT cs.cs_item_sk) AS number_of_unique_items_sold FROM catalog_sales cs INNER JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk INNER JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk INNER JOIN store s ON cc.cc_division = s.s_division_id WHERE cc.cc_market_manager IN ('Matthew Clifton', 'Gary Colburn') AND s.s_country = 'United States' GROUP BY call_center_name, warehouse_name, state ORDER BY total_items_sold DESC, average_sales_price DESC;
SELECT hd.hd_dep_count, hd.hd_vehicle_count, ib.ib_lower_bound, ib.ib_upper_bound, COUNT(DISTINCT p.p_promo_sk) AS num_promotions, SUM(p.p_cost) AS total_promo_cost, AVG(p.p_cost) AS avg_promo_cost, COUNT(DISTINCT r.r_reason_sk) AS num_reasons, AVG(hd.hd_vehicle_count) AS avg_vehicle_count, SUM(CASE WHEN p.p_channel_event = 'N' THEN 1 ELSE 0 END) AS non_event_promos, SUM(CASE WHEN p.p_response_target = 1 THEN 1 ELSE 0 END) AS target_response_promos FROM promotion p JOIN household_demographics hd ON p.p_item_sk = hd.hd_demo_sk JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk LEFT JOIN reason r ON r.r_reason_sk = p.p_promo_sk WHERE p.p_channel_event = 'N' AND p.p_response_target = 1 GROUP BY hd.hd_dep_count, hd.hd_vehicle_count, ib.ib_lower_bound, ib.ib_upper_bound ORDER BY total_promo_cost DESC, num_promotions DESC;
SELECT i.i_category, i.i_brand, w.w_state, COUNT(DISTINCT cr.cr_order_number) as total_returns, SUM(cr.cr_return_amount) as total_return_amount, AVG(cr.cr_return_amount) as avg_return_amount, SUM(cr.cr_return_quantity) as total_return_quantity, AVG(cr.cr_return_quantity) as avg_return_quantity, COUNT(DISTINCT wr.wr_order_number) as total_web_returns, SUM(wr.wr_return_amt) as total_web_return_amount, AVG(wr.wr_return_amt) as avg_web_return_amount, SUM(wr.wr_return_quantity) as total_web_return_quantity, AVG(wr.wr_return_quantity) as avg_web_return_quantity, SUM(cr.cr_refunded_cash + wr.wr_refunded_cash) as total_refunded_cash, SUM(cr.cr_return_ship_cost + wr.wr_return_ship_cost) as total_shipping_cost FROM catalog_returns cr JOIN item i ON cr.cr_item_sk = i.i_item_sk JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk LEFT JOIN web_returns wr ON cr.cr_item_sk = wr.wr_item_sk AND cr.cr_order_number = wr.wr_order_number GROUP BY i.i_category, i.i_brand, w.w_state ORDER BY total_returns DESC, total_return_amount DESC, total_web_returns DESC, total_web_return_amount DESC;
SELECT w_state, EXTRACT(YEAR FROM wp_rec_end_date) AS year, SUM(cr_return_amount) AS total_return_amount, AVG(cr_return_amount) AS avg_return_amount, COUNT(DISTINCT cr_refunded_customer_sk) AS unique_customers, COUNT(cr_order_number) AS total_returns, SUM(cr_return_quantity) AS total_returned_items FROM catalog_returns cr JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk JOIN web_page wp ON cr.cr_catalog_page_sk = wp.wp_web_page_sk WHERE wp.wp_rec_end_date BETWEEN '1999-01-01' AND CURRENT_DATE GROUP BY w_state, year ORDER BY w_state, year;
SELECT ib.ib_lower_bound, ib.ib_upper_bound, COUNT(DISTINCT cc.cc_call_center_sk) AS number_of_call_centers, AVG(cc.cc_employees) AS average_employees, SUM(p.p_cost) AS total_promotion_cost, COUNT(DISTINCT p.p_promo_sk) AS number_of_promotions FROM call_center cc JOIN promotion p ON (cc.cc_mkt_id = p.p_promo_sk) JOIN income_band ib ON (cc.cc_gmt_offset >= ib.ib_lower_bound AND cc.cc_gmt_offset < ib.ib_upper_bound) WHERE cc.cc_country = 'United States' AND cc.cc_rec_end_date IS NULL AND p.p_cost = 1000.00 AND ib.ib_lower_bound IN (30001, 10001, 140001, 90001, 0) GROUP BY ib.ib_income_band_sk, ib.ib_lower_bound, ib.ib_upper_bound ORDER BY ib.ib_lower_bound;
SELECT cc.cc_call_center_id, cc.cc_name, cc.cc_city, cc.cc_state, AVG(ss.ss_sales_price) AS average_sale_price, SUM(ss.ss_net_paid) AS total_sales, COUNT(ss.ss_ticket_number) AS number_of_sales FROM store_sales ss INNER JOIN call_center cc ON ss.ss_store_sk = cc.cc_call_center_sk GROUP BY cc.cc_call_center_id, cc.cc_name, cc.cc_city, cc.cc_state ORDER BY total_sales DESC, average_sale_price DESC LIMIT 10;
SELECT web.web_name AS website_name, cp.cp_department AS catalog_department, hd.hd_vehicle_count AS vehicle_count, r.r_reason_desc AS return_reason, COUNT(cr.cr_item_sk) AS total_returns, SUM(cr.cr_return_quantity) AS total_returned_quantity, AVG(cr.cr_return_amount) AS avg_return_amount, SUM(cr.cr_return_amount) AS total_return_amount, AVG(cr.cr_return_amt_inc_tax) AS avg_return_amount_incl_tax, SUM(cr.cr_return_amt_inc_tax) AS total_return_amount_incl_tax, SUM(cr.cr_fee) AS total_fees, SUM(cr.cr_net_loss) AS total_net_loss FROM web_site web JOIN catalog_returns cr ON web.web_site_sk = cr.cr_returning_addr_sk JOIN catalog_page cp ON cr.cr_catalog_page_sk = cp.cp_catalog_page_sk JOIN reason r ON cr.cr_reason_sk = r.r_reason_sk JOIN household_demographics hd ON cr.cr_returning_hdemo_sk = hd.hd_demo_sk WHERE web.web_company_id IN ('4', '1', '3') AND cp.cp_end_date_sk IN ('2451144', '2451389') AND hd.hd_vehicle_count IN ('3', '1', '4', '0') GROUP BY web_name, cp_department, vehicle_count, return_reason ORDER BY total_returns DESC, total_return_amount DESC;
SELECT r.r_reason_desc, COUNT(*) AS total_returns, SUM(sr_return_amt) AS total_return_amount, AVG(sr_return_amt) AS average_return_amount, SUM(sr_return_quantity) AS total_returned_quantity, SUM(sr_fee) AS total_return_fees, SUM(sr_net_loss) AS total_net_loss FROM store_returns sr JOIN reason r ON sr.sr_reason_sk = r.r_reason_sk WHERE sr.sr_return_amt > 0 AND r.r_reason_desc IN ('reason 26', 'reason 34', 'Did not fit', 'Not the product that was ordred') GROUP BY r.r_reason_desc ORDER BY total_return_amount DESC;
SELECT hd.hd_income_band_sk, sm.sm_type, COUNT(DISTINCT wr.wr_order_number) AS total_returns, SUM(wr.wr_return_quantity) AS total_returned_quantity, AVG(wr.wr_return_amt) AS avg_return_amount, SUM(wr.wr_return_amt) AS sum_return_amount, SUM(wr.wr_fee) AS sum_fees, SUM(wr.wr_return_ship_cost) AS sum_shipping_costs, SUM(wr.wr_net_loss) AS sum_net_loss FROM web_returns wr JOIN household_demographics hd ON wr.wr_refunded_hdemo_sk = hd.hd_demo_sk JOIN ship_mode sm ON sm.sm_ship_mode_sk = wr.wr_returned_time_sk GROUP BY hd.hd_income_band_sk, sm.sm_type ORDER BY sum_net_loss DESC;
