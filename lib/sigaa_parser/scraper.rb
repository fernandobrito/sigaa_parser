module SigaaParser
  class AuthenticationFailed < Exception ; end

  class Scraper
    def initialize
      @browser = Watir::Browser.new :phantomjs, args: '--ssl-protocol=any'

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
      @browser.goto('https://sigaa.ufpb.br/sigaa/escolhaVinculo.do?dispatch=escolher&vinculo=1')

      # Parse student data
      return parse_student_data(@browser.html)
    end

    def fill_and_submit_login_form(login, password)
      raise 'Empty username or password' if login.nil? || password.nil?

      # Request page
      puts '=> Logging in'
      @browser.goto('https://sigaa.ufpb.br/sigaa/verTelaLogin.do')

      # Fill form
      @browser.text_field(:name => 'user.login').set login
      @browser.text_field(:name => 'user.senha').set password

      # Submit form
      @browser.button(:text => 'Entrar').click

      # Check if login worked
      if Nokogiri::HTML(@browser.html).search('//*[@id="conteudo"]/center[2]').text.include?('inválidos')
        raise SigaaParser::AuthenticationFailed.new('Authentication failed. Please check your username and password.')
      end

      @authenticated = true
    end

    # Parse details from the student
    # @return [Student]
    def parse_student_data(html_string)
      page = Nokogiri::HTML(html_string)

      id = page.search('#agenda-docente')
               .search(".//td[contains(., 'Matrícula')]/following-sibling::td[1]")
               .text.remove_tabulation
      name = page.search('.nome').text.remove_tabulation
      program = page.search("//td[contains(., 'Curso:')]/following-sibling::td[1]").text.remove_tabulation

      SigaaParser::Student.new(id, name, program)
    end
  end
end