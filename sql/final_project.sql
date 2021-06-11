DROP DATABASE IF EXISTS starbucks_project;
DROP USER IF EXISTS 'starbucks-admin'@'localhost';

CREATE DATABASE starbucks_project;
CREATE USER  'starbucks-admin'@'localhost' IDENTIFIED BY 'password';

GRANT ALL PRIVILEGES ON starbucks_project.* TO  'starbucks-admin'@'localhost';


USE starbucks_project;

CREATE TABLE starbucks_admin(
	admin_id VARCHAR(60),
	admin_name VARCHAR(60),
    login_pass VARCHAR(100),
    PRIMARY KEY(admin_id)
);

CREATE TABLE starbucks_chain (
    chain_id INT,
    chain_name VARCHAR(60),
    phone_num VARCHAR(11),
    email VARCHAR(60),
    PRIMARY KEY (chain_id)
);

CREATE TABLE executive (
    executive_id INT,
    login_pass VARCHAR(100),
    chain_id INT,
    exec_name  VARCHAR(100),
    PRIMARY KEY (executive_id),
    FOREIGN KEY (chain_id) REFERENCES  starbucks_chain(chain_id)
);

CREATE TABLE chain_manages (
    executive_id INT,
    chain_id INT,
    FOREIGN KEY (chain_id) REFERENCES  starbucks_chain(chain_id),
    FOREIGN KEY (executive_id) REFERENCES  executive(executive_id)
);

CREATE TABLE employee (
    emp_id VARCHAR(100),
    emp_name VARCHAR(60),
    phone_num VARCHAR(110),
    PRIMARY KEY (emp_id)
);

CREATE TABLE department (
    dept_id varchar(100) NOT NULL,
    dept_name VARCHAR(60) NOT NULL,
    mgr_id VARCHAR(100),
    PRIMARY KEY (dept_id),
    FOREIGN KEY (mgr_id) REFERENCES  employee(emp_id)
);



CREATE TABLE works_in (
    emp_id VARCHAR(100),
    dept_id VARCHAR(100),
    chain_id INT,
    since VARCHAR(60),
    title VARCHAR(60),
    salary REAL,
    PRIMARY KEY (emp_id, dept_id),
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
    item_size VARCHAR(20),
    item_price REAL,
    item_url VARCHAR(2000),
    is_currently_sold BOOLEAN, 
    PRIMARY KEY (item_id)
);


CREATE TABLE chain_menu (
    chain_id INT,
    item_id INT,
    FOREIGN KEY (item_id) REFERENCES main_menu(item_id)
);

CREATE TABLE order_hist_details (
    order_id VARCHAR(100),
    item_id INT,
    item_quantity INT,
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (item_id) REFERENCES main_menu(item_id)
);


CREATE TABLE order_hist (
    order_id VARCHAR(100),
    cust_id INT,
    order_date DATE,
    chain_id INT,
    PRIMARY KEY (order_id),
    FOREIGN KEY (cust_id) REFERENCES  customer(cust_id),
    FOREIGN KEY (order_id) REFERENCES  order_hist_details(order_id),    
    FOREIGN KEY (chain_id) REFERENCES  starbucks_chain(chain_id)
);


CREATE TABLE ratings (
    cust_id INT,
    chain_id INT,
    rating INT,
    review VARCHAR(500),
    review_date DATE,
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
    stock_url VARCHAR(1000),
    PRIMARY KEY (chain_id, supply_id),
    FOREIGN KEY (supply_id) REFERENCES supplies(supply_id),
    FOREIGN KEY (chain_id) REFERENCES  starbucks_chain(chain_id)
);

/*
SET SQL_SAFE_UPDATES=0;
DELETE FROM manages WHERE executive_id =0;
SET SQL_SAFE_UPDATES=1;
*/




-- GRANT ALL PRIVILEGES ON starbucks_project.* TO  'starbucks-admin'@'localhost';


-- USE starbucks_project;
INSERT INTO starbucks_admin VALUES("admin", "Kevin Johnson", "d033e22ae348aeb5660fc2140aec35850c4da997");

