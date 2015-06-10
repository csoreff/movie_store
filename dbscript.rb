#!/usr/bin/ruby

require 'sqlite3'

begin
  db = SQLite3::Database.open 'database.db'
  db.execute "CREATE TABLE IF NOT EXISTS dvds(sku INTEGER PRIMARY KEY,
    movie_name VARCHAR(45), release_year VARCHAR(4), num_in_inventory INT,
    minutes INT, price DECIMAL)"
  db.execute "INSERT INTO dvds VALUES(12345,'Braveheart', '1995', 6, 182, 9.99)"
  db.execute "INSERT INTO dvds VALUES(23456,'Zoolander', '2001', 5, 105, 8.99)"
  db.execute "INSERT INTO dvds VALUES(34567,'Anchorman', '2004', 7, 104, 7.99)"
  db.execute "INSERT INTO dvds VALUES(45678,'Troy', '2004', 3, 196, 9.99)"
  db.execute "INSERT INTO dvds VALUES(56789,'Lethal Weapon', '1987', 2, 117, 5.99)"
  db.execute "INSERT INTO dvds VALUES(98765,'Avatar', '2009', 4, 178, 13.99)"
  db.execute "INSERT INTO dvds VALUES(87654,'Enter the Dragon', '1973', 1, 110, 4.99)"
  db.execute "INSERT INTO dvds VALUES(76543,'Kill Bill', '2003', 1, 112, 6.99)"


  db.execute "CREATE TABLE IF NOT EXISTS employees(employee_id INTEGER PRIMARY KEY,
    store_num INTEGER, first_name VARCHAR(45), last_name VARCHAR(45), password VARCHAR(20),
    FOREIGN KEY (store_num) REFERENCES stores(store_num))"
  db.execute "INSERT INTO employees VALUES(1, 01, 'Corey', 'LeBlanc', 'password1')"
  db.execute "INSERT INTO employees VALUES(2, 02, 'Jane', 'Doe', 'password2')"
  db.execute "INSERT INTO employees VALUES(3, 03, 'Batman', 'Robin', 'password3')"

  db.execute "CREATE TABLE IF NOT EXISTS stores(store_num INTEGER PRIMARY KEY,
    address VARCHAR(45))"
  db.execute "INSERT INTO stores VALUES(01, '1 Main Street, Framingham, MA 01701')"
  db.execute "INSERT INTO stores VALUES(02, '1 Random Road, Boston, MA 02115')"
  db.execute "INSERT INTO stores VALUES(03, '1 Fake Terrace, Malden, MA 02145')"

  db.execute "CREATE TABLE IF NOT EXISTS customers(customer_id INTEGER PRIMARY KEY,
    address VARCHAR(45), f_name VARCHAR(45), l_Name VARCHAR(45))"
  db.execute "INSERT INTO customers VALUES(4321, '1 Blah Street', 'James', 'Smith')"

  db.execute "CREATE TABLE IF NOT EXISTS sales_history(sku INTEGER, customer_id INTEGER,
    price DECIMAL, store_num INTEGER, PRIMARY KEY (sku, customer_id), FOREIGN KEY (sku)
    REFERENCES dvds(sku), FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (store_num) REFERENCES stores(store_num))"

rescue SQLite3::Exception => e
  puts 'Exception occured'
  puts e
ensure
  db.close if db
end
