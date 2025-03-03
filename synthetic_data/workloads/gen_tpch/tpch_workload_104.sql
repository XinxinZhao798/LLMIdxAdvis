SELECT r_name AS region, AVG(s_acctbal) AS average_supplier_account_balance, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT p_partkey) AS number_of_parts, SUM(l_extendedprice) AS total_sales, SUM(l_extendedprice * (1 - l_discount)) AS total_sales_after_discount, SUM(l_quantity) AS total_quantity_sold FROM region JOIN supplier ON r_regionkey = s_nationkey JOIN part ON p_partkey IN (SELECT l_partkey FROM lineitem) JOIN lineitem ON l_suppkey = s_suppkey AND l_partkey = p_partkey WHERE r_comment LIKE '%final%' OR p_type LIKE '%BRASS' GROUP BY r_name ORDER BY total_sales_after_discount DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, AVG(s_acctbal) AS avg_supplier_acctbal, AVG(c_acctbal) AS avg_customer_acctbal, SUM(l_extendedprice * (1 - l_discount)) AS total_sales_volume FROM region JOIN nation ON n_regionkey = r_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN orders ON o_custkey = c_custkey JOIN lineitem ON l_orderkey = o_orderkey JOIN part ON l_partkey = p_partkey WHERE r_name IN ('EUROPE', 'AMERICA') AND o_orderdate BETWEEN date '1993-01-01' AND date '1993-12-31' AND p_size IN (7, 42) AND p_name LIKE ANY (ARRAY['%peach%', '%cyan%', '%orange%', '%aquamarine%', '%sienna%']) GROUP BY region, nation ORDER BY total_sales_volume DESC;
SELECT r.r_name AS region_name, n.n_name AS nation_name, COUNT(DISTINCT c.c_custkey) AS num_customers, SUM(o.o_totalprice) AS total_sales, AVG(c.c_acctbal) AS avg_customer_balance, (SELECT AVG(p.p_retailprice) FROM part p INNER JOIN partsupp ps ON p.p_partkey = ps.ps_partkey WHERE p.p_type LIKE '%BRASS') AS avg_part_price, COUNT(DISTINCT o.o_orderkey) AS num_orders FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey WHERE o.o_orderdate BETWEEN '1995-01-01' AND '1995-12-31' AND c.c_address IN ( 'jxPFbepi6qNtr8Eg3C vB5bauDWGA0AYTO', 'D1ZFwn0v6drnpT2wBmd12yoFZ XggzLck', 'g4sY4Dculyxv4IPXWKRC2o BqwDxq6nQgRv4' ) GROUP BY region_name, nation_name ORDER BY total_sales DESC, avg_customer_balance DESC;
SELECT r_name AS region, c_mktsegment AS market_segment, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, SUM(o_totalprice) AS total_sales, AVG(o_totalprice) AS avg_order_value, COUNT(DISTINCT o_orderkey) AS number_of_orders FROM region JOIN supplier ON supplier.s_nationkey = region.r_regionkey JOIN customer ON customer.c_nationkey = region.r_regionkey JOIN orders ON orders.o_custkey = customer.c_custkey WHERE r_regionkey = 0 GROUP BY r_name, c_mktsegment ORDER BY total_sales DESC;
SELECT n.n_name AS nation, AVG(c.c_acctbal) AS avg_customer_balance, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN part p ON l.l_partkey = p.p_partkey WHERE c.c_mktsegment = 'BUILDING' AND l.l_shipmode IN ('TRUCK', 'AIR') AND l.l_shipdate BETWEEN '2021-01-01' AND '2021-12-31' GROUP BY n.n_name ORDER BY total_revenue DESC, avg_customer_balance DESC LIMIT 10;
SELECT n_name, p_brand, p_type, p_size, avg(ps_supplycost) AS average_supply_cost, sum(l_extendedprice) AS total_sales_value, sum(l_extendedprice * (1 - l_discount)) AS total_sales_after_discount, count(DISTINCT o_orderkey) AS number_of_orders, count(DISTINCT l_suppkey) AS number_of_suppliers FROM nation JOIN supplier ON n_nationkey = s_nationkey JOIN partsupp ON s_suppkey = ps_suppkey JOIN part ON ps_partkey = p_partkey JOIN lineitem ON p_partkey = l_partkey AND ps_suppkey = l_suppkey JOIN orders ON l_orderkey = o_orderkey WHERE n_nationkey IN (1, 8, 9) AND l_commitdate BETWEEN '1995-06-22' AND '1997-02-19' AND l_receiptdate BETWEEN '1996-06-02' AND '1998-10-08' AND p_brand IN ('Brand#12', 'Brand#35', 'Brand#34', 'Brand#13', 'Brand#24') AND p_mfgr = 'Manufacturer#1' GROUP BY n_name, p_brand, p_type, p_size ORDER BY total_sales_after_discount DESC;
SELECT n.n_name AS nation_name, p.p_type AS part_type, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(p.p_retailprice * ps.ps_availqty) AS total_retail_value, AVG(ps.ps_supplycost) AS average_supply_cost, AVG(c.c_acctbal) AS average_customer_balance FROM nation n JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN partsupp ps ON c.c_custkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey GROUP BY nation_name, part_type ORDER BY total_retail_value DESC, average_supply_cost ASC LIMIT 10;
SELECT n.n_name AS nation, c.c_mktsegment AS market_segment, AVG(c.c_acctbal) AS avg_customer_balance, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_spending, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT p.p_partkey) AS number_of_parts FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN partsupp ps ON l.l_partkey = ps.ps_partkey AND l.l_suppkey = ps.ps_suppkey JOIN supplier s ON ps.ps_suppkey = s.s_suppkey AND s.s_nationkey = n.n_nationkey JOIN part p ON ps.ps_partkey = p.p_partkey WHERE n.n_regionkey IN ('3', '1') AND l.l_shipmode IN ('AIR', 'MAIL', 'SHIP', 'FOB', 'RAIL', 'TRUCK') GROUP BY n.n_name, c.c_mktsegment ORDER BY total_spending DESC, avg_customer_balance DESC LIMIT 10;
SELECT r.r_name AS region, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, AVG(s.s_acctbal) AS average_account_balance, SUM(p.ps_availqty) AS total_parts_available, AVG(p.ps_supplycost) AS average_supply_cost, SUM(o.o_totalprice) AS total_order_value, AVG(o.o_totalprice) AS average_order_value FROM region r JOIN supplier s ON s.s_nationkey = r.r_regionkey JOIN partsupp p ON p.ps_suppkey = s.s_suppkey JOIN orders o ON o.o_custkey = s.s_nationkey WHERE r.r_name IN ('ASIA', 'EUROPE', 'AMERICA') AND o.o_orderstatus IN ('F', 'O', 'P') GROUP BY r.r_name ORDER BY total_order_value DESC;
SELECT n.n_name AS nation_name, AVG(c.c_acctbal) AS avg_customer_balance, COUNT(DISTINCT c.c_custkey) AS total_customers, COUNT(DISTINCT p.p_partkey) AS total_parts, SUM(p.p_retailprice) AS total_retail_price FROM nation AS n JOIN customer AS c ON n.n_nationkey = c.c_nationkey JOIN part AS p ON p.p_size IN (4, 24, 41) WHERE n.n_regionkey IN (1, 3, 4) AND c.c_phone LIKE '___-___-___-____' GROUP BY n.n_name ORDER BY avg_customer_balance DESC, total_customers DESC;
SELECT s.s_name, p.p_brand, l.l_shipmode, COUNT(DISTINCT l.l_orderkey) AS total_orders, SUM(l.l_extendedprice) AS total_sales, AVG(l.l_extendedprice * (1 - l_discount)) AS avg_discounted_price, SUM(CASE WHEN l.l_returnflag = 'R' THEN l.l_quantity ELSE 0 END) AS total_returned_qty, AVG(l.l_discount) AS avg_discount_rate, COUNT(*) AS total_lineitems FROM supplier s JOIN lineitem l ON s.s_suppkey = l.l_suppkey JOIN part p ON l.l_partkey = p.p_partkey WHERE l.l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' AND l.l_shipmode IN ('AIR', 'TRUCK') AND s.s_phone LIKE '15-%' GROUP BY s.s_name, p.p_brand, l.l_shipmode ORDER BY total_sales DESC, s.s_name, p.p_brand;
SELECT p.p_brand, r.r_name AS region_name, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales, AVG(l.l_discount) AS average_discount, COUNT(*) AS total_items_sold FROM part p JOIN lineitem l ON p.p_partkey = l.l_partkey JOIN region r ON r.r_regionkey = p.p_partkey % 5 WHERE l.l_shipdate > date '1992-01-01' AND l.l_quantity > 30 GROUP BY p.p_brand, r.r_name ORDER BY total_sales DESC, region_name, p.p_brand;
SELECT r.r_name AS region, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, COUNT(DISTINCT c.c_custkey) AS total_customers, AVG(p.p_retailprice) AS average_part_price, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN lineitem l ON p.p_partkey = l.l_partkey AND s.s_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey AND c.c_custkey = o.o_custkey WHERE r.r_name IN ('EUROPE', 'ASIA') AND o.o_orderdate >= DATE '2020-01-01' AND o.o_orderdate < DATE '2020-01-01' + INTERVAL '1' YEAR GROUP BY r.r_name ORDER BY revenue DESC;
SELECT r.r_name AS region, COUNT(DISTINCT n.n_nationkey) AS number_of_nations, SUM(l.l_quantity) AS total_quantity, AVG(ps.ps_supplycost) AS average_supply_cost, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, COUNT(*) AS number_of_line_items FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN partsupp ps ON n.n_nationkey = ps.ps_suppkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey GROUP BY r.r_name ORDER BY total_revenue DESC;
SELECT c.c_mktsegment, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_quantity) AS average_quantity, COUNT(DISTINCT c.c_custkey) AS number_of_customers FROM customer c JOIN lineitem l ON c.c_custkey = l.l_suppkey JOIN partsupp ps ON l.l_partkey = ps.ps_partkey AND l.l_suppkey = ps.ps_suppkey WHERE l.l_shipdate BETWEEN date '2022-01-01' AND date '2022-12-31' GROUP BY c.c_mktsegment ORDER BY total_revenue DESC;
SELECT s.s_nationkey, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT p.p_partkey) AS number_of_parts, AVG(ps.ps_supplycost) AS average_supply_cost, SUM(ps.ps_availqty) AS total_available_quantity, AVG(o.o_totalprice) AS average_order_total, COUNT(DISTINCT o.o_orderkey) AS number_of_orders FROM supplier s JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN orders o ON s.s_nationkey = o.o_custkey WHERE s.s_nationkey IN (23, 14, 11) AND o.o_orderstatus = 'F' GROUP BY s.s_nationkey ORDER BY average_order_total DESC;
SELECT r.r_name AS region_name, COUNT(DISTINCT n.n_nationkey) AS number_of_nations, SUM(ps.ps_availqty) AS total_parts_available, AVG(ps.ps_supplycost) AS average_supply_cost, SUM(o.o_totalprice) AS total_order_value, AVG(p.p_retailprice) AS average_part_retail_price FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN partsupp ps ON ps.ps_suppkey = n.n_nationkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN orders o ON n.n_nationkey = o.o_custkey WHERE r.r_regionkey IN (1, 4, 0, 2, 3) AND o.o_orderstatus = 'F' GROUP BY r.r_name ORDER BY total_order_value DESC, number_of_nations;
SELECT EXTRACT(YEAR FROM o_orderdate) AS order_year, COUNT(DISTINCT o_orderkey) AS total_orders, SUM(l_extendedprice) AS total_revenue, AVG(l_extendedprice * (1 - l_discount)) AS avg_discounted_revenue, SUM(l_quantity) AS total_quantity_sold, AVG(ps_supplycost) AS avg_supply_cost, SUM(ps_availqty) AS total_available_quantity FROM orders JOIN lineitem ON o_orderkey = l_orderkey JOIN partsupp ON l_partkey = ps_partkey AND l_suppkey = ps_suppkey WHERE o_orderstatus = 'F' AND l_returnflag = 'N' AND l_shipdate BETWEEN '2022-01-01' AND '2022-12-31' AND ps_suppkey IN ('180465', '1179', '120006', '180387') AND ps_comment LIKE '%slyly%' GROUP BY order_year ORDER BY total_revenue DESC, avg_discounted_revenue DESC;
SELECT r.r_name AS region_name, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, COUNT(DISTINCT p.p_partkey) AS total_parts, AVG(s.s_acctbal) AS average_supplier_acctbal, SUM(o.o_totalprice) AS total_order_price, AVG(o.o_totalprice) AS average_order_price FROM region r JOIN supplier s ON s.s_nationkey = r.r_regionkey JOIN part p ON p.p_size = r.r_regionkey JOIN orders o ON o.o_orderkey = p.p_partkey WHERE r.r_name IN ('ASIA', 'AFRICA') AND p.p_retailprice IN (1396.48, 991.08, 966.05) AND r.r_comment LIKE '%final%' GROUP BY r.r_name ORDER BY total_order_price DESC;
SELECT n.n_name AS nation_name, AVG(ps.ps_supplycost) AS avg_supply_cost, SUM(ps.ps_availqty) AS total_avail_qty, COUNT(o.o_orderkey) AS order_count, AVG(o.o_totalprice) AS avg_order_price FROM nation n JOIN partsupp ps ON n.n_nationkey = ps.ps_suppkey LEFT JOIN orders o ON n.n_nationkey = o.o_custkey AND o.o_orderdate >= '2020-01-01' AND o.o_orderdate < '2021-01-01' WHERE ps.ps_availqty IN (1805, 7621, 9995, 1615, 669) GROUP BY n.n_name ORDER BY n.n_name;
SELECT s_nationkey, COUNT(DISTINCT s_suppkey) AS total_suppliers, AVG(s_acctbal) AS average_balance, SUM(o_totalprice) AS total_order_value, COUNT(DISTINCT o_orderkey) AS total_orders, p_brand, AVG(p_retailprice) AS average_retail_price, COUNT(DISTINCT p_partkey) AS total_parts FROM supplier JOIN orders ON s_suppkey = o_custkey JOIN part ON p_size = s_nationkey WHERE o_orderstatus IN ('F', 'O') AND s_phone LIKE '25-349-496-8423%' GROUP BY s_nationkey, p_brand ORDER BY total_order_value DESC, average_balance DESC;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS number_of_customers, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, AVG(c.c_acctbal) AS average_customer_account_balance, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_discount) AS average_discount, COUNT(DISTINCT l.l_orderkey) AS number_of_orders FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey WHERE c.c_mktsegment = 'MACHINERY' AND l.l_shipdate BETWEEN '2022-01-01' AND '2022-12-31' GROUP BY r.r_name, n.n_name ORDER BY total_revenue DESC;
SELECT r.r_name as Region, n.n_name as Nation, COUNT(p.p_partkey) as TotalParts, AVG(p.p_retailprice) as AvgRetailPrice, SUM(o.o_totalprice) as TotalOrderPrice, COUNT(DISTINCT o.o_orderkey) as TotalOrders, MAX(o.o_totalprice) as MaxOrderPrice, MIN(o.o_totalprice) as MinOrderPrice FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN orders o ON o.o_orderdate BETWEEN '2020-01-01' AND '2020-12-31' JOIN part p ON p.p_size BETWEEN 30 AND 50 GROUP BY r.r_name, n.n_name ORDER BY TotalOrderPrice DESC, AvgRetailPrice DESC;
SELECT r.r_name AS region_name, avg(c.c_acctbal) AS average_account_balance, sum(ps.ps_availqty) AS total_available_quantity, sum(p.p_retailprice * ps.ps_availqty) AS total_inventory_value, count(DISTINCT c.c_custkey) AS number_of_customers, count(DISTINCT p.p_partkey) AS number_of_parts FROM region r JOIN customer c ON c.c_nationkey = r.r_regionkey JOIN partsupp ps ON ps.ps_suppkey = c.c_custkey JOIN part p ON p.p_partkey = ps.ps_partkey WHERE r.r_name IN ('AFRICA', 'AMERICA') AND p.p_brand IN ('Brand#54', 'Brand#35', 'Brand#44') AND c.c_acctbal > 0 GROUP BY r.r_name ORDER BY total_inventory_value DESC;
SELECT r.r_name AS region_name, COUNT(DISTINCT s.s_suppkey) AS supplier_count, COUNT(DISTINCT c.c_custkey) AS customer_count, AVG(c.c_acctbal) AS avg_customer_acctbal, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(p.p_retailprice) AS avg_part_retailprice FROM region r JOIN supplier s ON r.r_regionkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN lineitem l ON p.p_partkey = l.l_partkey AND s.s_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey JOIN customer c ON o.o_custkey = c.c_custkey AND c.c_nationkey = s.s_nationkey WHERE r.r_regionkey IN (1, 4, 0, 2, 3) AND p.p_size IN (36, 16, 18, 50, 22) AND l.l_shipmode IN ('AIR', 'SHIP') AND l.l_returnflag = 'N' AND c.c_phone LIKE '29-827-271-6785%' AND o.o_orderdate BETWEEN DATE '1995-01-01' AND DATE '1995-12-31' GROUP BY r.r_name ORDER BY total_revenue DESC;
SELECT n_name AS nation_name, r_name AS region_name, COUNT(DISTINCT s_suppkey) AS total_suppliers, COUNT(DISTINCT o_orderkey) AS total_orders, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(p_retailprice) AS average_retail_price, AVG(l_quantity) AS average_quantity_sold FROM nation JOIN region ON n_regionkey = r_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN partsupp ON ps_suppkey = s_suppkey JOIN part ON p_partkey = ps_partkey JOIN lineitem ON l_partkey = p_partkey AND l_suppkey = s_suppkey JOIN orders ON o_orderkey = l_orderkey WHERE o_orderstatus = 'F' AND l_shipdate BETWEEN '1995-01-01' AND '1996-12-31' AND p_size IN (46, 2, 5) GROUP BY nation_name, region_name ORDER BY total_revenue DESC, average_retail_price DESC LIMIT 10;
SELECT r.r_name AS region_name, COUNT(DISTINCT c.c_custkey) AS total_customers, AVG(c.c_acctbal) AS avg_account_balance, SUM(p.p_retailprice) AS sum_retail_price, AVG(ps.ps_supplycost) AS avg_supply_cost, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(o.o_totalprice) AS sum_order_total, EXTRACT(YEAR FROM o.o_orderdate) AS order_year FROM region r JOIN customer c ON r.r_regionkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN partsupp ps ON ps.ps_suppkey = o.o_orderkey JOIN part p ON p.p_partkey = ps.ps_partkey WHERE r.r_regionkey IN (1, 3) AND o.o_orderstatus = 'F' AND ps.ps_supplycost < 500.00 GROUP BY region_name, order_year ORDER BY region_name, order_year;
SELECT c.c_mktsegment, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_discounted_price, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_discounted_price, AVG(l.l_discount) AS avg_discount, COUNT(CASE WHEN l.l_returnflag = 'R' THEN 1 END) AS returned_orders, MAX(s.s_acctbal) AS max_supplier_acctbal, MIN(s.s_acctbal) AS min_supplier_acctbal FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN supplier s ON l.l_suppkey = s.s_suppkey WHERE c.c_nationkey IN (12, 24, 22, 8, 7) AND l.l_shipinstruct IN ('COLLECT COD', 'TAKE BACK RETURN', 'NONE', 'DELIVER IN PERSON') AND l.l_returnflag IN ('N', 'A', 'R') AND o.o_orderstatus = 'F' GROUP BY c.c_mktsegment ORDER BY total_discounted_price DESC;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_quantity) AS average_quantity_sold, SUM(ps.ps_availqty) AS total_available_quantity FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN lineitem l ON p.p_partkey = l.l_partkey AND s.s_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey JOIN customer c ON o.o_custkey = c.c_custkey AND c.c_nationkey = n.n_nationkey WHERE p.p_type IN ('ECONOMY BURNISHED NICKEL', 'ECONOMY POLISHED TIN', 'STANDARD BRUSHED NICKEL') AND l.l_shipdate BETWEEN '2020-01-01' AND '2020-12-31' GROUP BY r.r_name, n.n_name ORDER BY total_revenue DESC;