INSERT INTO starbucks_chain VALUES(1, "Seatle", "0104444", "seattle@startbucks.com");
INSERT INTO starbucks_chain VALUES(2, "Los Angeles", "0103232", "la@startbucks.com");
INSERT INTO starbucks_chain VALUES(3, "Baltimore", "0105544", "baltimore@startbucks.com");
INSERT INTO starbucks_chain VALUES(4, "Miami", "0103423", "miami@startbucks.com");
INSERT INTO starbucks_chain VALUES(5, "New York", "0108989", "ny@startbucks.com");

INSERT INTO executive VALUES(01, "7e240de74fb1ed08fa08d38063f6a6a91462a815", 1, "Mark Smith");
INSERT INTO executive VALUES(02, "5cb138284d431abd6a053a56625ec088bfb88912", 2, "Tom Crus");
INSERT INTO executive VALUES(03, "bdb480de655aa6ec75ca058c849c4faf3c0f75b1", 3, "Denzel Washington");
INSERT INTO executive VALUES(04, "388ad1c312a488ee9e12998fe097f2258fa8d5ee", 4, "Chris Flair");
INSERT INTO executive VALUES(05, "1f444844b1ca616009c2b0e3564fecc065872b5b", 5, "Hailey Sparkles");

INSERT INTO chain_manages VALUES(01, 1);
INSERT INTO chain_manages VALUES(02, 2);
INSERT INTO chain_manages VALUES(03, 3);
INSERT INTO chain_manages VALUES(04, 4);
INSERT INTO chain_manages VALUES(05, 5);

INSERT INTO employee VALUES('1', "john doe", "0101111");
INSERT INTO employee VALUES('2', "Cris Bens", "01022332");
INSERT INTO employee VALUES('3', "Louis Tate", "0102345987");
INSERT INTO employee VALUES('4', "Mark Andrews", "01035467");
INSERT INTO employee VALUES('5', "Andrew Lasher", "01078900");
INSERT INTO employee VALUES('6', "Desmond Dube", "0104562344");
INSERT INTO employee VALUES('7', "Samson Daniels", "010345689");
INSERT INTO employee VALUES('8', "Michael James", "01023098");
INSERT INTO employee VALUES('9', "Thomas Tuchel", "0104567987");
INSERT INTO employee VALUES('10', "Bob Horton", "0104567987");
INSERT INTO employee VALUES('11', "Darrell Bricks", "0104567987");
INSERT INTO employee VALUES('12', "Tedd Swarlee", "0104567987");
INSERT INTO employee VALUES('13', "Sweets Farley", "0104567987");
INSERT INTO employee VALUES('14', "Latrae Horton", "0104567987");
INSERT INTO employee VALUES('15', "Jason Matthews", "0104567987");
INSERT INTO employee VALUES('16', "Wilson Mcdaniels", "0104567987");
INSERT INTO employee VALUES('17', "Sean Goldberg", "0104567987");
INSERT INTO employee VALUES('18', "Michale Goldberg", "010444543");
INSERT INTO employee VALUES('19', "Forest Gump", "010413456");
INSERT INTO employee VALUES('20', "Quavo Huncho", "01009872");
INSERT INTO employee VALUES('21', "John Currry", "010876534");
INSERT INTO employee VALUES('22', "Michael Jordan", "010123086");
INSERT INTO employee VALUES('23', "Hang Maps", "0102340987");
INSERT INTO employee VALUES('24', "Ricky James", "010586710");
INSERT INTO employee VALUES('25', "Cristopher Huter", "01045472910");

INSERT INTO employee VALUES('26', "Saul Dodgers", "01048972234");
INSERT INTO employee VALUES('27', "Scarlette Johnson", "01023098765");
INSERT INTO employee VALUES('28', "Emette Smith", "01023450987");
INSERT INTO employee VALUES('29', "Harry Porter", "01023098765");
INSERT INTO employee VALUES('30', "Nicholas Cage", "0106667778");
INSERT INTO employee VALUES('31', "Blake Matthews", "0105674820");
INSERT INTO employee VALUES('32', "Larry Sour", "010999222");
INSERT INTO employee VALUES('33', "Linda Mazey", "0109087652");
INSERT INTO employee VALUES('34', "Michaella Tate", "0104627910");
INSERT INTO employee VALUES('35', "Sharpy Lake", "010190876351");
INSERT INTO employee VALUES('36', "Rodger Ferrari", "01023098765");
INSERT INTO employee VALUES('37', "Thomas Lamborghini", "0101237890");
INSERT INTO employee VALUES('38', "John Mustang", "0102337654891");
INSERT INTO employee VALUES('39', "Riley Motors", "010176501928");
INSERT INTO employee VALUES('40', "Emmerson Grace", "01023098765");
INSERT INTO employee VALUES('41', "Luke Parker", "01099923490");
INSERT INTO employee VALUES('42', "Mary Swarley", "0103456098");
INSERT INTO employee VALUES('43', "Bob Marley", "0101678934214");
INSERT INTO employee VALUES('44', "Matt Bradley", "01013455678");


