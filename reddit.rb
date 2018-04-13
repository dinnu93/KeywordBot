require 'httparty'
require 'nokogiri'
require 'mail'

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

def text_email(data)
  res = ""
  data.each do |post|
    res << "\n#{post[:title]}\n#{post[:link]}\n"
  end
  res
end

OPTIONS = { address: "smtp.gmail.com",
            port: 587,
            user_name: ENV['GMAIL_USERNAME'],
            password: ENV['GMAIL_PASSWORD'],
            authentication: 'plain',
            enable_starttls_auto: true
          }

def send_email(data)
  Mail.defaults { delivery_method :smtp, OPTIONS}

  Mail.deliver do 
    from ENV['GMAIL_USERNAME']
    to ENV['GMAIL_USERNAME']
    subject 'Here is the reddit feed you requested'
    body text_email(data)
  end
end

begin 
  while true do
    keyword = "ruby on rails" 
    subreddit = "" # "subreddit: ruby&"
    search_url = "https://www.reddit.com/search?q=#{subreddit}#{keyword}&t=day"
    data = get_data(search_url)
    puts "Sending the email..."
    send_email(data)
    a_day = 24*60*60
    sleep a_day
  end
rescue SystemExit, Interrupt
  puts " Program exited!"
end


