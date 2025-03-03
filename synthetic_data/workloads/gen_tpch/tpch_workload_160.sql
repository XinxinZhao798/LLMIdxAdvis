SELECT r_name, COUNT(DISTINCT ps_partkey) AS num_parts, SUM(ps_availqty) AS total_availability, AVG(ps_supplycost) AS avg_supply_cost, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(l_quantity) AS avg_quantity_sold FROM region JOIN partsupp ON r_regionkey = ps_suppkey % 5 JOIN lineitem ON ps_partkey = l_partkey AND ps_suppkey = l_suppkey WHERE r_regionkey IN (1, 3) AND l_shipdate BETWEEN date '2022-01-01' AND date '2022-12-31' AND l_discount BETWEEN 0.05 AND 0.07 AND l_quantity BETWEEN 5 AND 25 GROUP BY r_name ORDER BY total_revenue DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS num_suppliers, COUNT(DISTINCT c_custkey) AS num_customers, SUM(l_extendedprice * (1 - l_discount)) AS revenue, AVG(s_acctbal) AS avg_supplier_acctbal, AVG(c_acctbal) AS avg_customer_acctbal, AVG(p_retailprice) AS avg_part_retailprice, SUM(ps_availqty) AS total_partsupply_quantity, AVG(ps_supplycost) AS avg_partsupply_cost FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON n_nationkey = s_nationkey JOIN customer ON n_nationkey = c_nationkey JOIN partsupp ON s_suppkey = ps_suppkey JOIN part ON ps_partkey = p_partkey JOIN lineitem ON l_suppkey = s_suppkey AND l_partkey = p_partkey JOIN orders ON o_orderkey = l_orderkey WHERE n_name IN ('KENYA', 'RUSSIA') AND l_shipdate BETWEEN '2020-01-01' AND '2020-12-31' AND o_orderstatus = 'F' AND l_returnflag = 'N' GROUP BY region, nation ORDER BY revenue DESC, avg_supplier_acctbal DESC, avg_customer_acctbal DESC;
SELECT r.r_name AS region_name, n.n_name AS nation_name, s.s_name AS supplier_name, COUNT(DISTINCT l.l_orderkey) AS total_orders, AVG(l.l_quantity) AS average_quantity, SUM(l.l_extendedprice) AS total_extended_price FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey WHERE n.n_regionkey = '1' AND l.l_receiptdate BETWEEN '1997-01-01' AND '1997-12-31' AND l.l_returnflag = 'A' GROUP BY r.r_name, n.n_name, s.s_name ORDER BY total_extended_price DESC, region_name, nation_name, supplier_name;
SELECT r_name AS region, n_name AS nation, c_mktsegment AS market_segment, COUNT(DISTINCT c_custkey) AS num_customers, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(c_acctbal) AS avg_account_balance, SUM(ps_availqty) AS total_available_quantity FROM customer JOIN nation ON customer.c_nationkey = nation.n_nationkey JOIN region ON nation.n_regionkey = region.r_regionkey JOIN lineitem ON customer.c_custkey IN (SELECT c_custkey FROM customer WHERE c_comment LIKE '%blithely%') JOIN partsupp ON lineitem.l_partkey = partsupp.ps_partkey AND lineitem.l_suppkey = partsupp.ps_suppkey WHERE c_mktsegment IN ('HOUSEHOLD', 'AUTOMOBILE', 'MACHINERY') AND nation.n_regionkey IN (1, 2) AND l_receiptdate >= '1996-09-16' AND ps_supplycost = 696.10 GROUP BY region, nation, market_segment ORDER BY total_revenue DESC, avg_account_balance DESC;
SELECT c.c_mktsegment, o.o_orderpriority, COUNT(DISTINCT c.c_custkey) AS num_customers, COUNT(DISTINCT o.o_orderkey) AS num_orders, SUM(l.l_extendedprice) AS total_sales, AVG(l.l_quantity) AS avg_quantity_sold, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue_after_discount FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE o.o_orderstatus = 'F' AND o.o_shippriority = '0' AND l.l_shipdate BETWEEN date '2022-01-01' AND date '2022-12-31' AND o.o_comment LIKE '%packages%' GROUP BY c.c_mktsegment, o.o_orderpriority ORDER BY total_revenue_after_discount DESC;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, COUNT(DISTINCT c.c_custkey) AS total_customers, AVG(s.s_acctbal) AS avg_supplier_acctbal, AVG(c.c_acctbal) AS avg_customer_acctbal, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE l.l_shipdate BETWEEN DATE '2022-01-01' AND DATE '2022-12-31' GROUP BY r.r_name, n.n_name ORDER BY revenue DESC LIMIT 5;
SELECT r.r_name AS region_name, COUNT(li.l_orderkey) AS lineitem_count, SUM(li.l_extendedprice * (1 - li.l_discount)) AS total_revenue, AVG(li.l_quantity) AS average_quantity FROM region r JOIN supplier s ON r.r_regionkey = s.s_nationkey JOIN lineitem li ON s.s_suppkey = li.l_suppkey JOIN part p ON li.l_partkey = p.p_partkey JOIN orders o ON li.l_orderkey = o.o_orderkey WHERE p.p_size = 5 AND p.p_container = 'WRAP CAN' AND o.o_orderstatus IN ('F', 'O') AND o.o_totalprice >= 85505.69 GROUP BY r.r_name ORDER BY total_revenue DESC, region_name;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(l.l_quantity) AS total_quantity_sold, AVG(l.l_extendedprice * (1 - l.l_discount)) AS average_discounted_price, SUM(l.l_extendedprice * (1 - l.l_discount) * (1 + l.l_tax)) AS total_sales_with_tax FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey WHERE c.c_mktsegment IN ('MACHINERY', 'HOUSEHOLD') AND r.r_regionkey IN (3, 2, 0) AND l.l_shipdate BETWEEN '2022-01-01' AND '2022-12-31' GROUP BY r.r_name, n.n_name ORDER BY total_sales_with_tax DESC, region, nation;
SELECT n.n_name AS nation, COUNT(DISTINCT ps.ps_partkey) AS distinct_parts_count, AVG(ps.ps_supplycost) AS average_supply_cost, SUM(ps.ps_availqty) AS total_available_quantity FROM nation n JOIN partsupp ps ON ps.ps_suppkey = n.n_nationkey JOIN part p ON p.p_partkey = ps.ps_partkey GROUP BY n.n_name ORDER BY average_supply_cost DESC, total_available_quantity DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, SUM(l_extendedprice * (1 - l_discount)) AS total_sales, AVG(l_quantity) AS average_quantity_sold, AVG(c_acctbal) AS average_customer_balance FROM region JOIN nation ON n_regionkey = r_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN orders ON o_custkey = c_custkey JOIN lineitem ON l_orderkey = o_orderkey AND l_suppkey = s_suppkey GROUP BY region, nation ORDER BY total_sales DESC LIMIT 5;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS number_of_customers, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, AVG(c.c_acctbal) AS average_customer_account_balance, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_discount) AS average_discount, COUNT(DISTINCT l.l_orderkey) AS number_of_orders FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey WHERE c.c_mktsegment = 'MACHINERY' AND l.l_shipdate BETWEEN '2022-01-01' AND '2022-12-31' GROUP BY r.r_name, n.n_name ORDER BY total_revenue DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, SUM(ps_availqty) AS total_available_quantity, AVG(l_extendedprice * (1 - l_discount)) AS average_revenue, SUM(CASE WHEN l_returnflag = 'R' THEN l_quantity ELSE 0 END) AS returned_quantity FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON n_nationkey = s_nationkey JOIN customer ON n_nationkey = c_nationkey JOIN partsupp ON s_suppkey = ps_suppkey JOIN lineitem ON s_suppkey = l_suppkey AND ps_partkey = l_partkey JOIN orders ON l_orderkey = o_orderkey AND c_custkey = o_custkey WHERE r_name IN ('EUROPE', 'AMERICA', 'MIDDLE EAST') AND o_orderdate BETWEEN date '1995-01-01' AND date '1996-12-31' GROUP BY region, nation ORDER BY average_revenue DESC;
SELECT s_nationkey, COUNT(DISTINCT s_suppkey) AS total_suppliers, AVG(s_acctbal) AS average_balance, SUM(o_totalprice) AS total_order_value, COUNT(DISTINCT o_orderkey) AS total_orders, p_brand, AVG(p_retailprice) AS average_retail_price, COUNT(DISTINCT p_partkey) AS total_parts FROM supplier JOIN orders ON s_suppkey = o_custkey JOIN part ON p_size = s_nationkey WHERE o_orderstatus IN ('F', 'O') AND s_phone LIKE '25-349-496-8423%' GROUP BY s_nationkey, p_brand ORDER BY total_order_value DESC, average_balance DESC;
SELECT r.r_name AS region_name, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(distinct o.o_orderkey) AS total_orders, AVG(o.o_totalprice) AS average_order_price, SUM(p.p_size) AS total_parts_size, AVG(p.p_retailprice) AS average_part_price FROM region r JOIN orders o ON r.r_regionkey = o.o_orderkey % 5 JOIN part p ON o.o_orderkey = p.p_partkey % 5 WHERE r.r_name LIKE 'E%' AND o.o_orderstatus = 'F' AND p.p_name IN ( 'coral magenta orange powder cyan', 'navy blanched cornflower medium drab', 'tomato misty almond cornflower papaya', 'firebrick tomato midnight violet thistle', 'medium aquamarine drab dark azure' ) GROUP BY region_name, order_year ORDER BY total_orders DESC, average_order_price DESC;
SELECT n.n_name, AVG(c.c_acctbal) AS avg_customer_balance, SUM(l.l_quantity) AS total_quantity_ordered, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(l.l_extendedprice * (1 - l_discount)) AS revenue_after_discount FROM nation n JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE n.n_name IN ('ARGENTINA', 'JORDAN', 'IRAQ', 'RUSSIA') AND n.n_regionkey IN (1, 0, 2) AND c.c_mktsegment IN ('HOUSEHOLD', 'AUTOMOBILE', 'BUILDING', 'MACHINERY', 'FURNITURE') AND l.l_suppkey = 183863 AND l.l_linenumber IN (6, 2, 1, 7, 4) AND o.o_clerk = 'Clerk#000001496' GROUP BY n.n_name ORDER BY revenue_after_discount DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT c_custkey) AS num_customers, SUM(c_acctbal) AS total_balance, AVG(c_acctbal) AS avg_balance, SUM(l_extendedprice) AS total_sales, SUM(l_extendedprice * (1 - l_discount)) AS discounted_total_sales, AVG(l_extendedprice) AS avg_sales_price, COUNT(DISTINCT o_orderkey) AS num_orders, AVG(o_totalprice) AS avg_order_value, COUNT(*) AS line_items_count FROM region JOIN nation ON n_regionkey = r_regionkey JOIN customer ON c_nationkey = n_nationkey JOIN orders ON o_custkey = c_custkey JOIN lineitem ON l_orderkey = o_orderkey WHERE r_comment LIKE '%final%' AND o_shippriority = 0 AND c_comment NOT LIKE '%theodolites%' AND l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' GROUP BY region, nation ORDER BY total_sales DESC, avg_order_value DESC LIMIT 10;
SELECT r.r_name AS region, COUNT(DISTINCT li.l_orderkey) AS number_of_orders, SUM(li.l_extendedprice) AS total_revenue, AVG(li.l_quantity) AS avg_quantity, SUM(li.l_extendedprice * (1 - li.l_discount) * (1 + li.l_tax)) AS total_revenue_after_discount_and_tax FROM region r JOIN partsupp ps ON r.r_regionkey = ps.ps_suppkey JOIN lineitem li ON ps.ps_partkey = li.l_partkey AND ps.ps_suppkey = li.l_suppkey WHERE r.r_name = 'EUROPE' AND li.l_returnflag = 'N' AND li.l_shipdate BETWEEN '2022-01-01' AND '2022-12-31' GROUP BY r.r_name ORDER BY total_revenue DESC;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS num_suppliers, COUNT(DISTINCT c.c_custkey) AS num_customers, SUM(p.p_retailprice) AS total_retail_price, AVG(l.l_quantity) AS average_quantity_ordered, SUM(l.l_extendedprice * (1 - l_discount)) AS total_revenue, COUNT(DISTINCT o.o_orderkey) AS num_orders FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN part p ON l.l_partkey = p.p_partkey WHERE r.r_name IN ('MIDDLE EAST', 'AFRICA') AND o.o_orderdate >= '2020-01-01' AND o.o_orderdate < '2021-01-01' AND l.l_returnflag = 'N' GROUP BY r.r_name, n.n_name ORDER BY total_revenue DESC, num_customers DESC LIMIT 10;
SELECT n.n_name AS nation_name, AVG(ps.ps_supplycost) AS avg_supply_cost, SUM(ps.ps_availqty) AS total_avail_qty, COUNT(o.o_orderkey) AS order_count, AVG(o.o_totalprice) AS avg_order_price FROM nation n JOIN partsupp ps ON n.n_nationkey = ps.ps_suppkey LEFT JOIN orders o ON n.n_nationkey = o.o_custkey AND o.o_orderdate >= '2020-01-01' AND o.o_orderdate < '2021-01-01' WHERE ps.ps_availqty IN (1805, 7621, 9995, 1615, 669) GROUP BY n.n_name ORDER BY n.n_name;
