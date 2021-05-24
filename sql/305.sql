DROP DATABASE IF EXISTS starbucks_project;
DROP USER IF EXISTS 'roshan'@'localhost';

CREATE DATABASE starbucks_project;
CREATE USER  'roshan'@'localhost' IDENTIFIED BY 'password';

GRANT ALL PRIVILEGES ON starbucks_project.* TO  'roshan'@'localhost';


USE starbucks_project;
CREATE TABLE starbucks_chain (
    chain_id INT,
    chain_name VARCHAR(60),
    phone_num VARCHAR(11),
    email VARCHAR(60),
    PRIMARY KEY (chain_id)
);

CREATE TABLE executive (
    executive_id INT,
    login_pass VARCHAR(11),
    is_admin BOOLEAN,
    chain_id INT,
    PRIMARY KEY (executive_id),
    FOREIGN KEY (chain_id) REFERENCES  starbucks_chain(chain_id)
);

CREATE TABLE manages (
    executive_id INT,
    chain_id INT,
    FOREIGN KEY (chain_id) REFERENCES  starbucks_chain(chain_id)
);


CREATE TABLE employee (
    emp_id INT,
    emp_name VARCHAR(60),
    phone_num VARCHAR(11),
    PRIMARY KEY (emp_id)
);

CREATE TABLE department (
    dept_id INT,
    dept_name VARCHAR(60),
    emp_id INT,
    PRIMARY KEY (dept_id)

);

CREATE TABLE works_in (
    emp_id INT,
    dept_id INT,
    chain_id INT,
    since DATE,
    title VARCHAR(60),
    salary REAL,
    PRIMARY KEY (emp_id),
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id)
        ON DELETE CASCADE,
    FOREIGN KEY (chain_id) REFERENCES  starbucks_chain(chain_id),
    FOREIGN KEY (dept_id) REFERENCES  department(dept_id)
    
);



CREATE TABLE customer (
    cust_id INT,
    cust_name VARCHAR(60),
    phone_num VARCHAR(11),
    PRIMARY KEY (cust_id)
);

CREATE TABLE main_menu (
    item_id INT,
    item_name VARCHAR(60),
    item_size VARCHAR(1),
    item_price REAL,
    item_url VARCHAR(100),
    is_currently_sold BOOLEAN, 
    PRIMARY KEY (item_id)
);

CREATE TABLE chain_menu (
    chain_id INT,
    item_id INT CHECK (1 IN (SELECT is_currently_sold FROM main_menu M WHERE M.item_id = item_id)),
    FOREIGN KEY (item_id) REFERENCES main_menu(item_id)
);

CREATE TABLE order_hist_details (
    order_id INT,
    item_id INT,
    item_quantity INT,
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (item_id) REFERENCES main_menu(item_id)
);

CREATE TABLE order_hist (
    order_id INT,
    cust_id INT,
    order_date DATE,
    chain_id INT,
    payment_type VARCHAR(60),
    FOREIGN KEY (cust_id) REFERENCES  customer(cust_id),
    FOREIGN KEY (order_id) REFERENCES  order_hist_details(order_id),    
    FOREIGN KEY (chain_id) REFERENCES  starbucks_chain(chain_id)
);

CREATE TABLE ratings (
    cust_id INT,
    chain_id INT,
    rating INT,
    review VARCHAR(500),
    PRIMARY KEY (cust_id, chain_id),
    FOREIGN KEY (chain_id) REFERENCES  starbucks_chain(chain_id),
    FOREIGN KEY (cust_id) REFERENCES  customer(cust_id)
);

CREATE TABLE chain_facility (
    chain_id INT,
    drive_through BOOLEAN,
    wheelchair_accessible BOOLEAN,
    has_parking BOOLEAN,
    wireless_charging BOOLEAN,
    WIFI BOOLEAN,
    PRIMARY KEY (chain_id),
    FOREIGN KEY (chain_id) REFERENCES  starbucks_chain(chain_id)

);

CREATE TABLE supplier(
    supplier_id INT,
    supplier_name VARCHAR(60),
    PRIMARY KEY (supplier_id)
);


CREATE TABLE supplies (
    supply_id INT,
    supply_name VARCHAR(60),
    supplier_id INT,
    PRIMARY KEY (supply_id),
    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);

CREATE TABLE supply_inventory (
    chain_id INT, 
    supply_id INT,
    inventory INT DEFAULT 100,
    FOREIGN KEY (supply_id) REFERENCES supplies(supply_id),
    FOREIGN KEY (chain_id) REFERENCES  starbucks_chain(chain_id)
);