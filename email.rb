module Email
  require 'mail'

  OPTIONS = { address: "smtp.gmail.com",
              port: 587,
              user_name: ENV['GMAIL_USERNAME'],
              password: ENV['GMAIL_PASSWORD'],
              authentication: 'plain',
              enable_starttls_auto: true
            }

  def Email.text_email(data)
    res = ""
    data.each do |post|
      res << "\n#{post[:title]}\n#{post[:link]}\n"
    end
    res
  end

  def Email.send_email(data, domain)
    Mail.defaults { delivery_method :smtp, OPTIONS}

    Mail.deliver do 
      from ENV['GMAIL_USERNAME']
      to ENV['GMAIL_USERNAME']
      subject "Your daily #{domain} feed"
      body Email.text_email(data)
    end
  end
end