# Welcome the user
# Ask user what action they want to do
# Store the user answer in a variable
# Direct the user to the correct action
# Make it loop until user says 'quit'

# STEP 2 LIST
# Model out gift list (hash)
# Iterate over the gift_list .each_with_index do |(key, value), index|
 # format 
#  1 - [ ] sockets
#  2 - [X] ruby book
#  3 - [ ] macbook pro

# STEP 3 ADD
# Ask the user what do they want to add
# Store it in a variable
# Add the gift to the hash (CRUD Create hash_name[new_key] = new_value)
# Tell the user the gift was added

# STEP 4 DELETE
# Display the list
# Ask the user for the NUMBER of the gift they want to delete
# Store the number (index)
# gift = get the gift to delete (key) to use on the hash (.keys) - 2 steps
# Remove the gift (CRUD delete)
# Tell the user the item was deleted

# STEP 5 MARK
# Add mark action to the case and to the actions string
# Display the list
# Ask the user for the NUMBER of the gift they want to delete
# Store the number (index)
# gift = get the gift to delete (key) to use on the hash (.keys) - 2 steps
# Update the value of the item (CRUD Update hash_name[key] = new_value)
# Tell the user the item was marked

# STEP 6 Import from Etsy
# Ask the user what they want to search on Etsy
# Store the answer (keyword)
# Scrape etsy for 5 results => scraper.rb
# call the scrape method => returns a hash
# display the etsy hash
# index = Ask user to pick the number to import
# get the item from the etsy hash (.keys)
# add the gift from etsy to our gift_list
require 'csv'
require_relative "scraper"

def display_list(gift_list)
  gift_list.each_with_index do |(gift, purchased), index|
    x_mark = purchased ? "X" : " " 
    puts "#{index + 1} - [#{x_mark}] - #{gift}" 
  end 
end

# should return a hash with my gifts
def load_csv
  filepath    = 'gifts.csv'
  gift_list = {}
  CSV.foreach(filepath, col_sep: ',', quote_char: '"', headers: :first_row) do |row|
    # TODO: build new gift from information stored in each row
    gift_name = row["name"]
            # "true" == "true"
            # "false" == "true"
    value = row["purchased"] == "true" # this gives us a real boolean
    gift_list[gift_name] =  value
  end
  gift_list
end

def save_csv(gift_list)
  filepath    = 'gifts.csv'

  CSV.open(filepath, 'wb', col_sep: ',', force_quotes: true, quote_char: '"') do |csv|
    # We had headers to the CSV
    csv << ['name', 'purchased']
    #TODO: store each gift
    gift_list.each do |name, purchased|
      csv << [name, purchased]
    end
  end
end

gift_list = load_csv


puts "Welcome to out Christmas List!"
action = "anything but quit"
# loop
until action == "quit"
  puts "Which action [list|add|delete|mark|import|quit]?"

  action = gets.chomp

  case action # thing we want to compare
  when "list" # thing we compare it too
    display_list(gift_list)
  when "add" # thing we compare it too
    puts "What gift do you want to add?"
    gift = gets.chomp
    gift_list[gift] = false
    puts "#{gift} was added to the list."
    save_csv(gift_list)
  when "delete" # thing we compare it too
    display_list(gift_list)
    puts "What is the number of the gift you want to delete?"
    index = gets.chomp.to_i - 1
    gifts = gift_list.keys
    gift = gifts[index] # gift that I want to delete
    gift_list.delete(gift)
    puts "#{gift} was deleted."
    save_csv(gift_list)
  when "mark"
    display_list(gift_list)
    puts "What is the number of the gift you want to mark?"
    index = gets.chomp.to_i - 1
    gifts = gift_list.keys
    gift = gifts[index] # gift that I want to mark
    gift_list[gift] = !gift_list[gift]
    puts "#{gift} was #{gift_list[gift] ? "marked" : "unmarked"}"
    save_csv(gift_list)
  when "import"
    # Ask the user what they want to search on Etsy
    puts "What do you want to look for on Etsy?"
    # Store the answer (keyword)
    keyword = gets.chomp
    # Scrape etsy for 5 results => scraper.rb
    # call the scrape method => returns a hash
    etsy_list = scrape(keyword)
    # display the etsy hash
    display_list(etsy_list)
    # index = Ask user to pick the number to import
    puts "What number do you want to import?"
    index = gets.chomp.to_i - 1
    # get the item from the etsy hash (.keys)
    gifts = etsy_list.keys
    gift = gifts[index]
    # add the gift from etsy to our gift_list
    gift_list[gift] = false
    puts "#{gift} was imported in the list"
    save_csv(gift_list)
  when "quit"
    puts "Thanks for using Christmas List"
  else
    puts "Wrong action"
  end
end
# loop end
