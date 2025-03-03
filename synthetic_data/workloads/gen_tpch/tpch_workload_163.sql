SELECT n.n_name AS nation, AVG(c.c_acctbal) AS avg_account_balance, COUNT(c.c_custkey) AS total_customers, SUM(c.c_acctbal) AS total_account_balance FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey WHERE r.r_name = 'Europe' AND o.o_orderdate >= DATE '2020-01-01' AND o.o_orderdate < DATE '2020-01-01' + INTERVAL '1 YEAR' GROUP BY n.n_name ORDER BY avg_account_balance DESC;
SELECT n.n_name AS nation, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS num_orders, SUM(o.o_totalprice) AS total_sales, AVG(c.c_acctbal) AS avg_customer_balance, SUM(ps.ps_availqty) AS total_avail_qty, AVG(ps.ps_supplycost) AS avg_supplycost FROM nation n JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN partsupp ps ON c.c_custkey = ps.ps_suppkey WHERE o.o_orderstatus = 'F' AND o.o_orderdate BETWEEN '1996-01-01' AND '1996-12-31' GROUP BY nation, order_year ORDER BY total_sales DESC, nation, order_year;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(s.s_suppkey) AS total_suppliers, COUNT(c.c_custkey) AS total_customers, SUM(ps.ps_availqty) AS total_parts_available, AVG(s.s_acctbal) AS avg_supplier_acctbal, AVG(c.c_acctbal) AS avg_customer_acctbal, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue, COUNT(DISTINCT o.o_orderkey) AS total_orders, COUNT(DISTINCT l.l_partkey) AS total_parts_ordered FROM region r JOIN nation n ON n.n_regionkey = r.r_regionkey JOIN supplier s ON s.s_nationkey = n.n_nationkey JOIN customer c ON c.c_nationkey = n.n_nationkey JOIN partsupp ps ON ps.ps_suppkey = s.s_suppkey JOIN lineitem l ON l.l_suppkey = s.s_suppkey AND l.l_partkey = ps.ps_partkey JOIN orders o ON o.o_orderkey = l.l_orderkey AND o.o_custkey = c.c_custkey GROUP BY r.r_name, n.n_name ORDER BY revenue DESC, total_suppliers DESC, total_customers DESC;
SELECT n.n_name AS nation_name, n.n_regionkey AS region_key, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_quantity) AS average_quantity, SUM(CASE WHEN p.p_type LIKE 'PROMO%' THEN 1 ELSE 0 END) AS promo_parts_count FROM nation n JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN part p ON l.l_partkey = p.p_partkey WHERE n.n_name IN ('UNITED STATES', 'ETHIOPIA', 'KENYA', 'IRAN') AND o.o_orderdate >= '1993-01-01' AND o.o_orderdate < '1998-01-01' AND l.l_linestatus IN ('F', 'O') AND l.l_tax = 0.03 AND p.p_container IN ('LG DRUM', 'SM JAR') GROUP BY nation_name, region_key, order_year ORDER BY total_revenue DESC, total_orders DESC, nation_name, order_year LIMIT 100;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(l.l_quantity) AS total_quantity_ordered, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_discounted_price, SUM(p.p_retailprice * l.l_quantity) AS total_retail_price, COUNT(DISTINCT o.o_orderkey) AS number_of_orders FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey JOIN customer c ON o.o_custkey = c.c_custkey AND n.n_nationkey = c.c_nationkey GROUP BY region, nation ORDER BY total_quantity_ordered DESC, avg_discounted_price DESC;
SELECT r.r_name AS region, c.c_mktsegment AS market_segment, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_revenue_per_order, COUNT(DISTINCT c.c_custkey) AS total_customers, SUM(l.l_extendedprice * (1 - l.l_discount)) / COUNT(DISTINCT c.c_custkey) AS avg_revenue_per_customer FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE o.o_orderpriority = '5-LOW' AND l.l_shipmode IN ('TRUCK', 'SHIP') GROUP BY r.r_name, c.c_mktsegment ORDER BY total_revenue DESC, avg_revenue_per_customer DESC;
SELECT r.r_name AS region_name, n.n_name AS nation_name, AVG(c.c_acctbal) AS avg_customer_acctbal, COUNT(DISTINCT o.o_orderkey) AS total_orders, AVG(l.l_quantity) AS avg_lineitem_quantity, AVG(l.l_extendedprice) AS avg_lineitem_extendedprice FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE EXTRACT(YEAR FROM l.l_shipdate) = 2022 GROUP BY r.r_name, n.n_name ORDER BY r.r_name, n.n_name;
SELECT r_name AS region, n_name AS nation, COUNT(c_custkey) AS num_customers, SUM(c_acctbal) AS total_account_balance, AVG(c_acctbal) AS average_account_balance, SUM(l_extendedprice * (1 - l_discount)) AS sales_volume, COUNT(DISTINCT o_orderkey) AS num_orders, COUNT(l_orderkey) AS num_lineitems, AVG(l_quantity) AS average_quantity_sold FROM region JOIN nation ON r_regionkey = n_regionkey JOIN customer ON n_nationkey = c_nationkey JOIN orders ON c_custkey = o_custkey JOIN lineitem ON o_orderkey = l_orderkey WHERE n_name IN ('CHINA', 'FRANCE', 'INDONESIA', 'JAPAN') AND o_orderdate BETWEEN '1993-01-01' AND '1997-12-31' AND (o_orderstatus = 'F' OR o_orderstatus = 'O') GROUP BY r_name, n_name ORDER BY sales_volume DESC, num_customers DESC;
SELECT r.r_name AS region_name, n.n_name AS nation_name, COUNT(s.s_suppkey) AS number_of_suppliers, SUM(p.ps_availqty) AS total_available_quantity, AVG(p.ps_supplycost) AS average_supply_cost, SUM(p.ps_availqty * p.ps_supplycost) AS total_value FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp p ON s.s_suppkey = p.ps_suppkey GROUP BY r.r_name, n.n_name ORDER BY r.r_name, n.n_name;
SELECT n.n_name, c.c_mktsegment, AVG(c.c_acctbal) AS average_account_balance, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(ps.ps_availqty) AS total_available_quantity, AVG(ps.ps_supplycost) AS average_supply_cost, SUM(p.p_retailprice * ps.ps_availqty) AS total_retail_value FROM nation n JOIN customer c ON c.c_nationkey = n.n_nationkey JOIN partsupp ps ON ps.ps_partkey IN (SELECT p_partkey FROM part WHERE p_name IN ('forest mint goldenrod saddle hot', 'wheat almond blue cream ivory')) JOIN part p ON p.p_partkey = ps.ps_partkey GROUP BY n.n_name, c.c_mktsegment ORDER BY n.n_name, c.c_mktsegment;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS customer_count, AVG(c.c_acctbal) AS avg_account_balance, SUM(CASE WHEN o.o_orderstatus = 'F' THEN 1 ELSE 0 END) AS finished_orders_count, SUM(l.l_quantity) AS total_quantity_ordered, SUM(l.l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(l.l_discount) AS avg_discount FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE c.c_mktsegment IN ('HOUSEHOLD', 'AUTOMOBILE', 'BUILDING', 'MACHINERY', 'FURNITURE') AND l.l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' AND l.l_returnflag = 'N' GROUP BY region, nation ORDER BY total_revenue DESC, avg_account_balance DESC;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, COUNT(DISTINCT c.c_custkey) AS total_customers, COUNT(DISTINCT o.o_orderkey) AS total_orders, AVG(s.s_acctbal) AS avg_supplier_acctbal, AVG(c.c_acctbal) AS avg_customer_acctbal, SUM(o.o_totalprice) AS total_order_value, AVG(ps.ps_supplycost) AS avg_part_supply_cost, SUM(ps.ps_availqty) AS total_available_parts_qty FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey WHERE o.o_orderstatus = 'O' AND o.o_clerk IN ('Clerk#000008805', 'Clerk#000017121', 'Clerk#000001732', 'Clerk#000008709') AND EXISTS ( SELECT 1 FROM part p WHERE p.p_partkey = ps.ps_partkey AND p.p_brand IN ('Brand#53', 'Brand#52', 'Brand#13', 'Brand#42', 'Brand#24') ) GROUP BY r.r_name, n.n_name ORDER BY total_order_value DESC;
SELECT r_name AS region, n_name AS nation, p_brand AS part_brand, COUNT(DISTINCT o_orderkey) AS total_orders, SUM(l_extendedprice) AS total_sales, AVG(l_extendedprice * (1 - l_discount)) AS avg_discounted_sales, SUM(l_quantity) AS total_quantity_sold, AVG(l_quantity) AS avg_quantity_sold FROM region JOIN nation ON r_regionkey = n_regionkey JOIN orders ON n_nationkey = o_custkey JOIN lineitem ON o_orderkey = l_orderkey JOIN part ON l_partkey = p_partkey WHERE o_orderstatus IN ('F', 'O', 'P') AND p_brand IN ('Brand#34', 'Brand#42', 'Brand#15', 'Brand#14', 'Brand#13') AND l_shipinstruct IN ('TAKE BACK RETURN', 'DELIVER IN PERSON', 'COLLECT COD') AND l_shipdate >= '1994-10-27' AND o_shippriority = '0' GROUP BY region, nation, part_brand ORDER BY total_sales DESC, region, nation;
SELECT r.r_name AS region_name, c.c_mktsegment AS market_segment, AVG(c.c_acctbal) AS avg_account_balance, COUNT(DISTINCT o.o_orderkey) AS total_orders, COUNT(l.l_orderkey) AS total_line_items, SUM(l.l_extendedprice) AS total_revenue FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE r.r_name IN ('ASIA', 'AMERICA', 'MIDDLE EAST', 'EUROPE') AND c.c_mktsegment IN ('FURNITURE', 'AUTOMOBILE') AND l.l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' GROUP BY r.r_name, c.c_mktsegment ORDER BY region_name, market_segment;
SELECT r.r_name AS region, o.o_orderpriority AS order_priority, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice) AS avg_price, SUM(l.l_extendedprice * (1 - l_discount)) AS revenue_after_discount, SUM(CASE WHEN l.l_receiptdate > l.l_commitdate THEN 1 ELSE 0 END) AS late_receipts_count FROM orders o JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN partsupp ps ON l.l_partkey = ps.ps_partkey AND l.l_suppkey = ps.ps_suppkey JOIN region r ON ps.ps_suppkey::varchar LIKE r.r_regionkey::varchar || '%' WHERE o.o_orderdate BETWEEN date '1993-01-01' AND date '1994-01-01' AND l.l_shipmode IN ('MAIL', 'SHIP') GROUP BY region, order_priority ORDER BY revenue_after_discount DESC, total_quantity DESC, number_of_orders DESC LIMIT 10;
SELECT r.r_name AS region_name, n.n_name AS nation_name, COUNT(DISTINCT c.c_custkey) AS total_customers, COUNT(DISTINCT o.o_orderkey) AS total_orders, ROUND(AVG(c.c_acctbal), 2) AS avg_customer_acctbal, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue, SUM(l.l_quantity) AS total_quantity_sold, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_order_value FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE r.r_name IN ('MIDDLE EAST', 'ASIA', 'EUROPE', 'AMERICA', 'AFRICA') AND l.l_shipdate BETWEEN '1993-07-01' AND '1994-07-01' AND l.l_receiptdate > l.l_commitdate AND o.o_orderstatus = 'F' GROUP BY region_name, nation_name ORDER BY revenue DESC, region_name, nation_name;
SELECT r.r_name AS region, AVG(ps.ps_supplycost) AS average_supply_cost, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT p.p_partkey) AS number_of_parts FROM region r JOIN supplier s ON s.s_nationkey = r.r_regionkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN lineitem l ON p.p_partkey = l.l_partkey AND s.s_suppkey = l.l_suppkey WHERE p.p_mfgr IN ('Manufacturer#1', 'Manufacturer#2', 'Manufacturer#3') AND l.l_shipinstruct = 'TAKE BACK RETURN' AND r.r_comment IN ('ly final courts cajole furiously final excuse', 'ges. thinly even pinto beans ca', 'hs use ironic, even requests. s') GROUP BY r.r_name ORDER BY total_revenue DESC;
SELECT r.r_name AS region_name, c.c_mktsegment AS market_segment, AVG(c.c_acctbal) AS avg_account_balance, COUNT(c.c_custkey) AS customer_count, SUM(c.c_acctbal) AS total_account_balance FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey GROUP BY r.r_name, c.c_mktsegment ORDER BY region_name, market_segment;
SELECT r.r_name AS region_name, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(o.o_totalprice) AS total_sales, AVG(l.l_quantity) AS average_quantity_sold, (SUM(l.l_extendedprice * (1 - l.l_discount)) / SUM(l.l_extendedprice)) AS average_discount_effect FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN supplier s ON l.l_suppkey = s.s_suppkey JOIN region r ON c.c_nationkey = s.s_nationkey WHERE c.c_acctbal > 0 AND o.o_orderdate BETWEEN '2020-01-01' AND '2020-12-31' AND r.r_regionkey IN (1, 2, 3) GROUP BY r.r_name ORDER BY total_sales DESC;
SELECT r.r_name AS region_name, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(l.l_quantity) AS total_quantity_sold, AVG(l.l_extendedprice) AS average_price, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue_after_discount, AVG((l.l_extendedprice * (1 - l.l_discount)) / l.l_quantity) AS average_price_per_unit FROM region r JOIN customer c ON c.c_nationkey = r.r_regionkey JOIN orders o ON o.o_custkey = c.c_custkey JOIN lineitem l ON l.l_orderkey = o.o_orderkey WHERE r.r_name IN ('AMERICA', 'EUROPE') AND o.o_orderdate BETWEEN '1995-01-01' AND '1996-12-31' AND c.c_mktsegment = 'AUTOMOBILE' GROUP BY region_name, order_year ORDER BY region_name, order_year;
SELECT r_name AS region, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(o.o_totalprice) AS total_sales, AVG(l.l_quantity) AS average_quantity_ordered, SUM((l.l_extendedprice * (1 - l.l_discount))) AS revenue, COUNT(DISTINCT o.o_orderkey) AS number_of_orders FROM region JOIN customer c ON c.c_nationkey = region.r_regionkey JOIN orders o ON o.o_custkey = c.c_custkey JOIN lineitem l ON l.l_orderkey = o.o_orderkey WHERE r_name IN ('MIDDLE EAST', 'ASIA', 'EUROPE', 'AMERICA', 'AFRICA') AND o.o_shippriority = 0 AND o.o_totalprice > 20000 GROUP BY r_name ORDER BY total_sales DESC;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, AVG(s.s_acctbal) AS average_account_balance, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales_value, AVG(p.p_retailprice) AS average_part_retail_price, COUNT(DISTINCT o.o_orderkey) AS number_of_orders FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE o.o_orderdate BETWEEN date '1995-01-01' AND date '1995-12-31' AND l.l_shipdate > o.o_orderdate AND ps.ps_suppkey <> 60835 GROUP BY region, nation ORDER BY total_sales_value DESC, region, nation;
SELECT n.n_name AS nation, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_extendedprice) AS total_sales, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_discounted_sales, SUM(l.l_quantity) AS total_quantity_sold, AVG(s.s_acctbal) AS avg_supplier_balance, AVG(c.c_acctbal) AS avg_customer_balance FROM nation n JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey JOIN customer c ON o.o_custkey = c.c_custkey WHERE n.n_name IN ('INDONESIA', 'JAPAN', 'ALGERIA', 'UNITED STATES', 'EGYPT', 'UNITED KINGDOM') AND c.c_phone IN ('30-866-194-9271', '33-773-557-6633', '29-216-836-3600') AND s.s_phone IN ('33-137-305-9447', '10-804-579-6434', '12-918-764-7526', '30-514-592-2334') AND o.o_orderdate >= '2020-01-01' GROUP BY nation, order_year ORDER BY nation, order_year DESC;
SELECT c.c_mktsegment, s.s_nationkey, p.p_brand, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue, AVG(l.l_quantity) AS average_quantity, COUNT(DISTINCT l.l_orderkey) AS count_orders FROM customer c JOIN lineitem l ON c.c_custkey = l.l_orderkey JOIN part p ON l.l_partkey = p.p_partkey JOIN supplier s ON l.l_suppkey = s.s_suppkey WHERE c.c_address IN ('P6zNDMefxN', 'eEsDHOObVMbUeOB1', 'jnlXUaNoejf4qeCkcdvTN8s1bNl44CkaOf', 'pHMkOf,,5l8') AND s.s_suppkey IN ('4438', '1480', '850') AND s.s_nationkey IN ('0', '16', '9', '22', '4', '7') AND l.l_shipdate BETWEEN '1994-01-01' AND '1994-12-31' GROUP BY c.c_mktsegment, s.s_nationkey, p.p_brand ORDER BY revenue DESC, c.c_mktsegment, s.s_nationkey, p.p_brand;
SELECT r.r_name AS region_name, p.p_type AS part_type, AVG(p.p_retailprice) AS avg_retail_price, SUM(li.l_quantity) AS total_quantity_sold, COUNT(DISTINCT li.l_orderkey) AS number_of_orders, SUM(li.l_extendedprice * (1 - li.l_discount) * (1 + li.l_tax)) AS total_sales_value FROM region r JOIN partsupp ps ON r.r_regionkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN lineitem li ON p.p_partkey = li.l_partkey AND ps.ps_suppkey = li.l_suppkey WHERE r.r_name IN ('MIDDLE EAST', 'ASIA', 'EUROPE', 'AMERICA', 'AFRICA') AND li.l_shipmode = 'REG AIR' AND li.l_shipdate BETWEEN '2021-01-01' AND '2021-12-31' GROUP BY r.r_name, p.p_type ORDER BY total_sales_value DESC, avg_retail_price DESC LIMIT 100;
SELECT n.n_name, COUNT(o.o_orderkey) AS total_orders, AVG(o.o_totalprice) AS avg_order_price, SUM(ps.ps_supplycost * ps.ps_availqty) AS total_supply_cost, MAX(o.o_orderdate) AS latest_order_date FROM nation n JOIN orders o ON n.n_nationkey = o.o_custkey JOIN partsupp ps ON o.o_orderkey = ps.ps_partkey WHERE n.n_name IN ('IRAQ', 'MOROCCO', 'INDONESIA', 'UNITED KINGDOM', 'RUSSIA', 'SAUDI ARABIA') AND o.o_orderstatus = 'F' AND o.o_orderpriority IN ('1-URGENT', '5-LOW', '3-MEDIUM') GROUP BY n.n_name ORDER BY total_orders DESC, avg_order_price DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, AVG(s_acctbal) AS average_account_balance, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue, COUNT(DISTINCT o_orderkey) AS number_of_orders, AVG(o_totalprice) AS average_order_total FROM supplier JOIN nation ON s_nationkey = n_nationkey JOIN region ON n_regionkey = r_regionkey JOIN lineitem ON s_suppkey = l_suppkey JOIN orders ON l_orderkey = o_orderkey WHERE r_name = 'EUROPE' AND o_orderdate BETWEEN '1995-01-01' AND '1995-12-31' AND s_comment LIKE '%across%' AND o_orderstatus = 'O' GROUP BY region, nation ORDER BY total_revenue DESC, average_account_balance DESC;
