SELECT n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(o.o_totalprice) AS total_sales, AVG(c.c_acctbal) AS average_account_balance FROM nation n JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN region r ON n.n_regionkey = r.r_regionkey WHERE r.r_name = 'ASIA' AND o.o_totalprice > (SELECT AVG(o2.o_totalprice) FROM orders o2) GROUP BY n.n_name ORDER BY total_sales DESC, average_account_balance DESC;
SELECT n.n_name, c.c_mktsegment, AVG(c.c_acctbal) AS average_account_balance, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(ps.ps_availqty) AS total_available_quantity, AVG(ps.ps_supplycost) AS average_supply_cost, SUM(p.p_retailprice * ps.ps_availqty) AS total_retail_value FROM nation n JOIN customer c ON c.c_nationkey = n.n_nationkey JOIN partsupp ps ON ps.ps_partkey IN (SELECT p_partkey FROM part WHERE p_name IN ('forest mint goldenrod saddle hot', 'wheat almond blue cream ivory')) JOIN part p ON p.p_partkey = ps.ps_partkey GROUP BY n.n_name, c.c_mktsegment ORDER BY n.n_name, c.c_mktsegment;
SELECT r_name AS region, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT p_partkey) AS number_of_parts, SUM(l_quantity) AS total_quantity, AVG(ps_supplycost) AS average_supply_cost, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue FROM region JOIN supplier ON s_nationkey = r_regionkey JOIN partsupp ON ps_suppkey = s_suppkey JOIN part ON ps_partkey = p_partkey JOIN lineitem ON l_partkey = p_partkey AND l_suppkey = s_suppkey JOIN orders ON l_orderkey = o_orderkey WHERE o_orderstatus = 'F' AND l_shipmode IN ('AIR', 'RAIL', 'TRUCK') AND s_comment LIKE '%packages%' GROUP BY region ORDER BY total_revenue DESC, region;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT c_custkey) AS num_customers, COUNT(DISTINCT s_suppkey) AS num_suppliers, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(l_quantity) AS avg_quantity_sold, AVG(c_acctbal) AS avg_customer_acctbal, AVG(s_acctbal) AS avg_supplier_acctbal FROM region JOIN nation ON n_regionkey = r_regionkey JOIN customer ON c_nationkey = n_nationkey JOIN supplier ON s_nationkey = n_nationkey JOIN lineitem ON (c_custkey = l_orderkey AND s_suppkey = l_suppkey) WHERE l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' AND r_name IN ('EUROPE', 'AMERICA', 'ASIA') GROUP BY r_name, n_name ORDER BY total_revenue DESC, avg_quantity_sold DESC LIMIT 10;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, COUNT(DISTINCT c.c_custkey) AS total_customers, AVG(s.s_acctbal) AS avg_supplier_acctbal, AVG(c.c_acctbal) AS avg_customer_acctbal, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales_volume, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_sales_price FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE n.n_name IN ('UNITED STATES', 'GERMANY') AND l.l_shipmode IN ('REG AIR', 'MAIL') AND l.l_shipdate BETWEEN date '1995-01-01' AND date '1996-12-31' GROUP BY region, nation ORDER BY total_sales_volume DESC, region, nation;
SELECT r.r_name AS region_name, COUNT(DISTINCT c.c_custkey) AS number_of_customers, AVG(c.c_acctbal) AS average_account_balance, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(o.o_totalprice) AS total_sales, AVG(o.o_totalprice) AS average_order_value FROM region r JOIN customer c ON r.r_regionkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey WHERE r.r_regionkey IN (0, 1, 3, 4) AND o.o_orderstatus = 'F' GROUP BY r.r_name ORDER BY total_sales DESC, region_name;
SELECT n.n_name AS nation_name, p.p_type AS part_type, AVG(ps.ps_supplycost) AS avg_supply_cost, SUM(ps.ps_availqty) AS total_availability, COUNT(DISTINCT p.p_partkey) AS unique_parts_count FROM nation n JOIN partsupp ps ON n.n_nationkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey WHERE ps.ps_availqty > 3000 AND p.p_size BETWEEN 30 AND 50 GROUP BY nation_name, part_type ORDER BY avg_supply_cost DESC, total_availability DESC LIMIT 10;
SELECT c.c_mktsegment, COUNT(DISTINCT c.c_custkey) AS num_customers, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice) AS avg_price, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue_after_discount, AVG(l.l_discount) AS avg_discount FROM customer c JOIN lineitem l ON c.c_custkey = l.l_suppkey JOIN supplier s ON l.l_suppkey = s.s_suppkey WHERE s.s_comment LIKE '%final%' OR s.s_comment LIKE '%instructions%' OR s.s_comment LIKE '%pinto beans%' AND l.l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' AND c.c_acctbal > 0 GROUP BY c.c_mktsegment ORDER BY revenue_after_discount DESC;
SELECT n_name AS nation, r_name AS region, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, SUM(l_extendedprice * (1 - l_discount)) AS total_sales, AVG(l_quantity) AS average_quantity_sold, AVG(c_acctbal) AS average_customer_balance FROM nation JOIN region ON n_regionkey = r_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN orders ON o_custkey = c_custkey JOIN lineitem ON l_orderkey = o_orderkey WHERE c_mktsegment = 'BUILDING' AND o_orderdate BETWEEN date '1995-01-01' AND date '1995-12-31' AND l_shipdate > date '1995-12-31' GROUP BY n_name, r_name ORDER BY total_sales DESC, region, nation;
SELECT r.r_name AS region_name, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales_revenue, AVG(l.l_extendedprice * (1 - l.l_discount)) AS average_sales_per_order FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN supplier s ON l.l_suppkey = s.s_suppkey JOIN region r ON s.s_nationkey = c.c_nationkey WHERE c.c_mktsegment = 'FURNITURE' AND o.o_orderdate BETWEEN DATE '2022-01-01' AND DATE '2022-12-31' GROUP BY r.r_name ORDER BY total_sales_revenue DESC;
SELECT c.c_mktsegment, s.s_name, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue, AVG(l.l_quantity) AS average_quantity, AVG(l.l_extendedprice) AS average_price, AVG(l.l_discount) AS average_discount FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN supplier s ON l.l_suppkey = s.s_suppkey WHERE c.c_mktsegment IN ('MACHINERY', 'AUTOMOBILE', 'FURNITURE') AND o.o_orderstatus = 'O' AND s.s_comment LIKE '%fluffily%' AND l.l_shipdate BETWEEN '1995-01-01' AND '1996-12-31' GROUP BY c.c_mktsegment, s.s_name ORDER BY revenue DESC, c.c_mktsegment, s.s_name;
SELECT n.n_name AS nation_name, AVG(c.c_acctbal) AS average_account_balance, COUNT(DISTINCT c.c_custkey) AS number_of_customers, p.p_brand, SUM(ps.ps_availqty) AS total_available_quantity, AVG(ps.ps_supplycost) AS average_supply_cost, SUM(p.p_retailprice * ps.ps_availqty) AS total_retail_value FROM nation n JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN partsupp ps ON ps.ps_suppkey = c.c_custkey JOIN part p ON ps.ps_partkey = p.p_partkey WHERE n.n_nationkey IN (23, 7, 17, 9, 24, 13) AND p.p_size = 1 AND p.p_brand IN ('Brand#42', 'Brand#11', 'Brand#45') GROUP BY n.n_name, p.p_brand ORDER BY nation_name, p.p_brand;
SELECT n.n_name AS nation, l.l_shipmode, SUM(l.l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(l.l_quantity) AS average_quantity, COUNT(*) AS total_orders FROM nation n JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey WHERE l.l_shipmode IN ('AIR', 'SHIP') AND l.l_shipdate >= '1995-01-01' AND l.l_shipdate < '1995-01-01'::date + INTERVAL '1 year' GROUP BY n.n_name, l.l_shipmode ORDER BY total_revenue DESC, n.n_name, l.l_shipmode;
SELECT n.n_name AS nation_name, c.c_mktsegment AS customer_market_segment, COUNT(DISTINCT c.c_custkey) AS number_of_customers, AVG(c.c_acctbal) AS average_customer_account_balance, SUM(ps.ps_availqty) AS total_available_parts, AVG(ps.ps_supplycost) AS average_supply_cost FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN supplier s ON s.s_nationkey = n.n_nationkey JOIN partsupp ps ON ps.ps_suppkey = s.s_suppkey WHERE n.n_nationkey IN (13, 23) AND c.c_comment LIKE '%special pinto beans%' AND s.s_name IN ('Supplier#000021082', 'Supplier#000018658', 'Supplier#000020174') GROUP BY n.n_name, c.c_mktsegment ORDER BY average_customer_account_balance DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, SUM(ps_availqty) AS total_available_quantity, AVG(l_extendedprice * (1 - l_discount)) AS average_revenue, SUM(CASE WHEN l_returnflag = 'R' THEN l_quantity ELSE 0 END) AS returned_quantity FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON n_nationkey = s_nationkey JOIN customer ON n_nationkey = c_nationkey JOIN partsupp ON s_suppkey = ps_suppkey JOIN lineitem ON s_suppkey = l_suppkey AND ps_partkey = l_partkey JOIN orders ON l_orderkey = o_orderkey AND c_custkey = o_custkey WHERE r_name IN ('EUROPE', 'AMERICA', 'MIDDLE EAST') AND o_orderdate BETWEEN date '1995-01-01' AND date '1996-12-31' GROUP BY region, nation ORDER BY average_revenue DESC;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, COUNT(DISTINCT c.c_custkey) AS total_customers, AVG(s.s_acctbal) AS avg_supplier_acctbal, AVG(c.c_acctbal) AS avg_customer_acctbal, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey WHERE r.r_name IN ('MIDDLE EAST', 'EUROPE', 'AMERICA') AND l.l_shipdate BETWEEN '2023-01-01' AND '2023-12-31' GROUP BY r.r_name, n.n_name ORDER BY revenue DESC, region, nation;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT c_custkey) AS num_customers, COUNT(DISTINCT s_suppkey) AS num_suppliers, SUM(l_quantity) AS total_quantity_ordered, AVG(l_extendedprice) AS average_order_price, SUM(l_extendedprice * (1 - l_discount)) AS revenue_after_discount FROM region JOIN nation ON n_regionkey = r_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN orders ON o_custkey = c_custkey JOIN lineitem ON l_orderkey = o_orderkey JOIN part ON l_partkey = p_partkey WHERE o_orderpriority = '5-LOW' AND o_orderstatus = 'F' AND p_retailprice IN (1426.52, 1454.54, 1027.11, 1681.77, 1790.88, 1465.56) AND n_nationkey IN (7, 4) AND r_regionkey IN (1, 4, 0, 2, 3) GROUP BY region, nation ORDER BY revenue_after_discount DESC;
SELECT r.r_name AS region_name, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT p.p_partkey) AS number_of_parts, AVG(ps.ps_supplycost) AS average_supply_cost, SUM(ps.ps_availqty) AS total_available_quantity, mps.most_common_size FROM region r JOIN nation n ON r.r_regionkey = n.n_nationkey JOIN supplier s ON s.s_nationkey = n.n_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey LEFT JOIN ( SELECT ps_inner.ps_suppkey, p_inner.p_size AS most_common_size, ROW_NUMBER() OVER(PARTITION BY ps_inner.ps_suppkey ORDER BY COUNT(*) DESC) AS rn FROM partsupp ps_inner JOIN part p_inner ON ps_inner.ps_partkey = p_inner.p_partkey GROUP BY ps_inner.ps_suppkey, p_inner.p_size ) mps ON s.s_suppkey = mps.ps_suppkey AND mps.rn = 1 GROUP BY r.r_name, mps.most_common_size ORDER BY average_supply_cost DESC, total_available_quantity DESC;
SELECT r.r_name AS region, avg(c.c_acctbal) AS avg_customer_acct_balance, avg(s.s_acctbal) AS avg_supplier_acct_balance, count(DISTINCT o.o_orderkey) AS total_orders, avg(o.o_totalprice) AS avg_order_total_price FROM region r INNER JOIN customer c ON c.c_nationkey = r.r_regionkey INNER JOIN supplier s ON s.s_nationkey = r.r_regionkey INNER JOIN orders o ON o.o_custkey = c.c_custkey INNER JOIN lineitem l ON l.l_orderkey = o.o_orderkey INNER JOIN part p ON p.p_partkey = l.l_partkey AND p.p_size = 17 GROUP BY r.r_name ORDER BY avg_customer_acct_balance DESC, avg_supplier_acct_balance DESC;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue, AVG(l.l_quantity) AS average_quantity, AVG(l.l_extendedprice) AS average_price, COUNT(DISTINCT o.o_orderkey) AS total_orders FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE r.r_name IN ('EUROPE', 'ASIA') AND o.o_orderpriority IN ('1-URGENT', '2-HIGH') AND l.l_shipinstruct = 'DELIVER IN PERSON' AND l.l_shipmode IN ('AIR', 'RAIL') GROUP BY r.r_name, n.n_name ORDER BY revenue DESC;
SELECT r.r_name AS region, n.n_name AS nation, p.p_type AS part_type, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_quantity) AS average_quantity, AVG(l.l_extendedprice) AS average_price, MAX(s.s_acctbal) AS max_supplier_acctbal FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN lineitem l ON p.p_partkey = l.l_partkey AND s.s_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE o.o_orderstatus = 'F' AND l.l_linestatus = 'F' AND p.p_type IN ('SMALL BRUSHED BRASS', 'ECONOMY PLATED COPPER', 'LARGE BRUSHED STEEL') GROUP BY region, nation, part_type ORDER BY total_revenue DESC, region, nation, part_type;
