module SigaaParser
  class AuthenticationFailed < Exception ; end

  class Parser
    attr_accessor :agent

    # @return [SigaaParser::StateViewId] the associated StateViewID
    attr_accessor :state_id

    def initialize
      @agent = Mechanize.new
      @state_id = SigaaParser::StateViewId.new(self)
    end

    def authenticate!
      # Login
      fill_and_submit_login_form(ENV['SIGAA_USERNAME'], ENV['SIGAA_PASSWORD'])

      # Choose enrollment (optional?)
      page = @agent.get('https://sigaa.ufpb.br/sigaa/escolhaVinculo.do?dispatch=escolher&vinculo=1')

      # Parse student data
      return parse_student_data(page)
    end

    def fill_and_submit_login_form(login, password)
      # Request page
      page = @agent.get('https://sigaa.ufpb.br/sigaa/verTelaLogin.do')

      # Fill form
      form = page.forms.first
      form.field_with(name: 'user.login').value = login
      form.field_with(name: 'user.senha').value = password
      page = form.submit

      # Check if login worked
      if page.search('//*[@id="conteudo"]/center[2]').text.include?('inválidos')
        raise SigaaParser::AuthenticationFailed.new('Authentication failed. Please check your username and password.')
      end
    end

    def parse_student_data(page)
      id = page.search("//td[contains(., 'Matrícula')]/following-sibling::td[1]").text.remove_tabulation
      name = page.search('.nome').text.remove_tabulation
      program = page.search("//td[contains(., 'Curso:')]/following-sibling::td[1]").text.remove_tabulation

      SigaaParser::Student.new(id, name, program)
    end
  end
end