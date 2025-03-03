SELECT r.r_name AS region, COUNT(o.o_orderkey) AS number_of_orders, AVG(o.o_totalprice) AS average_order_total, SUM(o.o_totalprice) AS sum_order_totals FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE o.o_orderdate >= (SELECT MAX(o_orderdate) FROM orders) - INTERVAL '3 months' GROUP BY r.r_name ORDER BY average_order_total DESC;
SELECT r.r_name AS region_name, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(c.c_acctbal) AS average_customer_acctbal, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c.c_custkey) AS number_of_customers FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN lineitem l ON p.p_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey JOIN customer c ON o.o_custkey = c.c_custkey WHERE c.c_mktsegment IN ('MACHINERY', 'AUTOMOBILE') AND r.r_name IN (SELECT r_name FROM region WHERE r_comment LIKE '%final%') GROUP BY r.r_name ORDER BY total_revenue DESC, average_customer_acctbal DESC;
SELECT r_name AS region, COUNT(DISTINCT o_orderkey) AS total_orders, COUNT(DISTINCT l_linenumber) AS total_line_items, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(l_quantity) AS average_quantity, SUM(ps_availqty) AS total_available_quantity FROM region JOIN supplier ON s_nationkey = region.r_regionkey JOIN customer ON c_nationkey = region.r_regionkey JOIN orders ON o_custkey = c_custkey JOIN lineitem ON l_orderkey = o_orderkey AND s_suppkey = l_suppkey JOIN partsupp ON ps_suppkey = l_suppkey AND ps_partkey = l_partkey JOIN part ON p_partkey = l_partkey WHERE o_orderdate BETWEEN date '1995-01-01' AND date '1995-12-31' AND l_shipmode IN ('RAIL', 'SHIP') AND p_type IN ('MEDIUM BURNISHED NICKEL', 'ECONOMY POLISHED TIN') GROUP BY region ORDER BY total_revenue DESC LIMIT 5;
SELECT n.n_name AS nation_name, AVG(s.s_acctbal) AS average_account_balance, SUM(ps.ps_supplycost) AS total_supply_cost, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT p.p_partkey) AS number_of_parts, COUNT(DISTINCT o.o_orderkey) AS number_of_orders FROM nation n JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN orders o ON o.o_orderdate BETWEEN DATE '1995-01-01' AND DATE '1996-12-31' WHERE p.p_brand IN ('Brand#22', 'Brand#24') AND n.n_nationkey IN (16, 17, 0, 24) AND o.o_shippriority = 0 AND ps.ps_comment LIKE ANY (ARRAY['%tions. furiously even theodolites haggle. furious%', '%ages after the blithely final ideas thrash carefu%', '%kly blithely regular packages. regular accounts p%']) GROUP BY nation_name ORDER BY total_supply_cost DESC;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS num_customers, COUNT(DISTINCT o.o_orderkey) AS num_orders, SUM(o.o_totalprice) AS total_sales, AVG(c.c_acctbal) AS avg_customer_balance, MAX(p.p_retailprice) AS max_part_price FROM region r LEFT JOIN nation n ON r.r_regionkey = n.n_regionkey LEFT JOIN customer c ON n.n_nationkey = c.c_nationkey LEFT JOIN orders o ON c.c_custkey = o.o_custkey LEFT JOIN partsupp ps ON ps.ps_suppkey = c.c_custkey LEFT JOIN part p ON ps.ps_partkey = p.p_partkey WHERE r.r_regionkey IN (1, 4, 0, 2, 3) AND c.c_nationkey IN (1, 15, 8) AND o.o_orderdate BETWEEN '2022-01-01' AND '2022-12-31' GROUP BY r.r_name, n.n_name ORDER BY total_sales DESC, avg_customer_balance DESC LIMIT 10;
SELECT r.r_name AS region, c.c_mktsegment AS market_segment, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_quantity) AS total_quantity_sold, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey AND o.o_orderstatus = 'F' JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE o.o_orderdate >= DATE '2022-10-01' AND o.o_orderdate < DATE '2023-01-01' GROUP BY r.r_name, c.c_mktsegment ORDER BY r.r_name, total_revenue DESC;
SELECT n_name AS nation_name, COUNT(s_suppkey) AS number_of_suppliers, SUM(l_quantity) AS total_quantity, AVG(s_acctbal) AS average_account_balance, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue, MAX(o_totalprice) AS max_order_price FROM nation JOIN supplier ON n_nationkey = s_nationkey JOIN lineitem ON s_suppkey = l_suppkey JOIN orders ON l_orderkey = o_orderkey WHERE n_comment LIKE '%unusual%' AND o_orderstatus = 'O' AND l_shipdate BETWEEN date '2022-01-01' AND date '2022-12-31' GROUP BY nation_name ORDER BY total_revenue DESC, average_account_balance DESC LIMIT 10;
SELECT n.n_name AS nation_name, COUNT(s.s_suppkey) AS number_of_suppliers, AVG(s.s_acctbal) AS average_account_balance, SUM(ps.ps_availqty) AS total_available_quantity, AVG(ps.ps_supplycost) AS average_supply_cost FROM nation AS n JOIN supplier AS s ON n.n_nationkey = s.s_nationkey JOIN partsupp AS ps ON s.s_suppkey = ps.ps_suppkey GROUP BY n.n_name ORDER BY average_account_balance DESC, nation_name;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, COUNT(DISTINCT c.c_custkey) AS total_customers, AVG(s.s_acctbal) AS avg_supplier_acctbal, AVG(c.c_acctbal) AS avg_customer_acctbal, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales_volume, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_sales_price FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE n.n_name IN ('UNITED STATES', 'GERMANY') AND l.l_shipmode IN ('REG AIR', 'MAIL') AND l.l_shipdate BETWEEN date '1995-01-01' AND date '1996-12-31' GROUP BY region, nation ORDER BY total_sales_volume DESC, region, nation;
