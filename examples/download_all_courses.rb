# Download all courses from an array of curricula

require_relative '../lib/sigaa_parser'

# CIENCIAS DA COMPUTAÇÃO, ENGENHARIA DE COMPUTAÇÃO, MATEMÁTICA COMPUTACIONAL
# ADMINISTRAÇÃO, MEDICINA, DIREITO
CURRICULA_CODES = %w{ 1626669 1626865 1626769
                      1626692 1626795 1626727 }

def save_to_file(filename, content)
  File.open('output/' + filename, 'w') do |file|
    file.write(content)
  end
end

# Main method
def download_all
  # Create scraper
  scraper = SigaaParser::Scraper.new

  # Create curriculum parser
  curriculum_parser = SigaaParser::CurriculumParser.new(scraper)

  # Array with all curricula (in hash notation)
  curricula = []

  # Download all curricula information
  CURRICULA_CODES.each do |curriculum_code|
    puts "===> Downloading #{curriculum_code}"

    curricula << curriculum_parser.retrieve_and_parse(curriculum_code)
  end

  # Converts to JSON and save file
  curricula_json = curricula.map(&:to_hash_short)
  save_to_file('curricula.json', JSON.pretty_generate(curricula_json))

  # Download courses from each curriculum and dump to file
  process_curricula(scraper, curricula)
end

# Get courses from each curriculum
def process_curricula(scraper, curricula)
  # Create course parser
  course_parser = SigaaParser::CourseParser.new(scraper)

  curricula.each do |curriculum|
    curriculum.courses.each do |course|

      # Get all prerequisites, for all curricula
      course.prerequisites = course_parser.retrieve_and_parse(course.code).prerequisites

      # Just keep the prerequisites for this curriculum
      course.prerequisites.keep_if { |p| p.curriculum == curriculum.code }
    end

    save_to_file("#{curriculum.code}.json", JSON.pretty_generate(curriculum.to_hash))
  end
end

download_all