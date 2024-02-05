#!/usr/bin/ruby
# frozen_string_literal: true

require 'date'
require 'ferrum'
require 'dotenv'
Dotenv.load
require 'discord_notifier'
is_piercing_run = ARGV.include?"PIERCING"

username = is_piercing_run ? "PIERCING REMINDER" : "SCHEDULE"
avatar = is_piercing_run ? "https://www.laurabond.co.uk/cdn/shop/files/Facetune_20-03-2023-14-15-52_6b920d0d-8b67-4e59-9fb8-47284f3b8419.jpg?v=1688118376&" : "https://www.float.com/static/e9803907069ec2dbb8524a05903fd4ff/51f9d524-5bc9-487e-8ed7-11f6a405b88e_master-schedule.png"

Discord::Notifier.setup do |config|
    config.url = ENV['WEBHOOK_URL']
    config.avatar_url = avatar
    config.username = username
    config.wait = true
end

def get_image_from_calendar
  b = Ferrum::Browser.new
  b.go_to("https://auth.univ-orleans.fr/cas/login?service=https://ent.univ-orleans.fr/uPortal/Login%3FrefUrl%3D%2FuPortal%2Ff%2Faccueil%2Fnormal%2Frender.uP")
  b.at_css("input#username").focus.type(ENV['EMAIL'])
  b.at_css("input#password").focus.type(ENV['PASSWORD'])
  b.at_css("button[type='submit']").focus.click
  b.network.wait_for_idle
  b.go_to('https://aderead2022.univ-orleans.fr/direct/myplanning.jsp')
  b.network.wait_for_idle(timeout: 500)
  b.screenshot(path: "schedule.png", selector: ".planningPanel")
  b.quit
  send_latest_screenshot_to_discord

end

def send_latest_screenshot_to_discord
  schedule_image = File.open('schedule.png')
  date_today = Date.today.strftime('%a %d %b %Y')
  Discord::Notifier.message(schedule_image, content: "Today is #{date_today} and here is the planning for this week!")
  File.delete('schedule.png') unless ARGV[0] === 'debug'
end

def send_reminder_message_to_discord
  Discord::Notifier.message("Don't forget to clean your piercing <@689551457883652140> !")
end


if is_piercing_run
  send_reminder_message_to_discord
else
  get_image_from_calendar
end
