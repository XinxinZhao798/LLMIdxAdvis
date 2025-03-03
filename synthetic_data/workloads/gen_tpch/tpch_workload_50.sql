SELECT r.r_name AS region, c.c_mktsegment AS market_segment, COUNT(DISTINCT c.c_custkey) AS total_customers, SUM(l.l_quantity) AS total_quantity_sold, AVG(l.l_extendedprice) AS avg_price, SUM(l.l_extendedprice * (1 - l_discount)) AS revenue_after_discount FROM region r JOIN customer c ON r.r_regionkey = c.c_nationkey JOIN lineitem l ON c.c_custkey = l.l_suppkey JOIN part p ON l.l_partkey = p.p_partkey WHERE p.p_size IN (4, 5, 14) AND p.p_container IN ('SM DRUM', 'JUMBO PACK') AND l.l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' GROUP BY r.r_name, c.c_mktsegment ORDER BY revenue_after_discount DESC, total_quantity_sold DESC;
SELECT s.s_name, r.r_name AS region_name, SUM(li.l_extendedprice * (1 - li.l_discount)) AS total_revenue, AVG(ps.ps_supplycost) AS avg_supply_cost, COUNT(*) AS total_lineitem_count FROM supplier AS s JOIN region AS r ON s.s_nationkey = r.r_regionkey JOIN partsupp AS ps ON s.s_suppkey = ps.ps_suppkey JOIN part AS p ON ps.ps_partkey = p.p_partkey JOIN lineitem AS li ON p.p_partkey = li.l_partkey AND s.s_suppkey = li.l_suppkey WHERE r.r_name = 'EUROPE' AND p.p_size = 15 AND ps.ps_availqty > 5000 AND li.l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' GROUP BY s.s_name, r.r_name ORDER BY total_revenue DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, AVG(s_acctbal) AS avg_supplier_acctbal, AVG(c_acctbal) AS avg_customer_acctbal, SUM(l_extendedprice * (1 - l_discount)) AS total_sales_value FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON n_nationkey = s_nationkey JOIN customer ON n_nationkey = c_nationkey JOIN orders ON c_custkey = o_custkey JOIN lineitem ON o_orderkey = l_orderkey WHERE o_orderstatus = 'F' AND l_shipdate <= '2023-01-01' AND l_returnflag = 'N' GROUP BY r_name, n_name ORDER BY total_sales_value DESC, region, nation;
SELECT r.r_name AS region, n.n_name AS nation, c.c_mktsegment AS market_segment, COUNT(DISTINCT c.c_custkey) AS number_of_customers, AVG(c.c_acctbal) AS average_account_balance, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales_value FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey JOIN lineitem l ON c.c_custkey = l.l_suppkey WHERE c.c_mktsegment IN ('HOUSEHOLD', 'AUTOMOBILE', 'BUILDING', 'MACHINERY', 'FURNITURE') AND n.n_nationkey IN (21, 23, 3) AND l.l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' GROUP BY region, nation, market_segment ORDER BY total_sales_value DESC, average_account_balance DESC;
SELECT r.r_name AS region, c.c_mktsegment AS market_segment, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_revenue_per_order, COUNT(DISTINCT c.c_custkey) AS total_customers, SUM(l.l_extendedprice * (1 - l.l_discount)) / COUNT(DISTINCT c.c_custkey) AS avg_revenue_per_customer FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE o.o_orderpriority = '5-LOW' AND l.l_shipmode IN ('TRUCK', 'SHIP') GROUP BY r.r_name, c.c_mktsegment ORDER BY total_revenue DESC, avg_revenue_per_customer DESC;
SELECT c.c_mktsegment, COUNT(DISTINCT o.o_orderkey) AS total_orders, AVG(c.c_acctbal) AS avg_acct_balance, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE c.c_acctbal > 0.00 AND l.l_shipinstruct = 'DELIVER IN PERSON' GROUP BY c.c_mktsegment ORDER BY total_revenue DESC;
SELECT r.r_name AS region_name, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales, AVG(l.l_discount) AS average_discount FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE o.o_orderpriority = '1-URGENT' GROUP BY r.r_name ORDER BY total_sales DESC;
SELECT s.s_name, r.r_name AS region, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(li.l_extendedprice) AS total_sales, AVG(li.l_quantity) AS avg_quantity_sold, SUM(li.l_extendedprice * (1 - li.l_discount)) AS revenue_after_discount, SUM(CASE WHEN li.l_shipmode = 'MAIL' THEN l_quantity ELSE 0 END) AS quantity_shipped_by_mail, SUM(CASE WHEN li.l_returnflag = 'R' THEN 1 ELSE 0 END) AS total_returns FROM supplier s JOIN customer c ON s.s_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem li ON o.o_orderkey = li.l_orderkey JOIN part p ON li.l_partkey = p.p_partkey JOIN region r ON s.s_nationkey = r.r_regionkey WHERE li.l_shipmode IN ('FOB', 'MAIL', 'TRUCK') AND o.o_orderstatus IN ('F', 'O', 'P') AND li.l_tax IN (0.02, 0.07) AND p.p_type IN ('STANDARD ANODIZED COPPER', 'SMALL BRUSHED NICKEL', 'PROMO ANODIZED TIN', 'SMALL PLATED TIN') AND p.p_partkey IN (718, 4647, 4547, 3249, 4189) GROUP BY s.s_name, region ORDER BY total_sales DESC LIMIT 10;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice) AS avg_extendedprice, SUM(l.l_extendedprice * (1 - l_discount)) AS revenue FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey JOIN part p ON l.l_partkey = p.p_partkey WHERE n.n_nationkey IN (1, 6, 8) AND l.l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' AND l.l_returnflag = 'N' GROUP BY r.r_name, n.n_name ORDER BY revenue DESC;
SELECT n.n_name AS nation_name, c.c_mktsegment AS market_segment, COUNT(DISTINCT c.c_custkey) AS num_customers, SUM(l.l_quantity) AS total_quantity_ordered, AVG(l.l_extendedprice) AS avg_price, SUM(l.l_extendedprice * (1 - l_discount)) AS revenue_after_discount, AVG(ps.ps_supplycost) AS avg_supply_cost FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN lineitem l ON c.c_custkey = l.l_suppkey JOIN partsupp ps ON l.l_partkey = ps.ps_partkey AND l.l_suppkey = ps.ps_suppkey WHERE c.c_mktsegment IN ('HOUSEHOLD', 'AUTOMOBILE', 'BUILDING', 'MACHINERY', 'FURNITURE') AND l.l_receiptdate BETWEEN '1994-01-01' AND '1998-12-31' AND l.l_commitdate < l.l_receiptdate AND ps.ps_supplycost IN (498.24, 99.63, 961.19, 162.95) AND ps.ps_partkey IN (1041, 906) GROUP BY nation_name, market_segment ORDER BY revenue_after_discount DESC, nation_name, market_segment;
SELECT r.r_name AS region_name, p.p_brand AS part_brand, AVG(ps.ps_supplycost) AS avg_supply_cost, SUM(ps.ps_availqty) AS total_available_quantity FROM region r JOIN partsupp ps ON true JOIN part p ON ps.ps_partkey = p.p_partkey JOIN lineitem li ON li.l_partkey = p.p_partkey AND li.l_suppkey = ps.ps_suppkey WHERE p.p_size IN (24, 18) AND ps.ps_supplycost < 300 AND ps.ps_comment NOT LIKE '%Customer%Complaints%' AND r.r_name IN ('AMERICA', 'EUROPE') AND li.l_shipdate BETWEEN '1996-01-01' AND '1996-12-31' GROUP BY r.r_name, p.p_brand ORDER BY avg_supply_cost DESC, total_available_quantity DESC;
SELECT r.r_name AS region_name, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, COUNT(DISTINCT p.p_partkey) AS total_parts, AVG(s.s_acctbal) AS average_supplier_acctbal, SUM(o.o_totalprice) AS total_order_price, AVG(o.o_totalprice) AS average_order_price FROM region r JOIN supplier s ON s.s_nationkey = r.r_regionkey JOIN part p ON p.p_size = r.r_regionkey JOIN orders o ON o.o_orderkey = p.p_partkey WHERE r.r_name IN ('ASIA', 'AFRICA') AND p.p_retailprice IN (1396.48, 991.08, 966.05) AND r.r_comment LIKE '%final%' GROUP BY r.r_name ORDER BY total_order_price DESC;
