                             ---data set for enterprise_nz_ecommerce_engine---


-- Regions
INSERT INTO nz_regions (region_id, region_code, region_name, island) VALUES
(1, 'AKL', 'Auckland', 'North'),
(2, 'WLG', 'Wellington', 'North'),
(3, 'CAN', 'Canterbury', 'South'),
(4, 'WKO', 'Waikato', 'North'),
(5, 'OTA', 'Otago', 'South');

-- Products
INSERT INTO products (product_id, product_name, category, unit_price_nzd, stock_quantity) VALUES
(501, 'Whicker Chair NZ Wool', 'Furniture', 249.99, 45),
(502, 'Manuka Honey Grade A 500g', 'Groceries', 45.00, 200),
(503, 'Ergonomic Desk Frame', 'Office', 599.00, 15),
(504, 'Mechanical Keyboard RGB', 'Electronics', 180.00, 30),
(505, 'Merino Wool Thermal Top', 'Apparel', 120.00, 80);

-- Customers
INSERT INTO customers (customer_id, customer_name, email, region_id, customer_tier) VALUES
(1001, 'Aroha Smith', 'aroha.smith@nzmail.co.nz', 1, 'Corporate'),
(1002, 'Liam Taylor', 'liam.taylor@wlg.govt.nz', 2, 'Gold'),
(1003, 'Tane Williams', 'tane.williams@canty.ac.nz', 3, 'Standard'),
(1004, 'Sophie Chen', 'sophie.chen@aklsales.co.nz', 1, 'Corporate'),
(1005, 'Anaru Brown', 'anaru.b@otagomail.com', 5, 'Standard');

-- Orders
INSERT INTO orders (order_id, customer_id, order_timestamp, payment_method, order_status) VALUES
(201, 1001, '2026-08-01 09:15:00', 'EFTPOS', 'COMPLETED'),
(202, 1001, '2026-08-01 09:18:00', 'EFTPOS', 'COMPLETED'),
(203, 1002, '2026-08-02 14:30:00', 'Bank Transfer', 'COMPLETED'),
(204, 1003, '2026-08-03 11:20:00', 'Credit Card', 'CANCELLED'),
(205, 1004, '2026-08-15 10:00:00', 'Bank Transfer', 'COMPLETED'),
(206, 1004, '2026-08-15 10:04:00', 'Bank Transfer', 'COMPLETED'),
(207, 1005, '2026-08-20 16:45:00', 'Afterpay', 'COMPLETED');

-- Order Items
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price_nzd) VALUES
(1, 201, 502, 2, 45.00),
(2, 202, 503, 1, 599.00),
(3, 203, 501, 4, 249.99),
(4, 204, 504, 1, 180.00),
(5, 205, 503, 5, 599.00),
(6, 206, 503, 10, 599.00),
(7, 207, 505, 2, 120.00);