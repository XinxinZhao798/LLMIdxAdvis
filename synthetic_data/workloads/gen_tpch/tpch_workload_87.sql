SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, SUM(l_extendedprice * (1 - l_discount)) AS total_sales, AVG(l_quantity) AS avg_quantity_sold, AVG(p_retailprice) AS avg_part_retail_price FROM region JOIN nation ON r_regionkey = n_regionkey JOIN supplier ON n_nationkey = s_nationkey JOIN customer ON n_nationkey = c_nationkey JOIN orders ON c_custkey = o_custkey JOIN lineitem ON o_orderkey = l_orderkey JOIN part ON l_partkey = p_partkey JOIN partsupp ON p_partkey = ps_partkey AND s_suppkey = ps_suppkey WHERE n_name IN ('JAPAN', 'PERU', 'KENYA', 'CHINA', 'FRANCE', 'UNITED KINGDOM') AND l_shipdate BETWEEN '2022-01-01' AND '2022-12-31' GROUP BY r_name, n_name ORDER BY total_sales DESC;
SELECT n.n_name AS nation_name, c.c_mktsegment AS market_segment, COUNT(o.o_orderkey) AS total_orders, SUM(o.o_totalprice) AS total_sales_volume, AVG(o.o_totalprice) AS average_order_value FROM orders o JOIN customer c ON o.o_custkey = c.c_custkey JOIN nation n ON c.c_nationkey = n.n_nationkey WHERE o.o_orderstatus = 'F' GROUP BY nation_name, market_segment ORDER BY total_sales_volume DESC, nation_name, market_segment;
SELECT n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(o.o_totalprice) AS total_sales, AVG(c.c_acctbal) AS average_account_balance FROM nation n JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN region r ON n.n_regionkey = r.r_regionkey WHERE r.r_name = 'ASIA' AND o.o_totalprice > (SELECT AVG(o2.o_totalprice) FROM orders o2) GROUP BY n.n_name ORDER BY total_sales DESC, average_account_balance DESC;
SELECT s.s_name, s.s_address, COUNT(o.o_orderkey) AS total_orders, AVG(o.o_totalprice) AS average_order_value, SUM(p.p_retailprice) AS total_retail_price_of_ordered_parts FROM supplier s JOIN orders o ON s.s_suppkey = o.o_custkey AND o.o_orderdate = '1996-05-30' JOIN part p ON p.p_type IN ('PROMO PLATED NICKEL', 'MEDIUM PLATED NICKEL', 'ECONOMY POLISHED BRASS') GROUP BY s.s_name, s.s_address ORDER BY total_orders DESC, average_order_value DESC LIMIT 10;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c.c_custkey) AS number_of_customers, AVG(s.s_acctbal) AS average_supplier_account_balance, AVG(c.c_acctbal) AS average_customer_account_balance, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales_value, AVG(l.l_quantity) AS average_quantity_sold FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey WHERE r.r_regionkey IN (1, 4, 0, 2, 3) AND c.c_mktsegment IN ('MACHINERY', 'BUILDING', 'AUTOMOBILE', 'FURNITURE') AND l.l_shipdate BETWEEN '2020-01-01' AND '2020-12-31' GROUP BY r.r_name, n.n_name ORDER BY total_sales_value DESC, region, nation;
SELECT n.n_name AS nation, AVG(c.c_acctbal) AS avg_customer_acctbal, AVG(s.s_acctbal) AS avg_supplier_acctbal, COUNT(DISTINCT o.o_orderkey) AS total_orders, COUNT(DISTINCT c.c_custkey) AS total_customers, COUNT(DISTINCT s.s_suppkey) AS total_suppliers FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN supplier s ON l.l_suppkey = s.s_suppkey JOIN nation n ON c.c_nationkey = n.n_nationkey AND s.s_nationkey = n.n_nationkey WHERE c.c_mktsegment = 'MACHINERY' GROUP BY n.n_name ORDER BY avg_customer_acctbal DESC, avg_supplier_acctbal DESC;
SELECT r.r_name AS region, c.c_mktsegment AS market_segment, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(c.c_acctbal) AS total_balance, AVG(c.c_acctbal) AS average_balance, SUM(ps.ps_availqty) AS total_available_parts, AVG(ps.ps_supplycost) AS average_supply_cost, COUNT(DISTINCT ps.ps_partkey) AS number_of_parts FROM region r JOIN customer c ON r.r_regionkey = c.c_nationkey JOIN partsupp ps ON c.c_custkey = ps.ps_suppkey WHERE r.r_name IN ('MIDDLE EAST', 'AFRICA', 'AMERICA', 'EUROPE') AND ps.ps_availqty > 1000 GROUP BY r.r_name, c.c_mktsegment ORDER BY total_balance DESC, average_supply_cost ASC;
SELECT r_name AS region, c_mktsegment AS market_segment, COUNT(DISTINCT o_orderkey) AS num_orders, SUM(l_quantity) AS total_quantity, AVG(l_extendedprice) AS avg_price, SUM(l_extendedprice * (1 - l_discount)) AS revenue FROM region JOIN supplier ON s_nationkey = r_regionkey JOIN partsupp ON ps_suppkey = s_suppkey JOIN lineitem ON l_suppkey = s_suppkey AND l_partkey = ps_partkey JOIN orders ON o_orderkey = l_orderkey JOIN customer ON c_custkey = o_custkey AND c_nationkey = s_nationkey WHERE c_acctbal > 8117.27 AND c_nationkey IN (20, 0) GROUP BY r_name, c_mktsegment ORDER BY revenue DESC, avg_price DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, SUM(l_extendedprice) AS total_sales, AVG(l_extendedprice * (1 - l_discount)) AS avg_discounted_sales, SUM(ps_supplycost * l_quantity) AS total_supply_cost, (SUM(l_extendedprice * (1 - l_discount)) - SUM(ps_supplycost * l_quantity)) AS total_profit FROM region JOIN nation ON region.r_regionkey = nation.n_regionkey JOIN supplier ON nation.n_nationkey = supplier.s_nationkey JOIN customer ON nation.n_nationkey = customer.c_nationkey JOIN orders ON customer.c_custkey = orders.o_custkey JOIN lineitem ON orders.o_orderkey = lineitem.l_orderkey JOIN partsupp ON lineitem.l_partkey = partsupp.ps_partkey AND lineitem.l_suppkey = partsupp.ps_suppkey WHERE customer.c_custkey IN (1899, 3404, 3033) AND customer.c_nationkey IN (11, 21, 23, 4, 10) GROUP BY region, nation ORDER BY total_profit DESC;
SELECT r.r_name AS region_name, n.n_name AS nation_name, p.p_type AS part_type, COUNT(o.o_orderkey) AS total_orders, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice) AS average_price, SUM(l.l_extendedprice * (1 - l_discount)) AS total_discounted_price, MAX(o.o_totalprice) AS max_order_totalprice FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN orders o ON o.o_orderdate >= DATE '2020-01-01' AND o.o_orderdate <= DATE '2020-12-31' JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN part p ON l.l_partkey = p.p_partkey WHERE p.p_container IN ('SM BOX', 'WRAP CASE', 'WRAP BAG') AND l.l_shipmode IN ('AIR', 'RAIL', 'TRUCK') AND o.o_shippriority = 0 AND r.r_comment LIKE '%final%' GROUP BY region_name, nation_name, part_type ORDER BY total_orders DESC, total_quantity DESC, average_price DESC LIMIT 10;
SELECT s.s_suppkey AS supplier_key, s.s_name AS supplier_name, COUNT(DISTINCT o.o_orderkey) AS total_orders, AVG(l.l_discount) AS average_discount, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue FROM supplier s JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN lineitem l ON ps.ps_suppkey = l.l_suppkey AND ps.ps_partkey = l.l_partkey JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE l.l_returnflag = 'N' AND l.l_shipinstruct = 'DELIVER IN PERSON' AND EXTRACT(YEAR FROM l.l_shipdate) = EXTRACT(YEAR FROM CURRENT_DATE) GROUP BY s.s_suppkey, s.s_name ORDER BY total_revenue DESC, supplier_name;
SELECT n.n_name AS nation_name, c.c_mktsegment AS customer_market_segment, COUNT(DISTINCT c.c_custkey) AS number_of_customers, AVG(c.c_acctbal) AS average_customer_account_balance, SUM(ps.ps_availqty) AS total_available_parts, AVG(ps.ps_supplycost) AS average_supply_cost FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN supplier s ON s.s_nationkey = n.n_nationkey JOIN partsupp ps ON ps.ps_suppkey = s.s_suppkey WHERE n.n_nationkey IN (13, 23) AND c.c_comment LIKE '%special pinto beans%' AND s.s_name IN ('Supplier#000021082', 'Supplier#000018658', 'Supplier#000020174') GROUP BY n.n_name, c.c_mktsegment ORDER BY average_customer_account_balance DESC;
SELECT r.r_name AS region_name, EXTRACT(YEAR FROM l.l_shipdate) AS year_shipped, COUNT(*) AS total_items_sold, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales, AVG(l.l_discount) AS average_discount FROM lineitem l JOIN supplier s ON l.l_suppkey = s.s_suppkey JOIN region r ON s.s_nationkey = r.r_regionkey GROUP BY r.r_name, EXTRACT(YEAR FROM l.l_shipdate) ORDER BY r.r_name, EXTRACT(YEAR FROM l.l_shipdate);
SELECT n.n_name AS nation_name, COUNT(s.s_suppkey) AS total_suppliers, AVG(s.s_acctbal) AS avg_account_balance, SUM(ps.ps_availqty) AS total_parts_quantity, AVG(ps.ps_supplycost) AS avg_supply_cost FROM nation n JOIN region r ON n.n_regionkey = r.r_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey WHERE r.r_name = 'EUROPE' GROUP BY n.n_name ORDER BY avg_account_balance DESC, total_suppliers DESC;
SELECT r_name AS region, n_name AS nation, p_brand, MAX(p_retailprice) AS max_retail_price, MIN(p_retailprice) AS min_retail_price, AVG(l_quantity) AS avg_quantity_sold, SUM(l_extendedprice * (1 - l_discount)) AS total_sales, COUNT(DISTINCT l_orderkey) AS number_of_orders FROM lineitem JOIN part ON lineitem.l_partkey = part.p_partkey JOIN nation ON nation.n_nationkey = ( SELECT n_nationkey FROM nation n2 WHERE n2.n_regionkey = part.p_partkey LIMIT 1 ) JOIN region ON nation.n_regionkey = region.r_regionkey GROUP BY region, nation, p_brand ORDER BY total_sales DESC;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS total_customers, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, SUM(o.o_totalprice) AS total_sales, AVG(c.c_acctbal) AS average_customer_balance, AVG(s.s_acctbal) AS average_supplier_balance, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(ps.ps_availqty) AS total_parts_available FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey WHERE r.r_name IN ('Europe', 'Asia') AND o.o_orderdate BETWEEN '2022-01-01' AND '2022-12-31' AND c.c_mktsegment = 'AUTOMOBILE' GROUP BY r.r_name, n.n_name ORDER BY total_sales DESC, region, nation;
SELECT r.r_name AS region_name, n.n_name AS nation_name, SUM(s.s_acctbal) AS total_balance, AVG(ps.ps_supplycost) AS avg_supply_cost, COUNT(DISTINCT s.s_suppkey) AS num_suppliers, SUM(l.l_quantity) AS total_quantity_ordered, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_discounted_price FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey WHERE r.r_name IN ('EUROPE', 'ASIA') AND l.l_returnflag = 'N' AND l.l_linestatus = 'O' AND l.l_shipdate >= date '1995-01-01' AND l.l_shipdate < date '1996-01-01' GROUP BY r.r_name, n.n_name ORDER BY region_name, total_balance DESC;
SELECT r.r_name AS region, n.n_name AS nation, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(o.o_totalprice) AS total_revenue, AVG(o.o_totalprice) AS average_order_value FROM orders o JOIN nation n ON o.o_custkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey GROUP BY region, nation, order_year ORDER BY region, nation, order_year;
