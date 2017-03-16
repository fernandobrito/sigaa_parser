module SigaaParser
  module EvaluationResultsParser
    DEPARTMENT_XPATH = "//th[contains(., 'Departamento')]/following-sibling::td[1]"
    SEMESTER_XPATH = "//th[contains(., 'Ano-Período')]/following-sibling::td[1]"
    ROWS_SELECTOR = 'table.tabelaRelatorioBorda tbody tr'

    def self.parse(html_string)
      page = Nokogiri::HTML(html_string)
      department = page.search(DEPARTMENT_XPATH).text
      semester = page.search(SEMESTER_XPATH).text

      rows = page.search(ROWS_SELECTOR)

      entries = []

      rows.each do |row|
        entry = parse_row(row)
        entry.department = department
        entry.semester = semester
        entries << entry
      end

      entries
    end

    def self.parse_row(row)
      values = row.search('td').map(&:text)

      entry = EvaluationResult.new

      entry.professor = values[0]
      entry.course_name = values[1]
      entry.course_group = values[2]
      entry.course_schedule = values[3]
      entry.quantity_students = values[4].to_i
      entry.scores = values[5..14].map { |s| to_float(s) }
      entry.average_score = to_float(values[15])
      entry.std_dev = to_float(values[16])

      entry
    end

    def self.to_float(string)
      string.tr(',', '.').to_f
    end
  end
end
