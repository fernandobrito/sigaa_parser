module SigaaParser
  # Retrieve and parse a curriculum
  class CurriculumParser
    include SigaaParser::Cacheable
    include SigaaParser::MenuNavigator

    def initialize(scraper = nil)
      @scraper = scraper
    end

    def cache_name(code)
      "program-#{code}"
    end

    def retrieve_and_parse(code)
      parse(retrieve(code))
    end

    # At the moment, the code we receive is the code from
    # the select field on the page :) :)
    def retrieve(code)
      cached = retrieve_cache_if_enabled_and_available(cache_name(code))
      return cached if cached

      navigate_to_right_page
      fill_and_submit_form(code)
      click_on_result

      # Store on cache
      store_cache_if_enabled(cache_name(code), browser.source_code)

      browser.source_code
    end

    CODE_XPATH = "//th[contains(., 'Código')]/following-sibling::td[1]"
    NAME_XPATH = "//th[contains(., 'Matriz Curricular')]/following-sibling::td[1]"
    FACULTY_XPATH = "//th[contains(., 'Unidade de Vinculação')]/following-sibling::td[1]"

    def parse(html_string)
      page = Nokogiri::HTML(html_string)

      code = page.search(CODE_XPATH).text.remove_tabulation
      name = page.search(NAME_XPATH).text.remove_tabulation
      faculty = page.search(FACULTY_XPATH).text.remove_tabulation

      # This is the third table
      # STRANGE: cached page works with first line. Live page with second!
      table = page.search('#relatorio > table > tbody > tr > td > table')[2]
      table ||= page.search('#relatorio > table > tr > td > table')

      # - 1 for 0th semester
      # - 1 because everything is inside one big td
      semesters = table.search("//td[contains(., 'º Semestre')]").size - 2

      # Create object
      curriculum = SigaaParser::Curriculum.new(code, name, semesters, faculty)

      # The HTML is not structured at all. Very ugly parsing:
      # Split into groups
      rows = table.search('tr.componentes, tr.tituloRelatorio')

      # First group is empty, so remove it
      groupped_rows = rows.to_a.split { |r| r.text.include? 'Semestre' }.from(1)

      groupped_rows.each_with_index do |group, index|
        group.each do |course_row|
          course = parse_course_row(course_row, index)
          curriculum.courses << course
        end
      end

      curriculum
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
      browser.td(text: 'Consultar Estrutura Curricular').click
    end

    def fill_and_submit_form(code)
      # Fill the program code on the form
      browser.select_list(name: 'busca:curso').select_value code

      # Submit the form
      browser.button(text: 'Buscar').click
    end

    def click_on_result
      # Click on the first result on the table
      # 2nd element because 1st one is on the legend
      browser.images(src: '/sigaa/img/report.png')[1].click
    end

    def parse_course_row(course_row, index)
      semester = index
      code = course_row.search('td')[0].text.strip
      name = course_row.search('td')[1].text.split('-').first.strip
      workload = course_row.search('td')[2].text.strip.gsub(/(\t|\n)/, '')
      type = course_row.search('td')[3].text.strip
      category = course_row.search('td')[4].text.strip

      SigaaParser::Course.new(code, name, semester, workload, type, category)
    end
  end
end
