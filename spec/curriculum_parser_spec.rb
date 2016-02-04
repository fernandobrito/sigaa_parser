describe SigaaParser::CurriculumParser do
  describe '#parse' do
    context 'when parsing a (cached) page' do
      let(:html_code) do
        File.read(File.join(HTML_DIR, 'cc-curriculum.html'))
      end

      let(:course) { SigaaParser::Course.new('1101171', 'FISICA APLICADA A COMPUTACAO I', '1') }

      it 'should find one of the courses' do
        expect(subject.parse(html_code)).to include(course)
      end
    end

    context 'when parsing a (live) page' do
      let(:page) do
        parser = SigaaParser::Parser.new
        parser.authenticate!

        SigaaParser::CurriculumParser.new(parser.browser).retrieve('1626669')
      end

      let(:course) { SigaaParser::Course.new('1101171', 'FISICA APLICADA A COMPUTACAO I', '1') }

      it 'should find one of the courses' do
        expect(subject.parse(page)).to include(course)
      end
    end
  end
end