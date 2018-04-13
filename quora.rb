require 'selenium-webdriver'
require 'nokogiri'
require_relative 'email'

def get_data(search_url)
  driver = Selenium::WebDriver.for :chrome
  driver.navigate.to search_url
  feed_html = driver.page_source
  driver.quit
  feed = Nokogiri::HTML(feed_html)
  feed.css(".PagedListItem").map do |post|
    title = post.css(".question_text .rendered_qtext").text
    link = "https://www.quora.com#{post.css(".question_link").first['href']}"
    {title: title, link: link}
  end
end

begin 
  while true do
    keyword = "ruby on rails" 
    search_url = "https://www.quora.com/search?q=#{keyword}&time=day&type=answer"
    data = get_data(search_url)
    puts "Sending the email..."
    Email.send_email(data, "Quora")
    puts "Email sent!"
    a_day = 24*60*60
    sleep a_day
  end
rescue SystemExit, Interrupt
  puts " Program exited!"
end