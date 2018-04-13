require 'httparty'
require 'json'
require_relative 'email'

HEADERS = { 'User-agent': 'KeywordBot App' }

def get_data(search_url)
  response = HTTParty.get(search_url, headers: HEADERS)
  if response.code == 200
    feed_json = response.body
    feed = JSON.parse(feed_json)
    feed["hits"].map do |post|
      title = post["title"]
      link = post["url"]
      hacker_news_link = "https://news.ycombinator.com/item?id=#{post["objectID"]}"
      if link.nil?
        {title: title, link: hacker_news_link}
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
    keyword = "design" 
    yesterday = (Time.now - 24*60*60).to_i
    search_url = "https://hn.algolia.com/api/v1/search?query=#{keyword}&tags=story&page=0&numericFilters=created_at_i>#{yesterday}"
    data = get_data(search_url)
    puts "Sending the email..."
    Email.send_email(data,"Hacker News")
    puts "Email sent!"
    a_day = 24*60*60
    sleep a_day
  end
rescue SystemExit, Interrupt
  puts " Program exited!"
end