INSERT INTO department VALUES('1', "Coffee House", '26');
INSERT INTO department VALUES('2', "Coffee House", '30');
INSERT INTO department VALUES('3', "Coffee House", '33');
INSERT INTO department VALUES('4', "Coffee House", '38');
INSERT INTO department VALUES('5', "Coffee House", '41');

INSERT INTO department VALUES('6', "finance", '27');
INSERT INTO department VALUES('7', "finance", '31');
INSERT INTO department VALUES('8', "finance", '34');
INSERT INTO department VALUES('9', "finance", '38');
INSERT INTO department VALUES('10', "finance", '42');

INSERT INTO department VALUES('11', "cleaning", '28');
INSERT INTO department VALUES('12', "cleaning", '32');
INSERT INTO department VALUES('13', "cleaning", '35');
INSERT INTO department VALUES('14', "cleaning", '39');
INSERT INTO department VALUES('15', "cleaning", '42');

INSERT INTO department VALUES('16', "sales", '27');
INSERT INTO department VALUES('17', "sales", '31');
INSERT INTO department VALUES('18', "sales", '36');
INSERT INTO department VALUES('19', "sales", '40');
INSERT INTO department VALUES('20', "sales", '43');

INSERT INTO department VALUES('21', "human resources", '29');
INSERT INTO department VALUES('22', "human resources", '31');
INSERT INTO department VALUES('23', "human resources", '37');
INSERT INTO department VALUES('24', "human resources", '40');
INSERT INTO department VALUES('25', "human resources", '44');


INSERT INTO works_in VALUES('1', '1', 1, "2000-12-12", "Barista", 30000);
INSERT INTO works_in VALUES('2', '2', 2, "2010-11-07", "Barista", 40000);
INSERT INTO works_in VALUES('3', '3', 3, "2020-04-12", "Barista", 34000);
INSERT INTO works_in VALUES('4', '4', 4, "2013-11-30", "Barista", 34000);
INSERT INTO works_in VALUES('5', '5', 5, "2000-01-10", "Barista", 34500);

INSERT INTO works_in VALUES('6', '6', 1, "2007-08-12", "clerk", 35600);
INSERT INTO works_in VALUES('7', '7', 2, "2009-05-27", "clerk", 34900);
INSERT INTO works_in VALUES('8', '8', 3, "2018-04-12", "clerk", 33000);
INSERT INTO works_in VALUES('9', '9', 4, "2013-01-14", "accountant", 37200);
INSERT INTO works_in VALUES('10', '10', 5, "2020-05-13", "accountant", 23000);

INSERT INTO works_in VALUES('11', '11', 1, "2010-06-02", "cleaning", 30000);
INSERT INTO works_in VALUES('12', '12', 2, "2009-07-14", "cleaning", 34000);
INSERT INTO works_in VALUES('13', '13', 3, "2020-12-13", "cleaning", 30030);
INSERT INTO works_in VALUES('14', '14', 4, "2021-12-23", "cleaning", 31000);
INSERT INTO works_in VALUES('15', '15', 5, "2010-12-07", "cleaning", 32000);

INSERT INTO works_in VALUES('16', '16', 1, "2012-12-12", "secretary", 20000);
INSERT INTO works_in VALUES('17', '17', 2, "2013-11-22", "secretary", 23900);
INSERT INTO works_in VALUES('18', '18', 3, "2016-10-13", "secretary", 22030);
INSERT INTO works_in VALUES('19', '19', 4, "2009-07-09", "secretary", 21000);
INSERT INTO works_in VALUES('20', '20', 5, "2010-06-02", "secretary", 18500);

INSERT INTO works_in VALUES('21', '21', 1, "2000-12-12", "recruiter", 50000);
INSERT INTO works_in VALUES('22', '22', 2, "2010-09-22", "recruiter", 53000);
INSERT INTO works_in VALUES('23', '23', 3, "2004-11-20", "recruiter", 51500);
INSERT INTO works_in VALUES('24', '24', 4, "2006-03-11", "recruiter", 45600);
INSERT INTO works_in VALUES('25', '25', 5, "2008-05-19", "recruiter", 50400);

