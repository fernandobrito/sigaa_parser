module SigaaParser
  class CurriculumParser
    include SigaaParser::Cacheable
    include SigaaParser::MenuNavigator

    def initialize(browser = nil)
      @browser = browser
    end

    def cache_name(code)
      "program-#{code}"
    end

    def retrieve_and_parse(code)
      parse(retrieve(code))
    end

    def retrieve(code)
      # Look for cached version
      cache_name = cache_name(code)
      return File.read(retrieve_cache_path(cache_name)) if has_cached?(cache_name)

      # Go to main page if this page has no menu
      go_to_main_page unless page_has_menu?

      # Go to the page by accessing the menu
      @browser.span(text: 'Ensino').hover
      @browser.td(text: 'Consultar Estrutura Curricular').click

      # Fill the program code on the form
      @browser.select_list(name: 'busca:curso').select_value code

      # Submit the form
      @browser.button(text: 'Buscar').click

      # Click on the first result on the table
      # 2nd element because 1st one is on the legend
      @browser.images(src: "/sigaa/img/report.png")[1].click

      # Store on cache
      store_cache(cache_name, @browser.html)

      @browser.html
    end

    def parse(html_string)
      page = Nokogiri::HTML(html_string)

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