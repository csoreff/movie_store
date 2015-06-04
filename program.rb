#!/usr/bin/ruby

require 'sqlite3'

begin

    def menu
        i = 0
        loop do
            puts "1. Find a dvd.","2. Display all current inventory.","3. Enter a sale.","4. Add a DVD to inventory.",
            "5. Update inventory.","6. Quit."

            input = gets.chomp

            case input
            when "1"
                puts "Enter sku"
                skuInput = gets.chomp
                    puts "Sku     Title            Year    Inventory    Minutes    Price"
                    puts "---     -----            ----    ---------    -------    -----"
                @db.execute("SELECT * FROM dvds WHERE sku = #{sku_input}") do |row|
                    puts "#{row[0]}   #{row[1]}       #{row[2]}    #{row[3]}           #{row[4]}        #{row[5]}"
                end


            when "2"
                puts "Inventory      Sku     Title"
                puts "---------     -----    ------"
                @db.execute("SELECT num_in_inventory, sku, movie_name FROM dvds WHERE num_in_inventory > 0") do |row|
                    puts "#{row[0]}             #{row[1]}    #{row[2]}"

                end


            when "3"
                puts "Enter/Scan DVD Sku."
                sale_sku = gets.chomp
                @db.execute "UPDATE dvds SET num_in_inventory = num_in_inventory - 1 WHERE sku = #{sale_sku}"

            when "4"
                puts "Enter Sku."
                sku_insert = gets.chomp
                puts "Enter DVD title."
                title_insert = gets.chomp
                puts "Enter release year."
                year_insert = gets.chomp
                puts "Enter length of film in minutes."
                length_insert = gets.chomp
                puts "Enter price."
                price_insert=gets.chomp

                #isThereInventory = @db.execute "SELECT sku FROM dvds WHERE sku = #{skuInsert}"
                @db.execute "INSERT INTO dvds VALUES(#{sku_insert}, '#{title_insert}', '#{year_insert}', 1, #{length_insert}, #{price_insert})"

            when "5"
                puts "Enter sku of the DVD you wish to update."
                update_sku = gets.chomp
                puts "Enter the number of copies you are adding to inventory."
                update_quantity = gets.chomp
                @db.execute "UPDATE dvds SET num_in_inventory = num_in_inventory + #{update_quantity} WHERE sku = #{update_sku}"

            when "6"
                puts "Goodbye!"
                i = 1
            else
                puts "Invalid option: #{input}"
            end

            break if i == 1
        end
    end

	@db = SQLite3::Database.open "database.db"
	puts "Enter Employee ID:"
	emp_id = gets.chomp
	puts "Enter Password:"
	pass_input = gets.chomp

	emp_pass = @db.execute "SELECT password FROM employees WHERE employee_id = #{emp_id}"

	if emp_pass.flatten.first == pass_input
	   menu
	end

	rescue SQLite3::Exception => e

    	puts "Exception occured"
    	puts e
    ensure
        @db.close if @db
end
