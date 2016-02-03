describe SigaaParser::CurriculumParser do
  describe '#parse' do
    context 'when parsing a (cached) page' do
      let(:page) do
        agent = Mechanize.new
        agent.get('file:///' + File.join(HTML_DIR, 'cc-curriculum.html'))
      end

      let(:course) { SigaaParser::Course.new('1101171', 'FISICA APLICADA A COMPUTACAO I', '1') }

      it 'should find one of the courses' do
        expect(subject.parse(page)).to include(course)
      end
    end

    context 'when parsing a (live) page' do
      let(:page) do
        parser = SigaaParser::Parser.new
        parser.authenticate!

        SigaaParser::CurriculumParser.new.retrieve(parser, '162006')
      end

      let(:course) { SigaaParser::Course.new('1101171', 'FISICA APLICADA A COMPUTACAO I', '1') }

      it 'should find one of the courses' do
        expect(subject.parse(page)).to include(course)
      end
    end
  end
end