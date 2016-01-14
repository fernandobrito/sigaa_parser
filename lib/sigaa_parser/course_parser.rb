module SigaaParser
  class CourseParser
    include SigaaParser::Cacheable

    attr_reader :view_state_id

    def initialize
    end

    def cache_name(code)
      "course-#{code}"
    end

    def retrieve(agent, code)
      cache_name = cache_name(code)
      return agent.get('file:///' + retrieve_cache_path(cache_name)) if has_cached?(cache_name)

      headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }

      url = 'https://sigaa.ufpb.br/sigaa/portais/discente/discente.jsf'
      payload = 'menu:form_menu_discente=menu:form_menu_discente&id=149639&jscook_action=menu_form_menu_discente_j_id_jsp_1030614539_62_menu:A]#{ componenteCurricular.popularBuscaDiscente }&javax.faces.ViewState=j_id2'
      page = agent.post(url, payload, headers)

      if page.search('//h2[contains(., "Consulta Geral de Componentes Curriculares")]').empty?
        raise 'Something went wrong!'
      end

      url = 'https://sigaa.ufpb.br/sigaa/geral/componente_curricular/busca_geral.jsf'
      payload = 'formBusca=formBusca&formBusca:checkNivel=on&formBusca:j_id_jsp_34245291_634=G&formBusca:checkCodigo=on&formBusca:j_id_jsp_34245291_638=1107148&formBusca:j_id_jsp_34245291_640=&formBusca:form:idPreRequisito=&formBusca:form:nomeDisciplinaPreRequisito=&formBusca:form2:idCoRequisito=&formBusca:form2:nomeDisciplinaCoRequisito=&formBusca:form3:idEquivalencia=&formBusca:form3:nomeDisciplinaEquivalencia=&formBusca:Data_Inicial=&formBusca:dataFim=&formBusca:unidades=0&formBusca:tipos=0&formBusca:btnBuscar=Buscar&javax.faces.ViewState=j_id3'
      page = agent.post(url, payload, headers)

      url = 'https://sigaa.ufpb.br/sigaa/geral/componente_curricular/busca_geral.jsf'
      payload = 'j_id_jsp_34245291_671:j_id_jsp_34245291_672=j_id_jsp_34245291_671:j_id_jsp_34245291_672&id=3829&j_id_jsp_34245291_671=j_id_jsp_34245291_671&javax.faces.ViewState=j_id4'
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
        program_code = row.search('td')[0].text.split('-').last.remove_tabulation
        prerequisites = row.search('td')[2].text.remove_tabulation

        course.add_prerequisite(Course.new(prerequisites))
      end

      course
    end
  end
end