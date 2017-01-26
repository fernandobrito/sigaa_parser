module SigaaParser
  # Exception for failed authentication
  class AuthenticationFailed < RuntimeError ; end

  # Main scraper class. Includes authentication methods
  # and exposes browser to be used by parsers
  class Scraper
    def initialize
      watir = Watir::Browser.new :phantomjs, args: '--ssl-protocol=any'
      @browser = WatirAdapter.new(watir)

      @authenticated = false
    end

    # Return browser. If not authenticated yet, do it
    def browser
      authenticate! unless @authenticated

      @browser
    end

    def authenticate!
      # Login
      fill_and_submit_login_form(ENV['SIGAA_USERNAME'], ENV['SIGAA_PASSWORD'])

      # Choose enrollment (optional?)
      puts '=> Choosing enrollment'
      @browser.visit('https://sigaa.ufpb.br/sigaa/escolhaVinculo.do?dispatch=escolher&vinculo=1')

      # Parse student data
      parse_student_data(@browser.source_code)
    end

    def fill_and_submit_login_form(login, password)
      raise 'Empty username or password' if login.nil? || password.nil?

      # Request page
      puts '=> Logging in'
      @browser.visit('https://sigaa.ufpb.br/sigaa/verTelaLogin.do')

      # Fill form
      @browser.text_field(name: 'user.login').set login
      @browser.text_field(name: 'user.senha').set password

      # Submit form
      @browser.button(text: 'Entrar').click

      # Check if login worked
      if login_worked
        raise SigaaParser::AuthenticationFailed,
              'Authentication failed. Please check your username and password.'
      end

      @authenticated = true
    end

    # Parse details from the student
    # @return [Student]
    ID_XPATH = ".//td[contains(., 'Matrícula')]/following-sibling::td[1]"
    PROGRAM_XPATH = "//td[contains(., 'Curso:')]/following-sibling::td[1]"

    def parse_student_data(html_string)
      page = Nokogiri::HTML(html_string)

      id = page.search('#agenda-docente')
               .search(ID_XPATH)
               .text.remove_tabulation
      name = page.search('.nome').text.remove_tabulation
      program = page.search(PROGRAM_XPATH).text.remove_tabulation

      SigaaParser::Student.new(id, name, program)
    end

    protected

    def login_worked
      Nokogiri::HTML(@browser.source_code)
          .search('//*[@id="conteudo"]/center[2]')
          .text.include?('inválidos')
    end
  end
end
