require 'active_support/core_ext/array'

module SigaaParser
  class CurriculumParser
    def parse(page)
      courses = []

      code = page.search("//th[contains(., 'Código')]/following-sibling::td[1]").text.strip
      name = page.search("//th[contains(., 'Matriz Curricular')]/following-sibling::td[1]").text.strip

      # This is the third table
      table = page.search("#relatorio > table > tbody > tr > td > table")[2]

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