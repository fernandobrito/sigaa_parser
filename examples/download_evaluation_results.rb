require_relative '../lib/sigaa_parser'

require 'pry-byebug'

base_scraper = SigaaParser::Scraper.new
scraper = SigaaParser::EvaluationResultsScraper.new(base_scraper)

department = 'CI - DEPARTAMENTO DE INFORMÁTICA'
semester = '2014.1'

puts scraper.retrieve(department, semester)
