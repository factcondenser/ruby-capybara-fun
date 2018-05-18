require 'capybara/dsl'
require 'yaml'
config = YAML.load_file('config.yml')
BMO_LOGIN = config['bmo']['login']
BMO_PASSWORD = config['bmo']['password']
HSBC_ME_LOGIN = config['hsbc_me']['login']
HSBC_ME_PASSWORD = config['hsbc_me']['login']

class StatementsGetter
  include Capybara::DSL

  def initialize
    Capybara.default_driver = :selenium
  end

  def get_bmo_statements(login, password)
    statements = []

    visit 'https://www.bmoharris.com/main/personal'

    within '#xyz' do
      fill_in 'Username', with: login
      fill_in 'password', with: password
      click_button 'signin'
    end

  #   return urls unless page.has_content?("Pages that include matching images")
  #
  #   while true
  #     page.all("h3.r a").each do |a|
  #       urls << a[:href]
  #     end
  #     within "#nav" do
  #       click_link "Next"
  #     end
  #   end
  #
  # rescue Capybara::ElementNotFound
  #   return urls.uniq
  end

  def get_hsbc_statements(logins, passwords)
  end
end

getter = StatementsGetter.new

bmo_statements = getter.get_bmo_statements(BMO_LOGIN, BMO_PASSWORD)

hsbc_statements = getter.get_hsbc_statements(
  [HSBC_ME_LOGIN, HSBC_MOM_LOGIN, HSBC_JOINT_LOGIN],
  [HSBC_ME_PASSWORD, HSBC_MOM_PASSWORD, HSBC_JOINT_PASSWORD]
)

puts "Found #{bmo_statements.count} statements for BMO:"
images.each do |img|
  puts img
end

puts "Found #{images.count} pages using this image:"
images.each do |img|
  puts img
end
