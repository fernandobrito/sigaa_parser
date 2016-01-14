module SigaaParser
  class AuthenticationFailed < Exception ; end

  class Parser
    def initialize
      @agent = Mechanize.new
    end

    def authenticate(login, password)
      # Login
      page = @agent.get('https://sigaa.ufpb.br/sigaa/verTelaLogin.do')
      form = page.forms.first

      form.field_with(name: 'user.login').value = login
      form.field_with(name: 'user.senha').value = password

      page = form.submit

      # Check if login worked
      if page.search('//*[@id="conteudo"]/center[2]').text.include?('inválidos')
        raise SigaaParser::AuthenticationFailed.new
      end

      # Choose enrollment (optional?)
      page = @agent.get('https://sigaa.ufpb.br/sigaa/escolhaVinculo.do?dispatch=escolher&vinculo=1')

      # Save some data
      id = page.search("//td[contains(., 'Matrícula')]/following-sibling::td[1]").text.remove_tabulation
      name = page.search('.nome').text.remove_tabulation
      program = page.search("//td[contains(., 'Curso:')]/following-sibling::td[1]").text.remove_tabulation

      return SigaaParser::Student.new(id, name, program)

      get_program_structure
    end

    def get_program_structure
      headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }

      url = 'https://sigaa.ufpb.br/sigaa/portais/discente/discente.jsf'
      #payload = 'menu%3Aform_menu_discente=menu%3Aform_menu_discente&id=149639&jscook_action=menu_form_menu_discente_j_id_jsp_1030614539_62_menu%3AA%5D%23%7B+curriculo.popularBuscaGeral+%7D&javax.faces.ViewState=j_id2'
      payload = 'menu:form_menu_discente=menu:form_menu_discente&id=149639&jscook_action=menu_form_menu_discente_j_id_jsp_1030614539_62_menu:A]#{ curriculo.popularBuscaGeral }&javax.faces.ViewState=j_id2'

      page = @agent.post(url, payload, headers)
      page.open_in_browser

      url = 'https://sigaa.ufpb.br/sigaa/geral/estrutura_curricular/busca_geral.jsf'
      # payload = 'busca=busca&busca%3AcheckCurso=on&busca%3Acurso=1626669&busca%3Amatriz=0&busca%3Acodigo=162006&busca%3Aj_id_jsp_648669378_450=Buscar&javax.faces.ViewState=j_id3'
      payload = 'busca=busca&busca:checkCurso=on&busca:curso=1626669&busca:matriz=0&busca:codigo=162006&busca:j_id_jsp_648669378_450=Buscar&javax.faces.ViewState=j_id3'

      page = @agent.post(url, payload, headers)
      page.open_in_browser

      url = 'https://sigaa.ufpb.br/sigaa/graduacao/curriculo/lista.jsf'
      payload = 'resultado=resultado&javax.faces.ViewState=j_id4&resultado%3Arelatorio=resultado%3Arelatorio&id=940'

      page = @agent.post(url, payload, headers)
      page.open_in_browser
    end
  end
end