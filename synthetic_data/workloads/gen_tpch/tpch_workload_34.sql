SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS number_of_customers, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, AVG(c.c_acctbal) AS average_customer_account_balance, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_discount) AS average_discount, COUNT(DISTINCT l.l_orderkey) AS number_of_orders FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey WHERE c.c_mktsegment = 'MACHINERY' AND l.l_shipdate BETWEEN '2022-01-01' AND '2022-12-31' GROUP BY r.r_name, n.n_name ORDER BY total_revenue DESC;
SELECT s_name, p_brand, SUM(l_extendedprice) AS total_sales, AVG(l_quantity) AS average_quantity_sold, COUNT(DISTINCT o_orderkey) AS number_of_orders, AVG(o_totalprice) AS average_order_value, MAX(p_retailprice) AS max_retail_price, MIN(s_acctbal) AS min_supplier_account_balance FROM supplier JOIN lineitem ON s_suppkey = l_suppkey JOIN part ON p_partkey = l_partkey JOIN orders ON o_orderkey = l_orderkey WHERE s_phone = '32-923-170-9487' AND o_clerk IN ('Clerk#000000421', 'Clerk#000009610', 'Clerk#000022774') AND p_retailprice IN (1616.71, 1175.26, 1624.71) AND o_orderdate BETWEEN '1995-01-01' AND '1995-12-31' GROUP BY s_name, p_brand ORDER BY total_sales DESC, average_quantity_sold DESC LIMIT 10;
SELECT r_name AS region, c_mktsegment AS market_segment, AVG(c_acctbal) AS avg_customer_acct_balance, SUM(l_extendedprice * (1 - l_discount)) AS total_sales_revenue FROM region JOIN nation ON region.r_regionkey = nation.n_regionkey JOIN customer ON nation.n_nationkey = customer.c_nationkey JOIN orders ON customer.c_custkey = orders.o_custkey JOIN lineitem ON orders.o_orderkey = lineitem.l_orderkey WHERE orders.o_orderdate >= date '1995-10-01' AND orders.o_orderdate <= date '1995-12-31' GROUP BY region, market_segment ORDER BY region, total_sales_revenue DESC;
SELECT r.r_name AS region, n.n_name AS nation, c.c_mktsegment AS market_segment, count(DISTINCT o.o_orderkey) AS total_orders, sum(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, avg(l.l_quantity) AS avg_quantity, avg(l.l_extendedprice) AS avg_price, avg(l.l_discount) AS avg_discount FROM orders o JOIN customer c ON c.c_custkey = o.o_custkey JOIN nation n ON n.n_nationkey = c.c_nationkey JOIN region r ON r.r_regionkey = n.n_regionkey JOIN lineitem l ON l.l_orderkey = o.o_orderkey WHERE o.o_orderdate >= date '1995-01-01' AND o.o_orderdate < date '1996-01-01' AND l.l_shipdate > o.o_orderdate AND r.r_name = 'EUROPE' GROUP BY region, nation, market_segment ORDER BY total_revenue DESC, total_orders DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS total_suppliers, COUNT(DISTINCT c_custkey) AS total_customers, SUM(l_extendedprice * (1 - l_discount)) AS total_sales, AVG(l_quantity) AS average_quantity, AVG(s_acctbal) AS average_supplier_account_balance, AVG(c_acctbal) AS average_customer_account_balance FROM region JOIN nation ON n_regionkey = r_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN orders ON o_custkey = c_custkey JOIN lineitem ON l_orderkey = o_orderkey WHERE r_name IN ('EUROPE', 'ASIA') AND o_orderdate BETWEEN date '2022-01-01' AND date '2022-12-31' AND l_shipdate > o_orderdate GROUP BY r_name, n_name ORDER BY total_sales DESC, region, nation;
SELECT c.c_mktsegment, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(o.o_totalprice) AS total_revenue, AVG(o.o_totalprice) AS average_order_value, SUM(s.s_acctbal) AS total_supplier_balance, COUNT(DISTINCT s.s_suppkey) AS total_suppliers FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN supplier s ON c.c_nationkey = s.s_nationkey WHERE o.o_orderstatus = 'F' AND c.c_mktsegment IN ('HOUSEHOLD', 'BUILDING', 'FURNITURE', 'AUTOMOBILE') AND o.o_orderdate BETWEEN '2020-01-01' AND '2023-01-01' GROUP BY c.c_mktsegment, order_year ORDER BY total_revenue DESC, c.c_mktsegment, order_year;
SELECT n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice * (1 - l_discount)) AS avg_revenue, SUM((l.l_extendedprice * (1 - l_discount)) * (1 + l_tax)) AS total_taxed_revenue FROM nation n JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey WHERE l.l_receiptdate BETWEEN '1994-01-01' AND '1995-12-31' AND l.l_shipinstruct IN ('COLLECT COD', 'DELIVER IN PERSON') AND s.s_acctbal > 0 GROUP BY nation ORDER BY total_taxed_revenue DESC, avg_revenue DESC LIMIT 10;
SELECT n.n_name AS nation, c.c_mktsegment AS market_segment, COUNT(DISTINCT o.o_orderkey) AS total_orders, AVG(o.o_totalprice) AS average_order_price, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_quantity) AS average_quantity_sold FROM customer AS c JOIN orders AS o ON c.c_custkey = o.o_custkey JOIN lineitem AS l ON o.o_orderkey = l.l_orderkey JOIN nation AS n ON c.c_nationkey = n.n_nationkey WHERE l.l_shipinstruct = 'DELIVER IN PERSON' AND c.c_phone LIKE '31-%' AND l.l_shipdate BETWEEN '1995-01-01' AND '1996-12-31' GROUP BY nation, market_segment ORDER BY total_revenue DESC, average_order_price DESC;
SELECT n_name, COUNT(DISTINCT s_suppkey) AS total_suppliers, COUNT(DISTINCT c_custkey) AS total_customers, AVG(s_acctbal) AS average_supplier_acctbal, AVG(c_acctbal) AS average_customer_acctbal, SUM(l_extendedprice * (1 - l_discount)) AS revenue, MAX(o_totalprice) AS max_order_totalprice, MIN(ps_supplycost) AS min_partsupp_supplycost FROM nation JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN partsupp ON s_suppkey = ps_suppkey JOIN lineitem ON l_suppkey = ps_suppkey AND l_partkey = ps_partkey JOIN orders ON l_orderkey = o_orderkey WHERE l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' AND o_orderpriority = '5-LOW' AND s_address IN ('98bqrrD5wRGOSB IAv9sT2', 'iC6sb9XOc1FuPrbtTqNRuMsMNay', 'piOimoavqzHBqI0GCxAmXPQvoyCvLhzK2,l9V') AND s_acctbal BETWEEN 1000 AND 6000 AND l_receiptdate IN ('1994-03-05', '1995-12-11', '1996-03-12', '1997-07-02') GROUP BY n_name ORDER BY revenue DESC, average_supplier_acctbal DESC, average_customer_acctbal DESC LIMIT 10;
SELECT r_name AS region, COUNT(DISTINCT s_suppkey) AS num_suppliers, COUNT(DISTINCT c_custkey) AS num_customers, COUNT(DISTINCT o_orderkey) AS num_orders, SUM(o_totalprice) AS total_sales, AVG(s_acctbal) AS avg_supplier_acctbal, AVG(c_acctbal) AS avg_customer_acctbal, AVG(p_retailprice) AS avg_part_retailprice, SUM(ps_availqty) AS total_parts_availqty, SUM(ps_supplycost * ps_availqty) AS total_parts_value FROM region JOIN supplier ON s_nationkey = r_regionkey JOIN customer ON c_nationkey = r_regionkey JOIN orders ON o_custkey = c_custkey JOIN partsupp ON ps_suppkey = s_suppkey JOIN part ON p_partkey = ps_partkey WHERE p_mfgr = 'Manufacturer#3' AND (s_acctbal BETWEEN 500 AND 10000) AND c_mktsegment = 'AUTOMOBILE' AND o_orderstatus = 'F' AND (p_comment LIKE '%uests. a%' OR p_comment LIKE '%old asymptotes%' OR p_comment LIKE '%y. express reques%' OR p_comment LIKE '%pending requests aft%') GROUP BY r_name ORDER BY total_sales DESC, avg_supplier_acctbal DESC;
SELECT r.r_name AS region_name, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales, AVG(l.l_discount) AS average_discount, AVG(l.l_quantity) AS average_quantity FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE o.o_orderpriority = '3-MEDIUM' AND l.l_shipmode IN ('AIR', 'RAIL', 'TRUCK') GROUP BY region_name, order_year ORDER BY total_sales DESC, region_name, order_year;
SELECT s_name, s_address, p_type, AVG(l_quantity) AS average_quantity, SUM(l_extendedprice) AS total_sales, COUNT(DISTINCT l_orderkey) AS number_of_orders, SUM(CASE WHEN l_discount > 0 THEN l_extendedprice * (1 - l_discount) ELSE 0 END) AS discounted_sales FROM supplier JOIN lineitem ON supplier.s_suppkey = lineitem.l_suppkey JOIN part ON lineitem.l_partkey = part.p_partkey WHERE s_acctbal > 5000 AND p_mfgr = 'Manufacturer#5' AND l_shipdate BETWEEN '2022-01-01' AND '2022-12-31' GROUP BY s_name, s_address, p_type ORDER BY total_sales DESC, s_name LIMIT 10;
SELECT r.r_name AS region_name, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, COUNT(DISTINCT p.p_partkey) AS total_parts, COUNT(DISTINCT o.o_orderkey) AS total_orders, AVG(s.s_acctbal) AS average_supplier_balance, AVG(p.p_retailprice) AS average_part_price, SUM(o.o_totalprice) AS total_revenue FROM region r JOIN supplier s ON r.r_regionkey = s.s_nationkey JOIN orders o ON s.s_suppkey = o.o_custkey JOIN part p ON p.p_size IN (19, 37) WHERE r.r_name = 'ASIA' AND p.p_name IN ( 'deep dim dodger navajo peru', 'navajo red mint misty papaya', 'rosy slate antique dodger sky', 'turquoise seashell misty navajo thistle' ) GROUP BY region_name ORDER BY total_revenue DESC;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, COUNT(DISTINCT c.c_custkey) AS total_customers, AVG(s.s_acctbal) AS avg_supplier_acctbal, AVG(c.c_acctbal) AS avg_customer_acctbal, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey WHERE r.r_name IN ('MIDDLE EAST', 'EUROPE', 'AMERICA') AND l.l_shipdate BETWEEN '2023-01-01' AND '2023-12-31' GROUP BY r.r_name, n.n_name ORDER BY revenue DESC, region, nation;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS suppliers_count, COUNT(DISTINCT c_custkey) AS customers_count, AVG(s_acctbal) AS avg_supplier_acctbal, AVG(c_acctbal) AS avg_customer_acctbal, SUM(l_extendedprice * (1 - l_discount)) AS total_sales, AVG(l_quantity) AS avg_quantity_sold, COUNT(DISTINCT o_orderkey) AS total_orders FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN orders ON o_custkey = c_custkey JOIN lineitem ON l_orderkey = o_orderkey WHERE l_shipdate BETWEEN '1994-01-01' AND '1994-12-31' AND l_returnflag = 'F' GROUP BY region, nation ORDER BY total_sales DESC, region, nation;
SELECT n_name, r_name, p_type, AVG(l_extendedprice) AS avg_price, SUM(l_extendedprice * (1 - l_discount)) AS revenue, COUNT(DISTINCT s_suppkey) AS supplier_count, COUNT(DISTINCT o_orderkey) AS order_count, COUNT(*) AS lineitem_count FROM nation JOIN region ON n_regionkey = r_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN lineitem ON l_suppkey = s_suppkey JOIN orders ON o_orderkey = l_orderkey JOIN part ON p_partkey = l_partkey JOIN partsupp ON ps_suppkey = s_suppkey AND ps_partkey = p_partkey WHERE r_name IN ('EUROPE', 'AMERICA') AND l_receiptdate >= '1997-01-01' AND l_receiptdate < '1997-04-01' AND l_discount BETWEEN 0.05 AND 0.07 AND p_size IN (1, 5, 10, 15, 20, 25) AND o_orderdate BETWEEN '1996-01-01' AND '1996-12-31' GROUP BY n_name, r_name, p_type ORDER BY revenue DESC, avg_price DESC LIMIT 10;
SELECT n.n_name AS nation, EXTRACT(YEAR FROM l.l_shipdate) AS ship_year, COUNT(*) AS total_orders, SUM(l.l_extendedprice) AS total_revenue, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue_after_discount, AVG(l.l_quantity) AS avg_quantity, AVG(l.l_extendedprice) AS avg_price, AVG(l.l_discount) AS avg_discount FROM nation n JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey WHERE l.l_returnflag IN ('A', 'N') AND l.l_discount BETWEEN 0.04 AND 0.09 AND s.s_acctbal BETWEEN -452.51 AND 2658.57 AND n.n_nationkey IN (3, 23, 17, 9, 21, 11) GROUP BY nation, ship_year ORDER BY nation, ship_year DESC;
SELECT r.r_name AS region_name, c.c_mktsegment AS market_segment, AVG(c.c_acctbal) AS average_account_balance, SUM(ps.ps_supplycost) AS total_supply_cost, COUNT(DISTINCT l.l_orderkey) AS total_orders, SUM(l.l_extendedprice * (1 - l_discount)) AS revenue FROM region r JOIN customer c ON c.c_nationkey = r.r_regionkey JOIN partsupp ps ON ps.ps_suppkey = c.c_custkey JOIN lineitem l ON l.l_suppkey = ps.ps_suppkey AND l.l_partkey = ps.ps_partkey WHERE r.r_name = 'EUROPE' AND c.c_address LIKE 'YlQxhRBm,bV0K9FefkpyODChB%' AND l.l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' AND l.l_orderkey IN (2464, 1221, 513, 3751) GROUP BY region_name, market_segment ORDER BY total_supply_cost DESC, revenue DESC, average_account_balance DESC;
SELECT r.r_name AS region, c.c_mktsegment AS market_segment, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_quantity) AS average_quantity_sold, AVG(ps.ps_supplycost) AS average_supply_cost, MAX(c.c_acctbal) AS max_customer_balance FROM region r JOIN customer c ON r.r_regionkey = c.c_nationkey JOIN lineitem l ON c.c_custkey = l.l_orderkey JOIN partsupp ps ON l.l_partkey = ps.ps_partkey AND l.l_suppkey = ps.ps_suppkey WHERE l.l_receiptdate BETWEEN '1993-01-01' AND '1998-12-31' GROUP BY r.r_name, c.c_mktsegment ORDER BY total_revenue DESC, average_quantity_sold DESC;
SELECT r_name AS region, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(o.o_totalprice) AS total_sales, AVG(l.l_quantity) AS average_quantity_ordered, SUM((l.l_extendedprice * (1 - l.l_discount))) AS revenue, COUNT(DISTINCT o.o_orderkey) AS number_of_orders FROM region JOIN customer c ON c.c_nationkey = region.r_regionkey JOIN orders o ON o.o_custkey = c.c_custkey JOIN lineitem l ON l.l_orderkey = o.o_orderkey WHERE r_name IN ('MIDDLE EAST', 'ASIA', 'EUROPE', 'AMERICA', 'AFRICA') AND o.o_shippriority = 0 AND o.o_totalprice > 20000 GROUP BY r_name ORDER BY total_sales DESC;
SELECT s.s_name AS supplier_name, n.n_name AS nation_name, COUNT(DISTINCT p.p_partkey) AS distinct_parts_count, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_discounted_revenue FROM supplier s JOIN nation n ON s.s_nationkey = n.n_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey JOIN part p ON l.l_partkey = p.p_partkey WHERE p.p_brand IN ('Brand#45', 'Brand#33', 'Brand#25') GROUP BY s.s_suppkey, s.s_name, n.n_name ORDER BY avg_discounted_revenue DESC, s.s_name;
SELECT r.r_name AS region, c.c_mktsegment AS market_segment, COUNT(DISTINCT c.c_custkey) AS number_of_customers, AVG(c.c_acctbal) AS average_account_balance, SUM(ps.ps_availqty) AS total_available_quantity, AVG(ps.ps_supplycost) AS average_supply_cost FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey JOIN partsupp ps ON ps.ps_suppkey = c.c_custkey WHERE c.c_acctbal > 7000 AND r.r_name IN ('ASIA', 'MIDDLE EAST', 'AMERICA') AND c.c_mktsegment IN ('HOUSEHOLD', 'AUTOMOBILE', 'BUILDING', 'MACHINERY', 'FURNITURE') AND ps.ps_supplycost < (SELECT AVG(ps_supplycost) FROM partsupp) GROUP BY region, market_segment ORDER BY region, market_segment;
SELECT r_name AS region, c_mktsegment AS market_segment, SUM(o_totalprice) AS total_sales, AVG(c_acctbal) AS avg_customer_balance, COUNT(DISTINCT c_custkey) AS number_of_customers, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, SUM(l_extendedprice * (1 - l_discount)) AS revenue_after_discount FROM customer JOIN orders ON c_custkey = o_custkey JOIN lineitem ON l_orderkey = o_orderkey JOIN supplier ON s_suppkey = l_suppkey JOIN region ON s_nationkey = r_regionkey GROUP BY region, market_segment ORDER BY total_sales DESC, avg_customer_balance DESC LIMIT 10;
SELECT r.r_name AS region_name, c.c_mktsegment AS customer_market_segment, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(o.o_totalprice) AS total_order_value, AVG(l.l_discount) AS average_discount, COUNT(DISTINCT s.s_suppkey) AS total_suppliers FROM orders o INNER JOIN customer c ON o.o_custkey = c.c_custkey INNER JOIN nation n ON c.c_nationkey = n.n_nationkey INNER JOIN region r ON n.n_regionkey = r.r_regionkey INNER JOIN lineitem l ON o.o_orderkey = l.l_orderkey INNER JOIN supplier s ON s.s_nationkey = n.n_nationkey WHERE l.l_returnflag <> 'N' AND c.c_mktsegment IN ('BUILDING', 'AUTOMOBILE', 'MACHINERY') AND l.l_shipdate IN ('1997-12-27', '1996-01-22', '1997-03-09', '1994-05-11', '1998-04-17') GROUP BY r.r_name, c.c_mktsegment ORDER BY total_order_value DESC, average_discount ASC;
SELECT n.n_name AS nation_name, COUNT(s.s_suppkey) AS total_suppliers, AVG(s.s_acctbal) AS avg_account_balance, SUM(ps.ps_availqty) AS total_parts_quantity, AVG(ps.ps_supplycost) AS avg_supply_cost FROM nation n JOIN region r ON n.n_regionkey = r.r_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey WHERE r.r_name = 'EUROPE' GROUP BY n.n_name ORDER BY avg_account_balance DESC, total_suppliers DESC;
SELECT r.r_name AS region_name, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT l.l_orderkey) AS total_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales, AVG(l.l_discount) AS average_discount, COUNT(DISTINCT ps.ps_suppkey) AS number_of_suppliers, AVG(ps.ps_supplycost) AS average_supply_cost FROM region r JOIN partsupp ps ON ps.ps_suppkey = r.r_regionkey JOIN lineitem l ON l.l_suppkey = ps.ps_suppkey AND l.l_partkey = ps.ps_partkey JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE EXTRACT(YEAR FROM o.o_orderdate) = 2023 GROUP BY r.r_name, order_year ORDER BY r.r_name, total_sales DESC;
