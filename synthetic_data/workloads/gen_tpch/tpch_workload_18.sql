SELECT c.c_mktsegment AS market_segment, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(c.c_acctbal) AS average_customer_acct_balance, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, AVG(p.p_retailprice) AS average_part_price FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN part p ON l.l_partkey = p.p_partkey JOIN supplier s ON l.l_suppkey = s.s_suppkey WHERE c.c_mktsegment = 'AUTOMOBILE' AND o.o_orderdate BETWEEN date '2022-01-01' AND date '2022-12-31' AND l.l_shipdate > o.o_orderdate AND p.p_container = 'JUMBO PACK' GROUP BY c.c_mktsegment ORDER BY total_revenue DESC, average_customer_acct_balance DESC LIMIT 10;
SELECT r.r_name AS region, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice) AS avg_price, AVG(l.l_discount) AS avg_discount, SUM(l.l_extendedprice * (1 - l_discount)) AS total_revenue FROM region r JOIN supplier s ON r.r_regionkey = s.s_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE o.o_orderpriority IN ('3-MEDIUM', '5-LOW', '4-NOT SPECIFIED') AND o.o_orderdate > CURRENT_DATE - INTERVAL '1 year' GROUP BY r.r_name ORDER BY total_revenue DESC, avg_price DESC;
SELECT n.n_name AS nation, c.c_mktsegment AS market_segment, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(*) AS total_orders, SUM(o.o_totalprice) AS total_revenue, AVG(o.o_totalprice) AS avg_order_value FROM customer AS c JOIN orders AS o ON c.c_custkey = o.o_custkey JOIN nation AS n ON c.c_nationkey = n.n_nationkey GROUP BY nation, market_segment, order_year ORDER BY nation, market_segment, order_year;
SELECT n.n_name AS nation_name, AVG(c.c_acctbal) AS average_account_balance, COUNT(DISTINCT c.c_custkey) AS number_of_customers, p.p_brand, SUM(ps.ps_availqty) AS total_available_quantity, AVG(ps.ps_supplycost) AS average_supply_cost, SUM(p.p_retailprice * ps.ps_availqty) AS total_retail_value FROM nation n JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN partsupp ps ON ps.ps_suppkey = c.c_custkey JOIN part p ON ps.ps_partkey = p.p_partkey WHERE n.n_nationkey IN (23, 7, 17, 9, 24, 13) AND p.p_size = 1 AND p.p_brand IN ('Brand#42', 'Brand#11', 'Brand#45') GROUP BY n.n_name, p.p_brand ORDER BY nation_name, p.p_brand;
SELECT r.r_name AS region, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_discounted_price, SUM(CASE WHEN l.l_returnflag = 'R' THEN l.l_extendedprice ELSE 0 END) AS total_returned_value FROM region r JOIN orders o ON r.r_regionkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE o.o_orderdate BETWEEN '1992-01-01' AND '1997-12-31' GROUP BY region, order_year ORDER BY region, order_year;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(l.l_quantity) AS total_quantity_ordered, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_discounted_price, SUM(p.p_retailprice * l.l_quantity) AS total_retail_price, COUNT(DISTINCT o.o_orderkey) AS number_of_orders FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey JOIN customer c ON o.o_custkey = c.c_custkey AND n.n_nationkey = c.c_nationkey GROUP BY region, nation ORDER BY total_quantity_ordered DESC, avg_discounted_price DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, AVG(s_acctbal) AS average_account_balance, SUM(o_totalprice) AS total_order_value, COUNT(DISTINCT o_orderkey) AS number_of_orders, AVG(ps_supplycost) AS average_supply_cost, SUM(ps_availqty) AS total_available_quantity FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN partsupp ON s_suppkey = ps_suppkey JOIN orders ON s_nationkey = o_custkey WHERE r_name IN ('ASIA', 'AMERICA') AND o_orderpriority IN ('1-URGENT', '2-HIGH') AND n_name IN ('UNITED STATES', 'JAPAN') GROUP BY region, nation ORDER BY total_order_value DESC, number_of_suppliers DESC;
SELECT r_name AS region_name, n_name AS nation_name, COUNT(DISTINCT c_custkey) AS number_of_customers, SUM(c_acctbal) AS total_balance, AVG(c_acctbal) AS avg_balance, COUNT(DISTINCT o_orderkey) AS number_of_orders, SUM(l_extendedprice) AS total_sales, SUM(l_extendedprice * (1 - l_discount)) AS total_sales_after_discount, AVG(l_quantity) AS avg_quantity_sold FROM region JOIN nation ON r_regionkey = n_regionkey JOIN customer ON n_nationkey = c_nationkey JOIN orders ON c_custkey = o_custkey JOIN lineitem ON o_orderkey = l_orderkey WHERE o_orderdate BETWEEN '1995-01-01' AND '1995-12-31' AND l_returnflag = 'N' GROUP BY region_name, nation_name ORDER BY total_sales_after_discount DESC, avg_quantity_sold;
SELECT c.c_mktsegment, COUNT(DISTINCT c.c_custkey) AS num_customers, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice) AS avg_price, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue_after_discount, AVG(l.l_discount) AS avg_discount FROM customer c JOIN lineitem l ON c.c_custkey = l.l_suppkey JOIN supplier s ON l.l_suppkey = s.s_suppkey WHERE s.s_comment LIKE '%final%' OR s.s_comment LIKE '%instructions%' OR s.s_comment LIKE '%pinto beans%' AND l.l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' AND c.c_acctbal > 0 GROUP BY c.c_mktsegment ORDER BY revenue_after_discount DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT ps_partkey) AS num_parts, SUM(ps_availqty) AS total_available_quantity, AVG(ps_supplycost) AS average_supply_cost, SUM(ps_supplycost * ps_availqty) AS total_value FROM partsupp JOIN nation ON partsupp.ps_suppkey = nation.n_nationkey JOIN region ON nation.n_regionkey = region.r_regionkey GROUP BY region, nation ORDER BY total_value DESC;
SELECT r_name AS region, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT p_partkey) AS number_of_parts, SUM(l_quantity) AS total_quantity, AVG(ps_supplycost) AS average_supply_cost, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue FROM region JOIN supplier ON s_nationkey = r_regionkey JOIN partsupp ON ps_suppkey = s_suppkey JOIN part ON ps_partkey = p_partkey JOIN lineitem ON l_partkey = p_partkey AND l_suppkey = s_suppkey JOIN orders ON l_orderkey = o_orderkey WHERE o_orderstatus = 'F' AND l_shipmode IN ('AIR', 'RAIL', 'TRUCK') AND s_comment LIKE '%packages%' GROUP BY region ORDER BY total_revenue DESC, region;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS num_suppliers, COUNT(DISTINCT c_custkey) AS num_customers, AVG(s_acctbal) AS avg_supplier_acctbal, AVG(c_acctbal) AS avg_customer_acctbal, SUM(l_extendedprice * (1 - l_discount)) AS revenue FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN orders ON o_custkey = c_custkey JOIN lineitem ON l_orderkey = o_orderkey WHERE o_orderstatus = 'O' AND l_shipdate BETWEEN '2023-01-01' AND '2023-12-31' GROUP BY region, nation ORDER BY revenue DESC;
SELECT r.r_name AS region, COUNT(DISTINCT c.c_custkey) AS number_of_customers, AVG(c.c_acctbal) AS average_account_balance, SUM(o.o_totalprice) AS total_order_value, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(l.l_quantity) AS total_parts_ordered, AVG(l.l_extendedprice * (1 - l_discount)) AS average_discounted_price FROM region r JOIN customer c ON c.c_nationkey = r.r_regionkey JOIN orders o ON o.o_custkey = c.c_custkey JOIN lineitem l ON l.l_orderkey = o.o_orderkey WHERE c.c_acctbal > 0 AND o.o_totalprice > 100000 AND l.l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' GROUP BY region ORDER BY total_order_value DESC, average_account_balance DESC;
SELECT c.c_mktsegment, p.p_brand, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice * (1 - l_discount)) AS avg_discounted_price, SUM(l.l_extendedprice * (1 - l_discount) * (1 + l_tax)) AS total_taxed_price FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN part p ON l.l_partkey = p.p_partkey WHERE c.c_acctbal > 0 AND p.p_mfgr IN ('Manufacturer#1', 'Manufacturer#2', 'Manufacturer#3') AND l.l_returnflag = 'N' AND o.o_orderstatus = 'O' AND o.o_orderpriority NOT IN ('1-URGENT', '2-HIGH') GROUP BY c.c_mktsegment, p.p_brand, order_year ORDER BY total_taxed_price DESC, total_quantity DESC, avg_discounted_price DESC, c.c_mktsegment, p.p_brand, order_year;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT o_orderkey) AS number_of_orders, SUM(l_extendedprice) AS total_sales, AVG(l_quantity) AS average_quantity, SUM(l_quantity * l_extendedprice * (1 - l_discount)) AS revenue_after_discount FROM region JOIN nation ON n_regionkey = r_regionkey JOIN orders ON o_orderdate >= DATE '1995-01-01' AND o_orderdate <= DATE '1996-12-31' JOIN lineitem ON l_orderkey = o_orderkey JOIN part ON p_partkey = l_partkey WHERE p_retailprice IN (1106.19, 935.03, 1061.15, 1378.47) AND l_shipdate > l_commitdate GROUP BY region, nation ORDER BY total_sales DESC, number_of_orders DESC;
SELECT r.r_name AS region_name, n.n_name AS nation_name, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(l.l_extendedprice) AS total_sales_value, AVG(l.l_quantity) AS average_quantity_sold, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue_after_discount, AVG(l.l_discount) AS average_discount_given FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE r.r_regionkey = 2 AND n.n_comment LIKE '%ven packages wake quickly. regu%' AND ( s.s_comment LIKE '%t the closely ironic packages. fluff%' OR s.s_comment LIKE '%accounts after the furious%' OR s.s_comment LIKE '%ecial deposits cajole slyly even ideas. furious%' OR s.s_comment LIKE '%ns. ironic ideas cajole. sl%' OR s.s_comment LIKE '%nto beans. stealthily final%' ) GROUP BY r.r_name, n.n_name ORDER BY total_sales_value DESC;
