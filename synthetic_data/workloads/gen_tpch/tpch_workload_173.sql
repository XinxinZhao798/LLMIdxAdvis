SELECT n_name AS nation, COUNT(DISTINCT c_custkey) AS number_of_customers, COUNT(DISTINCT s_suppkey) AS number_of_suppliers, SUM(ps_availqty) AS total_available_quantity, AVG(l_extendedprice * (1 - l_discount)) AS avg_discounted_price, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue FROM nation JOIN supplier ON n_nationkey = s_nationkey JOIN partsupp ON s_suppkey = ps_suppkey JOIN lineitem ON ps_partkey = l_partkey AND ps_suppkey = l_suppkey JOIN orders ON l_orderkey = o_orderkey JOIN customer ON o_custkey = c_custkey AND n_nationkey = c_nationkey WHERE n_name = 'BRAZIL' AND c_acctbal > 0 AND l_shipdate BETWEEN date '1995-01-01' AND date '1996-12-31' GROUP BY n_name ORDER BY total_revenue DESC;
SELECT n.n_name AS nation_name, c.c_mktsegment AS market_segment, SUM(l.l_extendedprice) AS total_sales, AVG(l.l_extendedprice) AS average_sale, COUNT(DISTINCT o.o_orderkey) AS total_orders, AVG(l.l_discount) AS average_discount FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN part p ON l.l_partkey = p.p_partkey JOIN supplier s ON l.l_suppkey = s.s_suppkey JOIN nation n ON s.s_nationkey = n.n_nationkey WHERE p.p_mfgr = 'Manufacturer#1' GROUP BY n.n_name, c.c_mktsegment ORDER BY total_sales DESC;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(o.o_totalprice) AS total_sales, AVG(c.c_acctbal) AS average_customer_balance, AVG(s.s_acctbal) AS average_supplier_balance, COUNT(DISTINCT o.o_orderkey) AS number_of_orders FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey WHERE o.o_orderstatus = 'F' AND o.o_orderdate BETWEEN DATE '2022-01-01' AND DATE '2022-12-31' AND o.o_clerk IN ('Clerk#000000428', 'Clerk#000021706', 'Clerk#000006122') GROUP BY r.r_name, n.n_name ORDER BY total_sales DESC, region, nation;
SELECT n_name AS nation, AVG(c_acctbal) AS avg_customer_balance, SUM(s_acctbal) AS total_supplier_balance, COUNT(DISTINCT o_orderkey) AS total_orders, SUM(l_extendedprice * (1 - l_discount)) AS revenue, AVG(p_retailprice) AS avg_part_retail_price FROM nation JOIN supplier ON n_nationkey = s_nationkey JOIN customer ON n_nationkey = c_nationkey JOIN orders ON o_custkey = c_custkey JOIN lineitem ON l_orderkey = o_orderkey JOIN part ON l_partkey = p_partkey JOIN partsupp ON ps_partkey = l_partkey AND ps_suppkey = l_suppkey WHERE n_regionkey IN (1, 4, 0, 2, 3) AND n_nationkey IN (18, 7, 17, 13) AND s_acctbal > 0 AND p_brand IN ('Brand#24', 'Brand#44') AND ps_suppkey IN (60452, 180565, 120646, 376, 920, 61065) AND ps_availqty > 4500 AND l_shipdate BETWEEN '1994-01-01' AND '1995-01-01' GROUP BY nation ORDER BY revenue DESC, avg_customer_balance DESC;
SELECT n.n_name AS nation, COUNT(o.o_orderkey) AS total_orders, AVG(o.o_totalprice) AS avg_order_value, SUM(c.c_acctbal) AS total_customer_balance, COUNT(DISTINCT c.c_custkey) AS num_customers FROM nation n JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN orders o ON c.c_custkey = o.o_custkey WHERE n.n_regionkey IN (3, 2, 0) AND o.o_orderstatus = 'F' GROUP BY n.n_name ORDER BY total_orders DESC, avg_order_value DESC;
SELECT p.p_type, r.r_name, AVG(s.s_acctbal) AS average_supplier_acct_balance, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, AVG(p.p_retailprice) AS average_part_retail_price FROM part p JOIN supplier s ON s.s_nationkey = p.p_partkey JOIN region r ON r.r_regionkey = s.s_nationkey WHERE p.p_size > 15 AND r.r_name IN ('EUROPE', 'AMERICA') GROUP BY p.p_type, r.r_name ORDER BY average_supplier_acct_balance DESC, total_suppliers DESC;
SELECT r.r_name AS region_name, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, AVG(s.s_acctbal) AS average_account_balance, SUM(ps.ps_availqty) AS total_available_quantity, AVG(ps.ps_supplycost) AS average_supply_cost, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(o.o_totalprice) AS total_order_value, AVG(o.o_totalprice) AS average_order_value FROM region r JOIN supplier s ON r.r_regionkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey LEFT JOIN orders o ON s.s_nationkey = o.o_custkey GROUP BY r.r_name ORDER BY r.r_name;
SELECT n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS num_customers, AVG(c.c_acctbal) AS avg_account_balance, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, COUNT(l.l_orderkey) AS num_orders FROM nation n JOIN customer c ON c.c_nationkey = n.n_nationkey JOIN orders o ON o.o_custkey = c.c_custkey JOIN lineitem l ON l.l_orderkey = o.o_orderkey WHERE n.n_comment LIKE '%efully alongside of the slyly final dependencies.%' AND o.o_shippriority = 0 AND l.l_tax IN (0.02, 0.07, 0.05, 0.01) AND c.c_phone IN ('22-845-781-3450', '20-697-924-2662', '29-363-137-9479', '32-857-129-2892') GROUP BY nation ORDER BY total_revenue DESC;
SELECT n.n_name, AVG(s.s_acctbal) AS avg_supplier_balance, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(l.l_quantity) AS total_quantity_ordered, SUM(l.l_extendedprice * (1 - l_discount)) AS revenue, AVG(p.p_retailprice) AS avg_part_retail_price FROM nation n JOIN supplier s ON s.s_nationkey = n.n_nationkey JOIN customer c ON c.c_nationkey = n.n_nationkey JOIN orders o ON o.o_custkey = c.c_custkey JOIN lineitem l ON l.l_orderkey = o.o_orderkey JOIN part p ON p.p_partkey = l.l_partkey JOIN partsupp ps ON ps.ps_suppkey = l.l_suppkey AND ps.ps_partkey = l.l_partkey WHERE l.l_shipmode IN ('AIR', 'FOB') AND l.l_discount BETWEEN 0.05 AND 0.07 AND o.o_orderdate >= date '1995-01-01' AND o.o_orderdate < date '1996-01-01' AND ps.ps_supplycost < 600.00 GROUP BY n.n_name ORDER BY revenue DESC, avg_supplier_balance DESC LIMIT 5;
SELECT r.r_name AS region, n.n_name AS nation, COUNT(DISTINCT c.c_custkey) AS customer_count, COUNT(DISTINCT s.s_suppkey) AS supplier_count, SUM(ps.ps_availqty) AS total_avail_qty, AVG(ps.ps_supplycost) AS avg_supply_cost, SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue, AVG(l.l_quantity) AS avg_quantity_sold FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey JOIN orders o ON l.l_orderkey = o.o_orderkey JOIN customer c ON o.o_custkey = c.c_custkey AND c.c_nationkey = n.n_nationkey WHERE r.r_name <> 'REGION NAME TO EXCLUDE' AND l.l_shipdate BETWEEN '2023-01-01' AND '2023-12-31' AND (ps.ps_supplycost = 387.63 OR ps.ps_supplycost = 353.01) AND ps.ps_availqty = 4669 AND (o.o_comment LIKE '%pinto beans wake furiously reg%' OR o.o_comment LIKE '%counts will use. carefully regular pinto beans%') AND c.c_address <> 'd9 fWSCFsPQ49YjEsfqtJ8Cemmix7nfTkRS8nU r' AND n.n_nationkey NOT IN (14, 1, 22) AND n.n_comment NOT LIKE '%ously. final, express gifts cajole a%' GROUP BY r.r_name, n.n_name ORDER BY revenue DESC, region, nation;
SELECT n.n_name AS nation_name, c.c_mktsegment AS market_segment, COUNT(DISTINCT c.c_custkey) AS customer_count, SUM(li.l_quantity) AS total_quantity, AVG(c.c_acctbal) AS average_account_balance, SUM(li.l_extendedprice * (1 - li.l_discount)) AS total_discounted_sales FROM customer c JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN lineitem li ON c.c_custkey = CAST(SUBSTRING(li.l_shipmode, 1, POSITION('-' IN li.l_shipmode) - 1) AS INTEGER) WHERE n.n_regionkey = 0 AND li.l_receiptdate BETWEEN '1996-01-01' AND '1997-12-31' AND li.l_returnflag = 'A' AND c.c_comment LIKE '%final%' GROUP BY nation_name, market_segment ORDER BY total_discounted_sales DESC, average_account_balance DESC;
SELECT n.n_name AS nation_name, p.p_type AS part_type, AVG(ps.ps_supplycost) AS avg_supply_cost, SUM(ps.ps_availqty) AS total_availability, COUNT(DISTINCT p.p_partkey) AS unique_parts_count FROM nation n JOIN partsupp ps ON n.n_nationkey = ps.ps_suppkey JOIN part p ON ps.ps_partkey = p.p_partkey WHERE ps.ps_availqty > 3000 AND p.p_size BETWEEN 30 AND 50 GROUP BY nation_name, part_type ORDER BY avg_supply_cost DESC, total_availability DESC LIMIT 10;
SELECT c.c_mktsegment, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_quantity) AS total_quantity, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_discounted_price, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, AVG(ps.ps_supplycost) AS avg_supply_cost FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN partsupp ps ON l.l_partkey = ps.ps_partkey AND l.l_suppkey = ps.ps_suppkey WHERE o.o_orderdate BETWEEN '1994-01-01' AND '1997-12-31' AND o.o_clerk IN ('Clerk#000013110', 'Clerk#000019634', 'Clerk#000022938', 'Clerk#000000992') GROUP BY c.c_mktsegment, order_year ORDER BY c.c_mktsegment, order_year;
SELECT p.p_type, SUM(l.l_extendedprice) AS total_sales_volume, AVG(l.l_discount) AS avg_discount, COUNT(*) AS lineitem_count FROM lineitem l INNER JOIN orders o ON l.l_orderkey = o.o_orderkey INNER JOIN supplier s ON l.l_suppkey = s.s_suppkey INNER JOIN nation n ON s.s_nationkey = n.n_nationkey INNER JOIN region r ON n.n_regionkey = r.r_regionkey INNER JOIN part p ON l.l_partkey = p.p_partkey WHERE r.r_name = 'MIDDLE EAST' GROUP BY p.p_type ORDER BY total_sales_volume DESC;
SELECT r.r_name AS region_name, COUNT(DISTINCT c.c_custkey) AS num_customers, AVG(c.c_acctbal) AS avg_acct_balance FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN customer c ON n.n_nationkey = c.c_nationkey WHERE c.c_mktsegment = 'BUILDING' AND n.n_nationkey IN (17, 19, 6) GROUP BY r.r_name ORDER BY num_customers DESC, avg_acct_balance DESC;
SELECT r_name AS region, n_name AS nation, COUNT(c_custkey) AS num_customers, SUM(c_acctbal) AS total_account_balance, AVG(c_acctbal) AS average_account_balance, SUM(l_extendedprice * (1 - l_discount)) AS sales_volume, COUNT(DISTINCT o_orderkey) AS num_orders, COUNT(l_orderkey) AS num_lineitems, AVG(l_quantity) AS average_quantity_sold FROM region JOIN nation ON r_regionkey = n_regionkey JOIN customer ON n_nationkey = c_nationkey JOIN orders ON c_custkey = o_custkey JOIN lineitem ON o_orderkey = l_orderkey WHERE n_name IN ('CHINA', 'FRANCE', 'INDONESIA', 'JAPAN') AND o_orderdate BETWEEN '1993-01-01' AND '1997-12-31' AND (o_orderstatus = 'F' OR o_orderstatus = 'O') GROUP BY r_name, n_name ORDER BY sales_volume DESC, num_customers DESC;
SELECT r.r_name AS region_name, avg(c.c_acctbal) AS average_account_balance, sum(ps.ps_availqty) AS total_available_quantity, sum(p.p_retailprice * ps.ps_availqty) AS total_inventory_value, count(DISTINCT c.c_custkey) AS number_of_customers, count(DISTINCT p.p_partkey) AS number_of_parts FROM region r JOIN customer c ON c.c_nationkey = r.r_regionkey JOIN partsupp ps ON ps.ps_suppkey = c.c_custkey JOIN part p ON p.p_partkey = ps.ps_partkey WHERE r.r_name IN ('AFRICA', 'AMERICA') AND p.p_brand IN ('Brand#54', 'Brand#35', 'Brand#44') AND c.c_acctbal > 0 GROUP BY r.r_name ORDER BY total_inventory_value DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT c_custkey) AS num_customers, COUNT(DISTINCT o_orderkey) AS num_orders, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(c_acctbal) AS average_account_balance, SUM(l_quantity) AS total_quantity_ordered FROM region JOIN nation ON r_regionkey = n_regionkey JOIN customer ON n_nationkey = c_nationkey JOIN orders ON c_custkey = o_custkey JOIN lineitem ON o_orderkey = l_orderkey WHERE o_orderstatus = 'O' AND n_nationkey IN (4, 15, 14) AND l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' GROUP BY r_name, n_name ORDER BY total_revenue DESC, num_orders DESC;
SELECT r.r_name AS region, c.c_mktsegment AS market_segment, EXTRACT(YEAR FROM o.o_orderdate) AS order_year, COUNT(DISTINCT o.o_orderkey) AS total_orders, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales_volume, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_purchase_size FROM customer c JOIN orders o ON c.c_custkey = o.o_custkey JOIN lineitem l ON o.o_orderkey = l.l_orderkey JOIN nation n ON c.c_nationkey = n.n_nationkey JOIN region r ON n.n_regionkey = r.r_regionkey WHERE o.o_orderstatus IN ('F', 'O') AND EXTRACT(YEAR FROM o.o_orderdate) = 1995 GROUP BY region, market_segment, order_year ORDER BY total_sales_volume DESC, avg_purchase_size DESC;
SELECT r.r_name AS region, COUNT(DISTINCT c.c_custkey) AS num_customers, COUNT(DISTINCT s.s_suppkey) AS num_suppliers, COUNT(DISTINCT o.o_orderkey) AS num_orders, SUM(p.p_retailprice * l.l_quantity) AS total_revenue, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_disc_price, SUM(l.l_quantity) AS total_quantity, AVG(s.s_acctbal) AS avg_supplier_acctbal, AVG(c.c_acctbal) AS avg_customer_acctbal FROM region r JOIN supplier s ON s.s_nationkey = r.r_regionkey JOIN partsupp ps ON ps.ps_suppkey = s.s_suppkey JOIN part p ON p.p_partkey = ps.ps_partkey JOIN lineitem l ON l.l_partkey = p.p_partkey AND l.l_suppkey = s.s_suppkey JOIN orders o ON o.o_orderkey = l.l_orderkey JOIN customer c ON c.c_custkey = o.o_custkey WHERE p.p_container IN ('SM BAG', 'WRAP BAG', 'JUMBO PKG', 'MED BOX', 'SM BOX', 'SM DRUM') AND p.p_type IN ('LARGE ANODIZED NICKEL', 'MEDIUM ANODIZED TIN', 'ECONOMY BRUSHED TIN', 'PROMO ANODIZED COPPER', 'SMALL BRUSHED NICKEL') AND o.o_orderstatus = 'O' GROUP BY r.r_name ORDER BY total_revenue DESC;
SELECT r.r_name AS region_name, COUNT(DISTINCT s.s_suppkey) AS total_suppliers, SUM(ps.ps_availqty) AS total_available_quantity, AVG(ps.ps_supplycost) AS average_supply_cost, SUM(s.s_acctbal) AS total_supplier_balance FROM region r INNER JOIN nation n ON r.r_regionkey = n.n_regionkey INNER JOIN supplier s ON n.n_nationkey = s.s_nationkey INNER JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey GROUP BY r.r_name ORDER BY total_available_quantity DESC, average_supply_cost
SELECT r.r_name AS region_name, n.n_name AS nation_name, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c.c_custkey) AS number_of_customers, SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_sales_value, AVG(l.l_quantity) AS average_quantity_sold, AVG(ps.ps_supplycost) AS average_supply_cost FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN customer c ON n.n_nationkey = c.c_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey WHERE r.r_name IN ('MIDDLE EAST', 'ASIA', 'EUROPE', 'AMERICA', 'AFRICA') AND l.l_shipdate BETWEEN '1992-01-01' AND '1994-12-31' AND l.l_returnflag = 'N' GROUP BY region_name, nation_name ORDER BY total_sales_value DESC;
SELECT r.r_name AS region, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c.c_custkey) AS number_of_customers, COUNT(DISTINCT o.o_orderkey) AS number_of_orders, SUM(l.l_extendedprice) AS total_revenue, AVG(l.l_extendedprice * (1 - l.l_discount)) AS avg_discounted_revenue, SUM(l.l_quantity) AS total_quantity_sold, AVG(p.p_retailprice) AS avg_retail_price, SUM(ps.ps_supplycost * l.l_quantity) AS total_supply_cost FROM region r JOIN nation n ON n.n_regionkey = r.r_regionkey JOIN supplier s ON s.s_nationkey = n.n_nationkey JOIN partsupp ps ON ps.ps_suppkey = s.s_suppkey JOIN part p ON p.p_partkey = ps.ps_partkey JOIN lineitem l ON l.l_partkey = p.p_partkey AND l.l_suppkey = s.s_suppkey JOIN orders o ON o.o_orderkey = l.l_orderkey JOIN customer c ON c.c_custkey = o.o_custkey AND c.c_nationkey = n.n_nationkey WHERE r.r_name IN ('AFRICA', 'EUROPE') AND p.p_type IN ('PROMO POLISHED NICKEL', 'ECONOMY BRUSHED COPPER') AND l.l_shipinstruct IN ('COLLECT COD', 'TAKE BACK RETURN') AND l.l_tax BETWEEN 0.01 AND 0.07 GROUP BY r.r_name ORDER BY total_revenue DESC;
SELECT r.r_name AS region, n.n_name AS nation, c.c_mktsegment AS market_segment, count(DISTINCT o.o_orderkey) AS total_orders, sum(l.l_extendedprice * (1 - l.l_discount)) AS total_revenue, avg(l.l_quantity) AS avg_quantity, avg(l.l_extendedprice) AS avg_price, avg(l.l_discount) AS avg_discount FROM orders o JOIN customer c ON c.c_custkey = o.o_custkey JOIN nation n ON n.n_nationkey = c.c_nationkey JOIN region r ON r.r_regionkey = n.n_regionkey JOIN lineitem l ON l.l_orderkey = o.o_orderkey WHERE o.o_orderdate >= date '1995-01-01' AND o.o_orderdate < date '1996-01-01' AND l.l_shipdate > o.o_orderdate AND r.r_name = 'EUROPE' GROUP BY region, nation, market_segment ORDER BY total_revenue DESC, total_orders DESC;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT c_custkey) AS number_of_customers, AVG(c_acctbal) AS average_account_balance, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue, COUNT(DISTINCT o_orderkey) AS number_of_orders FROM region JOIN nation ON r_regionkey = n_regionkey JOIN customer ON n_nationkey = c_nationkey JOIN orders ON c_custkey = o_custkey JOIN lineitem ON o_orderkey = l_orderkey WHERE r_name IN ('EUROPE', 'AMERICA') AND o_orderdate BETWEEN DATE '1995-01-01' AND DATE '1995-12-31' AND l_shipdate > o_orderdate GROUP BY region, nation ORDER BY total_revenue DESC;
SELECT n.n_name AS nation, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT c.c_custkey) AS number_of_customers, AVG(s.s_acctbal) AS avg_supplier_acctbal, AVG(c.c_acctbal) AS avg_customer_acctbal FROM nation n LEFT JOIN supplier s ON n.n_nationkey = s.s_nationkey LEFT JOIN customer c ON n.n_nationkey = c.c_nationkey WHERE c.c_mktsegment = 'HOUSEHOLD' GROUP BY n.n_name ORDER BY n.n_name;
SELECT r_name AS region, n_name AS nation, COUNT(DISTINCT c_custkey) AS num_customers, AVG(c_acctbal) AS avg_account_balance, SUM(l_extendedprice * (1 - l_discount)) AS revenue, AVG(l_quantity) AS avg_quantity_sold, COUNT(*) AS lineitem_count FROM region JOIN nation ON n_regionkey = r_regionkey JOIN customer ON c_nationkey = n_nationkey JOIN lineitem ON l_orderkey = c_custkey WHERE r_regionkey IN (0, 1) AND l_shipdate BETWEEN '1995-02-23' AND '1998-06-06' AND c_acctbal > 0 GROUP BY region, nation ORDER BY revenue DESC;
SELECT r_name, COUNT(DISTINCT ps_partkey) AS num_parts, SUM(ps_availqty) AS total_availability, AVG(ps_supplycost) AS avg_supply_cost, SUM(l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(l_quantity) AS avg_quantity_sold FROM region JOIN partsupp ON r_regionkey = ps_suppkey % 5 JOIN lineitem ON ps_partkey = l_partkey AND ps_suppkey = l_suppkey WHERE r_regionkey IN (1, 3) AND l_shipdate BETWEEN date '2022-01-01' AND date '2022-12-31' AND l_discount BETWEEN 0.05 AND 0.07 AND l_quantity BETWEEN 5 AND 25 GROUP BY r_name ORDER BY total_revenue DESC;
SELECT r.r_name AS region_name, COUNT(DISTINCT s.s_suppkey) AS number_of_suppliers, COUNT(DISTINCT n.n_nationkey) AS number_of_nations, AVG(s.s_acctbal) AS avg_supplier_acct_balance, AVG(ps.ps_supplycost) AS avg_supply_cost, SUM(ps.ps_availqty) AS total_available_quantity FROM region r JOIN nation n ON r.r_regionkey = n.n_regionkey JOIN supplier s ON n.n_nationkey = s.s_nationkey JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey GROUP BY r.r_name ORDER BY r.r_name;
SELECT s.s_name, s.s_address, AVG(s.s_acctbal) AS average_balance, COUNT(DISTINCT p.p_partkey) AS part_count, SUM(l.l_quantity) AS total_quantity, SUM(l.l_extendedprice * (1 - l_discount)) AS total_revenue, AVG(l.l_extendedprice * (1 - l_discount)) AS average_revenue_per_part FROM supplier s JOIN lineitem l ON s.s_suppkey = l.l_suppkey JOIN part p ON l.l_partkey = p.p_partkey WHERE l.l_shipdate BETWEEN '1995-01-01' AND '1995-12-31' AND l.l_returnflag IN ('N', 'A', 'R') AND p.p_brand = 'Brand#14' GROUP BY s.s_name, s.s_address ORDER BY total_revenue DESC, s.s_name LIMIT 10;
