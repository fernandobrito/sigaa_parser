describe SigaaParser::EvaluationResultsScraper do
  # Disable cache on unit tests
  before(:all) do
    SigaaParser::EvaluationResultsScraper.cache_enabled = false
  end

  after(:all) do
    SigaaParser::EvaluationResultsScraper.cache_enabled = true
  end

  let(:base_scraper) { SigaaParser::Scraper.new }
  let(:scraper) { SigaaParser::EvaluationResultsScraper.new(base_scraper) }

  describe '#retrieve' do
    context 'without cache' do
      it 'fetches the page from the server' do
        department = 'CI - DEPARTAMENTO DE INFORMÁTICA'
        semester = '2014.1'
        result = scraper.retrieve(department, semester)

        expect(result).to include 'Resultado Sintético da Avaliação'
        expect(result).to include department
        expect(result).to include semester
      end
    end
  end
end
