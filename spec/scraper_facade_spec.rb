describe SigaaParser::ScraperFacade, headless: true do
  describe '#parse_curricula' do
    COURSE_NAME = 'CIÊNCIA DA COMPUTAÇÃO - João Pessoa - Presencial - MT - BACHARELADO'
    subject { SigaaParser::ScraperFacade.new.parse_curricula(['1626669']) }

    context 'given code for one course' do
      it 'should return only one result' do
        expect(subject.size).to be(1)
      end

      it 'should have correct name' do
        expect(subject.first.name).to eq(COURSE_NAME)
      end

      it 'should have all courses' do
        expect(subject.first.courses.size).to be(118)
      end
    end
  end
end
