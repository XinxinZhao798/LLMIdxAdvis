SELECT r.r_name AS region, c.c_mktsegment AS market_segment, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice) AS avg_price, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue_after_discount, SUM(CASE WHEN l.l_returnflag = 'R' THEN l.l_quantity ELSE 0 END) AS returned_quantity, COUNT(CASE WHEN l.l_shipinstruct = 'DELIVER IN PERSON' THEN 1 END) AS personal_deliveries FROM region r JOIN customer c ON c.c_nationkey = r.r_regionkey JOIN orders o ON o.o_custkey = c.c_custkey JOIN lineitem l ON l.l_orderkey = o.o_orderkey WHERE r.r_regionkey = 1 AND o.o_orderdate BETWEEN date '1995-01-01' AND date '1996-12-31' AND l.l_shipmode IN ('RAIL', 'TRUCK') GROUP BY region, market_segment ORDER BY revenue_after_discount DESC;
SELECT c_nationkey AS nation_key, AVG(c_acctbal) AS avg_customer_acct_balance, AVG(s_acctbal) AS avg_supplier_acct_balance, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue FROM customer JOIN supplier ON customer.c_nationkey = supplier.s_nationkey JOIN orders ON customer.c_custkey = orders.o_custkey JOIN lineitem ON orders.o_orderkey = lineitem.l_orderkey WHERE lineitem.l_shipdate BETWEEN '2023-01-01' AND '2023-12-31' AND lineitem.l_returnflag = 'F' GROUP BY c_nationkey ORDER BY total_revenue DESC;
SELECT r.r_name AS region, COUNT(DISTINCT c.c_custkey) AS number_of_customers, AVG(c.c_acctbal) AS average_account_balance, SUM(ps.ps_availqty) AS total_available_quantity, AVG(ps.ps_supplycost) AS average_supply_cost FROM region r JOIN customer c ON r.r_regionkey = c.c_nationkey JOIN partsupp ps ON c.c_custkey = ps.ps_suppkey WHERE c.c_mktsegment = 'BUILDING' AND ps.ps_supplycost BETWEEN 200 AND 600 GROUP BY r.r_name ORDER BY average_account_balance DESC, total_available_quantity DESC;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue, AVG(l.l_quantity) AS average_quantity, AVG(l.l_extendedprice) AS average_price, COUNT(DISTINCT o.o_orderkey) AS total_orders FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE r.r_name IN ('EUROPE', 'ASIA') AND o.o_orderpriority IN ('1-URGENT', '2-HIGH') AND l.l_shipinstruct = 'DELIVER IN PERSON' AND l.l_shipmode IN ('AIR', 'RAIL') GROUP BY r.r_name, n.n_name ORDER BY revenue DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, SUM(l_extendedprice) AS total_sales, AVG(l_extendedprice * (1 - l_discount)) AS avg_undiscounted_sales, AVG(l_quantity) AS avg_quantity_sold, COUNT(DISTINCT o_orderkey) AS number_of_orders FROM region JOIN nation ON n_regionkey = r_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN partsupp ON ps_suppkey = s_suppkey JOIN lineitem ON l_suppkey = s_suppkey AND l_partkey = ps_partkey JOIN orders ON o_orderkey = l_orderkey JOIN customer ON c_custkey = o_custkey AND c_nationkey = n_nationkey GROUP BY region, nation ORDER BY total_sales DESC, region, nation;
SELECT r.r_name AS region_name, n.n_name AS nation_name, COUNT(DISTINCT c.c_custkey) AS customer_count, COUNT(DISTINCT s.s_suppkey) AS supplier_count, AVG(c.c_acctbal) AS avg_customer_acctbal, SUM(o.o_totalprice) AS total_sales, AVG(o.o_totalprice) AS avg_order_value FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN supplier s ON n.n_nationkey = s.s_nationkey WHERE r.r_regionkey IN (1, 0, 2) AND n.n_name <> 'MOROCCO' AND o.o_orderdate BETWEEN '2022-01-01' AND '2022-12-31' GROUP BY r.r_name, n.n_name ORDER BY total_sales DESC, avg_order_value DESC, region_name, nation_name;
SELECT n.n_name AS nation_name, c.c_mktsegment AS market_segment, COUNT(DISTINCT c.c_custkey) AS num_customers, SUM(l.l_quantity) AS total_quantity_ordered, AVG(l.l_extendedprice) AS avg_price, SUM(l.l_extendedprice * (1 - l_discount)) AS revenue_after_discount, AVG(ps.ps_supplycost) AS avg_supply_cost FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN lineitem l ON c.c_custkey = l.l_suppkey JOIN partsupp ps ON l.l_partkey = ps.ps_partkey AND l.l_suppkey = ps.ps_suppkey WHERE c.c_mktsegment IN ('HOUSEHOLD', 'AUTOMOBILE', 'BUILDING', 'MACHINERY', 'FURNITURE') AND l.l_receiptdate BETWEEN '1994-01-01' AND '1998-12-31' AND l.l_commitdate < l.l_receiptdate AND ps.ps_supplycost IN (498.24, 99.63, 961.19, 162.95) AND ps.ps_partkey IN (1041, 906) GROUP BY nation_name, market_segment ORDER BY revenue_after_discount DESC, nation_name, market_segment;
SELECT r.r_name AS region, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, AVG(s.s_acctbal) AS average_account_balance, SUM(p.ps_availqty) AS total_available_quantity, AVG(p.ps_supplycost) AS average_supply_cost, SUM(l.l_quantity) AS total_quantity_ordered, SUM(l.l_extendedprice * (1 - l_discount)) AS total_revenue, COUNT(DISTINCT l.l_orderkey) AS number_of_orders FROM region r JOIN supplier s ON s.s_nationkey = r.r_regionkey JOIN partsupp p ON p.ps_suppkey = s.s_suppkey JOIN lineitem l ON l.l_suppkey = p.ps_suppkey AND l.l_partkey = p.ps_partkey WHERE r.r_name IN ('MIDDLE EAST', 'ASIA', 'EUROPE', 'AMERICA', 'AFRICA') AND s.s_acctbal BETWEEN 1500 AND 7000 AND l.l_shipinstruct = 'COLLECT COD' AND l.l_shipdate BETWEEN '1993-01-01' AND '1993-12-31' GROUP BY r.r_name ORDER BY total_revenue DESC;
SELECT r_name AS region_name, p_brand, AVG(p_retailprice) AS avg_retail_price, SUM(l_quantity) AS total_quantity_sold, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue, COUNT(DISTINCT l_orderkey) AS number_of_orders FROM region JOIN partsupp ON ps_suppkey::text LIKE r_regionkey::text || '%' JOIN part ON p_partkey = ps_partkey JOIN lineitem ON l_partkey = p_partkey AND l_suppkey = ps_suppkey WHERE r_name = 'EUROPE' AND l_shipdate BETWEEN '2020-01-01' AND '2020-12-31' GROUP BY r_name, p_brand ORDER BY total_revenue DESC, avg_retail_price DESC LIMIT 10;
SELECT n.n_name, AVG(c.c_acctbal) AS avg_customer_balance, SUM(o.o_totalprice) AS total_sales, COUNT(DISTINCT c.c_custkey) AS number_of_customers, COUNT(DISTINCT p.p_partkey) AS number_of_parts_sold, SUM(ps.ps_availqty) AS total_parts_available FROM nation n JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN partsupp ps ON ps.ps_suppkey = o.o_orderkey JOIN part p ON p.p_partkey = ps.ps_partkey WHERE p.p_container IN ('LG CASE', 'JUMBO PKG') AND p.p_brand IN ('Brand#25', 'Brand#51') AND o.o_clerk IN ('Clerk#000010208', 'Clerk#000008953') AND o.o_orderstatus = 'F' GROUP BY n.n_name ORDER BY total_sales DESC, avg_customer_balance DESC LIMIT 10;
SELECT c.c_mktsegment, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_discounted_price, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(ps.ps_supplycost) AS avg_supply_cost FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN partsupp ps ON l.l_partkey = ps.ps_partkey AND l.l_suppkey = ps.ps_suppkey WHERE o.o_orderdate BETWEEN '1994-01-01' AND '1997-12-31' AND o.o_clerk IN ('Clerk#000013110', 'Clerk#000019634', 'Clerk#000022938', 'Clerk#000000992') GROUP BY c.c_mktsegment, order_year ORDER BY c.c_mktsegment, order_year;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(p.p_partkey) AS number_of_parts, AVG(p.p_retailprice) AS average_retail_price, SUM(p.p_retailprice) AS total_retail_value, MAX(p.p_size) AS max_part_size, MIN(p.p_size) AS min_part_size FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN part p ON p.p_size BETWEEN 1 AND 15 WHERE n.n_comment LIKE '%final%' AND p.p_type LIKE '%STEEL' GROUP BY r.r_name, n.n_name ORDER BY total_retail_value DESC, average_retail_price DESC;
SELECT r.r_name AS region, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_discounted_price, SUM(CASE WHEN l.l_returnflag = 'R' THEN l.l_extendedprice ELSE 0 END) AS total_returned_value FROM region r JOIN orders o ON r.r_regionkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE o.o_orderdate BETWEEN '1992-01-01' AND '1997-12-31' GROUP BY region, order_year ORDER BY region, order_year;
SELECT n.n_name AS nation_name, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, COUNT(DISTINCT p.p_partkey) AS total_parts, SUM(l.l_quantity) AS total_quantity_sold, AVG(l.l_extendedprice) AS avg_sale_price, SUM(l.l_extendedprice * (1 - l_discount)) AS total_discounted_sales_value, AVG(l.l_discount) AS avg_discount_given, COUNT(DISTINCT o.o_orderkey) AS total_orders_processed FROM nation n JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN lineitem l ON p.p_partkey = l.l_partkey AND s.s_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE o.o_orderdate BETWEEN '2022-01-01' AND '2022-12-31' AND l.l_shipdate > o.o_orderdate AND n.n_regionkey IN (1, 2, 3) GROUP BY n.n_name ORDER BY total_quantity_sold DESC, avg_sale_price DESC LIMIT 5;
SELECT n.n_name, c.c_mktsegment, AVG(c.c_acctbal) AS avg_acct_balance, COUNT(c.c_custkey) AS customer_count, SUM(li.l_extendedprice * (1 - li.l_discount)) AS total_sales FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN lineitem li ON c.c_custkey = li.l_suppkey WHERE c.c_comment LIKE '%y across the accounts. even deposits try to cajo%' AND c.c_mktsegment IN ('HOUSEHOLD', 'BUILDING', 'AUTOMOBILE') GROUP BY n.n_name, c.c_mktsegment ORDER BY n.n_name, c.c_mktsegment;
SELECT n.n_name AS nation, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales, AVG(s.s_acctbal) AS avg_supplier_balance, SUM(ps.ps_availqty) AS total_available_quantity FROM nation n INNER JOIN supplier s ON n.n_nationkey = s.s_nationkey INNER JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey INNER JOIN lineitem l ON ps.ps_suppkey = l.l_suppkey AND ps.ps_partkey = l.l_partkey INNER JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE n.n_nationkey IN (12, 9, 11, 15) AND l.l_suppkey IN (128236, 197502, 170405, 85908) GROUP BY nation, order_year ORDER BY nation, order_year DESC;
SELECT r_name AS region, COUNT(DISTINCT s_suppkey) AS total_suppliers, COUNT(DISTINCT c_custkey) AS total_customers, SUM(l_extendedprice) AS total_sales, AVG(l_quantity) AS average_quantity_sold, SUM(l_extendedprice * (1 - l_discount)) AS revenue_after_discount FROM region JOIN supplier ON region.r_regionkey = supplier.s_nationkey JOIN partsupp ON supplier.s_suppkey = partsupp.ps_suppkey JOIN lineitem ON partsupp.ps_partkey = lineitem.l_partkey AND partsupp.ps_suppkey = lineitem.l_suppkey JOIN part ON lineitem.l_partkey = part.p_partkey JOIN orders ON lineitem.l_orderkey = orders.o_orderkey JOIN customer ON orders.o_custkey = customer.c_custkey WHERE customer.c_acctbal > 5000 AND part.p_retailprice > 1000 AND lineitem.l_shipdate BETWEEN '1995-01-01' AND '1996-12-31' GROUP BY region.r_name ORDER BY total_sales DESC LIMIT 1;
SELECT r.r_name AS region_name, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales_revenue, AVG(l.l_extendedprice * (1 - l.l_discount)) AS average_sales_per_order FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN supplier s ON l.l_suppkey = s.s_suppkey JOIN region r ON s.s_nationkey = c.c_nationkey WHERE c.c_mktsegment = 'FURNITURE' AND o.o_orderdate BETWEEN DATE '2022-01-01' AND DATE '2022-12-31' GROUP BY r.r_name ORDER BY total_sales_revenue DESC;
SELECT c.c_mktsegment, p.p_size, COUNT(DISTINCT l.l_orderkey) AS number_of_orders, SUM(l.l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(l.l_discount) AS average_discount FROM customer AS c JOIN lineitem AS l ON c.c_custkey = l.l_suppkey JOIN part AS p ON l.l_partkey = p.p_partkey JOIN region AS r ON c.c_nationkey = r.r_regionkey WHERE c.c_mktsegment = 'AUTOMOBILE' AND r.r_name = 'AMERICA' AND p.p_size BETWEEN 1 AND 5 AND l.l_shipmode IN ('AIR', 'AIR REG') GROUP BY c.c_mktsegment, p.p_size ORDER BY total_revenue DESC;
SELECT n.n_name AS nation_name, p.p_type AS part_type, AVG(ps.ps_supplycost) AS avg_supply_cost, SUM(ps.ps_availqty) AS total_avail_qty, COUNT(DISTINCT p.p_partkey) AS num_parts FROM nation n JOIN partsupp ps ON n.n_nationkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey WHERE n.n_name IN ('RUSSIA', 'INDONESIA', 'ETHIOPIA') AND p.p_type LIKE '%Widget%' AND p.p_size BETWEEN 10 AND 20 GROUP BY n.n_name, p.p_type ORDER BY avg_supply_cost DESC, total_avail_qty DESC;
SELECT r.r_name AS region_name, c.c_mktsegment AS market_segment, AVG(c.c_acctbal) AS avg_account_balance, COUNT(c.c_custkey) AS customer_count, SUM(c.c_acctbal) AS total_account_balance FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey GROUP BY r.r_name, c.c_mktsegment ORDER BY region_name, market_segment;
SELECT p.p_brand, c.c_mktsegment, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales, AVG(l.l_discount) AS average_discount, SUM(l.l_quantity) AS total_quantity FROM part p JOIN lineitem l ON p.p_partkey = l.l_partkey JOIN orders o ON l.l_orderkey = o.o_orderkey JOIN customer c ON o.o_custkey = c.c_custkey GROUP BY p.p_brand, c.c_mktsegment ORDER BY p.p_brand, c.c_mktsegment;
SELECT r.r_name AS region, c.c_mktsegment AS market_segment, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(l_extendedprice) AS total_sales, AVG(l_quantity) AS average_quantity_sold, SUM(l_extendedprice * (1 - l_discount)) AS revenue_after_discount FROM customer c JOIN region r ON c.c_nationkey = r.r_regionkey JOIN lineitem l ON l_suppkey IN ( SELECT s_suppkey FROM supplier s WHERE s.s_nationkey = c.c_nationkey ) WHERE c.c_mktsegment IN ('HOUSEHOLD', 'AUTOMOBILE', 'BUILDING', 'MACHINERY', 'FURNITURE') AND l.l_shipdate BETWEEN date '2022-01-01' AND date '2022-12-31' GROUP BY r.r_name, c.c_mktsegment ORDER BY total_sales DESC;
SELECT c.c_mktsegment, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT c.c_custkey) AS num_customers, COUNT(DISTINCT o.o_orderkey) AS num_orders, SUM(o.o_totalprice) AS total_revenue, AVG(o.o_totalprice) AS avg_order_value, SUM(p.p_retailprice) AS total_parts_value, AVG(p.p_retailprice) AS avg_part_price FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN part p ON p.p_partkey = ANY (SELECT p_partkey FROM part WHERE p_comment LIKE '%s. instr%' OR p_comment LIKE '%ct furiously%' OR p_comment LIKE '%unusual%' OR p_comment LIKE '%old id%' OR p_comment LIKE '%r requests cajole flu%') WHERE c.c_name IN ('Customer#000023416', 'Customer#000027111', 'Customer#000023731', 'Customer#000025059', 'Customer#000023541', 'Customer#000028235') AND c.c_address IN ('Z8tV2uksV4Ml,yfagECI69f26scpmQWOeN', 'ejMUZ,WG1Q', '2P8wQpwlFa', 'igke6sLYDpoVUMkFod') AND o.o_orderstatus = 'F' GROUP BY c.c_mktsegment, order_year ORDER BY c.c_mktsegment, order_year;
