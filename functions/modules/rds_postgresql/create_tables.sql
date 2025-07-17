-- This file needs to be uploaded to the S3 bucket:

-- Create the schema for the raw-data bucket
CREATE SCHEMA IF NOT EXISTS insightflow_raw;

-- Set the search path to the new schema - PostgreSQL syntax

SET search_path TO insightflow_raw;

-- -- Orders Table
DROP TABLE IF EXISTS insightflow_raw.orders;
CREATE TABLE insightflow_raw.orders (
    order_id           INTEGER PRIMARY KEY,
    user_id            INTEGER NOT NULL,
    eval_set           VARCHAR(20) NOT NULL,
    order_number       INTEGER NOT NULL,
    order_dow          INTEGER NOT NULL,
    order_hour_of_day  INTEGER NOT NULL,
    days_since_prior   REAL,
    year               INT NOT NULL,
    month              INT NOT NULL,
    day                INT NOT NULL,
    hhmm               TEXT NOT NULL
);

-- Aisles Table
DROP TABLE IF EXISTS insightflow_raw.aisles;
CREATE TABLE insightflow_raw.aisles (
    aisle_id   INTEGER PRIMARY KEY,
    aisle      VARCHAR(255) NOT NULL,
    year       INT NOT NULL,
    month      INT NOT NULL,
    day        INT NOT NULL,
    hhmm       TEXT NOT NULL
);


-- Departments Table
DROP TABLE IF EXISTS insightflow_raw.departments;
CREATE TABLE insightflow_raw.departments (
    department_id   INTEGER PRIMARY KEY,
    department      VARCHAR(255) NOT NULL,
    year       INT NOT NULL,
    month      INT NOT NULL,
    day        INT NOT NULL,
    hhmm       TEXT NOT NULL
);


-- Products Table
DROP TABLE IF EXISTS insightflow_raw.products;
CREATE TABLE insightflow_raw.products (
    product_id     INTEGER PRIMARY KEY,
    product_name   VARCHAR(255) NOT NULL,
    aisle_id       INTEGER NOT NULL,
    department_id  INTEGER NOT NULL,
    year           INT NOT NULL,
    month          INT NOT NULL,
    day            INT NOT NULL,
    hhmm           TEXT NOT NULL,
    FOREIGN KEY (aisle_id) REFERENCES insightflow_raw.aisles(aisle_id),
    FOREIGN KEY (department_id) REFERENCES insightflow_raw.departments(department_id)
);

-- Order_products__prior Orders Table
DROP TABLE IF EXISTS insightflow_raw.order_products__prior;
CREATE TABLE insightflow_raw.order_products__prior (
    order_id           INTEGER NOT NULL,
    product_id         INTEGER NOT NULL,
    add_to_cart_order  INTEGER NOT NULL,
    reordered          BOOLEAN NOT NULL,
    year               INT NOT NULL,
    month              INT NOT NULL,
    day                INT NOT NULL,
    hhmm               TEXT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES insightflow_raw.orders(order_id),
    FOREIGN KEY (product_id) REFERENCES insightflow_raw.products(product_id)
);

-- Order_products__train Orders Table
DROP TABLE IF EXISTS insightflow_raw.order_products__train;
CREATE TABLE insightflow_raw.order_products__train (
    order_id           INTEGER NOT NULL,
    product_id         INTEGER NOT NULL,
    add_to_cart_order  INTEGER NOT NULL,
    reordered          BOOLEAN NOT NULL,
    year               INT NOT NULL,
    month              INT NOT NULL,
    day                INT NOT NULL,
    hhmm               TEXT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES insightflow_raw.orders(order_id),
    FOREIGN KEY (product_id) REFERENCES insightflow_raw.products(product_id)
);