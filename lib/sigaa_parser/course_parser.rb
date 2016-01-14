module SigaaParser
  class CourseParser
    include SigaaParser::Cacheable

    attr_reader :view_state_id

    def initialize
    end

    def cache_name(code)
      "course-#{code}"
    end

    def retrieve(parser, code)
      agent = parser.agent

      cache_name = cache_name(code)
      return agent.get('file:///' + retrieve_cache_path(cache_name)) if has_cached?(cache_name)

      headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }

      sleep(1)

      url = 'https://sigaa.ufpb.br/sigaa/portais/discente/discente.jsf'
      payload = "menu:form_menu_discente=menu:form_menu_discente&id=149639&jscook_action=menu_form_menu_discente_j_id_jsp_1030614539_62_menu:A]\#{ componenteCurricular.popularBuscaDiscente }&javax.faces.ViewState=j_id#{parser.state_id.get_and_increment}"
      page = agent.post(url, payload, headers)

      if page.search('//h2[contains(., "Consulta Geral de Componentes Curriculares")]').empty?
        raise 'Something went wrong!'
      end

      sleep(1)

      url = 'https://sigaa.ufpb.br/sigaa/geral/componente_curricular/busca_geral.jsf'
      payload = "formBusca=formBusca&formBusca:checkNivel=on&formBusca:j_id_jsp_34245291_634=G&formBusca:checkCodigo=on&formBusca:j_id_jsp_34245291_638=#{code}&formBusca:j_id_jsp_34245291_640=&formBusca:form:idPreRequisito=&formBusca:form:nomeDisciplinaPreRequisito=&formBusca:form2:idCoRequisito=&formBusca:form2:nomeDisciplinaCoRequisito=&formBusca:form3:idEquivalencia=&formBusca:form3:nomeDisciplinaEquivalencia=&formBusca:Data_Inicial=&formBusca:dataFim=&formBusca:unidades=0&formBusca:tipos=0&formBusca:btnBuscar=Buscar&javax.faces.ViewState=j_id#{parser.state_id.get_and_increment}"
      page = agent.post(url, payload, headers)

      internal_id = page.search('//a[@title="Visualizar Componente Curricular"]').attr('onclick').text[/id,([0-9]*)/, 1]

      sleep(1)

      url = 'https://sigaa.ufpb.br/sigaa/geral/componente_curricular/busca_geral.jsf'
      payload = "j_id_jsp_34245291_671:j_id_jsp_34245291_672=j_id_jsp_34245291_671:j_id_jsp_34245291_672&id=#{internal_id}&j_id_jsp_34245291_671=j_id_jsp_34245291_671&javax.faces.ViewState=j_id#{parser.state_id.get}"
      page = agent.post(url, payload, headers)

      store_cache(cache_name, page.content)

      page
    end

    def parse(page)
      code = page.search("//th[contains(., 'Código')]/following-sibling::td[1]").text.remove_tabulation
      name = page.search("//th[contains(., 'Nome')]/following-sibling::td[1]").text.remove_tabulation

      course = SigaaParser::Course.new(code, name)

      table = page.search('//caption[contains(., "Expressões específicas de currículo cadastradas para este componente")]/parent::*')

      table.search('tr').to_a.from(1).each do |row|
        program_name = row.search('td')[0].text.remove_tabulation
        prerequisite_codes = parse_prerequisites(row.search('td')[2].text.remove_tabulation)

        prerequisites = SigaaParser::Prerequisites.new(program_name)

        prerequisite_codes.each do |prerequisite_code|
          prerequisites.add_course(Course.new(prerequisite_code))
        end

        course.add_prerequisites(prerequisites)
      end

      course
    end

    def parse_prerequisites(string)
      string.scan(/\d+/)
    end
  end
end