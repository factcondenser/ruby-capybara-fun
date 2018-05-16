require 'capybara'
session = Capybara::Session.new(:selenium)
session.visit "http://www.amberbit.com"

puts(session)
if session.has_content?("Ruby on Rails")
  puts "All shiny, captain!"
else
  puts ":( no tagline fonud, possibly something's broken"
  exit(-1)
end
