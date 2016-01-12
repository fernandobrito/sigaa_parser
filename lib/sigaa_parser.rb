require "sigaa_parser/version"

require 'mechanize'

begin
  require 'launchy'

  class Mechanize::Page
    def open_in_browser
      if body
        file = File.new("/tmp/#{Time.now.to_i}.html", 'w')
        file.write body
        Launchy.open "file://#{file.path}"
        # system "sleep 2 && rm #{file.path} &"
      end
    end
  end
rescue LoadError
end

class SigaaParser
  def initialize(url)
    @url = url
    @agent = Mechanize.new
  end

  def authenticate(login, password)
    # Login
    page = @agent.get('https://sigaa.ufpb.br/sigaa/verTelaLogin.do')
    form = page.forms.first

    form.field_with(name: 'user.login').value = ''
    form.field_with(name: 'user.senha').value = ''

    page = form.submit

    # Choose enrollment (optional?)
    page = @agent.get('https://sigaa.ufpb.br/sigaa/escolhaVinculo.do?dispatch=escolher&vinculo=1')

    # Save some data
    @student_id = page.search("//td[contains(., 'Matrícula')]/following-sibling::td[1]").text.strip
    @program = page.search("//td[contains(., 'Curso:')]/following-sibling::td[1]").text.strip
  end

  def get_program_structure
    params = 'form_menu_discente=form_menu_discente&id=149639&jscook_action=form_menu_discente_j_id_jsp_648669378_2_menu%3AA%5D%23%7B+curriculo.popularBuscaGeral+%7D&javax.faces.ViewState=j_id16'

    page = @agent.post(
        'https://sigaa.ufpb.br/sigaa/geral/estrutura_curricular/busca_geral.jsf',
        params,
        {'Content-Type' => 'application/x-www-form-urlencoded'})

  end
end
