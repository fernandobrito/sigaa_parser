require_relative '../lib/sigaa_parser'

DEPARTMENTS = ['CI - DEPARTAMENTO DE INFORMÁTICA', 'CCEN - DEPARTAMENTO DE ESTATÍSTICA',
               'CCEN - DEPARTAMENTO DE FÍSICA', 'CCHLA - DEPARTAMENTO DE CIÊNCIAS SOCIAIS',
               'CCHLA - DEPARTAMENTO DE FILOSOFIA', 'CCHLA - DEPARTAMENTO DE LETRAS CLÁSSICAS E VERNÁCULAS',
               'CCHLA - DEPARTAMENTO DE LETRAS ESTRANGEIRAS E MODERNAS', 'CCHLA - DEPARTAMENTO DE PSICOLOGIA',
               'CCJ - DEPARTAMENTO DE DIREITO PÚBLICO', 'CCS - DEPARTAMENTO DE EDUCAÇÃO FÍSICA',
               'CCSA - DEPARTAMENTO DE ADMINISTRACAO', 'CCSA - DEPARTAMENTO DE FINANÇAS E CONTABILIDADE',
               'CCTA - DEPARTAMENTO DE COMUNICAÇÃO', 'CI - DEPARTAMENTO DE COMPUTAÇÃO CIENTÍFICA']
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

  DEPARTMENTS.each do |department|
    SEMESTERS.each do |semester|
      puts "Parsing #{department} #{semester}"
      html = scraper.retrieve(department, semester)
      entries.push(*SigaaParser::EvaluationResultsParser.parse(html))
    end
  end

  save_to_file_as_json('evaluation_results.json', entries)
end

download_all
