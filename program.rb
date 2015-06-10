#!/usr/bin/ruby

require 'sqlite3'

def find_dvd
  puts "Enter sku"
  skuInput = gets.chomp
  puts "Sku     Title            Year    Inventory    Minutes    Price"
  puts "---     -----            ----    ---------    -------    -----"
  @db.execute("SELECT * FROM dvds WHERE sku = #{sku_input}") do |row|
    puts "#{row[0]}   #{row[1]}       #{row[2]}    #{row[3]}           #{row[4]}        #{row[5]}"
  end
end

def display_all_inventory
  puts "Inventory      Sku     Title"
  puts "---------     -----    ------"
  @db.execute("SELECT num_in_inventory, sku, movie_name FROM dvds WHERE num_in_inventory > 0") do |row|
    puts "#{row[0]}             #{row[1]}    #{row[2]}"
  end
end

def enter_sale
  puts "Enter/Scan DVD Sku."
  sale_sku = gets.chomp
  @db.execute "UPDATE dvds SET num_in_inventory = num_in_inventory - 1 WHERE sku = #{sale_sku}"
end

def add_dvd_to_inv
  puts "Enter Sku."
  sku_insert = gets.chomp
  puts "Enter DVD title."
  title_insert = gets.chomp
  puts "Enter release year."
  year_insert = gets.chomp
  puts "Enter length of film in minutes."
  length_insert = gets.chomp
  puts "Enter price."
  price_insert = gets.chomp
  @db.execute "INSERT INTO dvds VALUES(#{sku_insert}, '#{title_insert}',
    '#{year_insert}', 1, #{length_insert}, #{price_insert})"
end

def update_inv
  puts "Enter sku of the DVD you wish to update."
  update_sku = gets.chomp
  puts "Enter the number of copies you are adding to inventory."
  update_quantity = gets.chomp
  @db.execute "UPDATE dvds SET num_in_inventory = num_in_inventory +
    #{update_quantity} WHERE sku = #{update_sku}"
end

def menu
  i = 0
  loop do
    puts "1. Find a dvd.","2. Display all current inventory.","3. Enter a sale.",
      "4. Add a DVD to inventory.", "5. Update inventory.","6. Quit."
    input = gets.chomp

    case input
    when "1"
      find_dvd
    when "2"
      display_all_inventory
    when "3"
      enter_sale
    when "4"
      add_dvd_to_inv
    when "5"
      update_inv
    when "6"
      puts "Goodbye!"
      i = 1
    else
      puts "Invalid option: #{input}"
    end
    break if i == 1
  end
end

begin
  menu
  @db = SQLite3::Database.open "database.db"
  puts "Enter Employee ID:"
  emp_id = gets.chomp
  puts "Enter Password:"
  pass_input = gets.chomp

  emp_pass = @db.execute "SELECT password FROM employees WHERE employee_id = #{emp_id}"

  menu if emp_pass.flatten.first == pass_input

  rescue SQLite3::Exception => e
    puts "Exception occured"
    puts e
  ensure
    @db.close if @db
end
