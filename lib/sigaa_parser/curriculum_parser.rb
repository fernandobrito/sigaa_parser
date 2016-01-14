require 'active_support/core_ext/array'

module SigaaParser
  class CurriculumParser
    # Name of the program
    def initialize(name = nil)
    end

    def retrieve(agent)
      headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }

      url = 'https://sigaa.ufpb.br/sigaa/portais/discente/discente.jsf'
      payload = 'menu:form_menu_discente=menu:form_menu_discente&id=149639&jscook_action=menu_form_menu_discente_j_id_jsp_1030614539_62_menu:A]#{ curriculo.popularBuscaGeral }&javax.faces.ViewState=j_id2'

      page = agent.post(url, payload, headers)
      page.open_in_browser

      url = 'https://sigaa.ufpb.br/sigaa/geral/estrutura_curricular/busca_geral.jsf'
      payload = 'busca=busca&busca:checkCurso=on&busca:curso=1626669&busca:matriz=0&busca:codigo=&busca:j_id_jsp_648669378_450=Buscar&javax.faces.ViewState=j_id3'

      page = agent.post(url, payload, headers)
      page.open_in_browser

      url = 'https://sigaa.ufpb.br/sigaa/graduacao/curriculo/lista.jsf'
      payload = 'resultado=resultado&javax.faces.ViewState=j_id4&resultado%3Arelatorio=resultado%3Arelatorio&id=940'

      page = agent.post(url, payload, headers)
      page.open_in_browser

      page
    end

    def parse(page)
      courses = []

      code = page.search("//th[contains(., 'Código')]/following-sibling::td[1]").text.remove_tabulation
      name = page.search("//th[contains(., 'Matriz Curricular')]/following-sibling::td[1]").text.remove_tabulation

      # This is the third table
      # STRANGE: cached page works with first line. Live page with second!
      table = page.search("#relatorio > table > tbody > tr > td > table")[2]
      table ||= page.search("#relatorio > table > tr > td > table")

      # - 1 for 0th semester
      # - 1 because everything is inside one big td
      semesters = table.search("//td[contains(., 'º Semestre')]").size - 2

      # The HTML is not structure at all. Very ugly parsing:
      # Split into groups
      rows = table.search("tr.componentes, tr.tituloRelatorio")

      # First group is empty, so remove it
      groupped_rows = rows.to_a.split{ |r| r.text.include? 'Semestre'}.from(1)

      groupped_rows.each_with_index do |group, index|
        group.each do |course_row|
          semester = index
          code = course_row.search('td')[0].text.strip
          name = course_row.search('td')[1].text.split('-').first.strip
          workload = course_row.search('td')[2].text.strip.gsub(/(\t|\n)/, '')
          type = course_row.search('td')[3].text.strip
          category = course_row.search('td')[4].text.strip

          course = SigaaParser::Course.new(code, name, semester, workload, type, category)

          courses << course
        end
      end

      courses
    end
  end
end