                        ---tables for enterprise_nz_ecommerce_engine---


-- 1. NZ Regions & Tax Reference Table
CREATE TABLE nz_regions (
    region_id INT PRIMARY KEY,
    region_code VARCHAR(10) UNIQUE NOT NULL, -- e.g., 'AKL', 'WLG', 'CAN'
    region_name VARCHAR(50) NOT NULL,
    island VARCHAR(10) CHECK (island IN ('North', 'South')),
    standard_gst_rate NUMERIC(4,2) DEFAULT 0.15
);

-- 2. Customer Profiles across NZ Cities
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    region_id INT REFERENCES nz_regions(region_id),
    customer_tier VARCHAR(20) DEFAULT 'Standard' CHECK (customer_tier IN ('Standard', 'Gold', 'Corporate')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Product Catalog (NZD Pricing & Inventory)
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price_nzd NUMERIC(10,2) NOT NULL CHECK (unit_price_nzd > 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0)
);

-- 4. Customer Orders & Payment Methods
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_timestamp TIMESTAMP NOT NULL,
    payment_method VARCHAR(30) CHECK (payment_method IN ('EFTPOS', 'Credit Card', 'Bank Transfer', 'Afterpay')),
    order_status VARCHAR(20) CHECK (order_status IN ('COMPLETED', 'CANCELLED', 'REFUNDED'))
);

-- 5. Order Item Details (Junction Table)
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price_nzd NUMERIC(10,2) NOT NULL
);