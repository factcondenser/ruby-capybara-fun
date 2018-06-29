require 'capybara/dsl'
require 'capybara'

class FakerRaker
  include Capybara::DSL

  def initialize
    Capybara.default_max_wait_time = 10
    # Capybara.default_driver = :selenium_chrome_headless
    Capybara.default_driver = :selenium
  end

  def get_gem_methods(gem_name)
    methods = []

    link = "https://www.rubydoc.info/gems/#{gem_name}"

    visit link

    within('#content') do
      if find('h1').text == 'Oops,'
        return nil
      end
    end

    puts "Retrieving methods from #{link}..."

    within_frame(find('#nav')) do
      within('#full_list_nav') { click_link 'Methods' }

      find('#full_list').all('div.item a').each do |a|
        methods << a[:title].split(' ')[0].sub(/\./, '#')
      end
    end

    methods
  end
end

methods = FakerRaker.new.get_gem_methods ARGV[0]

if methods
  puts "Found #{methods.count} methods for #{ARGV[0]}"
  methods.each do |method|
    puts method
  end
else
  puts "Couldn't find gem with name '#{ARGV[0]}' on www.rubydoc.info"
end
