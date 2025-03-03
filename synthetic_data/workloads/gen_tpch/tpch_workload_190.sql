SELECT r_name AS region, c_mktsegment AS market_segment, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, SUM(o_totalprice) AS total_sales, AVG(o_totalprice) AS avg_order_value, COUNT(DISTINCT o_orderkey) AS number_of_orders FROM region JOIN supplier ON supplier.s_nationkey = region.r_regionkey JOIN customer ON customer.c_nationkey = region.r_regionkey JOIN orders ON orders.o_custkey = customer.c_custkey WHERE r_regionkey = 0 GROUP BY r_name, c_mktsegment ORDER BY total_sales DESC;
SELECT s_nationkey, c_mktsegment, COUNT(DISTINCT o_orderkey) AS num_orders, SUM(l_extendedprice * (1 - l_discount)) AS revenue, AVG(l_quantity) AS avg_quantity, AVG(l_extendedprice) AS avg_price, AVG(l_discount) AS avg_discount, COUNT(*) AS lineitem_count FROM supplier, orders, lineitem, customer WHERE s_suppkey = l_suppkey AND l_orderkey = o_orderkey AND o_custkey = c_custkey AND s_nationkey IN (21, 12) AND s_phone IN ('18-343-591-7200', '27-424-904-2482') GROUP BY s_nationkey, c_mktsegment ORDER BY revenue DESC;
SELECT r_name, p_type, COUNT(DISTINCT c_custkey) AS num_customers, SUM(l_extendedprice) AS total_sales, AVG(l_quantity) AS avg_quantity_sold, AVG(l_extendedprice * (1 - l_discount)) AS avg_discounted_price FROM region JOIN customer ON c_nationkey = r_regionkey JOIN lineitem ON l_suppkey = c_custkey JOIN part ON p_partkey = l_partkey WHERE r_name IN ('EUROPE', 'AMERICA', 'AFRICA') AND p_type IN ('LARGE ANODIZED NICKEL', 'ECONOMY BRUSHED STEEL', 'MEDIUM PLATED BRASS', 'ECONOMY ANODIZED NICKEL', 'STANDARD BURNISHED COPPER') AND l_linestatus IN ('F', 'O') GROUP BY r_name, p_type ORDER BY r_name, total_sales DESC;
SELECT r.r_name AS region_name, p.p_type AS part_type, AVG(l.l_quantity) AS average_quantity, SUM(l.l_extendedprice * (1 - l.l_discount)) AS net_revenue, COUNT(DISTINCT o.o_orderkey) AS number_of_orders FROM region r JOIN partsupp ps ON r.r_regionkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN lineitem l ON p.p_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE o.o_orderdate BETWEEN date '1994-01-01' AND date '1994-12-31' AND l.l_shipmode IN ('AIR', 'RAIL') GROUP BY r.r_name, p.p_type ORDER BY net_revenue DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT c_custkey) AS num_customers, COUNT(DISTINCT s_suppkey) AS num_suppliers, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(l_quantity) AS avg_quantity_sold, AVG(c_acctbal) AS avg_customer_acctbal, AVG(s_acctbal) AS avg_supplier_acctbal FROM region JOIN nation ON n_regionkey = r_regionkey JOIN customer ON c_nationkey = n_nationkey JOIN supplier ON s_nationkey = n_nationkey JOIN lineitem ON (c_custkey = l_orderkey AND s_suppkey = l_suppkey) WHERE l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' AND r_name IN ('EUROPE', 'AMERICA', 'ASIA') GROUP BY r_name, n_name ORDER BY total_revenue DESC, avg_quantity_sold DESC LIMIT 10;
SELECT n.n_name AS nation, COUNT(s.s_suppkey) AS number_of_suppliers, AVG(s.s_acctbal) AS average_account_balance, SUM(li.l_quantity) AS total_quantity_supplied FROM nation AS n JOIN supplier AS s ON n.n_nationkey = s.s_nationkey JOIN lineitem AS li ON s.s_suppkey = li.l_suppkey WHERE s.s_name IN ('Supplier#000021987', 'Supplier#000020830', 'Supplier#000021117', 'Supplier#000020718', 'Supplier#000021295', 'Supplier#000017813') GROUP BY n.n_name ORDER BY average_account_balance DESC, number_of_suppliers DESC;
SELECT r_name AS region, EXTRACT(YEAR FROM o_orderdate) AS order_year, COUNT(DISTINCT o_orderkey) AS total_orders, SUM(l_extendedprice * (1 - l_discount)) AS revenue, AVG(l_quantity) AS average_quantity, SUM(ps_supplycost * l_quantity) AS total_supply_cost, (SUM(l_extendedprice * (1 - l_discount)) - SUM(ps_supplycost * l_quantity)) AS profit FROM region JOIN nation ON n_regionkey = r_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN partsupp ON ps_suppkey = s_suppkey JOIN lineitem ON l_suppkey = s_suppkey AND l_partkey = ps_partkey JOIN orders ON o_orderkey = l_orderkey WHERE o_orderdate BETWEEN '1994-01-01' AND '1995-12-31' AND l_discount BETWEEN 0.05 AND 0.10 AND l_shipdate > o_orderdate AND o_orderstatus = 'F' GROUP BY region, order_year ORDER BY profit DESC, region, order_year;
SELECT n.n_name AS nation, l.l_shipmode, SUM(l.l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(l.l_quantity) AS average_quantity, COUNT(*) AS total_orders FROM nation n JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey WHERE l.l_shipmode IN ('AIR', 'SHIP') AND l.l_shipdate >= '1995-01-01' AND l.l_shipdate < '1995-01-01'::date + INTERVAL '1 year' GROUP BY n.n_name, l.l_shipmode ORDER BY total_revenue DESC, n.n_name, l.l_shipmode;
SELECT r.r_name AS region, COUNT(DISTINCT c.c_custkey) AS number_of_customers, AVG(c.c_acctbal) AS average_account_balance, SUM(ps.ps_availqty) AS total_available_parts, SUM(o.o_totalprice) AS total_order_value, COUNT(DISTINCT o.o_orderkey) AS number_of_orders FROM customer c JOIN region r ON c.c_nationkey = r.r_regionkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN partsupp ps ON ps.ps_suppkey = c.c_custkey WHERE c.c_comment LIKE '%accounts%' AND o.o_orderstatus IN ('F', 'O', 'P') AND o.o_orderdate BETWEEN '2022-01-01' AND '2022-12-31' GROUP BY r.r_name ORDER BY total_order_value DESC, region;
SELECT r_name AS region, p_type, COUNT(DISTINCT o_orderkey) AS total_orders, SUM(o_totalprice) AS total_revenue, AVG(ps_supplycost) AS average_supply_cost, SUM(ps_availqty) AS total_available_quantity FROM region JOIN orders ON region.r_regionkey = (orders.o_orderkey % 5) JOIN partsupp ON orders.o_orderkey = (partsupp.ps_suppkey % 5) JOIN part ON partsupp.ps_partkey = part.p_partkey WHERE p_type IN ('PROMO ANODIZED STEEL', 'MEDIUM BURNISHED COPPER', 'ECONOMY POLISHED COPPER', 'SMALL BURNISHED TIN', 'LARGE PLATED STEEL', 'ECONOMY BURNISHED TIN') AND o_orderdate BETWEEN DATE '2022-01-01' AND DATE '2022-12-31' GROUP BY region, p_type ORDER BY total_revenue DESC;
SELECT r.r_name AS region, n.n_name AS nation, c.c_mktsegment AS market_segment, COUNT(*) AS customer_count, AVG(c.c_acctbal) AS avg_account_balance, SUM(c.c_acctbal) AS total_account_balance FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey GROUP BY r.r_name, n.n_name, c.c_mktsegment ORDER BY r.r_name, n.n_name, c.c_mktsegment;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT c_custkey) AS num_customers, COUNT(DISTINCT s_suppkey) AS num_suppliers, SUM(l_quantity) AS total_quantity_ordered, AVG(l_extendedprice) AS average_order_price, SUM(l_extendedprice * (1 - l_discount)) AS revenue_after_discount FROM region JOIN nation ON n_regionkey = r_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN orders ON o_custkey = c_custkey JOIN lineitem ON l_orderkey = o_orderkey JOIN part ON l_partkey = p_partkey WHERE o_orderpriority = '5-LOW' AND o_orderstatus = 'F' AND p_retailprice IN (1426.52, 1454.54, 1027.11, 1681.77, 1790.88, 1465.56) AND n_nationkey IN (7, 4) AND r_regionkey IN (1, 4, 0, 2, 3) GROUP BY region, nation ORDER BY revenue_after_discount DESC;
SELECT n.n_name AS nation_name, AVG(ps.ps_supplycost) AS avg_supply_cost, SUM(ps.ps_availqty) AS total_avail_qty, COUNT(o.o_orderkey) AS order_count, AVG(o.o_totalprice) AS avg_order_price FROM nation n JOIN partsupp ps ON n.n_nationkey = ps.ps_suppkey LEFT JOIN orders o ON n.n_nationkey = o.o_custkey AND o.o_orderdate >= '2020-01-01' AND o.o_orderdate < '2021-01-01' WHERE ps.ps_availqty IN (1805, 7621, 9995, 1615, 669) GROUP BY n.n_name ORDER BY n.n_name;
SELECT c.c_mktsegment, s.s_nationkey, p.p_brand, p.p_type, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice) AS avg_price, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue, COUNT(DISTINCT c.c_custkey) AS number_of_customers, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers FROM customer c JOIN lineitem l ON c.c_custkey = l.l_orderkey JOIN part p ON l.l_partkey = p.p_partkey JOIN supplier s ON l.l_suppkey = s.s_suppkey GROUP BY c.c_mktsegment, s.s_nationkey, p.p_brand, p.p_type ORDER BY revenue DESC LIMIT 10;
SELECT nation.n_name AS supplier_nation, COUNT(DISTINCT supplier.s_suppkey) AS number_of_suppliers, SUM(lineitem.l_quantity) AS total_quantity, AVG(lineitem.l_extendedprice) AS average_price, SUM(lineitem.l_extendedprice * (1 - lineitem.l_discount)) AS total_revenue_after_discount FROM supplier JOIN nation ON supplier.s_nationkey = nation.n_nationkey JOIN lineitem ON supplier.s_suppkey = lineitem.l_suppkey WHERE nation.n_name IN ('CHINA', 'VIETNAM', 'INDONESIA', 'GERMANY', 'SAUDI ARABIA', 'ARGENTINA') AND lineitem.l_linestatus IN ('F', 'O') AND lineitem.l_linenumber IN (5, 3) AND supplier.s_comment IN ( 's nag. slyly pending accounts', 'gular packages. ironic requ', 'ingly bold foxes are quickly regular t', 'l packages boost always slyly', 'otes are quickly final fo', 'ress final theodolites. blithely final pack' ) AND lineitem.l_shipdate BETWEEN '1995-01-01' AND '1996-12-31' GROUP BY supplier_nation ORDER BY total_revenue_after_discount DESC, supplier_nation;
SELECT c.c_mktsegment, p.p_brand, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue, AVG(ps.ps_supplycost) AS avg_supply_cost, COUNT(distinct o.o_orderkey) AS total_orders FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN part p ON l.l_partkey = p.p_partkey JOIN partsupp ps ON p.p_partkey = ps.ps_partkey AND l.l_suppkey = ps.ps_suppkey WHERE c.c_mktsegment IN ('MACHINERY', 'HOUSEHOLD') AND p.p_brand IN ('Brand#54', 'Brand#22', 'Brand#41', 'Brand#32') AND l.l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' GROUP BY c.c_mktsegment, p.p_brand ORDER BY revenue DESC, avg_supply_cost;
SELECT c.c_mktsegment, COUNT(DISTINCT o.o_orderkey) AS total_orders, AVG(o.o_totalprice) AS avg_order_price, SUM(o.o_totalprice) AS total_order_price, COUNT(DISTINCT ps.ps_suppkey) AS number_of_suppliers FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN partsupp ps ON o.o_orderkey = ps.ps_partkey WHERE ps.ps_supplycost BETWEEN 50 AND 600 GROUP BY c.c_mktsegment ORDER BY total_order_price DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT ps_suppkey) AS supplier_count, SUM(ps_availqty) AS total_avail_qty, AVG(ps_supplycost) AS avg_supply_cost, SUM(l_extendedprice) AS total_extended_price, SUM(l_extendedprice * (1 - l_discount)) AS total_discounted_price, AVG(l_quantity) AS avg_quantity_ordered FROM region JOIN nation ON n_regionkey = r_regionkey JOIN partsupp ON ps_suppkey = n_nationkey JOIN lineitem ON l_partkey = ps_partkey AND l_suppkey = ps_suppkey WHERE r_comment LIKE '%final%' AND l_shipdate BETWEEN '2022-01-01' AND '2022-12-31' GROUP BY region, nation ORDER BY total_discounted_price DESC LIMIT 10;
SELECT n.n_name AS nation_name, c.c_mktsegment AS market_segment, COUNT(c.c_custkey) AS total_customers, SUM(c.c_acctbal) AS total_account_balance, AVG(c.c_acctbal) AS average_account_balance FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey GROUP BY n.n_name, c.c_mktsegment ORDER BY n.n_name, c.c_mktsegment;
SELECT s.s_name, r.r_name AS region_name, SUM(li.l_extendedprice * (1 - li.l_discount)) AS total_revenue, AVG(ps.ps_supplycost) AS avg_supply_cost, COUNT(*) AS total_lineitem_count FROM supplier AS s JOIN region AS r ON s.s_nationkey = r.r_regionkey JOIN partsupp AS ps ON s.s_suppkey = ps.ps_suppkey JOIN part AS p ON ps.ps_partkey = p.p_partkey JOIN lineitem AS li ON p.p_partkey = li.l_partkey AND s.s_suppkey = li.l_suppkey WHERE r.r_name = 'EUROPE' AND p.p_size = 15 AND ps.ps_availqty > 5000 AND li.l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' GROUP BY s.s_name, r.r_name ORDER BY total_revenue DESC;
SELECT n.n_name, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue, AVG(l.l_quantity) AS average_quantity, AVG(s.s_acctbal) AS average_account_balance FROM nation n JOIN supplier s ON s.s_nationkey = n.n_nationkey JOIN partsupp ps ON ps.ps_suppkey = s.s_suppkey JOIN lineitem l ON l.l_suppkey = s.s_suppkey AND l.l_partkey = ps.ps_partkey WHERE n.n_regionkey IN (2, 3, 4) AND s.s_acctbal > -1000 AND l.l_shipdate BETWEEN '2022-01-01' AND '2022-12-31' GROUP BY n.n_name HAVING COUNT(DISTINCT s.s_suppkey) > 5 ORDER BY revenue DESC;
SELECT r_name AS region, n_name AS nation, COUNT(o_orderkey) AS total_orders, AVG(o_totalprice) AS avg_order_price, SUM(ps_availqty) AS total_available_parts, AVG(ps_supplycost) AS avg_part_supply_cost FROM orders JOIN nation ON o_custkey = n_nationkey JOIN region ON n_regionkey = r_regionkey JOIN supplier ON n_nationkey = s_nationkey JOIN partsupp ON s_suppkey = ps_suppkey GROUP BY r_name, n_name ORDER BY total_orders DESC, avg_order_price DESC LIMIT 10;
SELECT s.s_name AS supplier_name, n.n_name AS nation_name, COUNT(DISTINCT p.p_partkey) AS distinct_parts_count, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_discounted_revenue FROM supplier s JOIN nation n ON s.s_nationkey = n.n_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey JOIN part p ON l.l_partkey = p.p_partkey WHERE p.p_brand IN ('Brand#45', 'Brand#33', 'Brand#25') GROUP BY s.s_suppkey, s.s_name, n.n_name ORDER BY avg_discounted_revenue DESC, s.s_name;
SELECT p_brand, AVG(l_extendedprice * (1 - l_discount)) AS avg_sale_price, SUM(l_quantity) AS total_quantity_sold, COUNT(DISTINCT o_custkey) AS customer_count FROM part JOIN lineitem ON part.p_partkey = lineitem.l_partkey JOIN orders ON lineitem.l_orderkey = orders.o_orderkey JOIN customer ON orders.o_custkey = customer.c_custkey WHERE orders.o_orderstatus = 'F' AND lineitem.l_shipdate >= date '2023-01-01' AND lineitem.l_shipdate < date '2023-01-01' + interval '1' YEAR GROUP BY p_brand ORDER BY avg_sale_price DESC, total_quantity_sold DESC;
SELECT s.s_name AS supplier_name, r.r_name AS region_name, COUNT(DISTINCT ps.ps_partkey) AS total_parts_provided, AVG(l.l_extendedprice / l.l_quantity) AS avg_purchase_size, SUM(l.l_quantity) AS total_quantity_purchased, SUM(l.l_extendedprice) AS total_purchase_value FROM supplier s JOIN region r ON s.s_nationkey = r.r_regionkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN lineitem l ON ps.ps_suppkey = l.l_suppkey AND ps.ps_partkey = l.l_partkey JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE o.o_orderdate >= '1995-01-01' AND o.o_orderdate < '1996-01-01' GROUP BY s.s_name, r.r_name ORDER BY total_purchase_value DESC, supplier_name;
SELECT n.n_name AS nation, COUNT(DISTINCT o.o_orderkey) AS num_of_orders, COUNT(DISTINCT l.l_orderkey) AS num_of_lineitems, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_quantity) AS avg_quantity, AVG(l.l_extendedprice) AS avg_price, AVG(l.l_discount) AS avg_discount, MAX(l.l_extendedprice) AS max_price, MIN(l.l_extendedprice) AS min_price FROM nation n JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE n.n_name IN ('ETHIOPIA', 'ROMANIA') AND o.o_clerk IN ('Clerk#000008851', 'Clerk#000013378', 'Clerk#000001659', 'Clerk#000003983') GROUP BY n.n_name ORDER BY total_revenue DESC;
