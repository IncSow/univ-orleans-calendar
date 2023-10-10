require 'discord_notifier'
require 'date'
require 'ferrum'
require 'dotenv'
Dotenv.load

Discord::Notifier.setup do |config|
    config.url = ENV['WEBHOOK_URL']
    config.username = 'Schedule'
    config.wait = true
  end

browser = Ferrum::Browser.new
browser.go_to("https://auth.univ-orleans.fr/cas/login?service=https://ent.univ-orleans.fr/uPortal/Login%3FrefUrl%3D%2FuPortal%2Ff%2Faccueil%2Fnormal%2Frender.uP")
browser.at_css("input#username").focus.type(ENV['EMAIL'])
browser.at_css("input#password").focus.type(ENV['PASSWORD'])
browser.at_css("button[type='submit']").focus.click
browser.network.wait_for_idle
browser.go_to('https://aderead2022.univ-orleans.fr/direct/myplanning.jsp')
browser.network.wait_for_idle
browser.screenshot(path: "schedule.png", selector: ".planningPanel")
browser.quit

schedule_image = File.open('schedule.png')
date_today = Date.today.strftime('%a %d %b %Y') 
Discord::Notifier.message(schedule_image, content: "Today is #{date_today} and here is the planning for this week!")
File.delete('schedule.png') unless ARGV[0] === 'debug'
