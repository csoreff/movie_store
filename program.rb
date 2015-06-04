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
                @db.execute("SELECT * FROM dvds WHERE sku = #{skuInput}") do |row|
                    puts "#{row[0]}   #{row[1]}       #{row[2]}    #{row[3]}           #{row[4]}        #{row[5]}"
                end


            when "2"
                puts "Inventory      Sku     Title"
                puts "---------     -----    ------"
                @db.execute("SELECT numInInventory, sku, movieName FROM dvds WHERE numInInventory > 0") do |row|
                    puts "#{row[0]}             #{row[1]}    #{row[2]}"

                end


            when "3"
                puts "Enter/Scan DVD Sku."
                saleSku = gets.chomp
                @db.execute "UPDATE dvds SET numInInventory = numInInventory - 1 WHERE sku = #{saleSku}"

            when "4"
                puts "Enter Sku."
                skuInsert = gets.chomp
                puts "Enter DVD title."
                titleInsert = gets.chomp
                puts "Enter release year."
                yearInsert = gets.chomp
                puts "Enter length of film in minutes."
                lengthInsert = gets.chomp
                puts "Enter price."
                priceInsert=gets.chomp

                #isThereInventory = @db.execute "SELECT sku FROM dvds WHERE sku = #{skuInsert}"
                @db.execute "INSERT INTO dvds VALUES(#{skuInsert}, '#{titleInsert}', '#{yearInsert}', 1, #{lengthInsert}, #{priceInsert})"

            when "5"
                puts "Enter sku of the DVD you wish to update."
                updateSku = gets.chomp
                puts "Enter the number of copies you are adding to inventory."
                updateQuantity = gets.chomp
                @db.execute "UPDATE dvds SET numInInventory = numInInventory + #{updateQuantity} WHERE sku = #{updateSku}"

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
	empID = gets.chomp
	puts "Enter Password:"
	passInput = gets.chomp

	empPass = @db.execute "SELECT password FROM employees WHERE employeeID = #{empID}"

	if empPass.flatten.first == passInput
	   menu
	end

	rescue SQLite3::Exception => e

    	puts "Exception occured"
    	puts e
    ensure
        @db.close if @db
end
