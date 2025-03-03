SELECT r_name AS region_name, n_name AS nation_name, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, SUM(l_extendedprice) AS total_sales, AVG(l_quantity) AS avg_quantity_sold, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue_after_discount FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN lineitem ON l_suppkey = s_suppkey JOIN orders ON o_orderkey = l_orderkey JOIN part ON p_partkey = l_partkey WHERE r_name IN ('AFRICA', 'EUROPE', 'AMERICA', 'MIDDLE EAST') AND o_shippriority = '0' AND (n_nationkey = '7' OR n_nationkey = '16') AND (p_comment LIKE '%g dependenc%' OR p_partkey IN ('3221', '674', '3988', '1591', '3091')) AND o_orderdate BETWEEN '1995-01-01' AND '1996-12-31' AND (r_comment LIKE '%ly final courts cajole furiously final excuse%' OR r_comment LIKE '%ges. thinly even pinto beans ca%' OR r_comment LIKE '%hs use ironic, even requests. s%') GROUP BY r_name, n_name ORDER BY total_revenue_after_discount DESC, region_name, nation_name;
SELECT r_name AS region, n_name AS nation, p_brand AS part_brand, COUNT(DISTINCT o_orderkey) AS total_orders, SUM(l_extendedprice) AS total_sales, AVG(l_extendedprice * (1 - l_discount)) AS avg_discounted_sales, SUM(l_quantity) AS total_quantity_sold, AVG(l_quantity) AS avg_quantity_sold FROM region JOIN nation ON r_regionkey = n_regionkey JOIN orders ON n_nationkey = o_custkey JOIN lineitem ON o_orderkey = l_orderkey JOIN part ON l_partkey = p_partkey WHERE o_orderstatus IN ('F', 'O', 'P') AND p_brand IN ('Brand#34', 'Brand#42', 'Brand#15', 'Brand#14', 'Brand#13') AND l_shipinstruct IN ('TAKE BACK RETURN', 'DELIVER IN PERSON', 'COLLECT COD') AND l_shipdate >= '1994-10-27' AND o_shippriority = '0' GROUP BY region, nation, part_brand ORDER BY total_sales DESC, region, nation;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(o.o_totalprice) AS total_sales, AVG(c.c_acctbal) AS average_customer_balance, AVG(l.l_quantity) AS average_quantity_ordered, SUM(l.l_extendedprice * (1 - l_discount)) AS revenue_after_discounts FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey WHERE r.r_name IN ('EUROPE', 'MIDDLE EAST', 'AFRICA', 'AMERICA') AND n.n_name = 'ETHIOPIA' AND n.n_nationkey IN ('21', '8') AND o.o_clerk IN ('Clerk#000015232', 'Clerk#000006604', 'Clerk#000022753', 'Clerk#000000797') AND o.o_custkey = '588251' AND EXISTS (SELECT 1 FROM part WHERE l.l_partkey = p_partkey AND p_comment LIKE '%dolphins%') GROUP BY r.r_name, n.n_name ORDER BY total_sales DESC, average_customer_balance DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS num_suppliers, COUNT(DISTINCT c_custkey) AS num_customers, COUNT(DISTINCT o_orderkey) AS num_orders, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(c_acctbal) AS avg_customer_acctbal, AVG(s_acctbal) AS avg_supplier_acctbal, AVG(l_quantity) AS avg_quantity_sold, MAX(p_retailprice) AS max_part_retailprice FROM region JOIN nation ON n_regionkey = r_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN orders ON o_custkey = c_custkey JOIN lineitem ON l_orderkey = o_orderkey AND l_suppkey = s_suppkey JOIN part ON p_partkey = l_partkey GROUP BY region, nation ORDER BY total_revenue DESC, region, nation;
SELECT r_name AS region, COUNT(DISTINCT c_custkey) AS number_of_customers, COUNT(DISTINCT o_orderkey) AS number_of_orders, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(l_extendedprice * (1 - l_discount)) AS avg_order_value, SUM(l_quantity) AS total_quantity_sold, AVG(l_quantity) AS avg_quantity_per_order FROM region JOIN customer ON c_nationkey = r_regionkey JOIN orders ON o_custkey = c_custkey JOIN lineitem ON l_orderkey = o_orderkey WHERE r_regionkey IN (3, 4, 0) AND l_receiptdate >= '1995-01-01' AND l_receiptdate <= '1998-12-31' GROUP BY r_name ORDER BY total_revenue DESC;
SELECT p.p_brand, COUNT(DISTINCT o.o_orderkey) AS total_orders, AVG(l.l_quantity) AS avg_quantity_ordered, AVG(o.o_totalprice) AS avg_order_total_price FROM part p JOIN partsupp ps ON p.p_partkey = ps.ps_partkey JOIN lineitem l ON p.p_partkey = l.l_partkey JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE ps.ps_suppkey = 682 AND l.l_receiptdate > '1997-11-01' GROUP BY p.p_brand ORDER BY total_orders DESC, avg_order_total_price DESC;
SELECT n.n_name AS nation, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(li.l_extendedprice * (1 - li.l_discount)) AS total_revenue, AVG(li.l_quantity) AS avg_quantity_sold, SUM(ps.ps_supplycost * li.l_quantity) AS total_supply_cost, (SUM(li.l_extendedprice * (1 - li.l_discount)) - SUM(ps.ps_supplycost * li.l_quantity)) AS total_profit FROM orders o JOIN lineitem li ON o.o_orderkey = li.l_orderkey JOIN partsupp ps ON li.l_partkey = ps.ps_partkey AND li.l_suppkey = ps.ps_suppkey JOIN supplier s ON li.l_suppkey = s.s_suppkey JOIN nation n ON s.s_nationkey = n.n_nationkey WHERE o.o_orderdate BETWEEN '1995-01-01' AND '1996-12-31' AND n.n_regionkey IN (1, 2, 3) AND s.s_comment LIKE '%ruthless%' GROUP BY nation, order_year ORDER BY nation, order_year DESC;
SELECT r_name AS region_name, p_type AS part_type, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, SUM(ps_availqty) AS total_available_quantity, AVG(l_extendedprice * (1 - l_discount)) AS average_discounted_price, SUM(l_quantity) AS total_quantity_ordered FROM region JOIN supplier ON region.r_regionkey = supplier.s_nationkey JOIN partsupp ON supplier.s_suppkey = partsupp.ps_suppkey JOIN part ON partsupp.ps_partkey = part.p_partkey JOIN lineitem ON part.p_partkey = lineitem.l_partkey JOIN orders ON lineitem.l_orderkey = orders.o_orderkey WHERE r_name IN ('AMERICA', 'ASIA') AND l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' GROUP BY region_name, part_type ORDER BY average_discounted_price DESC, total_quantity_ordered DESC;
SELECT r.r_name AS region, COUNT(DISTINCT c.c_custkey) AS num_customers, COUNT(DISTINCT p.p_partkey) AS num_parts, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_quantity) AS avg_quantity_sold, AVG(ps.ps_supplycost) AS avg_supply_cost FROM region r JOIN customer c ON r.r_regionkey = c.c_nationkey JOIN lineitem l ON c.c_custkey = l.l_suppkey JOIN part p ON l.l_partkey = p.p_partkey JOIN partsupp ps ON p.p_partkey = ps.ps_partkey AND l.l_suppkey = ps.ps_suppkey WHERE r.r_name IN ('MIDDLE EAST', 'ASIA', 'EUROPE', 'AMERICA', 'AFRICA') AND p.p_container IN ('SM BOX', 'LG BAG') AND ps.ps_supplycost IN (631.31, 848.83) AND l.l_receiptdate BETWEEN '1994-01-01' AND '1997-12-31' GROUP BY r.r_name ORDER BY total_revenue DESC;
