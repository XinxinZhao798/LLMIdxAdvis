SELECT n.n_name AS nation, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales, AVG(s.s_acctbal) AS avg_supplier_balance, SUM(ps.ps_availqty) AS total_available_quantity FROM nation n INNER JOIN supplier s ON n.n_nationkey = s.s_nationkey INNER JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey INNER JOIN lineitem l ON ps.ps_suppkey = l.l_suppkey AND ps.ps_partkey = l.l_partkey INNER JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE n.n_nationkey IN (12, 9, 11, 15) AND l.l_suppkey IN (128236, 197502, 170405, 85908) GROUP BY nation, order_year ORDER BY nation, order_year DESC;
SELECT n_name, p_brand, p_type, l_shipmode, AVG(l_discount) AS average_discount, SUM(l_quantity) AS total_quantity, COUNT(*) AS lineitem_count, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(l_extendedprice * (1 - l_discount)) AS average_revenue FROM nation JOIN lineitem ON n_nationkey = l_suppkey JOIN orders ON l_orderkey = o_orderkey JOIN part ON l_partkey = p_partkey WHERE n_regionkey = 2 AND l_shipmode IN ('SHIP', 'RAIL', 'TRUCK') AND o_orderdate >= date '2020-01-01' AND o_orderdate < date '2020-01-01' + INTERVAL '1 YEAR' GROUP BY n_name, p_brand, p_type, l_shipmode ORDER BY total_revenue DESC, n_name, p_brand, p_type, l_shipmode LIMIT 10;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS supplier_count, AVG(s.s_acctbal) AS average_account_balance, SUM(o.o_totalprice) AS total_sales, AVG(p.p_retailprice) AS average_part_price FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN orders o ON s.s_suppkey = o.o_custkey JOIN part p ON o.o_orderkey = p.p_partkey WHERE r.r_name IN ('EUROPE', 'AMERICA') AND o.o_orderdate BETWEEN '1995-01-01' AND '1995-12-31' AND p.p_container IN ('JUMBO BOX', 'LG PACK') AND p.p_type LIKE '%STEEL' GROUP BY r.r_name, n.n_name ORDER BY total_sales DESC, average_account_balance DESC LIMIT 10;
SELECT r.r_name AS region_name, c.c_mktsegment AS market_segment, COUNT(DISTINCT l.l_orderkey) AS order_count, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales, AVG(l.l_discount) AS average_discount FROM lineitem l JOIN customer c ON l.l_orderkey = c.c_custkey JOIN supplier s ON l.l_suppkey = s.s_suppkey JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey GROUP BY r.r_name, c.c_mktsegment ORDER BY total_sales DESC, average_discount ASC;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS number_of_customers, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, AVG(c.c_acctbal) AS average_customer_acctbal, AVG(s.s_acctbal) AS average_supplier_acctbal, SUM(p.p_retailprice) AS total_retail_price FROM region r INNER JOIN nation n ON r.r_regionkey = n.n_regionkey INNER JOIN customer c ON n.n_nationkey = c.c_nationkey INNER JOIN supplier s ON n.n_nationkey = s.s_nationkey INNER JOIN part p ON p.p_size BETWEEN 30 AND 50 WHERE n.n_nationkey IN (3, 24, 17, 14, 22) AND c.c_acctbal > 2500 AND s.s_phone LIKE '25-%' GROUP BY r.r_name, n.n_name ORDER BY total_retail_price DESC, average_customer_acctbal DESC LIMIT 10;
SELECT r.r_name AS region_name, n.n_name AS nation_name, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales_volume, AVG(l.l_discount) AS average_discount FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE r.r_name IN ('AFRICA', 'EUROPE', 'ASIA') AND o.o_orderpriority = '2-HIGH' GROUP BY region_name, nation_name, order_year ORDER BY region_name, nation_name, order_year;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS number_of_customers, AVG(c.c_acctbal) AS average_account_balance, SUM(l.l_quantity) AS total_quantity_ordered, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_extendedprice * (1 - l.l_discount)) AS average_order_value FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey JOIN lineitem l ON c.c_custkey = l.l_suppkey WHERE l.l_shipdate >= DATE '2023-01-01' AND l.l_shipdate < DATE '2024-01-01' AND l.l_quantity >= 23 AND l.l_quantity <= 25 AND c.c_acctbal BETWEEN 4000 AND 10000 GROUP BY r.r_name, n.n_name ORDER BY total_revenue DESC;
SELECT r_name AS region, n_name AS nation, count(DISTINCT s_suppkey) AS num_suppliers, count(DISTINCT c_custkey) AS num_customers, sum(l_extendedprice) AS total_sales, avg(l_extendedprice * (1 - l_discount)) AS avg_discounted_sales, count(DISTINCT o_orderkey) AS num_orders FROM region JOIN nation ON n_regionkey = r_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN orders ON o_custkey = c_custkey JOIN lineitem ON l_orderkey = o_orderkey AND l_suppkey = s_suppkey GROUP BY region, nation ORDER BY total_sales DESC, region, nation;
SELECT n_name AS nation, r_name AS region, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, SUM(l_extendedprice * (1 - l_discount)) AS total_sales, AVG(l_quantity) AS average_quantity_sold, AVG(c_acctbal) AS average_customer_balance FROM nation JOIN region ON n_regionkey = r_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN orders ON o_custkey = c_custkey JOIN lineitem ON l_orderkey = o_orderkey WHERE c_mktsegment = 'BUILDING' AND o_orderdate BETWEEN date '1995-01-01' AND date '1995-12-31' AND l_shipdate > date '1995-12-31' GROUP BY n_name, r_name ORDER BY total_sales DESC, region, nation;
SELECT r.r_name AS region_name, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, SUM(o.o_totalprice) AS total_order_value, AVG(s.s_acctbal) AS average_supplier_account_balance FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN orders o ON ps.ps_suppkey = o.o_custkey WHERE r.r_regionkey = 3 AND o.o_shippriority = 0 AND s.s_phone IN ('16-788-260-1555', '22-116-846-1797', '10-306-731-9589') GROUP BY r.r_name ORDER BY total_order_value DESC, average_supplier_account_balance DESC;
SELECT n.n_name AS nation, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, AVG(l.l_quantity) AS average_quantity_ordered, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue FROM supplier s JOIN nation n ON s.s_nationkey = n.n_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey JOIN customer c ON o.o_custkey = c.c_custkey JOIN part p ON l.l_partkey = p.p_partkey WHERE n.n_regionkey IN (4, 2) AND p.p_size BETWEEN 25 AND 31 AND o.o_orderdate BETWEEN DATE '2020-01-01' AND DATE '2020-12-31' AND o.o_clerk IN ('Clerk#000005453', 'Clerk#000013807', 'Clerk#000023271') GROUP BY nation, order_year ORDER BY total_revenue DESC, order_year;
SELECT n.n_name AS nation_name, AVG(c.c_acctbal) AS avg_customer_balance, COUNT(DISTINCT c.c_custkey) AS total_customers, COUNT(DISTINCT p.p_partkey) AS total_parts, SUM(p.p_retailprice) AS total_retail_price FROM nation AS n JOIN customer AS c ON n.n_nationkey = c.c_nationkey JOIN part AS p ON p.p_size IN (4, 24, 41) WHERE n.n_regionkey IN (1, 3, 4) AND c.c_phone LIKE '___-___-___-____' GROUP BY n.n_name ORDER BY avg_customer_balance DESC, total_customers DESC;
SELECT r.r_name AS region_name, n.n_name AS nation_name, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(l.l_extendedprice) AS total_sales_value, AVG(l.l_quantity) AS average_quantity_sold, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue_after_discount, AVG(l.l_discount) AS average_discount_given FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE r.r_regionkey = 2 AND n.n_comment LIKE '%ven packages wake quickly. regu%' AND ( s.s_comment LIKE '%t the closely ironic packages. fluff%' OR s.s_comment LIKE '%accounts after the furious%' OR s.s_comment LIKE '%ecial deposits cajole slyly even ideas. furious%' OR s.s_comment LIKE '%ns. ironic ideas cajole. sl%' OR s.s_comment LIKE '%nto beans. stealthily final%' ) GROUP BY r.r_name, n.n_name ORDER BY total_sales_value DESC;
SELECT n.n_name AS nation_name, p.p_type AS part_type, COUNT(DISTINCT ps.ps_suppkey) AS unique_suppliers, SUM(ps.ps_availqty) AS total_availability, AVG(ps.ps_supplycost) AS average_supply_cost, MIN(p.p_retailprice) AS min_retail_price, MAX(p.p_retailprice) AS max_retail_price FROM nation AS n JOIN partsupp AS ps ON n.n_nationkey = ps.ps_suppkey JOIN part AS p ON ps.ps_partkey = p.p_partkey WHERE n.n_regionkey IN (1, 4, 0, 2, 3) AND ( p.p_container = 'WRAP PKG' OR p.p_container = 'LG PACK' OR p.p_container = 'LG PKG' OR p.p_container = 'WRAP CAN' OR p.p_container = 'JUMBO PKG' ) GROUP BY n.n_name, p.p_type ORDER BY total_availability DESC, average_supply_cost ASC;
SELECT r.r_name AS region_name, c.c_mktsegment AS market_segment, COUNT(DISTINCT o.o_orderkey) AS total_orders, COUNT(DISTINCT c.c_custkey) AS unique_customers, SUM(o.o_totalprice) AS total_sales, AVG(o.o_totalprice) AS average_order_value FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey GROUP BY r.r_name, c.c_mktsegment ORDER BY r.r_name, c.c_mktsegment;
SELECT r.r_name AS region, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c.c_custkey) AS number_of_customers, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(l.l_extendedprice) AS total_revenue, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_discounted_revenue, SUM(l.l_quantity) AS total_quantity_sold, AVG(p.p_retailprice) AS avg_retail_price, SUM(ps.ps_supplycost * l.l_quantity) AS total_supply_cost FROM region r JOIN nation n ON n.n_regionkey = r.r_regionkey JOIN supplier s ON s.s_nationkey = n.n_nationkey JOIN partsupp ps ON ps.ps_suppkey = s.s_suppkey JOIN part p ON p.p_partkey = ps.ps_partkey JOIN lineitem l ON l.l_partkey = p.p_partkey AND l.l_suppkey = s.s_suppkey JOIN orders o ON o.o_orderkey = l.l_orderkey JOIN customer c ON c.c_custkey = o.o_custkey AND c.c_nationkey = n.n_nationkey WHERE r.r_name IN ('AFRICA', 'EUROPE') AND p.p_type IN ('PROMO POLISHED NICKEL', 'ECONOMY BRUSHED COPPER') AND l.l_shipinstruct IN ('COLLECT COD', 'TAKE BACK RETURN') AND l.l_tax BETWEEN 0.01 AND 0.07 GROUP BY r.r_name ORDER BY total_revenue DESC;
