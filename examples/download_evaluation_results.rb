require_relative '../lib/sigaa_parser'

SEMESTERS = %w(2014.1 2014.2 2015.1 2015.2)

def save_to_file_as_json(filename, collection)
  File.open('output/' + filename, 'w') do |file|
    json = JSON.pretty_generate(collection.map(&:to_hash))
    file.write(json)
  end
end

def download_all
  base_scraper = SigaaParser::Scraper.new
  scraper = SigaaParser::EvaluationResultsScraper.new(base_scraper)

  entries = []

  departments = scraper.retrieve_departments_available

  departments.each do |department|
    SEMESTERS.each do |semester|
      puts "Parsing #{department} #{semester}"
      html = scraper.retrieve(department, semester)
      entries.push(*SigaaParser::EvaluationResultsParser.parse(html))
    end
  end

  save_to_file_as_json('evaluation_results.json', entries)
end

download_all
