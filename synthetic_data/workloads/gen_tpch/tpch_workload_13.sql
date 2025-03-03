SELECT r.r_name AS region, c.c_mktsegment AS market_segment, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(l.l_extendedprice) AS total_sales, AVG(l.l_discount) AS average_discount FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey JOIN lineitem l ON c.c_custkey = l.l_suppkey JOIN part p ON l.l_partkey = p.p_partkey WHERE p.p_brand = 'Brand#12' GROUP BY r.r_name, c.c_mktsegment ORDER BY total_sales DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT c_custkey) AS total_customers, SUM(o_totalprice) AS total_sales, AVG(s_acctbal) AS avg_supplier_acct_balance, MAX(p_retailprice) AS max_part_retail_price FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey JOIN supplier s ON s.s_nationkey = n.n_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey WHERE r.r_regionkey IN ('1', '4') AND c.c_mktsegment IN ('MACHINERY', 'AUTOMOBILE') AND ps.ps_supplycost = '37.33' AND ( c.c_comment LIKE '%y pending foxes sleep blithely at the furi%' OR c.c_comment LIKE '%y final deposits wake slyly quickly express re%' OR c.c_comment LIKE '%t the thinly unusual packages sublate after t%' OR c.c_comment LIKE '%, bold requests haggle silently speci%' ) GROUP BY region, nation ORDER BY total_sales DESC, avg_supplier_acct_balance DESC;
SELECT r.r_name AS region_name, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, COUNT(DISTINCT n.n_nationkey) AS total_nations, SUM(s.s_acctbal) AS total_account_balance, AVG(s.s_acctbal) AS average_account_balance FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey GROUP BY r.r_name ORDER BY total_account_balance DESC;
SELECT r.r_name AS region_name, c.c_mktsegment AS customer_market_segment, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(o.o_totalprice) AS total_order_value, AVG(l.l_discount) AS average_discount, COUNT(DISTINCT s.s_suppkey) AS total_suppliers FROM orders o INNER JOIN customer c ON o.o_custkey = c.c_custkey INNER JOIN nation n ON c.c_nationkey = n.n_nationkey INNER JOIN region r ON n.n_regionkey = r.r_regionkey INNER JOIN lineitem l ON o.o_orderkey = l.l_orderkey INNER JOIN supplier s ON s.s_nationkey = n.n_nationkey WHERE l.l_returnflag <> 'N' AND c.c_mktsegment IN ('BUILDING', 'AUTOMOBILE', 'MACHINERY') AND l.l_shipdate IN ('1997-12-27', '1996-01-22', '1997-03-09', '1994-05-11', '1998-04-17') GROUP BY r.r_name, c.c_mktsegment ORDER BY total_order_value DESC, average_discount ASC;
SELECT r.r_name AS region_name, COUNT(DISTINCT c.c_custkey) AS number_of_customers, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, SUM(l.l_quantity) AS total_quantity_ordered, AVG(l.l_extendedprice) AS average_order_price, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue_after_discount, COUNT(DISTINCT o.o_orderkey) AS number_of_orders FROM region r JOIN supplier s ON s.s_nationkey = r.r_regionkey JOIN customer c ON c.c_nationkey = r.r_regionkey JOIN orders o ON o.o_custkey = c.c_custkey JOIN lineitem l ON l.l_orderkey = o.o_orderkey WHERE r.r_name = 'AFRICA' AND l.l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' AND o.o_shippriority = '0' GROUP BY r.r_name ORDER BY revenue_after_discount DESC;
SELECT c.c_mktsegment, s.s_nationkey, COUNT(DISTINCT c.c_custkey) AS total_customers, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_quantity) AS average_quantity, AVG(l.l_extendedprice) AS average_extended_price FROM customer c JOIN lineitem l ON c.c_custkey = l.l_suppkey JOIN supplier s ON l.l_suppkey = s.s_suppkey WHERE l.l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' AND c.c_acctbal > 0 AND s.s_comment LIKE '%care%' GROUP BY c.c_mktsegment, s.s_nationkey ORDER BY total_revenue DESC, total_customers;
SELECT r_name AS region, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT p_partkey) AS number_of_parts, SUM(l_quantity) AS total_quantity, AVG(ps_supplycost) AS average_supply_cost, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue FROM region JOIN supplier ON s_nationkey = r_regionkey JOIN partsupp ON ps_suppkey = s_suppkey JOIN part ON ps_partkey = p_partkey JOIN lineitem ON l_partkey = p_partkey AND l_suppkey = s_suppkey JOIN orders ON l_orderkey = o_orderkey WHERE o_orderstatus = 'F' AND l_shipmode IN ('AIR', 'RAIL', 'TRUCK') AND s_comment LIKE '%packages%' GROUP BY region ORDER BY total_revenue DESC, region;
SELECT r_name AS region, n_name AS nation, p_brand, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, SUM(l_quantity) AS total_quantity_sold, AVG(l_extendedprice * (1 - l_discount)) AS avg_discounted_price, SUM(l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity) AS total_profit FROM region JOIN nation ON n_regionkey = r_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN partsupp ON ps_suppkey = s_suppkey JOIN part ON p_partkey = ps_partkey JOIN lineitem ON l_partkey = p_partkey AND l_suppkey = s_suppkey WHERE r_regionkey = 4 AND p_brand IN ('Brand#21', 'Brand#44', 'Brand#43', 'Brand#22', 'Brand#13', 'Brand#33') AND (partsupp.ps_comment LIKE '%furiously%' OR partsupp.ps_comment LIKE '%special deposits%') AND (supplier.s_comment LIKE '%s? ironic accounts%' OR supplier.s_comment LIKE '%ts after the slyly%') GROUP BY region, nation, p_brand ORDER BY total_profit DESC, number_of_customers DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS supplier_count, COUNT(DISTINCT c_custkey) AS customer_count, SUM(s_acctbal) AS total_supplier_balance, AVG(s_acctbal) AS average_supplier_balance, SUM(c_acctbal) AS total_customer_balance, AVG(c_acctbal) AS average_customer_balance, SUM(ps_availqty) AS total_parts_available, AVG(ps_supplycost) AS average_supply_cost, SUM(l_extendedprice) AS total_sales, SUM(l_extendedprice * (1 - l_discount)) AS total_discounted_sales, AVG(l_quantity) AS average_quantity_sold, COUNT(DISTINCT p_partkey) AS part_count FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON n_nationkey = s_nationkey JOIN customer ON n_nationkey = c_nationkey JOIN partsupp ON s_suppkey = ps_suppkey JOIN lineitem ON ps_partkey = l_partkey AND ps_suppkey = l_suppkey JOIN part ON p_partkey = l_partkey WHERE s_nationkey IN (8, 17, 5, 9) AND s_address IN ('iRMUcv4DhTAmNMGPMauw,WxwEDthLr3pYUMnfZD', 'Rb0LA4sA0x') AND l_shipdate BETWEEN DATE '1995-01-01' AND DATE '1996-12-31' GROUP BY region, nation ORDER BY total_sales DESC;
SELECT n.n_name AS nation_name, AVG(c.c_acctbal) AS average_account_balance, COUNT(DISTINCT c.c_custkey) AS number_of_customers, p.p_brand, SUM(ps.ps_availqty) AS total_available_quantity, AVG(ps.ps_supplycost) AS average_supply_cost, SUM(p.p_retailprice * ps.ps_availqty) AS total_retail_value FROM nation n JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN partsupp ps ON ps.ps_suppkey = c.c_custkey JOIN part p ON ps.ps_partkey = p.p_partkey WHERE n.n_nationkey IN (23, 7, 17, 9, 24, 13) AND p.p_size = 1 AND p.p_brand IN ('Brand#42', 'Brand#11', 'Brand#45') GROUP BY n.n_name, p.p_brand ORDER BY nation_name, p.p_brand;
SELECT n.n_name AS nation, o.o_orderpriority AS order_priority, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(l.l_quantity) AS total_quantity, SUM(l.l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(l.l_quantity) AS average_quantity_per_order, AVG(l.l_extendedprice * (1 - l_discount)) AS average_revenue_per_order FROM nation AS n JOIN orders AS o ON n.n_nationkey = o.o_custkey JOIN lineitem AS l ON o.o_orderkey = l.l_orderkey WHERE n.n_name IN ('CHINA', 'INDONESIA') AND o.o_orderdate BETWEEN '1996-01-01' AND '1996-12-31' AND o.o_shippriority = '0' GROUP BY nation, order_priority ORDER BY total_revenue DESC;
SELECT n.n_name AS nation_name, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales_value, AVG(l.l_quantity) AS average_quantity_sold, AVG(l.l_extendedprice) AS average_sales_price, AVG(l.l_discount) AS average_discount FROM supplier s JOIN nation n ON s.s_nationkey = n.n_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey JOIN customer c ON o.o_custkey = c.c_custkey AND c.c_nationkey = n.n_nationkey GROUP BY n.n_name ORDER BY total_sales_value DESC;
SELECT r.r_name AS region_name, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, AVG(s.s_acctbal) AS avg_account_balance, SUM(o.o_totalprice) AS total_sales, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, MAX(o.o_totalprice) AS max_order_value, MIN(o.o_totalprice) AS min_order_value FROM region AS r JOIN supplier AS s ON s.s_nationkey = r.r_regionkey JOIN orders AS o ON o.o_custkey = s.s_suppkey WHERE o.o_orderstatus IN ('F', 'P') AND s.s_address LIKE '1hFY4cxmBsHd zr3j5WoGDbH3bQx%' AND r.r_name IN ('ASIA', 'AMERICA', 'EUROPE', 'AFRICA') AND o.o_clerk IN ('Clerk#000003154', 'Clerk#000009681', 'Clerk#000022126', 'Clerk#000010059') GROUP BY r.r_name ORDER BY total_sales DESC;
SELECT r.r_name AS region_name, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales_revenue, AVG(l.l_extendedprice * (1 - l.l_discount)) AS average_sales_per_order FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN supplier s ON l.l_suppkey = s.s_suppkey JOIN region r ON s.s_nationkey = c.c_nationkey WHERE c.c_mktsegment = 'FURNITURE' AND o.o_orderdate BETWEEN DATE '2022-01-01' AND DATE '2022-12-31' GROUP BY r.r_name ORDER BY total_sales_revenue DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, SUM(l_extendedprice) AS total_sales, AVG(l_extendedprice * (1 - l_discount)) AS avg_discounted_sales, SUM(l_quantity) AS total_quantity_sold, AVG(l_quantity) AS avg_quantity_sold FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON n_nationkey = s_nationkey JOIN customer ON n_nationkey = c_nationkey JOIN orders ON c_custkey = o_custkey JOIN lineitem ON o_orderkey = l_orderkey AND s_suppkey = l_suppkey GROUP BY region, nation ORDER BY total_sales DESC, avg_discounted_sales DESC LIMIT 10;
SELECT c.c_mktsegment, COUNT(DISTINCT c.c_custkey) AS num_customers, AVG(c.c_acctbal) AS avg_customer_balance, SUM(o.o_totalprice) AS total_order_value, AVG(o.o_totalprice) AS avg_order_value, COUNT(DISTINCT o.o_orderkey) AS total_orders, s.s_nationkey, SUM(p.ps_availqty) AS total_parts_available, AVG(p.ps_supplycost) AS avg_supply_cost FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN partsupp p ON o.o_orderkey = p.ps_partkey JOIN supplier s ON p.ps_suppkey = s.s_suppkey WHERE o.o_totalprice > 15000 AND (s.s_suppkey IN (437, 4167, 1561)) GROUP BY c.c_mktsegment, s.s_nationkey ORDER BY total_order_value DESC, total_parts_available DESC;
SELECT s_name, s_address, AVG(p_retailprice) AS avg_retail_price, SUM(l_extendedprice) AS total_sales, COUNT(DISTINCT o_orderkey) AS total_orders FROM supplier JOIN partsupp ON supplier.s_suppkey = partsupp.ps_suppkey JOIN part ON partsupp.ps_partkey = part.p_partkey JOIN lineitem ON partsupp.ps_partkey = lineitem.l_partkey AND partsupp.ps_suppkey = lineitem.l_suppkey JOIN orders ON lineitem.l_orderkey = orders.o_orderkey WHERE lineitem.l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' AND lineitem.l_discount BETWEEN 0.05 AND 0.07 AND lineitem.l_quantity < 24 GROUP BY s_name, s_address ORDER BY total_sales DESC, s_name LIMIT 10;
SELECT s_name, c_name, COUNT(o_orderkey) AS total_orders, SUM(l_quantity) AS total_quantity, AVG(l_extendedprice) AS average_price, SUM(l_extendedprice * (1 - l_discount)) AS revenue, AVG(l_discount) AS average_discount, MAX(p_retailprice) AS max_retail_price, MIN(ps_supplycost) AS min_supply_cost FROM supplier JOIN partsupp ON supplier.s_suppkey = partsupp.ps_suppkey JOIN part ON partsupp.ps_partkey = part.p_partkey JOIN lineitem ON part.p_partkey = lineitem.l_partkey AND partsupp.ps_suppkey = lineitem.l_suppkey JOIN orders ON lineitem.l_orderkey = orders.o_orderkey JOIN customer ON orders.o_custkey = customer.c_custkey WHERE customer.c_nationkey IN (14, 21, 19, 16) AND orders.o_shippriority = 0 AND part.p_type = 'SMALL ANODIZED TIN' AND lineitem.l_quantity IN (45.00, 1.00, 36.00, 24.00, 9.00, 26.00) AND orders.o_totalprice = 138888.94 GROUP BY s_name, c_name ORDER BY revenue DESC, total_orders DESC, s_name, c_name;
