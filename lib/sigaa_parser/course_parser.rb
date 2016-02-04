module SigaaParser
  class CourseParser
    include SigaaParser::Cacheable
    include SigaaParser::MenuNavigator

    def initialize(browser = nil)
      @browser = browser
    end

    def cache_name(code)
      "course-#{code}"
    end

    def retrieve_and_parse(code)
      parse(retrieve(code))
    end

    # @return [String] HTML content of the page
    def retrieve(code)
      # Look for cached version
      cache_name = cache_name(code)
      return File.read(retrieve_cache_path(cache_name)) if has_cached?(cache_name)

      # Go to main page if this page has no menu
      go_to_main_page unless page_has_menu?

      # Go to the page by accessing the menu
      @browser.span(text: 'Ensino').hover
      @browser.td(text: 'Consultar Componente Curricular').click

      # Finds label, go to <td>, go to <tr>, find <td>s, get last, find inputs, get last
      # Fill the course code on the form
      @browser.labels(for: 'checkCodigo').first.parent.parent.tds.last.text_fields.last.set code

      # Submit the form
      @browser.button(text: 'Buscar').click

      # Click on the first result on the table
      # 2nd element because 1st one is on the legend
      @browser.images(src: "/sigaa/img/view.gif")[1].click

      # Store on cache
      store_cache(cache_name, @browser.html)

      @browser.html
    end

    def parse(html_string)
      page = Nokogiri::HTML(html_string)

      code = page.search("//th[contains(., 'Código')]/following-sibling::td[1]").text.remove_tabulation
      name = page.search("//th[contains(., 'Nome')]/following-sibling::td[1]").text.remove_tabulation

      course = SigaaParser::Course.new(code, name)

      table = page.search('//caption[contains(., "Expressões específicas de currículo cadastradas para este componente")]/parent::*')

      table.search('tr').to_a.from(1).each do |row|
        # Ex: "CIÊNCIAS DA COMPUTAÇÃO (BACHARELADO)/CI - João Pessoa - 2006.1 - 162006"
        curriculum_name = row.search('td')[0].text.remove_tabulation
        prerequisite_codes = parse_prerequisites(row.search('td')[2].text.remove_tabulation)

        prerequisites = SigaaParser::Prerequisites.new(curriculum_name)

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