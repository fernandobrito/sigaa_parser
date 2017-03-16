describe SigaaParser::EvaluationResultsParser do
  let(:html_string) { File.read(File.join(HTML_DIR, 'eval-result-informatics-2014.1.html')) }
  let(:parser) { SigaaParser::EvaluationResultsParser }

  describe '.parse' do
    let(:results) { parser.parse(html_string) }
    it 'extracts all entries from HTML' do
      expect(results.length).to eq 48
    end

    it 'extracts details for each entry' do
      result = results.first
      expect(result.department).to eq 'CI - DEPARTAMENTO DE INFORMÁTICA (11.01.34.01.01)'
      expect(result.semester).to eq '2014.1'
      expect(result.professor).to eq 'ALVARO FRANCISCO DE CASTRO MEDEIROS'
      expect(result.course_name).to eq '1107184 - ESPECIFICACAO DE REQUISITOS DE SOFTWARE'
      expect(result.course_group).to eq '02'
      expect(result.course_schedule).to eq ''
      expect(result.quantity_students).to eq 17
      expect(result.scores.length).to eq 10
      expect(result.average_score).to eq 6.32
      expect(result.std_dev).to eq 4.53
    end
  end
end
