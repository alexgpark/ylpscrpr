
require 'open-uri'
require 'nokogiri'
require 'curb'
require "csv"
require 'watir-webdriver'
#require_relative 'crawler'

# theURLS = ["https://www.yelp.com/search?find_desc=consultant&find_loc=Chicago,+IL&start=10"]
# url = "https://www.yelp.com/search?find_desc=consultant&find_loc=Chicago,+IL&start=10"
# page = Nokogiri::HTML(open(url))

urls = []
yelp_root_url = 'http://www.yelp.com'
yelp_url      = 'https://www.yelp.com/search?find_desc=hostel&find_loc=Charleston,+SC&cflt=tours,bedbreakfast,vacation_rentals,walkingtours,historicaltours,hostels&start='
paged_count   = 0
browser  = Watir::Browser.new

while paged_count < 200 do  

  paged_url = "#{yelp_url}#{paged_count}"
  browser.goto paged_url

  loading_div = browser.div :class => 'yelp-spinner'
  Watir::Wait.until do
    loading_div.display.nil?
  end

  span_tag = browser.span :class => 'indexed-biz-name'
  span_tag.wait_until_present

  a_tags = browser.links :class => 'biz-name'
  urls   += a_tags.collect do |tag|
    tag.href
  end

  paged_count += 10
end

iteration = 0
new_browser = Watir::Browser.new

while iteration < 200 do
  current_url = urls[iteration]
  # current_url = "https://www.yelp.com/biz/siragusa-law-chicago-2"
  new_browser.goto current_url

  # if they don't have a website
  if new_browser.span(:class, 'biz-website').exists? == false
    # get the biz name
    # name = new_browser.h1(:class, 'biz-page-title').text

    # # if they don't have a phone number, just skip to the next bc its useless
    # if new_browser.span(:class, 'biz-phone').exists? == false
    #   iteration += 1
    # else
    #   # if they do have a phone number, get the phone number
    #   number = new_browser.span(:class, 'biz-phone').text

    #   if new_browser.span(:class, 'category-str-list').exists? == false
    #     # puts "#{name}: #{number} // #{current_url}"
    #     iteration += 1
    #   else
    #     category = new_browser.span(:class, 'category-str-list').a.text
    #     # puts "#{name}: #{number} // #{current_url} // #{category}"
    #     iteration += 1
    #   end
    # end

    iteration += 1
    
    next

  else
    site = new_browser.span(:class, 'biz-website').a.text

    # if no category, the print site + no category

    if new_browser.span(:class, 'category-str-list').exists? == false
      puts site
      # puts "No category"
      iteration += 1
    else
      category = new_browser.span(:class, 'category-str-list').a.text
      puts site
      # puts category
      iteration += 1
    end
    
  end
  
end