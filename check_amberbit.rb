session = if ARGV[0] != 'phantomjs'
  require 'capybara'
  Capybara::Session.new(:selenium)
else
  require 'capybara/poltergeist'
  Capybara::Session.new(:poltergeist)
end

session.visit "https://www.amberbit.com/blog/2014/2/12/automate-tasks-on-the-web-with-ruby-and-capybara/"

if session.has_content?("Ruby on Rails web development")
  puts "All shiny, captain!"
else
  puts ":( no tagline fonud, possibly something's broken"
  exit(-1)
end