-- Dept. Managers

INSERT INTO works_in VALUES('26', '1', 1, "2015-01-01", "Dept. Manager", 100000);
INSERT INTO works_in VALUES('30', '2', 2, "2016-01-01", "Coffee House", 120000);
INSERT INTO works_in VALUES('33','3', 3, "2017-01-01", "Coffee House", 123000);
INSERT INTO works_in VALUES('38', '4', 4, "2019-01-01", "Coffee House", 122000);
INSERT INTO works_in VALUES('41', '5', 5, "2010-01-01", "Coffee House", 200000);

INSERT INTO works_in VALUES('27', '6', 1, "2020-01-01", "Dept. Manager", 150000);
INSERT INTO works_in VALUES('31', '7', 2, "2019-01-01", "Dept. Manager", 230000);
INSERT INTO works_in VALUES('34', '8', 3, "2018-01-01", "Dept. Manager", 90000);
INSERT INTO works_in VALUES('38', '9', 4, "2014-01-01", "Dept. Manager", 109000);
INSERT INTO works_in VALUES('42', '10', 5, "2015-01-01", "Dept. Manager", 129000);

INSERT INTO works_in VALUES('28', '11', 1, "2008-11-01", "Dept. Manager", 210000);
INSERT INTO works_in VALUES('32', '12', 2, "2010-02-22", "Dept. Manager", 154000);
INSERT INTO works_in VALUES('35', '13', 3, "2012-04-06", "Dept. Manager", 210000);
INSERT INTO works_in VALUES('39', '14', 4, "2014-02-08", "Dept. Manager", 300000);
INSERT INTO works_in VALUES('42', '15', 5, "2013-08-09", "Dept. Manager", 124000);

INSERT INTO works_in VALUES('27', '16', 1, "2004-07-01", "Dept. Manager", 190000);
INSERT INTO works_in VALUES('31', '17', 2, "2010-06-01", "Dept. Manager", 122000);
INSERT INTO works_in VALUES('36', '18', 3, "2009-05-01", "Dept. Manager", 150000);
INSERT INTO works_in VALUES('40', '19', 4, "2000-07-12", "Dept. Manager", 300500);
INSERT INTO works_in VALUES('43', '20', 5, "2000-12-12", "Dept. Manager", 350000);


INSERT INTO works_in VALUES('29', '21', 1, "2011-01-01", "Dept. Manager", 223000);
INSERT INTO works_in VALUES('31', '22', 2, "2009-01-01", "Dept. Manager", 200000);
INSERT INTO works_in VALUES('37', '23', 3, "2012-01-01", "Dept. Manager", 126000);
INSERT INTO works_in VALUES('40', '24', 4, "2013-01-01", "Dept. Manager", 120000);
INSERT INTO works_in VALUES('44', '25', 5, "2015-01-01", "Dept. Manager", 92000);


INSERT INTO customer VALUES(456, "Mark Rogers", "+156666");
INSERT INTO customer VALUES(458, "Mark Johns", "+153333");
INSERT INTO customer VALUES(459, "Kyrie Irving", "+158989");
INSERT INTO customer VALUES(500, "Kevin Samuels", "+15567788");
INSERT INTO customer VALUES(510, "Marc Delacruz", "+15656533s");
INSERT INTO customer VALUES(511, "Swiss Mathews", "+12345667");
INSERT INTO customer VALUES(512, "Kevin Gates", "+1566662344");

