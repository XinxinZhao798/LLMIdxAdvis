SELECT cp.cp_department, AVG(cr.cr_return_amount) AS avg_return_amount, SUM(cr.cr_return_quantity) AS total_return_quantity, COUNT(DISTINCT cr.cr_returned_date_sk) AS num_return_dates, SUM(ss.ss_net_paid) AS total_store_sales, SUM(ss.ss_quantity) AS total_store_quantity_sold, AVG(ws.ws_net_profit) AS avg_web_net_profit, SUM(ws.ws_quantity) AS total_web_quantity_sold FROM catalog_page cp JOIN catalog_returns cr ON cp.cp_catalog_page_sk = cr.cr_catalog_page_sk JOIN store_sales ss ON ss.ss_customer_sk = cr.cr_refunded_customer_sk JOIN web_sales ws ON ws.ws_bill_customer_sk = cr.cr_refunded_customer_sk WHERE cp.cp_end_date_sk BETWEEN 2450964 AND 2451694 AND cr.cr_return_amt_inc_tax BETWEEN 500 AND 1500 AND ss.ss_net_paid BETWEEN 500 AND 2100 AND ws.ws_ext_ship_cost BETWEEN 50 AND 1000 GROUP BY cp.cp_department ORDER BY total_return_quantity DESC, avg_return_amount DESC;
SELECT dd.d_year, dd.d_quarter_name, COUNT(DISTINCT cr.cr_order_number) AS catalog_return_orders, SUM(cr.cr_return_quantity) AS total_catalog_returned_qty, AVG(cr.cr_return_amount) AS avg_catalog_return_amount, SUM(cr.cr_net_loss) AS total_catalog_net_loss, COUNT(DISTINCT wr.wr_order_number) AS web_return_orders, SUM(wr.wr_return_quantity) AS total_web_returned_qty, AVG(wr.wr_return_amt) AS avg_web_return_amount, SUM(wr.wr_net_loss) AS total_web_net_loss, COUNT(DISTINCT h.hd_demo_sk) AS unique_households_affected, SUM(CASE WHEN i.i_rec_end_date = '2001-10-26' THEN cr.cr_return_quantity ELSE 0 END) AS qty_items_end_date_oct26 FROM date_dim dd LEFT JOIN catalog_returns cr ON dd.d_date_sk = cr.cr_returned_date_sk LEFT JOIN web_returns wr ON dd.d_date_sk = wr.wr_returned_date_sk LEFT JOIN item i ON cr.cr_item_sk = i.i_item_sk OR wr.wr_item_sk = i.i_item_sk LEFT JOIN household_demographics h ON cr.cr_returning_hdemo_sk = h.hd_demo_sk OR wr.wr_returning_hdemo_sk = h.hd_demo_sk WHERE dd.d_date IS NOT NULL AND (cr.cr_return_amount > 0 OR wr.wr_return_amt > 0) AND (cr.cr_reason_sk = 28 OR wr.wr_reason_sk = 28) GROUP BY dd.d_year, dd.d_quarter_name ORDER BY dd.d_year, dd.d_quarter_name;
SELECT cs.cs_call_center_sk, cc.cc_name AS call_center_name, cp.cp_catalog_page_id, cp.cp_department, COUNT(cs.cs_order_number) AS total_orders, SUM(cs.cs_quantity) AS total_quantity_sold, AVG(cs.cs_sales_price) AS avg_sales_price, SUM(cs.cs_net_paid) AS total_revenue, SUM(cs.cs_net_profit) AS total_profit, AVG(cs.cs_net_profit) AS avg_profit_per_sale, cd.cd_marital_status, COUNT(DISTINCT cs.cs_bill_customer_sk) AS unique_customers, SUM(inv.inv_quantity_on_hand) AS total_inventory_on_hand FROM catalog_sales cs LEFT JOIN call_center cc ON cs.cs_call_center_sk = cc.cc_call_center_sk LEFT JOIN catalog_page cp ON cs.cs_catalog_page_sk = cp.cp_catalog_page_sk LEFT JOIN customer_demographics cd ON cs.cs_bill_cdemo_sk = cd.cd_demo_sk LEFT JOIN inventory inv ON cs.cs_item_sk = inv.inv_item_sk AND cs_sold_date_sk = inv.inv_date_sk WHERE cc.cc_country = 'United States' AND cs.cs_net_profit > 0 AND inv.inv_date_sk = 2450815 GROUP BY cs.cs_call_center_sk, call_center_name, cp.cp_catalog_page_id, cp.cp_department, cd.cd_marital_status ORDER BY total_revenue DESC, total_profit DESC LIMIT 100;
SELECT i.i_item_id, i.i_category, SUM(cs.cs_net_paid) AS total_sales, AVG(cs.cs_sales_price) AS avg_sales_price, COUNT(DISTINCT c.c_customer_sk) AS unique_customers, SUM(cs.cs_quantity) AS total_quantity_sold, AVG(cs.cs_net_profit) AS avg_net_profit, COUNT(DISTINCT w.w_warehouse_sk) AS number_of_warehouses_used FROM catalog_sales cs JOIN item i ON cs.cs_item_sk = i.i_item_sk JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk JOIN warehouse w ON cs.cs_warehouse_sk = w.w_warehouse_sk WHERE i.i_category IN ('Electronics', 'Clothing') AND c.c_email_address LIKE '%@%' AND cs.cs_sold_date_sk BETWEEN 20000101 AND 20001231 GROUP BY i.i_item_id, i.i_category ORDER BY total_sales DESC, avg_sales_price DESC LIMIT 10;
SELECT w.web_class AS website_category, ca.ca_state AS customer_state, COUNT(ws.ws_order_number) AS total_orders, SUM(ws.ws_net_paid_inc_ship_tax) AS total_sales, AVG(ws.ws_ext_discount_amt) AS avg_discount_amount, AVG(ws.ws_net_profit) AS avg_net_profit FROM web_sales ws JOIN web_site w ON ws.ws_web_site_sk = w.web_site_sk JOIN customer_address ca ON ws.ws_ship_addr_sk = ca.ca_address_sk WHERE ws.ws_net_paid_inc_ship BETWEEN 500 AND 9500 GROUP BY ROLLUP(website_category, customer_state) ORDER BY total_sales DESC, website_category, customer_state;
SELECT d_year, i_category, SUM(ws_net_paid_inc_tax) AS total_sales, AVG(ws_quantity) AS average_quantity, COUNT(DISTINCT ws_bill_customer_sk) AS unique_customers, SUM(cr_net_loss) AS total_returns_loss, COUNT(DISTINCT cr_returned_date_sk) AS return_days FROM web_sales JOIN date_dim ON ws_sold_date_sk = d_date_sk JOIN item ON ws_item_sk = i_item_sk LEFT JOIN catalog_returns ON ws_item_sk = cr_item_sk AND ws_order_number = cr_order_number WHERE d_year = 2002 AND ws_net_paid_inc_tax > 0 AND d_current_year = 'N' GROUP BY d_year, i_category ORDER BY total_sales DESC;
SELECT ca_state, i_category, sm_type, COUNT(DISTINCT c_customer_sk) AS num_customers, SUM(ss_quantity) AS total_quantity_sold, AVG(ss_sales_price) AS avg_sales_price, SUM(ss_net_profit) AS total_net_profit FROM store_sales JOIN customer ON ss_customer_sk = c_customer_sk JOIN item ON ss_item_sk = i_item_sk JOIN ship_mode ON ss_sold_date_sk = sm_ship_mode_sk JOIN customer_address ON c_current_addr_sk = ca_address_sk WHERE ca_gmt_offset IN (-10.00, -6.00, -5.00) AND i_units IN ('Each', 'Dozen', 'Tsp') AND sm_type IN ('REGULAR', 'OVERNIGHT', 'EXPRESS') AND c_first_sales_date_sk IN (2450027, 2449229, 2451727) GROUP BY ca_state, i_category, sm_type ORDER BY total_net_profit DESC, avg_sales_price DESC;
