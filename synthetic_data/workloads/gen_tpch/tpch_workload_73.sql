SELECT c.c_mktsegment, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_discounted_price, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(ps.ps_supplycost) AS avg_supply_cost FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN partsupp ps ON l.l_partkey = ps.ps_partkey AND l.l_suppkey = ps.ps_suppkey WHERE o.o_orderdate BETWEEN '1994-01-01' AND '1997-12-31' AND o.o_clerk IN ('Clerk#000013110', 'Clerk#000019634', 'Clerk#000022938', 'Clerk#000000992') GROUP BY c.c_mktsegment, order_year ORDER BY c.c_mktsegment, order_year;
SELECT r_name AS region, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(o.o_totalprice) AS total_sales, AVG(l.l_quantity) AS average_quantity_ordered, SUM((l.l_extendedprice * (1 - l.l_discount))) AS revenue, COUNT(DISTINCT o.o_orderkey) AS number_of_orders FROM region JOIN customer c ON c.c_nationkey = region.r_regionkey JOIN orders o ON o.o_custkey = c.c_custkey JOIN lineitem l ON l.l_orderkey = o.o_orderkey WHERE r_name IN ('MIDDLE EAST', 'ASIA', 'EUROPE', 'AMERICA', 'AFRICA') AND o.o_shippriority = 0 AND o.o_totalprice > 20000 GROUP BY r_name ORDER BY total_sales DESC;
SELECT r.r_name AS region, c.c_mktsegment AS market_segment, COUNT(DISTINCT c.c_custkey) AS number_of_customers, AVG(c.c_acctbal) AS average_account_balance, SUM(o.o_totalprice) AS total_sales, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, AVG(p.p_retailprice) AS average_retail_price_of_parts_ordered FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN part p ON o.o_orderkey = p.p_partkey JOIN region r ON c.c_nationkey = r.r_regionkey WHERE c.c_acctbal > 6000 AND r.r_name IN ('MIDDLE EAST', 'ASIA', 'EUROPE', 'AMERICA', 'AFRICA') AND o.o_orderdate BETWEEN '1993-01-01' AND '1998-12-31' AND c.c_mktsegment IN ('BUILDING', 'HOUSEHOLD', 'AUTOMOBILE') GROUP BY r.r_name, c.c_mktsegment ORDER BY total_sales DESC, average_account_balance DESC;
SELECT n.n_name, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(ps.ps_supplycost) AS average_supply_cost, SUM(l.l_quantity) AS total_quantity_ordered FROM nation n JOIN supplier s ON s.s_nationkey = n.n_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey WHERE n.n_nationkey IN (12, 16, 8, 11) AND l.l_orderkey IN (2406, 1761, 837, 772, 1764) GROUP BY n.n_name ORDER BY total_revenue DESC;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(o.o_totalprice) AS total_sales, AVG(c.c_acctbal) AS avg_customer_balance, AVG(l.l_quantity) AS avg_lineitem_quantity, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, MAX(p.p_retailprice) AS max_part_retailprice, MIN(ps.ps_supplycost) AS min_supplycost FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN part p ON l.l_partkey = p.p_partkey JOIN partsupp ps ON p.p_partkey = ps.ps_partkey AND l.l_suppkey = ps.ps_suppkey WHERE r.r_name IN ('MIDDLE EAST', 'ASIA', 'EUROPE', 'AMERICA') AND o.o_orderpriority IN ('1-URGENT', '5-LOW', '4-NOT SPECIFIED') AND c.c_mktsegment IN ('FURNITURE', 'MACHINERY') GROUP BY region, nation ORDER BY total_sales DESC, total_revenue DESC;
SELECT r.r_name AS region_name, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, COUNT(DISTINCT o.o_orderkey) AS total_orders, AVG(o.o_totalprice) AS avg_order_total_price, SUM(li.l_quantity) AS total_quantity_supplied FROM supplier s JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN lineitem li ON ps.ps_partkey = li.l_partkey AND ps.ps_suppkey = li.l_suppkey JOIN orders o ON li.l_orderkey = o.o_orderkey JOIN customer c ON o.o_custkey = c.c_custkey JOIN region r ON c.c_nationkey = s.s_nationkey WHERE s.s_acctbal > 0 GROUP BY r.r_name ORDER BY total_quantity_supplied DESC, avg_order_total_price DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, SUM(l_extendedprice * (1 - l_discount)) AS total_sales, AVG(l_quantity) AS avg_quantity_sold, AVG(p_retailprice) AS avg_part_retail_price FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON n_nationkey = s_nationkey JOIN customer ON n_nationkey = c_nationkey JOIN orders ON c_custkey = o_custkey JOIN lineitem ON o_orderkey = l_orderkey JOIN part ON l_partkey = p_partkey JOIN partsupp ON p_partkey = ps_partkey AND s_suppkey = ps_suppkey WHERE n_name IN ('JAPAN', 'PERU', 'KENYA', 'CHINA', 'FRANCE', 'UNITED KINGDOM') AND l_shipdate BETWEEN '2022-01-01' AND '2022-12-31' GROUP BY r_name, n_name ORDER BY total_sales DESC;
SELECT r_name AS region_name, n_name AS nation_name, COUNT(DISTINCT o_orderkey) AS total_orders, SUM(c_acctbal) AS total_customer_balance, AVG(l_extendedprice * (1 - l_discount)) AS avg_order_value, SUM(l_quantity) AS total_parts_ordered FROM region JOIN nation ON r_regionkey = n_regionkey JOIN customer ON n_nationkey = c_nationkey JOIN orders ON c_custkey = o_custkey JOIN lineitem ON o_orderkey = l_orderkey JOIN part ON p_partkey = l_partkey WHERE r_regionkey IN (1, 2, 3) AND l_linestatus = 'O' AND p_comment LIKE '%ular p%' GROUP BY region_name, nation_name ORDER BY total_orders DESC, total_customer_balance DESC, avg_order_value DESC;
SELECT r.r_name AS region_name, avg(c.c_acctbal) AS average_account_balance, sum(ps.ps_availqty) AS total_available_quantity, sum(p.p_retailprice * ps.ps_availqty) AS total_inventory_value, count(DISTINCT c.c_custkey) AS number_of_customers, count(DISTINCT p.p_partkey) AS number_of_parts FROM region r JOIN customer c ON c.c_nationkey = r.r_regionkey JOIN partsupp ps ON ps.ps_suppkey = c.c_custkey JOIN part p ON p.p_partkey = ps.ps_partkey WHERE r.r_name IN ('AFRICA', 'AMERICA') AND p.p_brand IN ('Brand#54', 'Brand#35', 'Brand#44') AND c.c_acctbal > 0 GROUP BY r.r_name ORDER BY total_inventory_value DESC;
SELECT r.r_name AS region, COUNT(DISTINCT c.c_custkey) AS num_customers, AVG(c.c_acctbal) AS avg_account_balance, SUM(p.p_retailprice) AS total_retail_price, COUNT(DISTINCT p.p_partkey) AS num_parts FROM region r JOIN customer c ON r.r_regionkey = c.c_nationkey JOIN part p ON c.c_custkey = p.p_partkey GROUP BY r.r_name ORDER BY total_retail_price DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, AVG(s_acctbal) AS average_account_balance, SUM(o_totalprice) AS total_order_value, COUNT(DISTINCT o_orderkey) AS number_of_orders, AVG(ps_supplycost) AS average_supply_cost, SUM(ps_availqty) AS total_available_quantity FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN partsupp ON s_suppkey = ps_suppkey JOIN orders ON s_nationkey = o_custkey WHERE r_name IN ('ASIA', 'AMERICA') AND o_orderpriority IN ('1-URGENT', '2-HIGH') AND n_name IN ('UNITED STATES', 'JAPAN') GROUP BY region, nation ORDER BY total_order_value DESC, number_of_suppliers DESC;
SELECT n.n_name, c.c_mktsegment, COUNT(o.o_orderkey) AS total_orders, AVG(l.l_quantity) AS average_quantity, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue, SUM(ps.ps_supplycost * l.l_quantity) AS total_supply_cost, (SUM(l.l_extendedprice * (1 - l.l_discount)) - SUM(ps.ps_supplycost * l.l_quantity)) AS profit FROM nation n JOIN supplier s ON s.s_nationkey = n.n_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey JOIN customer c ON o.o_custkey = c.c_custkey AND c.c_nationkey = n.n_nationkey WHERE n.n_regionkey IN (1, 3, 0) AND l.l_receiptdate BETWEEN '1994-01-01' AND '1997-12-31' AND c.c_comment LIKE 'slyly regular requests. slyly%' GROUP BY n.n_name, c.c_mktsegment ORDER BY revenue DESC, n.n_name, c.c_mktsegment;
SELECT r.r_name AS region, COUNT(DISTINCT n.n_nationkey) AS number_of_nations, SUM(c.c_acctbal) AS total_cust_balance, AVG(s.s_acctbal) AS avg_supp_balance, COUNT(DISTINCT l.l_orderkey) AS number_of_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue, AVG(l.l_quantity) AS avg_quantity_sold FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey AND o.o_orderstatus = 'F' JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE r.r_regionkey IN (1, 4, 0, 2, 3) AND l.l_shipdate >= '1997-01-01' AND l.l_shipdate < '1998-01-01' GROUP BY region ORDER BY revenue DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS total_suppliers, COUNT(DISTINCT c_custkey) AS total_customers, AVG(s_acctbal) AS average_supplier_balance, AVG(c_acctbal) AS average_customer_balance, SUM(l_extendedprice * (1 - l_discount)) AS total_sales_volume, AVG(l_quantity) AS average_quantity_sold FROM region JOIN nation ON n_regionkey = r_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN lineitem ON l_suppkey = s_suppkey JOIN orders ON o_orderkey = l_orderkey AND o_custkey = c_custkey JOIN part ON p_partkey = l_partkey WHERE l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' AND r_name IN ('EUROPE', 'AMERICA') GROUP BY region, nation ORDER BY total_sales_volume DESC;
SELECT n.n_name AS nation_name, AVG(s.s_acctbal) AS average_account_balance, SUM(ps.ps_supplycost) AS total_supply_cost, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT p.p_partkey) AS number_of_parts, COUNT(DISTINCT o.o_orderkey) AS number_of_orders FROM nation n JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN orders o ON o.o_orderdate BETWEEN DATE '1995-01-01' AND DATE '1996-12-31' WHERE p.p_brand IN ('Brand#22', 'Brand#24') AND n.n_nationkey IN (16, 17, 0, 24) AND o.o_shippriority = 0 AND ps.ps_comment LIKE ANY (ARRAY['%tions. furiously even theodolites haggle. furious%', '%ages after the blithely final ideas thrash carefu%', '%kly blithely regular packages. regular accounts p%']) GROUP BY nation_name ORDER BY total_supply_cost DESC;
SELECT r.r_name AS region_name, p.p_brand AS brand, p.p_type AS product_type, AVG(p.p_retailprice) AS average_retail_price, SUM(ps.ps_availqty) AS total_available_quantity, AVG(ps.ps_supplycost) AS average_supply_cost, COUNT(DISTINCT p.p_partkey) AS unique_parts_count FROM region r JOIN partsupp ps ON ps.ps_suppkey = r.r_regionkey JOIN part p ON ps.ps_partkey = p.p_partkey GROUP BY r.r_name, p.p_brand, p.p_type ORDER BY r.r_name, p.p_brand, p.p_type;
SELECT r_name, COUNT(DISTINCT o_orderkey) AS total_orders, SUM(l_quantity) AS total_quantity, AVG(l_extendedprice) AS avg_price, SUM(l_extendedprice * (1 - l_discount) * (1 + l_tax)) AS total_revenue FROM region JOIN orders ON r_regionkey = o_orderkey % 5 JOIN lineitem ON o_orderkey = l_orderkey WHERE r_regionkey IN (1, 4, 0, 2, 3) AND l_shipdate BETWEEN '1995-01-01' AND '1996-12-31' AND o_orderstatus = 'F' GROUP BY r_name ORDER BY total_revenue DESC;
SELECT c.c_mktsegment AS market_segment, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(c.c_acctbal) AS average_customer_acct_balance, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, AVG(p.p_retailprice) AS average_part_price FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN part p ON l.l_partkey = p.p_partkey JOIN supplier s ON l.l_suppkey = s.s_suppkey WHERE c.c_mktsegment = 'AUTOMOBILE' AND o.o_orderdate BETWEEN date '2022-01-01' AND date '2022-12-31' AND l.l_shipdate > o.o_orderdate AND p.p_container = 'JUMBO PACK' GROUP BY c.c_mktsegment ORDER BY total_revenue DESC, average_customer_acct_balance DESC LIMIT 10;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS number_of_customers, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, AVG(c.c_acctbal) AS average_customer_account_balance, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_discount) AS average_discount, COUNT(DISTINCT l.l_orderkey) AS number_of_orders FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey WHERE c.c_mktsegment = 'MACHINERY' AND l.l_shipdate BETWEEN '2022-01-01' AND '2022-12-31' GROUP BY r.r_name, n.n_name ORDER BY total_revenue DESC;
SELECT n.n_name AS nation, c.c_mktsegment AS market_segment, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(*) AS total_orders, SUM(o.o_totalprice) AS total_revenue, AVG(o.o_totalprice) AS avg_order_value FROM customer AS c JOIN orders AS o ON c.c_custkey = o.o_custkey JOIN nation AS n ON c.c_nationkey = n.n_nationkey GROUP BY nation, market_segment, order_year ORDER BY nation, market_segment, order_year;
SELECT r.r_name AS region, COUNT(DISTINCT li.l_orderkey) AS number_of_orders, SUM(li.l_extendedprice) AS total_revenue, AVG(li.l_quantity) AS avg_quantity, SUM(li.l_extendedprice * (1 - li.l_discount) * (1 + li.l_tax)) AS total_revenue_after_discount_and_tax FROM region r JOIN partsupp ps ON r.r_regionkey = ps.ps_suppkey JOIN lineitem li ON ps.ps_partkey = li.l_partkey AND ps.ps_suppkey = li.l_suppkey WHERE r.r_name = 'EUROPE' AND li.l_returnflag = 'N' AND li.l_shipdate BETWEEN '2022-01-01' AND '2022-12-31' GROUP BY r.r_name ORDER BY total_revenue DESC;
SELECT r.r_name AS region_name, COUNT(DISTINCT c.c_custkey) AS number_of_customers, AVG(c.c_acctbal) AS average_account_balance, COUNT(DISTINCT p.p_partkey) AS number_of_parts, SUM(ps.ps_availqty) AS total_available_quantity, AVG(ps.ps_supplycost) AS average_supply_cost, SUM(ps.ps_supplycost * ps.ps_availqty) AS total_inventory_value FROM region r JOIN customer c ON r.r_regionkey = c.c_nationkey JOIN partsupp ps ON c.c_custkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey WHERE r.r_regionkey IN (1, 4, 0, 2, 3) AND p.p_mfgr IN ('Manufacturer#5', 'Manufacturer#4', 'Manufacturer#2', 'Manufacturer#1', 'Manufacturer#3') AND c.c_nationkey = 0 AND c.c_comment IN ( 'ely: bravely regular accounts acr', 'y ironic pinto beans cajole deposits.', 'lyly silent platelets sleep epitaphs. f', 'lay boldly? blithely final deposits are', 'le quickly. quickly enticing excu' ) AND ps.ps_supplycost IN (184.83, 329.63, 916.51, 486.89) GROUP BY r.r_name ORDER BY total_inventory_value DESC;
SELECT c.c_mktsegment, AVG(c.c_acctbal) AS average_account_balance, SUM(o.o_totalprice) AS total_sales, COUNT(DISTINCT s.s_suppkey) AS supplier_count, n.n_name AS nation_name FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN supplier s ON l.l_suppkey = s.s_suppkey JOIN nation n ON s.s_nationkey = n.n_nationkey WHERE o.o_orderdate >= '2020-01-01' AND o.o_orderdate < '2021-01-01' GROUP BY c.c_mktsegment, n.n_name ORDER BY c.c_mktsegment, total_sales DESC;
SELECT r.r_name AS region, c.c_mktsegment AS market_segment, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_quantity) AS total_quantity_sold, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey AND o.o_orderstatus = 'F' JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE o.o_orderdate >= DATE '2022-10-01' AND o.o_orderdate < DATE '2023-01-01' GROUP BY r.r_name, c.c_mktsegment ORDER BY r.r_name, total_revenue DESC;
SELECT s_name, s_address, p_type, AVG(l_quantity) AS average_quantity, SUM(l_extendedprice) AS total_sales, COUNT(DISTINCT l_orderkey) AS number_of_orders, SUM(CASE WHEN l_discount > 0 THEN l_extendedprice * (1 - l_discount) ELSE 0 END) AS discounted_sales FROM supplier JOIN lineitem ON supplier.s_suppkey = lineitem.l_suppkey JOIN part ON lineitem.l_partkey = part.p_partkey WHERE s_acctbal > 5000 AND p_mfgr = 'Manufacturer#5' AND l_shipdate BETWEEN '2022-01-01' AND '2022-12-31' GROUP BY s_name, s_address, p_type ORDER BY total_sales DESC, s_name LIMIT 10;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS number_of_customers, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, AVG(c.c_acctbal) AS average_customer_acctbal, AVG(s.s_acctbal) AS average_supplier_acctbal, SUM(p.p_retailprice) AS total_retail_price FROM region r INNER JOIN nation n ON r.r_regionkey = n.n_regionkey INNER JOIN customer c ON n.n_nationkey = c.c_nationkey INNER JOIN supplier s ON n.n_nationkey = s.s_nationkey INNER JOIN part p ON p.p_size BETWEEN 30 AND 50 WHERE n.n_nationkey IN (3, 24, 17, 14, 22) AND c.c_acctbal > 2500 AND s.s_phone LIKE '25-%' GROUP BY r.r_name, n.n_name ORDER BY total_retail_price DESC, average_customer_acctbal DESC LIMIT 10;
SELECT reg.r_name AS region_name, COUNT(DISTINCT cust.c_custkey) AS customer_count, AVG(cust.c_acctbal) AS average_customer_balance, COUNT(DISTINCT ord.o_orderkey) AS order_count, SUM(ord.o_totalprice) AS total_order_price FROM region reg JOIN nation nat ON reg.r_regionkey = nat.n_regionkey JOIN customer cust ON nat.n_nationkey = cust.c_nationkey JOIN orders ord ON cust.c_custkey = ord.o_custkey WHERE reg.r_regionkey = 2 AND ord.o_orderstatus = 'F' GROUP BY reg.r_name ORDER BY reg.r_name;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS supplier_count, COUNT(DISTINCT c_custkey) AS customer_count, AVG(s_acctbal) AS avg_supplier_acctbal, AVG(c_acctbal) AS avg_customer_acctbal, SUM(ps_availqty) AS total_partsupply_quantity, SUM(o_totalprice) AS total_order_value FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON n_nationkey = s_nationkey JOIN customer ON n_nationkey = c_nationkey JOIN partsupp ON s_suppkey = ps_suppkey JOIN orders ON c_custkey = o_custkey WHERE s_phone IN ('28-923-811-2946', '32-666-395-9711', '22-163-107-5664', '28-252-244-8841') AND c_mktsegment = 'FURNITURE' AND o_orderdate BETWEEN '1995-01-01' AND '1995-12-31' GROUP BY r_name, n_name ORDER BY total_order_value DESC, avg_supplier_acctbal DESC;
SELECT c.c_mktsegment, s.s_nationkey, p.p_brand, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue, AVG(l.l_quantity) AS average_quantity, COUNT(DISTINCT l.l_orderkey) AS count_orders FROM customer c JOIN lineitem l ON c.c_custkey = l.l_orderkey JOIN part p ON l.l_partkey = p.p_partkey JOIN supplier s ON l.l_suppkey = s.s_suppkey WHERE c.c_address IN ('P6zNDMefxN', 'eEsDHOObVMbUeOB1', 'jnlXUaNoejf4qeCkcdvTN8s1bNl44CkaOf', 'pHMkOf,,5l8') AND s.s_suppkey IN ('4438', '1480', '850') AND s.s_nationkey IN ('0', '16', '9', '22', '4', '7') AND l.l_shipdate BETWEEN '1994-01-01' AND '1994-12-31' GROUP BY c.c_mktsegment, s.s_nationkey, p.p_brand ORDER BY revenue DESC, c.c_mktsegment, s.s_nationkey, p.p_brand;
