SELECT r.r_name AS region, p.p_brand AS brand, COUNT(DISTINCT l_orderkey) AS total_orders, SUM(l_extendedprice * (1 - l_discount)) AS revenue, AVG(l_quantity) AS average_quantity, AVG(l_extendedprice) AS average_price, AVG(l_discount) AS average_discount FROM region r JOIN lineitem l ON r.r_regionkey = CAST(SUBSTRING(l.l_comment FROM 1 FOR 1) AS integer) JOIN part p ON l.l_partkey = p.p_partkey WHERE l.l_shipdate BETWEEN '2020-01-01' AND '2020-12-31' AND l.l_discount BETWEEN 0.05 AND 0.10 AND l.l_linestatus = 'O' GROUP BY r.r_name, p.p_brand ORDER BY revenue DESC, total_orders DESC LIMIT 5;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT c_custkey) AS number_of_customers, AVG(c_acctbal) AS average_account_balance, SUM(l_extendedprice * (1 - l_discount)) AS revenue, AVG(l_quantity) AS average_quantity_sold FROM region JOIN nation ON r_regionkey = n_regionkey JOIN customer ON n_nationkey = c_nationkey JOIN orders ON c_custkey = o_custkey JOIN lineitem ON o_orderkey = l_orderkey JOIN part ON l_partkey = p_partkey WHERE n_name IN ('CANADA', 'UNITED KINGDOM', 'PERU', 'IRAN') AND r_comment LIKE 'ges. thinly even pinto beans ca%' AND c_nationkey IN (2, 12, 8) AND p_size IN (43, 45, 28) AND p_brand NOT IN ('Brand#32', 'Brand#45') AND l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' GROUP BY region, nation ORDER BY revenue DESC, region, nation;
SELECT n.n_name AS nation, COUNT(o.o_orderkey) AS total_orders, AVG(o.o_totalprice) AS avg_order_value, SUM(c.c_acctbal) AS total_customer_balance, COUNT(DISTINCT c.c_custkey) AS num_customers FROM nation n JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey WHERE n.n_regionkey IN (3, 2, 0) AND o.o_orderstatus = 'F' GROUP BY n.n_name ORDER BY total_orders DESC, avg_order_value DESC;
SELECT r_name AS region, p_type AS part_type, COUNT(DISTINCT s_suppkey) AS total_suppliers, COUNT(DISTINCT c_custkey) AS total_customers, SUM(l_extendedprice) AS sales_value, AVG(l_quantity) AS average_quantity, SUM(l_quantity * l_discount) AS total_discount_amount FROM region JOIN supplier ON s_nationkey = r_regionkey JOIN partsupp ON ps_suppkey = s_suppkey JOIN part ON ps_partkey = p_partkey JOIN lineitem ON l_partkey = p_partkey AND l_suppkey = s_suppkey JOIN orders ON o_orderkey = l_orderkey JOIN customer ON c_custkey = o_custkey AND c_nationkey = r_regionkey WHERE r_name IN ('EUROPE', 'AMERICA') AND p_type = 'SMALL BURNISHED STEEL' AND p_size IN (13, 16, 37) AND o_orderdate BETWEEN '2021-01-01' AND '2021-12-31' AND o_orderpriority IN ('1-URGENT', '3-MEDIUM') GROUP BY r_name, p_type ORDER BY sales_value DESC;
SELECT r.r_name AS region, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, AVG(s.s_acctbal) AS average_account_balance, SUM(ps.ps_availqty) AS total_available_quantity, AVG(ps.ps_supplycost) AS average_supply_cost, COUNT(DISTINCT l.l_orderkey) AS total_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, SUM(CASE WHEN l.l_returnflag = 'F' THEN l.l_quantity ELSE 0 END) AS total_finalized_quantity, SUM(CASE WHEN l.l_returnflag = 'O' THEN l.l_quantity ELSE 0 END) AS total_open_quantity FROM region r JOIN supplier s ON r.r_regionkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey WHERE s.s_acctbal > 0 AND l.l_linestatus IN ('F', 'O') AND l.l_shipdate >= '2022-01-01' AND l.l_shipdate < '2023-01-01' GROUP BY r.r_name ORDER BY total_revenue DESC;
SELECT r.r_name AS region_name, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, SUM(ps.ps_availqty) AS total_available_quantity, AVG(ps.ps_supplycost) AS average_supply_cost, SUM(l.l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(l.l_quantity) AS average_quantity_ordered FROM region r JOIN supplier s ON r.r_regionkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey GROUP BY r.r_name ORDER BY total_revenue DESC;
SELECT r_name AS region, n_name AS nation, p_brand, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c_custkey) AS number_of_customers, SUM(l_quantity) AS total_quantity_sold, AVG(l_extendedprice * (1 - l_discount)) AS avg_discounted_price, SUM(l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity) AS total_profit FROM region JOIN nation ON n_regionkey = r_regionkey JOIN supplier ON s_nationkey = n_nationkey JOIN customer ON c_nationkey = n_nationkey JOIN partsupp ON ps_suppkey = s_suppkey JOIN part ON p_partkey = ps_partkey JOIN lineitem ON l_partkey = p_partkey AND l_suppkey = s_suppkey WHERE r_regionkey = 4 AND p_brand IN ('Brand#21', 'Brand#44', 'Brand#43', 'Brand#22', 'Brand#13', 'Brand#33') AND (partsupp.ps_comment LIKE '%furiously%' OR partsupp.ps_comment LIKE '%special deposits%') AND (supplier.s_comment LIKE '%s? ironic accounts%' OR supplier.s_comment LIKE '%ts after the slyly%') GROUP BY region, nation, p_brand ORDER BY total_profit DESC, number_of_customers DESC;
SELECT r.r_name AS region, avg(c.c_acctbal) AS avg_customer_acct_balance, avg(s.s_acctbal) AS avg_supplier_acct_balance, count(DISTINCT o.o_orderkey) AS total_orders, avg(o.o_totalprice) AS avg_order_total_price FROM region r INNER JOIN customer c ON c.c_nationkey = r.r_regionkey INNER JOIN supplier s ON s.s_nationkey = r.r_regionkey INNER JOIN orders o ON o.o_custkey = c.c_custkey INNER JOIN lineitem l ON l.l_orderkey = o.o_orderkey INNER JOIN part p ON p.p_partkey = l.l_partkey AND p.p_size = 17 GROUP BY r.r_name ORDER BY avg_customer_acct_balance DESC, avg_supplier_acct_balance DESC;
SELECT n.n_name AS nation, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales, AVG(s.s_acctbal) AS avg_supplier_balance, SUM(ps.ps_availqty) AS total_available_quantity FROM nation n INNER JOIN supplier s ON n.n_nationkey = s.s_nationkey INNER JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey INNER JOIN lineitem l ON ps.ps_suppkey = l.l_suppkey AND ps.ps_partkey = l.l_partkey INNER JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE n.n_nationkey IN (12, 9, 11, 15) AND l.l_suppkey IN (128236, 197502, 170405, 85908) GROUP BY nation, order_year ORDER BY nation, order_year DESC;
SELECT n.n_name AS nation_name, p.p_type AS part_type, AVG(ps.ps_supplycost) AS avg_supply_cost, SUM(ps.ps_availqty) AS total_availability, COUNT(DISTINCT p.p_partkey) AS unique_parts_count FROM nation n JOIN partsupp ps ON n.n_nationkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey WHERE ps.ps_availqty > 3000 AND p.p_size BETWEEN 30 AND 50 GROUP BY nation_name, part_type ORDER BY avg_supply_cost DESC, total_availability DESC LIMIT 10;
SELECT n_name AS nation, p_type AS part_type, AVG(l_quantity) AS average_quantity, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue, COUNT(DISTINCT o_orderkey) AS total_orders FROM nation JOIN customer ON n_nationkey = c_nationkey JOIN orders ON c_custkey = o_custkey JOIN lineitem ON o_orderkey = l_orderkey JOIN part ON l_partkey = p_partkey JOIN partsupp ON p_partkey = ps_partkey AND l_suppkey = ps_suppkey JOIN supplier ON s_suppkey = l_suppkey WHERE p_size IN (30, 22, 19) AND s_acctbal BETWEEN 5000 AND 10000 AND o_orderdate BETWEEN '1995-01-01' AND '1995-12-31' AND l_shipmode IN ('AIR', 'RAIL') GROUP BY nation, part_type ORDER BY total_revenue DESC, nation, part_type;
SELECT s.s_name, r.r_name AS region, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(li.l_extendedprice) AS total_sales, AVG(li.l_quantity) AS avg_quantity_sold, SUM(li.l_extendedprice * (1 - li.l_discount)) AS revenue_after_discount, SUM(CASE WHEN li.l_shipmode = 'MAIL' THEN l_quantity ELSE 0 END) AS quantity_shipped_by_mail, SUM(CASE WHEN li.l_returnflag = 'R' THEN 1 ELSE 0 END) AS total_returns FROM supplier s JOIN customer c ON s.s_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem li ON o.o_orderkey = li.l_orderkey JOIN part p ON li.l_partkey = p.p_partkey JOIN region r ON s.s_nationkey = r.r_regionkey WHERE li.l_shipmode IN ('FOB', 'MAIL', 'TRUCK') AND o.o_orderstatus IN ('F', 'O', 'P') AND li.l_tax IN (0.02, 0.07) AND p.p_type IN ('STANDARD ANODIZED COPPER', 'SMALL BRUSHED NICKEL', 'PROMO ANODIZED TIN', 'SMALL PLATED TIN') AND p.p_partkey IN (718, 4647, 4547, 3249, 4189) GROUP BY s.s_name, region ORDER BY total_sales DESC LIMIT 10;
SELECT r.r_name AS region_name, n.n_name AS nation_name, COUNT(s.s_suppkey) AS number_of_suppliers, AVG(s.s_acctbal) AS average_account_balance, SUM(p.ps_availqty) AS total_available_quantity, AVG(p.ps_supplycost) AS average_supply_cost FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp p ON s.s_suppkey = p.ps_suppkey GROUP BY r.r_name, n.n_name ORDER BY r.r_name, n.n_name;
SELECT r_name, COUNT(DISTINCT o_orderkey) AS total_orders, SUM(l_quantity) AS total_quantity, AVG(l_extendedprice) AS avg_price, SUM(l_extendedprice * (1 - l_discount) * (1 + l_tax)) AS total_revenue FROM region JOIN orders ON r_regionkey = o_orderkey % 5 JOIN lineitem ON o_orderkey = l_orderkey WHERE r_regionkey IN (1, 4, 0, 2, 3) AND l_shipdate BETWEEN '1995-01-01' AND '1996-12-31' AND o_orderstatus = 'F' GROUP BY r_name ORDER BY total_revenue DESC;
SELECT n.n_name AS nation, p.p_type AS part_type, AVG(ps.ps_supplycost) AS avg_supply_cost, SUM(l.l_quantity) AS total_quantity, SUM(l.l_extendedprice * (1 - l_discount)) AS total_revenue, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers FROM nation n JOIN supplier s ON s.s_nationkey = n.n_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey WHERE s.s_name IN ('Supplier#000022340', 'Supplier#000018268', 'Supplier#000019413') AND l.l_shipdate BETWEEN DATE '2022-01-01' AND DATE '2022-12-31' GROUP BY nation, part_type ORDER BY total_revenue DESC, avg_supply_cost ASC;
