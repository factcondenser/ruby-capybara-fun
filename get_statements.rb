require 'capybara/dsl'
require 'selenium-webdriver'
require 'yaml'
require 'pry'

config = YAML.load_file('config.yml')
BMO_LOGIN = config['bmo']['login']
BMO_PASSWORD = config['bmo']['password']
BMO_SAVE_PATH = config['bmo']['save_path']
HSBC_ME_LOGIN = config['hsbc_me']['login']
HSBC_ME_PASSWORD = config['hsbc_me']['login']

class StatementsGetter
  include Capybara::DSL

  def initialize
    Capybara.register_driver :ffselenium do |app|
      profile = Selenium::WebDriver::Firefox::Profile.from_name 'ffselenium'
      # ("/Users/markcuipan/Library/Application Support/firefox/Profiles/744k648p.default")
      # profile['browser.download.folderList'] = 2
      # profile['browser.download.manager.showWhenStarting'] = false
      # profile['browser.download.dir'] = BMO_SAVE_PATH
      # profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/pdf'
      # profile['pdfjs.disabled'] = true
      # # disable Acrobat plugin for previewing PDFs in Firefox (if installed)
      # profile['plugin.scan.Acrobat'] = '99.0'
      # profile['plugin.scan.plid.all'] = false
      caps = Selenium::WebDriver::Remote::Capabilities.firefox(
        {
          firefox_profile: profile
        }
      )
      # driver = Selenium::WebDriver.for :remote, desired_capabilities: capabilities
      Capybara::Selenium::Driver.new(app, { browser: :firefox, desired_capabilities: caps })
    end

    Capybara.current_driver = :ffselenium
    Capybara.default_max_wait_time = 10
  end

  def get_bmo_statements(login, password)
    def load_account_options
      within '#eStatementForm' do
        return find_field('account').all('option')
      end
    end

    def load_year_options
      within '#eStatementForm' do
        return find_field('yearStatemement').all('option')
      end
    end

    visit 'https://www.bmoharris.com/main/personal'

    # login to personal banking
    within '#xyz' do
      fill_in 'Username', with: login
      fill_in 'password', with: password
      click_button 'signin'
    end

    top_nav = '#_ctl0_TopNavigation1'

    # get eStatements
    within top_nav do
      click_link 'Online Statements'
    end

    accounts = load_account_options.map(&:text)
    for i in 0..accounts.length-1
      puts "Account: #{accounts[i]}"
      load_account_options[i].select_option
      years = load_year_options.map(&:value)
      for j in 0..years.length-1
        load_year_options[j].select_option
        within '#eStatements' do
          within first('#listTableLinkBody') do
            statements = find_all('a').map(&:text)
            puts "#{years[j]}: #{statements.length} statement(s)"
            for k in 0..statements.length-1
              click_link statements[k]
            end
          end
        end
      end
      puts ""
    end

    puts 'DONE'

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

# hsbc_statements = getter.get_hsbc_statements(
#   [HSBC_ME_LOGIN, HSBC_MOM_LOGIN, HSBC_JOINT_LOGIN],
#   [HSBC_ME_PASSWORD, HSBC_MOM_PASSWORD, HSBC_JOINT_PASSWORD]
# )

# puts "Found #{bmo_statements.count} statements for BMO:"
# images.each do |img|
#   puts img
# end
#
# puts "Found #{images.count} pages using this image:"
# images.each do |img|
#   puts img
# end
