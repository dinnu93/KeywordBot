# KeywordBot
A bot which periodically checks forums, social media sites, news sites to monitor certain keywords and email the report at the end of the day.

* ## Usage
  * [Let less secure apps access your account](https://support.google.com/accounts/answer/6010255?hl=en)
  * Add the following environment variables before running the scripts.
    * GMAIL_USERNAME = "your gmail address"
    * GMAIL_PASSWORD = "your gmail password"
  * Change the keyword variable in reddit.rb or hacker_news.rb
  * Specify a subreddit to search in reddit.rb(**optional**)
  * run the ruby script: *ruby reddit.rb* or *ruby hacker_news.rb*

