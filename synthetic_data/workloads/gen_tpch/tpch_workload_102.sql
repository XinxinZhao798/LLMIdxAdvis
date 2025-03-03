SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, COUNT(DISTINCT c.c_custkey) AS total_customers, COUNT(DISTINCT o.o_orderkey) AS total_orders, AVG(s.s_acctbal) AS avg_supplier_acctbal, AVG(c.c_acctbal) AS avg_customer_acctbal, SUM(o.o_totalprice) AS total_order_value, AVG(ps.ps_supplycost) AS avg_part_supply_cost, SUM(ps.ps_availqty) AS total_available_parts_qty FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey WHERE o.o_orderstatus = 'O' AND o.o_clerk IN ('Clerk#000008805', 'Clerk#000017121', 'Clerk#000001732', 'Clerk#000008709') AND EXISTS ( SELECT 1 FROM part p WHERE p.p_partkey = ps.ps_partkey AND p.p_brand IN ('Brand#53', 'Brand#52', 'Brand#13', 'Brand#42', 'Brand#24') ) GROUP BY r.r_name, n.n_name ORDER BY total_order_value DESC;
SELECT c.c_mktsegment, r.r_name AS region, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue, AVG(l.l_quantity) AS average_quantity, AVG(l.l_extendedprice) AS average_price, AVG(l.l_discount) AS average_discount, COUNT(DISTINCT s.s_suppkey) AS total_suppliers FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN supplier s ON s.s_suppkey = l.l_suppkey JOIN region r ON s.s_nationkey = r.r_regionkey WHERE o.o_orderdate BETWEEN '1994-01-01' AND '1994-12-31' AND l.l_shipdate > o.o_orderdate GROUP BY c.c_mktsegment, region ORDER BY revenue DESC, c.c_mktsegment, region;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS num_suppliers, COUNT(DISTINCT c_custkey) AS num_customers, SUM(l_extendedprice * (1 - l_discount)) AS total_sales, AVG(l_quantity) AS average_quantity_sold, AVG(ps_supplycost) AS average_supply_cost FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON n_nationkey = s_nationkey JOIN customer ON n_nationkey = c_nationkey JOIN orders ON c_custkey = o_custkey JOIN lineitem ON o_orderkey = l_orderkey JOIN partsupp ON s_suppkey = ps_suppkey AND l_partkey = ps_partkey WHERE l_shipdate BETWEEN date '1994-01-01' AND date '1994-12-31' AND o_orderstatus = 'F' GROUP BY region, nation ORDER BY total_sales DESC;
SELECT r.r_name AS region, c.c_mktsegment AS market_segment, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_quantity) AS total_quantity_sold, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey AND o.o_orderstatus = 'F' JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE o.o_orderdate >= DATE '2022-10-01' AND o.o_orderdate < DATE '2023-01-01' GROUP BY r.r_name, c.c_mktsegment ORDER BY r.r_name, total_revenue DESC;
SELECT r.r_name AS region_name, AVG(l.l_quantity) AS average_quantity, AVG(l.l_discount) AS average_discount, COUNT(DISTINCT o.o_orderkey) AS number_of_orders FROM region r JOIN orders o ON o.o_orderkey IN (SELECT l_orderkey FROM lineitem WHERE l_shipdate BETWEEN '1997-01-01' AND '1997-12-31') JOIN lineitem l ON l.l_orderkey = o.o_orderkey JOIN part p ON p.p_partkey = l.l_partkey JOIN partsupp ps ON ps.ps_partkey = p.p_partkey AND ps.ps_suppkey = l.l_suppkey WHERE p.p_size IN (15, 27, 30) AND r.r_regionkey IN (2, 4) AND l.l_shipdate BETWEEN '1997-01-01' AND '1997-12-31' GROUP BY r.r_name ORDER BY average_quantity DESC, average_discount DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, SUM(ps_availqty) AS total_available_quantity, AVG(l_extendedprice * (1 - l_discount)) AS average_revenue, SUM(CASE WHEN l_returnflag = 'R' THEN l_quantity ELSE 0 END) AS returned_quantity FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON n_nationkey = s_nationkey JOIN customer ON n_nationkey = c_nationkey JOIN partsupp ON s_suppkey = ps_suppkey JOIN lineitem ON s_suppkey = l_suppkey AND ps_partkey = l_partkey JOIN orders ON l_orderkey = o_orderkey AND c_custkey = o_custkey WHERE r_name IN ('EUROPE', 'AMERICA', 'MIDDLE EAST') AND o_orderdate BETWEEN date '1995-01-01' AND date '1996-12-31' GROUP BY region, nation ORDER BY average_revenue DESC;
SELECT r.r_name AS region, n.n_name AS nation, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_quantity) AS average_quantity, AVG(c.c_acctbal) AS average_customer_balance, SUM(p.p_retailprice * l.l_quantity) AS total_parts_value FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey JOIN customer c ON o.o_custkey = c.c_custkey JOIN part p ON l.l_partkey = p.p_partkey WHERE l.l_receiptdate >= '1994-01-01' AND l.l_receiptdate < '1995-01-01' AND l.l_returnflag = 'A' AND c.c_acctbal > 4000 AND s.s_comment LIKE '%quiet%' GROUP BY region, nation, order_year ORDER BY total_revenue DESC, region, nation, order_year;
SELECT r.r_name AS region_name, COUNT(DISTINCT p.p_partkey) AS number_of_parts, AVG(p.p_retailprice) AS average_retail_price, SUM(ps.ps_availqty) AS total_available_quantity, SUM(ps.ps_supplycost) AS total_supply_cost, AVG(ps.ps_supplycost) AS average_supply_cost FROM region r JOIN partsupp ps ON ps.ps_partkey = ps.ps_partkey JOIN part p ON p.p_partkey = ps.ps_partkey GROUP BY r.r_name ORDER BY total_supply_cost DESC;
SELECT n.n_name AS nation_name, COUNT(DISTINCT c.c_custkey) AS customer_count, COUNT(DISTINCT s.s_suppkey) AS supplier_count, AVG(c.c_acctbal) AS avg_customer_acctbal, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales, MAX(o.o_totalprice) AS max_order_totalprice FROM nation n JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE n.n_name IN ('INDIA', 'MOROCCO', 'VIETNAM') AND l.l_shipdate BETWEEN '2020-01-01' AND '2020-12-31' GROUP BY n.n_name ORDER BY total_sales DESC, nation_name;
SELECT r_name AS region, n_name AS nation, count(DISTINCT s_suppkey) AS num_suppliers, count(DISTINCT c_custkey) AS num_customers, sum(l_extendedprice) AS total_sales, avg(l_extendedprice * (1 - l_discount)) AS avg_discounted_sales, count(DISTINCT o_orderkey) AS num_orders FROM region JOIN nation ON n_regionkey = r_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN orders ON o_custkey = c_custkey JOIN lineitem ON l_orderkey = o_orderkey AND l_suppkey = s_suppkey GROUP BY region, nation ORDER BY total_sales DESC, region, nation;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS num_customers, COUNT(o.o_orderkey) AS num_orders, SUM(o.o_totalprice) AS total_sales, AVG(o.o_totalprice) AS avg_order_value FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey GROUP BY r.r_name, n.n_name ORDER BY r.r_name, total_sales DESC;
SELECT n.n_name AS nation, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(li.l_extendedprice * (1 - li.l_discount)) AS total_revenue, AVG(li.l_quantity) AS avg_quantity_sold, SUM(ps.ps_supplycost * li.l_quantity) AS total_supply_cost, (SUM(li.l_extendedprice * (1 - li.l_discount)) - SUM(ps.ps_supplycost * li.l_quantity)) AS total_profit FROM orders o JOIN lineitem li ON o.o_orderkey = li.l_orderkey JOIN partsupp ps ON li.l_partkey = ps.ps_partkey AND li.l_suppkey = ps.ps_suppkey JOIN supplier s ON li.l_suppkey = s.s_suppkey JOIN nation n ON s.s_nationkey = n.n_nationkey WHERE o.o_orderdate BETWEEN '1995-01-01' AND '1996-12-31' AND n.n_regionkey IN (1, 2, 3) AND s.s_comment LIKE '%ruthless%' GROUP BY nation, order_year ORDER BY nation, order_year DESC;
SELECT n.n_name, p.p_type, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_discounted_price, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, MAX(o.o_totalprice) AS max_order_value FROM nation AS n JOIN orders AS o ON o.o_clerk IN ('Clerk#000017551', 'Clerk#000015437', 'Clerk#000017513') JOIN lineitem AS l ON o.o_orderkey = l.l_orderkey JOIN part AS p ON l.l_partkey = p.p_partkey WHERE n.n_nationkey IN (22, 23, 20) AND o.o_orderstatus = 'F' AND o.o_orderdate BETWEEN date '1995-01-01' AND date '1996-12-31' GROUP BY n.n_name, p.p_type ORDER BY total_revenue DESC, n.n_name, p.p_type;
