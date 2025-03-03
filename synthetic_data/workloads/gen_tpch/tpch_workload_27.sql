SELECT r.r_name AS region, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(l.l_extendedprice) AS total_sales, AVG(l.l_discount) AS average_discount, AVG(l.l_tax) AS average_tax FROM region r JOIN nation n ON r.r_regionkey = n.n_nationkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN lineitem l ON s.s_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE o.o_orderstatus = 'F' AND l.l_shipdate BETWEEN DATE '2022-01-01' AND DATE '2022-12-31' GROUP BY r.r_name ORDER BY total_sales DESC;
SELECT r_name AS region, n_name AS nation, COUNT(o_orderkey) AS total_orders, SUM(o_totalprice) AS total_revenue, AVG(o_totalprice) AS average_order_value, MAX(o_totalprice) AS max_order_value, MIN(o_totalprice) AS min_order_value FROM region JOIN nation ON n_regionkey = r_regionkey JOIN orders ON o_custkey = n_nationkey WHERE o_orderstatus = 'F' AND o_shippriority = 0 AND o_orderdate BETWEEN '1995-01-01' AND '1995-12-31' GROUP BY r_name, n_name ORDER BY total_revenue DESC, region, nation;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(l.l_quantity) AS total_quantity_ordered, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_discounted_price, SUM(p.p_retailprice * l.l_quantity) AS total_retail_price, COUNT(DISTINCT o.o_orderkey) AS number_of_orders FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey JOIN customer c ON o.o_custkey = c.c_custkey AND n.n_nationkey = c.c_nationkey GROUP BY region, nation ORDER BY total_quantity_ordered DESC, avg_discounted_price DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS total_suppliers, COUNT(DISTINCT c_custkey) AS total_customers, AVG(s_acctbal) AS avg_supplier_acctbal, AVG(c_acctbal) AS avg_customer_acctbal, SUM(l_extendedprice * (1 - l_discount)) AS revenue, AVG(l_quantity) AS avg_lineitem_quantity FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN orders ON o_custkey = c_custkey JOIN lineitem ON l_orderkey = o_orderkey JOIN partsupp ON ps_suppkey = s_suppkey AND ps_partkey = l_partkey WHERE r_name IN ('EUROPE', 'AMERICA') AND o_orderdate BETWEEN date '1995-01-01' AND date '1995-12-31' AND l_shipdate > o_orderdate GROUP BY r_name, n_name ORDER BY revenue DESC, region, nation;
SELECT nation.n_name AS supplier_nation, COUNT(DISTINCT supplier.s_suppkey) AS number_of_suppliers, SUM(lineitem.l_quantity) AS total_quantity, AVG(lineitem.l_extendedprice) AS average_price, SUM(lineitem.l_extendedprice * (1 - lineitem.l_discount)) AS total_revenue_after_discount FROM supplier JOIN nation ON supplier.s_nationkey = nation.n_nationkey JOIN lineitem ON supplier.s_suppkey = lineitem.l_suppkey WHERE nation.n_name IN ('CHINA', 'VIETNAM', 'INDONESIA', 'GERMANY', 'SAUDI ARABIA', 'ARGENTINA') AND lineitem.l_linestatus IN ('F', 'O') AND lineitem.l_linenumber IN (5, 3) AND supplier.s_comment IN ( 's nag. slyly pending accounts', 'gular packages. ironic requ', 'ingly bold foxes are quickly regular t', 'l packages boost always slyly', 'otes are quickly final fo', 'ress final theodolites. blithely final pack' ) AND lineitem.l_shipdate BETWEEN '1995-01-01' AND '1996-12-31' GROUP BY supplier_nation ORDER BY total_revenue_after_discount DESC, supplier_nation;
SELECT n.n_name AS Nation, c.c_mktsegment AS MarketSegment, COUNT(DISTINCT c.c_custkey) AS NumberOfCustomers, SUM(l.l_quantity) AS TotalQuantityPurchased, AVG(l.l_extendedprice * (1 - l.l_discount)) AS AvgPurchaseSizeAfterDiscount, SUM(l.l_extendedprice * (1 - l.l_discount)) AS TotalValueAfterDiscount FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN lineitem l ON c.c_custkey = l.l_orderkey JOIN partsupp ps ON l.l_partkey = ps.ps_partkey AND l.l_suppkey = ps.ps_suppkey WHERE c.c_acctbal > 0 AND l.l_discount BETWEEN 0.01 AND 0.09 AND l.l_tax BETWEEN 0.01 AND 0.07 AND ps.ps_availqty IN (1315, 850, 8293, 6212, 2536) GROUP BY Nation, MarketSegment ORDER BY TotalValueAfterDiscount DESC, NumberOfCustomers DESC;
SELECT r.r_name AS region, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice) AS average_price, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue, AVG(l.l_discount) AS average_discount FROM region r JOIN supplier s ON s.s_nationkey = r.r_regionkey JOIN lineitem l ON l.l_suppkey = s.s_suppkey JOIN orders o ON o.o_orderkey = l.l_orderkey WHERE r.r_regionkey IN (1, 4, 0, 2, 3) AND (s.s_phone = '16-774-964-3208' OR s.s_phone = '32-729-386-1256' OR s.s_phone = '28-846-303-1561') AND (l.l_shipinstruct = 'COLLECT COD' OR l.l_shipinstruct = 'TAKE BACK RETURN') AND o.o_orderstatus IN ('F', 'O', 'P') GROUP BY region, order_year ORDER BY revenue DESC, region, order_year;
SELECT r.r_name AS region, c.c_mktsegment AS market_segment, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(l_extendedprice) AS total_sales, AVG(l_quantity) AS average_quantity_sold, SUM(l_extendedprice * (1 - l_discount)) AS revenue_after_discount FROM customer c JOIN region r ON c.c_nationkey = r.r_regionkey JOIN lineitem l ON l_suppkey IN ( SELECT s_suppkey FROM supplier s WHERE s.s_nationkey = c.c_nationkey ) WHERE c.c_mktsegment IN ('HOUSEHOLD', 'AUTOMOBILE', 'BUILDING', 'MACHINERY', 'FURNITURE') AND l.l_shipdate BETWEEN date '2022-01-01' AND date '2022-12-31' GROUP BY r.r_name, c.c_mktsegment ORDER BY total_sales DESC;
SELECT n.n_name AS nation_name, COUNT(o.o_orderkey) AS total_orders, SUM(o.o_totalprice) AS total_revenue, AVG(ps.ps_supplycost) AS average_supply_cost, SUM(ps.ps_availqty) AS total_parts_available FROM orders o JOIN nation n ON o.o_custkey = n.n_nationkey JOIN partsupp ps ON o.o_orderkey = ps.ps_partkey JOIN part p ON ps.ps_partkey = p.p_partkey WHERE o.o_orderstatus = 'O' AND o.o_shippriority = 0 AND p.p_size BETWEEN 1 AND 50 GROUP BY n.n_name HAVING SUM(o.o_totalprice) > 100000 ORDER BY total_revenue DESC, nation_name;
SELECT c_mktsegment, r_name AS region, SUM(l_extendedprice * (1 - l_discount)) AS revenue, AVG(l_quantity) AS average_quantity, COUNT(DISTINCT o_orderkey) AS total_orders, COUNT(DISTINCT s_suppkey) AS unique_suppliers FROM customer JOIN orders ON c_custkey = o_custkey JOIN lineitem ON o_orderkey = l_orderkey JOIN supplier ON s_suppkey = l_suppkey JOIN partsupp ON ps_suppkey = s_suppkey AND ps_partkey = l_partkey JOIN region ON r_regionkey = s_nationkey WHERE l_shipdate BETWEEN '2022-01-01' AND '2022-12-31' AND l_returnflag = 'N' AND o_orderstatus = 'F' GROUP BY c_mktsegment, r_name ORDER BY revenue DESC, c_mktsegment, r_name;
SELECT c_mktsegment, avg(c_acctbal) AS avg_customer_balance, sum(l_extendedprice) AS total_sales, sum(l_extendedprice * (1 - l_discount)) AS total_revenue_after_discount, sum(l_quantity) AS total_quantity_sold, count(DISTINCT c_custkey) AS number_of_customers, count(DISTINCT o_orderkey) AS number_of_orders FROM customer JOIN orders ON c_custkey = o_custkey JOIN lineitem ON o_orderkey = l_orderkey WHERE c_phone IN ('20-575-839-6001', '29-715-109-4065', '24-296-834-6966', '17-307-523-6875', '32-719-964-8079') AND c_mktsegment IN ('AUTOMOBILE', 'MACHINERY', 'HOUSEHOLD', 'BUILDING') AND l_shipdate > o_orderdate GROUP BY c_mktsegment ORDER BY total_revenue_after_discount DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, SUM(ps_availqty) AS total_available_quantity, AVG(s_acctbal) AS avg_supplier_acctbal, AVG(c_acctbal) AS avg_customer_acctbal, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(l_quantity) AS avg_quantity_sold FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN partsupp ON s_suppkey = ps_suppkey JOIN lineitem ON l_suppkey = s_suppkey AND l_partkey = ps_partkey WHERE r_regionkey IN (1, 2, 4) AND ps_suppkey IN ('121031', '120304') AND s_address IN ('s,fan,VoI4tUAGGH1gI4bgEb794k', '90qRn8EpBglfWnkjVP5', 'srXPQd19EypYn,xGNUH9PaDXJqSHo', 'QkfYlLgz351M,w', '69rnn0LIo8CqkmiPmkbzgOKeMtgWFnXssK9', 'zUH7haRVvYGOxm9NI48Wvrie5') AND (l_shipmode IN ('AIR', 'AIR REG') AND l_shipinstruct = 'DELIVER IN PERSON') GROUP BY region, nation ORDER BY total_revenue DESC;
SELECT r_name, p_type, COUNT(DISTINCT c_custkey) AS num_customers, SUM(l_extendedprice) AS total_sales, AVG(l_quantity) AS avg_quantity_sold, AVG(l_extendedprice * (1 - l_discount)) AS avg_discounted_price FROM region JOIN customer ON c_nationkey = r_regionkey JOIN lineitem ON l_suppkey = c_custkey JOIN part ON p_partkey = l_partkey WHERE r_name IN ('EUROPE', 'AMERICA', 'AFRICA') AND p_type IN ('LARGE ANODIZED NICKEL', 'ECONOMY BRUSHED STEEL', 'MEDIUM PLATED BRASS', 'ECONOMY ANODIZED NICKEL', 'STANDARD BURNISHED COPPER') AND l_linestatus IN ('F', 'O') GROUP BY r_name, p_type ORDER BY r_name, total_sales DESC;
SELECT r.r_name AS region_name, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales, AVG(l.l_discount) AS average_discount FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN orders o ON o.o_custkey = n.n_nationkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN part p ON l.l_partkey = p.p_partkey WHERE p.p_retailprice > 1300.00 AND EXTRACT(YEAR FROM o.o_orderdate) = 2023 GROUP BY r.r_name ORDER BY total_sales DESC;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS number_of_customers, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, AVG(c.c_acctbal) AS average_customer_acctbal, AVG(s.s_acctbal) AS average_supplier_acctbal, SUM(p.p_retailprice) AS total_retail_price FROM region r INNER JOIN nation n ON r.r_regionkey = n.n_regionkey INNER JOIN customer c ON n.n_nationkey = c.c_nationkey INNER JOIN supplier s ON n.n_nationkey = s.s_nationkey INNER JOIN part p ON p.p_size BETWEEN 30 AND 50 WHERE n.n_nationkey IN (3, 24, 17, 14, 22) AND c.c_acctbal > 2500 AND s.s_phone LIKE '25-%' GROUP BY r.r_name, n.n_name ORDER BY total_retail_price DESC, average_customer_acctbal DESC LIMIT 10;
SELECT r.r_name AS region, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, AVG(s.s_acctbal) AS average_account_balance, SUM(ps.ps_availqty) AS total_available_quantity, AVG(ps.ps_supplycost) AS average_supply_cost, COUNT(DISTINCT l.l_orderkey) AS total_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, SUM(CASE WHEN l.l_returnflag = 'F' THEN l.l_quantity ELSE 0 END) AS total_finalized_quantity, SUM(CASE WHEN l.l_returnflag = 'O' THEN l.l_quantity ELSE 0 END) AS total_open_quantity FROM region r JOIN supplier s ON r.r_regionkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey WHERE s.s_acctbal > 0 AND l.l_linestatus IN ('F', 'O') AND l.l_shipdate >= '2022-01-01' AND l.l_shipdate < '2023-01-01' GROUP BY r.r_name ORDER BY total_revenue DESC;
SELECT n.n_name AS nation_name, n.n_regionkey AS region_key, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(l.l_quantity) AS average_quantity, SUM(CASE WHEN p.p_type LIKE 'PROMO%' THEN 1 ELSE 0 END) AS promo_parts_count FROM nation n JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN part p ON l.l_partkey = p.p_partkey WHERE n.n_name IN ('UNITED STATES', 'ETHIOPIA', 'KENYA', 'IRAN') AND o.o_orderdate >= '1993-01-01' AND o.o_orderdate < '1998-01-01' AND l.l_linestatus IN ('F', 'O') AND l.l_tax = 0.03 AND p.p_container IN ('LG DRUM', 'SM JAR') GROUP BY nation_name, region_key, order_year ORDER BY total_revenue DESC, total_orders DESC, nation_name, order_year LIMIT 100;
SELECT r_name AS region, n_name AS nation, p_brand, MAX(p_retailprice) AS max_retail_price, MIN(p_retailprice) AS min_retail_price, AVG(l_quantity) AS avg_quantity_sold, SUM(l_extendedprice * (1 - l_discount)) AS total_sales, COUNT(DISTINCT l_orderkey) AS number_of_orders FROM lineitem JOIN part ON lineitem.l_partkey = part.p_partkey JOIN nation ON nation.n_nationkey = ( SELECT n_nationkey FROM nation n2 WHERE n2.n_regionkey = part.p_partkey LIMIT 1 ) JOIN region ON nation.n_regionkey = region.r_regionkey GROUP BY region, nation, p_brand ORDER BY total_sales DESC;
SELECT r.r_name AS region, AVG(c.c_acctbal) AS average_customer_balance, SUM(s.s_acctbal) AS total_supplier_balance, COUNT(DISTINCT p.p_partkey) AS number_of_unique_parts, SUM(ps.ps_availqty) AS total_available_quantity, AVG(ps.ps_supplycost) AS average_supply_cost FROM region r JOIN supplier s ON s.s_nationkey = r.r_regionkey JOIN customer c ON c.c_nationkey = r.r_regionkey JOIN partsupp ps ON ps.ps_suppkey = s.s_suppkey JOIN part p ON p.p_partkey = ps.ps_partkey WHERE p.p_size IN (40, 21, 11, 6, 48, 37) AND p.p_retailprice BETWEEN 100 AND 1000 AND c.c_name <> 'Customer#000024855' AND ps.ps_supplycost < 356.43 GROUP BY r.r_name ORDER BY total_supplier_balance DESC, average_customer_balance DESC LIMIT 5;
