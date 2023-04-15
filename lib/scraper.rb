require 'nokogiri'
require 'open-uri'

def scrape(keyword)
  # filepath = "results.html"
  # 1. We get the HTML page content
  # html_content = File.open(filepath)
  url = "https://www.etsy.com/search?q=#{keyword}&ref=search_bar"
  # 2. We build a Nokogiri document from this file
  html_content = URI.open(url).read
  doc = Nokogiri::HTML.parse(html_content)
  etsy_list = {
    # key => value
  }
  # 3. We search for the correct elements containing the items' title in our HTML doc
  doc.search('.v2-listing-card__info .v2-listing-card__title').first(5).each do |element|
    # 4. For each item found, we extract its title and print it
    gift = element.text.strip.split.first(4).join(" ")
    etsy_list[gift] = false
  end
  etsy_list
end

# p scrape("socks")
# turn this code into a method
# Use keyword to get the right results (ONLY after everything works with the local file)
# .take(5) / .first(5)
# This method should return a HASH with 5 etsy gifts
