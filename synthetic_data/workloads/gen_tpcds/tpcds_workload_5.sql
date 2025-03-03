SELECT w_state, cp_department, COUNT(DISTINCT cr_order_number) AS num_returns, SUM(cr_return_quantity) AS total_returned_qty, AVG(cr_return_amount) AS avg_return_amount, SUM(cr_return_amount) AS total_return_amount, SUM(cr_fee) AS total_fees, SUM(cr_return_ship_cost) AS total_shipping_cost, SUM(cr_net_loss) AS total_net_loss FROM catalog_returns JOIN catalog_page ON catalog_returns.cr_catalog_page_sk = catalog_page.cp_catalog_page_sk JOIN warehouse ON catalog_returns.cr_warehouse_sk = warehouse.w_warehouse_sk GROUP BY w_state, cp_department ORDER BY total_return_amount DESC, total_net_loss DESC LIMIT 10;
SELECT cc.cc_name AS CallCenter, SUM(cr.cr_return_amount) AS TotalReturnAmount, AVG(cr.cr_return_amount) AS AverageReturnAmount, COUNT(cr.cr_order_number) AS NumberOfReturns, r.r_reason_desc AS ReturnReason, ib.ib_lower_bound AS IncomeBandLowerBound, ib.ib_upper_bound AS IncomeBandUpperBound, COUNT(DISTINCT ws.ws_order_number) AS NumberOfWebSales, SUM(ws.ws_net_profit) AS TotalWebSalesProfit FROM catalog_returns cr INNER JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk INNER JOIN reason r ON cr.cr_reason_sk = r.r_reason_sk INNER JOIN income_band ib ON cr.cr_refunded_cdemo_sk = ib.ib_income_band_sk LEFT JOIN web_sales ws ON cr.cr_order_number = ws.ws_order_number WHERE cc.cc_market_manager IN ('Julius Durham', 'Matthew Clifton', 'Gary Colburn', 'Julius Tran') AND ib.ib_upper_bound IN (50000, 130000, 180000, 60000, 160000) AND ib.ib_lower_bound IN (0, 50001, 170001, 60001, 110001, 90001) AND ws.ws_warehouse_sk IN (3, 1, 2, 5) AND cc.cc_call_center_id IN ('AAAAAAAACAAAAAAA', 'AAAAAAAABAAAAAAA', 'AAAAAAAAEAAAAAAA') GROUP BY CallCenter, ReturnReason, IncomeBandLowerBound, IncomeBandUpperBound ORDER BY TotalReturnAmount DESC, NumberOfReturns DESC, TotalWebSalesProfit DESC;
SELECT p.p_promo_name AS promotion_name, COUNT(DISTINCT wr.wr_order_number) AS total_returns, SUM(wr.wr_return_quantity) AS total_returned_quantity, AVG(wr.wr_return_amt) AS average_return_amount, SUM(wr.wr_return_amt_inc_tax) - SUM(wr.wr_fee) AS net_loss_after_fees, COUNT(DISTINCT wp.wp_web_page_id) AS distinct_pages_involved, sm.sm_type AS ship_method_type, MAX(wr.wr_return_amt_inc_tax) AS max_return_amount_incl_tax, MIN(wr.wr_return_amt_inc_tax) AS min_return_amount_incl_tax, COUNT(DISTINCT CASE WHEN cd.cd_gender = 'M' THEN wr.wr_returning_customer_sk END) AS male_customers, COUNT(DISTINCT CASE WHEN cd.cd_gender = 'F' THEN wr.wr_returning_customer_sk END) AS female_customers FROM web_returns wr INNER JOIN promotion p ON wr.wr_reason_sk = p.p_promo_sk INNER JOIN web_page wp ON wr.wr_web_page_sk = wp.wp_web_page_sk INNER JOIN ship_mode sm ON CAST(SUBSTRING(wp.wp_url FROM 'http://www.%#"sm"#"%' FOR '#') AS INTEGER) = sm.sm_ship_mode_sk LEFT JOIN customer_demographics cd ON wr.wr_returning_cdemo_sk = cd.cd_demo_sk WHERE wr.wr_returned_date_sk BETWEEN p.p_start_date_sk AND p.p_end_date_sk AND wp.wp_url = 'http://www.foo.com' AND wp.wp_link_count IN (15, 11) AND wr.wr_return_tax = 52.13 GROUP BY p.p_promo_name, sm.sm_type ORDER BY total_returns DESC, net_loss_after_fees DESC;
SELECT w.web_class AS website_category, ca.ca_state AS customer_state, COUNT(ws.ws_order_number) AS total_orders, SUM(ws.ws_net_paid_inc_ship_tax) AS total_sales, AVG(ws.ws_ext_discount_amt) AS avg_discount_amount, AVG(ws.ws_net_profit) AS avg_net_profit FROM web_sales ws JOIN web_site w ON ws.ws_web_site_sk = w.web_site_sk JOIN customer_address ca ON ws.ws_ship_addr_sk = ca.ca_address_sk WHERE ws.ws_net_paid_inc_ship BETWEEN 500 AND 9500 GROUP BY ROLLUP(website_category, customer_state) ORDER BY total_sales DESC, website_category, customer_state;
SELECT item.i_product_name, promotion.p_promo_name, call_center.cc_name, COUNT(DISTINCT catalog_sales.cs_item_sk) AS item_sold_count, SUM(catalog_sales.cs_net_paid) AS total_sales, AVG(catalog_sales.cs_ext_discount_amt / NULLIF(catalog_sales.cs_quantity, 0)) AS average_discount_per_item, SUM(catalog_sales.cs_quantity) AS total_units_sold, promotion.p_channel_dmail, promotion.p_channel_email, promotion.p_channel_catalog, promotion.p_channel_tv, promotion.p_channel_radio, promotion.p_channel_press, promotion.p_channel_event, promotion.p_channel_demo FROM catalog_sales INNER JOIN item ON catalog_sales.cs_item_sk = item.i_item_sk INNER JOIN promotion ON catalog_sales.cs_promo_sk = promotion.p_promo_sk INNER JOIN call_center ON catalog_sales.cs_call_center_sk = call_center.cc_call_center_sk WHERE item.i_product_name IN ('barationbarought', 'ableoughtoughtese', 'ablebarn stpri', 'prioughteingable', 'priationanti') AND promotion.p_promo_sk IN (169, 149, 296, 99) AND call_center.cc_call_center_id IN ('AAAAAAAAEAAAAAAA', 'AAAAAAAABAAAAAAA', 'AAAAAAAACAAAAAAA') AND catalog_sales.cs_sold_date_sk IS NOT NULL AND catalog_sales.cs_sold_date_sk BETWEEN 20000101 AND 20001231 GROUP BY item.i_product_name, promotion.p_promo_name, call_center.cc_name, promotion.p_channel_dmail, promotion.p_channel_email, promotion.p_channel_catalog, promotion.p_channel_tv, promotion.p_channel_radio, promotion.p_channel_press, promotion.p_channel_event, promotion.p_channel_demo ORDER BY total_sales DESC, item_sold_count DESC, average_discount_per_item DESC;
SELECT sm.sm_type, w.w_state, COUNT(DISTINCT cr.cr_order_number) AS total_returns, SUM(cr.cr_return_amount) AS total_return_amount, AVG(cr.cr_return_amount) AS average_return_amount, SUM(cr.cr_net_loss) AS total_net_loss, SUM(cs.cs_sales_price) AS total_sales, AVG(cs.cs_sales_price) AS average_sales_price, SUM(cs.cs_net_profit) AS total_net_profit, SUM(i.inv_quantity_on_hand) AS total_inventory_on_hand FROM catalog_returns cr JOIN ship_mode sm ON cr.cr_ship_mode_sk = sm.sm_ship_mode_sk JOIN warehouse w ON cr.cr_warehouse_sk = w.w_warehouse_sk JOIN catalog_sales cs ON cr.cr_item_sk = cs.cs_item_sk AND cr.cr_order_number = cs.cs_order_number JOIN inventory i ON cr.cr_item_sk = i.inv_item_sk AND w.w_warehouse_sk = i.inv_warehouse_sk WHERE cr.cr_returning_customer_sk IN ('98306', '44541', '85') GROUP BY sm.sm_type, w.w_state ORDER BY total_net_loss DESC;
SELECT ca_state, EXTRACT(YEAR FROM d.d_date) AS sales_year, COUNT(DISTINCT c.c_customer_sk) AS num_customers, SUM(ss_quantity) AS total_quantity_sold, AVG(ss_sales_price) AS avg_sales_price, SUM(ss_net_profit) AS total_net_profit, SUM(sr_return_amt_inc_tax) AS total_returns, AVG(sr_fee) AS avg_return_fee FROM store_sales ss JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk JOIN store_returns sr ON ss.ss_ticket_number = sr.sr_ticket_number AND ss.ss_item_sk = sr.sr_item_sk JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk WHERE ca.ca_state IN ('IL', 'KY', 'OR') AND EXTRACT(YEAR FROM d.d_date) IN (2001, 2002) AND ss.ss_sales_price BETWEEN 100 AND 150 AND sr.sr_return_amt_inc_tax > 0 GROUP BY ca_state, sales_year ORDER BY sales_year DESC, ca_state;
SELECT dd.d_year, dd.d_month_seq, SUM(inv.inv_quantity_on_hand) AS total_inventory, AVG(promo.p_response_target) AS avg_response_target, COUNT(DISTINCT cc.cc_call_center_id) AS num_call_centers, SUM(CASE WHEN promo.p_channel_dmail = 'Y' THEN 1 ELSE 0 END) AS dmail_promo_count, SUM(CASE WHEN promo.p_channel_tv = 'N' THEN 1 ELSE 0 END) AS non_tv_promo_count, ib.ib_income_band_sk, COUNT(DISTINCT inv.inv_item_sk) AS unique_items, COUNT(DISTINCT inv.inv_warehouse_sk) AS unique_warehouses FROM date_dim AS dd JOIN inventory AS inv ON dd.d_date_sk = inv.inv_date_sk JOIN promotion AS promo ON dd.d_date_sk BETWEEN promo.p_start_date_sk AND promo.p_end_date_sk JOIN call_center AS cc ON cc.cc_open_date_sk <= dd.d_date_sk AND (cc.cc_closed_date_sk IS NULL OR cc.cc_closed_date_sk >= dd.d_date_sk) JOIN income_band AS ib ON cc.cc_mkt_id = ib.ib_income_band_sk WHERE dd.d_year = 2000 AND inv.inv_warehouse_sk IN (1, 2) AND inv.inv_item_sk IN (8690, 8431, 8896, 6346) AND dd.d_moy BETWEEN 1 AND 6 GROUP BY dd.d_year, dd.d_month_seq, ib.ib_income_band_sk ORDER BY dd.d_year, dd.d_month_seq, total_inventory DESC;
