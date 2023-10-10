# About this project

I slapped this together in a single evening to automate the process of getting my girlfriend's schedule from her uni website.
It just works tbh.


## Requirements : 
Ruby installed ( coded in ruby 3.2.2, untested everywhere else )
The gems  installed localy
Chrome or chromium to run ferrum (the headless browser used to crawl the pages)
A .env file containing these informations : 
- WEBHOOK_URL
- EMAIL
- PASSWORD

## How to run : 

Install the gems using `bundle install` then simply run the schedule_notifier.rb.
If you want to keep the screenshot that the program takes, then pass 'debug' as such : `ruby schedule_notifier.rb debug`