INSERT INTO main_menu VALUES(12, "Brewed Coffee", "regular", 3, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/brewed_coffee.jpg', TRUE);
INSERT INTO main_menu VALUES(13, "Caffe latte", "regular", 4, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/caffe_latte.jpg', TRUE);
INSERT INTO main_menu VALUES(14, "Caffe Misto", "regular", 4, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/caffe_isto.jpg', TRUE);
INSERT INTO main_menu VALUES(15, "Caffe Americano", "regular", 5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/caffe_americano.jpg', TRUE);
INSERT INTO main_menu VALUES(16, "Caffe Mocha", "regular", 6, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/caffe_mocha.jpg', TRUE);
INSERT INTO main_menu VALUES(17, "Cappuccino", "regular", 3.4, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/SBX20080807_3256_1.jpg', TRUE);
INSERT INTO main_menu VALUES(18, "Caramel Macchiato", "regular", 3.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/Caramel%20Macchiato.jpg', TRUE);
INSERT INTO main_menu VALUES(19, "Caramel Mocha", "regular", 3, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/caramel_mocha.jpg', TRUE);
INSERT INTO main_menu VALUES(20, "Cinnamon Dolce Latte", "regular", 6.1, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Promo/9.5-Autumn-2019/cinnamon-dolce-latte.png', TRUE);
INSERT INTO main_menu VALUES(21, "Espresso", "regular", 3, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/espresso_shot.jpg', TRUE);
INSERT INTO main_menu VALUES(22, "Espresso Con Panna", "regular", 3.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/espresso_con_panna.jpg', TRUE);
INSERT INTO main_menu VALUES(23, "Espresso Machiato", "regular", 3, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/espresso_macchiato.jpg', TRUE);
INSERT INTO main_menu VALUES(24, "Flat White", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/New-Website---Coffee/flatwhite-2-.jpg', TRUE);
INSERT INTO main_menu VALUES(25, "White Chocolate Mocha", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/White%20Chocolate%20Mocha.jpg', TRUE);
INSERT INTO main_menu VALUES(26, "Black Tea with Ruby Grapefruit & Honey", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Promo/9.5-Autumn-2019/duo-black-tea-honey-grapefruit.png', TRUE);
INSERT INTO main_menu VALUES(27, "Caramel Signature Hot Chocolate", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/New-Website---Coffee/caramelhotchoc-2-.jpg', TRUE);
INSERT INTO main_menu VALUES(28, "Chai Tea", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/sbx20160502-64911-pr.jpg', TRUE);
INSERT INTO main_menu VALUES(29, "Chai Tea Latte", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/chat_tea_latte.jpg', TRUE);
INSERT INTO main_menu VALUES(30, "Earl Grey Tea", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/sbx20160502-64914-pr.jpg', TRUE);
INSERT INTO main_menu VALUES(31, "Emperor's Coud and Mist® Green Tea", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/sbx20160502-64916-pr.jpg', TRUE);
INSERT INTO main_menu VALUES(32, "English Breakfast Tea Latte", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/english_tea_latte.jpg', TRUE);
INSERT INTO main_menu VALUES(33, "Green Tea Latte", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/green_tea_latte.jpg', TRUE);
INSERT INTO main_menu VALUES(34, "Mint Blend Herbal Infusion", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/sbx20160502-64919-pr.jpg', TRUE);
INSERT INTO main_menu VALUES(35, "Signature Hot Chocolate", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/signature_hot_chocolcate.jpg', TRUE);
INSERT INTO main_menu VALUES(36, "White Hot Chocolate", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/white_hot_chocolate.jpg', TRUE);
INSERT INTO main_menu VALUES(37, "Cold Brew", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/cold-brew.png', TRUE);
INSERT INTO main_menu VALUES(38, "Dark Caramel Cold Foam Nitro", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Promo/9.5-Autumn-2019/dark-caramel-nitro.png', TRUE);
INSERT INTO main_menu VALUES(39, "Iced Americano", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/icedamericano.jpg', TRUE);
INSERT INTO main_menu VALUES(40, "Iced Caffè Mocha", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/icedcafemocha.jpg', TRUE);
INSERT INTO main_menu VALUES(41, "Iced Caramel Machiato", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/icedcaramelmacchiato.jpg', TRUE);
INSERT INTO main_menu VALUES(42, "Iced Green Tea Latte", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/icedgreentealatte.jpg', TRUE);
INSERT INTO main_menu VALUES(43, "Iced Latte", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/icedlatte.jpg', TRUE);
INSERT INTO main_menu VALUES(44, "Iced Shaken Lemon Tea", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/icedshakenlemontea.jpg', TRUE);
INSERT INTO main_menu VALUES(45, "Iced Shaken Tea", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/icedshakenblacktea.jpg', TRUE);
INSERT INTO main_menu VALUES(46, "Mango Passionfruit Frappuccino® Blended Juice", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/mangopassionfruitblendedjuice.jpg', TRUE);
INSERT INTO main_menu VALUES(47, "Raspberry Blackcurrant Blended Juice", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/raspberryblackcurrantblendedjuice.jpg', TRUE);
INSERT INTO main_menu VALUES(48, "Caramel Frappuccino®", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/caramelfrapp.jpg', TRUE);
INSERT INTO main_menu VALUES(49, "Coffee Frappuccino®", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/coffeefrapp.jpg', TRUE);
INSERT INTO main_menu VALUES(50, "Dark Mocha Frappuccino®", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/darkmochafrapp.jpg', TRUE);
INSERT INTO main_menu VALUES(51, "Espresso Frappuccino®", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/espressofrapp.jpg', TRUE);
INSERT INTO main_menu VALUES(52, "Java Chip Frappuccino®", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/javachipfrapp.jpg', TRUE);
INSERT INTO main_menu VALUES(53, "Mocha Frappuccino®", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/mochafrapp.jpg', TRUE);
INSERT INTO main_menu VALUES(54, "White Chocolate Mocha Frappuccino®", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/whitechocolatemochafrapp.jpg', TRUE);
INSERT INTO main_menu VALUES(55, "Chai Frappuccino®", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/chaifrapp.jpg', TRUE);
INSERT INTO main_menu VALUES(56, "Cotton Candy Frappuccino®", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Promo/9.5-Autumn-2019/cotton-candy.png', TRUE);
INSERT INTO main_menu VALUES(57, "Double Chocolate Chip Frappuccino®", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/doublechocchipfrapp.jpg', TRUE);
INSERT INTO main_menu VALUES(58, "Green Tea Frappuccino®", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/greenteafrapp.jpg', TRUE);
INSERT INTO main_menu VALUES(59, "Lemon Bar Frappuccino®", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Promo/9.5-Autumn-2019/lemon-bar.png', TRUE);
INSERT INTO main_menu VALUES(60, "Strawberries & Creme Frappuccino®", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/strawberriescreamfrapp.jpg', TRUE);
INSERT INTO main_menu VALUES(61, "Vanilla Frappuccino®", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/vanillafrapp.jpg', TRUE);
INSERT INTO main_menu VALUES(62, "White Chocolate Frappuccino®", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/processed-2013/whitechocolatefrapp.jpg', TRUE);
INSERT INTO main_menu VALUES(63, "Flavoured Steamed Milk", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/Beverages/steamed_milk.jpg', TRUE);
INSERT INTO main_menu VALUES(64, "Bakery", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/NEW-Photos-2016/Food/bakery.jpg', TRUE);
INSERT INTO main_menu VALUES(65, "Cakes, Slices & Cookies", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/NEW-Photos-2016/Food/cakes-slices.jpg', TRUE);
INSERT INTO main_menu VALUES(66, "Sandwiches & Wraps", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/NEW-Photos-2016/Food/sandwiches-wraps.jpg', TRUE);
INSERT INTO main_menu VALUES(77, "Savoury Bites", "regular", 4.5, 'https://assets.mystarbucks.com.au/imagecache/bestfit/288x288/_files/NEW-Photos-2016/Food/savoury-bites.jpg', TRUE);

INSERT INTO chain_menu VALUES(1,12);
INSERT INTO chain_menu VALUES(1,13);
INSERT INTO chain_menu VALUES(1,14);
INSERT INTO chain_menu VALUES(1,15);
INSERT INTO chain_menu VALUES(1,16);
INSERT INTO chain_menu VALUES(1,50);
INSERT INTO chain_menu VALUES(1,56);
INSERT INTO chain_menu VALUES(1,64);
INSERT INTO chain_menu VALUES(1,66);

INSERT INTO chain_menu VALUES(2,17);
INSERT INTO chain_menu VALUES(2,18);
INSERT INTO chain_menu VALUES(2,19);
INSERT INTO chain_menu VALUES(2,20);
INSERT INTO chain_menu VALUES(2,23);
INSERT INTO chain_menu VALUES(2,24);
INSERT INTO chain_menu VALUES(2,25);
INSERT INTO chain_menu VALUES(2,26);
INSERT INTO chain_menu VALUES(2,34);
INSERT INTO chain_menu VALUES(2,35);
INSERT INTO chain_menu VALUES(2,36);
INSERT INTO chain_menu VALUES(2,37);
INSERT INTO chain_menu VALUES(2,38);

INSERT INTO chain_menu VALUES(3,12);
INSERT INTO chain_menu VALUES(3,13);
INSERT INTO chain_menu VALUES(3,22);
INSERT INTO chain_menu VALUES(3,23);
INSERT INTO chain_menu VALUES(3,50);
INSERT INTO chain_menu VALUES(3,51);
INSERT INTO chain_menu VALUES(3,52);
INSERT INTO chain_menu VALUES(3,53);
INSERT INTO chain_menu VALUES(3,54);
INSERT INTO chain_menu VALUES(3,56);

INSERT INTO chain_menu VALUES(4,40);
INSERT INTO chain_menu VALUES(4,41);
INSERT INTO chain_menu VALUES(4,42);
INSERT INTO chain_menu VALUES(4,43);
INSERT INTO chain_menu VALUES(4,44);
INSERT INTO chain_menu VALUES(4,45);
INSERT INTO chain_menu VALUES(4,46);
INSERT INTO chain_menu VALUES(4,47);
INSERT INTO chain_menu VALUES(4,48);
INSERT INTO chain_menu VALUES(4,49);
INSERT INTO chain_menu VALUES(4,50);
INSERT INTO chain_menu VALUES(4,51);

INSERT INTO chain_menu VALUES(5,20);
INSERT INTO chain_menu VALUES(5,21);
INSERT INTO chain_menu VALUES(5,22);
INSERT INTO chain_menu VALUES(5,23);
INSERT INTO chain_menu VALUES(5,24);
INSERT INTO chain_menu VALUES(5,25);
INSERT INTO chain_menu VALUES(5,27);
INSERT INTO chain_menu VALUES(5,28);
INSERT INTO chain_menu VALUES(5,29);
INSERT INTO chain_menu VALUES(5,30);


INSERT INTO order_hist_details VALUES('1',12, 3);
INSERT INTO order_hist_details VALUES('2',22, 5);
INSERT INTO order_hist_details VALUES('3',23, 1);
INSERT INTO order_hist_details VALUES('4',16, 10);
INSERT INTO order_hist_details VALUES('5',20, 3);
INSERT INTO order_hist_details VALUES('6',30, 8);
INSERT INTO order_hist_details VALUES('7',55, 22);
INSERT INTO order_hist_details VALUES('8',44, 9);
INSERT INTO order_hist_details VALUES('9',34, 20);
INSERT INTO order_hist_details VALUES('10',14, 45);
INSERT INTO order_hist_details VALUES('11',56, 29);

INSERT INTO order_hist VALUES('1', 456, '2000-12-12', 3);
INSERT INTO order_hist VALUES('2', 458, '2021-09-03', 4);
INSERT INTO order_hist VALUES('3', 459, '2021-09-04', 5);
INSERT INTO order_hist VALUES('4', 459, '2000-12-12', 1);
INSERT INTO order_hist VALUES('5', 500, '2000-12-12', 2);
INSERT INTO order_hist VALUES('6', 500, '2000-12-12', 5);
INSERT INTO order_hist VALUES('7', 511, '2000-12-12', 4);
INSERT INTO order_hist VALUES('8', 511, '2000-12-12', 3);
INSERT INTO order_hist VALUES('9', 511, '2000-12-12', 2);
INSERT INTO order_hist VALUES('10', 512, '2000-12-12', 1);
INSERT INTO order_hist VALUES('11', 512, '2000-12-12', 3);

INSERT INTO ratings VALUES(456, 3, 4, "Great service, I loved it", '2020-11-12');
INSERT INTO ratings VALUES(458, 1, 3, "I strongly recommend people to there", '2020-12-12');
INSERT INTO ratings VALUES(500, 2, 5, "awesome customer care", '2021=06-04');
INSERT INTO ratings VALUES(456, 4, 2, "I do not recommend anyone this places", '2020-09-02');
INSERT INTO ratings VALUES(512, 5, 4, "Iced Caffè Mocha is the best", '2020-08-09');
INSERT INTO ratings VALUES(511, 1, 3, "the barrister was fantastic and friendly", '2021-06-09');

INSERT INTO supplier VALUES(100, "Black Ivory Coffee");
INSERT INTO supplier VALUES(200, "Dairy Board ltd");
INSERT INTO supplier VALUES(300, "Hullets Sugars");
INSERT INTO supplier VALUES(400, "Honey Bee ltd");
INSERT INTO supplier VALUES(500, "Benders Cups");

INSERT INTO supplies VALUES(1, "Coffe beans", 100);
INSERT INTO supplies VALUES(2, "Milk", 200);
INSERT INTO supplies VALUES(3, "Sugar", 300);
INSERT INTO supplies VALUES(4, "Honey", 400);
INSERT INTO supplies VALUES(5, "cups", 500);

INSERT INTO supply_inventory VALUES(1, 1, 20, "https://assets.mystarbucks.com.au/imagecache/bestfit/288x166/_files/NEW-Photos-2016/Packaged-coffee/veranda-stamp.png");
INSERT INTO supply_inventory VALUES(2, 1, 12, "https://assets.mystarbucks.com.au/imagecache/bestfit/288x166/_files/NEW-Photos-2016/Packaged-coffee/willow-stamp.png");
INSERT INTO supply_inventory VALUES(3, 1, 34, "https://assets.mystarbucks.com.au/imagecache/bestfit/288x166/_files/NEW-Photos-2016/Packaged-coffee/breakfast-stamp.png");
INSERT INTO supply_inventory VALUES(4, 2, 55, "https://assets.mystarbucks.com.au/imagecache/bestfit/288x166/_files/NEW-Photos-2016/Packaged-coffee/colombia-stamp.png");
INSERT INTO supply_inventory VALUES(5, 2, 66, "https://assets.mystarbucks.com.au/imagecache/bestfit/288x166/_files/NEW-Photos-2016/Packaged-coffee/ethiopia-stamp.png");
INSERT INTO supply_inventory VALUES(1, 2, 77, "https://assets.mystarbucks.com.au/imagecache/bestfit/288x166/_files/NEW-Photos-2016/Packaged-coffee/guatemala-stamp.png");
INSERT INTO supply_inventory VALUES(2, 2, 70, "https://assets.mystarbucks.com.au/imagecache/bestfit/288x166/_files/NEW-Photos-2016/Packaged-coffee/house-stamp.png");
INSERT INTO supply_inventory VALUES(3, 3, 23, "https://assets.mystarbucks.com.au/imagecache/bestfit/288x166/_files/NEW-Photos-2016/Packaged-coffee/kenya-stamp.png");
INSERT INTO supply_inventory VALUES(4, 3, 45, "https://assets.mystarbucks.com.au/imagecache/bestfit/288x166/_files/NEW-Photos-2016/Packaged-coffee/pike-stamp.png");
INSERT INTO supply_inventory VALUES(5, 3, 67, "https://assets.mystarbucks.com.au/imagecache/bestfit/288x166/_files/NEW-Photos-2016/Packaged-coffee/verona-s.png");
INSERT INTO supply_inventory VALUES(1, 3, 71, "https://assets.mystarbucks.com.au/imagecache/bestfit/288x166/_files/NEW-Photos-2016/Packaged-coffee/komodo-stamp.png");
INSERT INTO supply_inventory VALUES(2, 4, 5, "https://assets.mystarbucks.com.au/imagecache/bestfit/288x166/_files/NEW-Photos-2016/Packaged-coffee/espresso-stamp.png");
INSERT INTO supply_inventory VALUES(3, 4, 10, "https://assets.mystarbucks.com.au/imagecache/bestfit/288x166/_files/NEW-Photos-2016/Packaged-coffee/french-stamp.png");
INSERT INTO supply_inventory VALUES(4, 4, 12, "https://assets.mystarbucks.com.au/imagecache/bestfit/288x166/_files/NEW-Photos-2016/Packaged-coffee/italianstamp.png");
INSERT INTO supply_inventory VALUES(5, 5, 45, "https://assets.mystarbucks.com.au/imagecache/bestfit/288x166/_files/NEW-Photos-2016/Packaged-coffee/sumatra-stamp.png");

INSERT INTO chain_facility VALUES(1, FALSE, TRUE, FALSE, TRUE, TRUE);
INSERT INTO chain_facility VALUES(2, TRUE, TRUE, TRUE, FALSE, TRUE);
INSERT INTO chain_facility VALUES(3, FALSE, TRUE, TRUE, FALSE, TRUE);
INSERT INTO chain_facility VALUES(4, TRUE, FALSE, TRUE, TRUE, TRUE);
INSERT INTO chain_facility VALUES(5, FALSE, TRUE, TRUE, FALSE, TRUE);

