module SigaaParser
  # Retrieve and parse a course
  class CourseParser
    include SigaaParser::Cacheable
    include SigaaParser::MenuNavigator

    def initialize(scraper = nil)
      @scraper = scraper
    end

    def cache_name(code)
      "course-#{code}"
    end

    def retrieve_and_parse(code)
      parse(retrieve(code))
    end

    # @return [String] HTML content of the page
    def retrieve(code)
      if self.class.cache_enabled
        # Look for cached version
        cache_name = cache_name(code)
        return File.read(retrieve_cache_path(cache_name)) if cached_page?(cache_name)
      end

      navigate_to_right_page
      fill_and_submit_form(code)
      click_on_result

      # Store on cache
      store_cache_if_enabled(cache_name, browser.source_code)

      browser.source_code
    end

    CODE_XPATH = "//th[contains(., 'Código')]/following-sibling::td[1]"
    NAME_XPATH = "//th[contains(., 'Nome')]/following-sibling::td[1]"

    def parse(html_string)
      page = Nokogiri::HTML(html_string)

      code = page.search(CODE_XPATH).text.remove_tabulation
      name = page.search(NAME_XPATH).text.remove_tabulation

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

    protected

    def browser
      @scraper.browser
    end

    def navigate_to_right_page
      # Go to main page if this page has no menu
      go_to_main_page unless page_has_menu?

      # Go to the page by accessing the menu
      browser.span(text: 'Ensino').hover
      browser.td(text: 'Consultar Componente Curricular').click
    end

    def fill_and_submit_form(code)
      # Finds label, go to <td>, go to <tr>, find <td>s, get last, find inputs, get last
      # Fill the course code on the form
      browser.labels(for: 'checkCodigo').first.parent.parent.tds.last.text_fields.last.set code

      # Submit the form
      browser.button(text: 'Buscar').click
    end

    def click_on_result
      # Click on the first result on the table
      # 2nd element because 1st one is on the legend
      browser.images(src: '/sigaa/img/view.gif')[1].click
    end

    def parse_prerequisites(string)
      string.scan(/\d+/)
    end
  end
end
