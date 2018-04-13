require 'httparty'
require 'nokogiri'
require_relative 'email'

HEADERS = { 'User-agent': 'KeywordBot App' }

def get_data(search_url)
  response = HTTParty.get(search_url, headers: HEADERS)
  if response.code == 200
    feed_html = response.body
    feed = Nokogiri::HTML(feed_html)
    feed.css(".search-result-link").map do |post|
      title = post.css(".search-title").text
      reddit_link = post.css(".search-title").first['href']
      link = post.css(".search-link").text
      if link.empty?
        {title: title, link: reddit_link}
      else
        {title: title, link: link}
      end
    end
  else
    nil
  end
end

begin 
  while true do
    keyword = "ruby on rails" 
    subreddit = "" # "subreddit: ruby&"
    search_url = "https://www.reddit.com/search?q=#{subreddit}#{keyword}&t=day"
    data = get_data(search_url)
    puts "Sending the email..."
    Email.send_email(data)
    a_day = 24*60*60
    sleep a_day
  end
rescue SystemExit, Interrupt
  puts " Program exited!"
end


