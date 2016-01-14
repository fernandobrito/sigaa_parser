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
        config = YAML.load_file(CONFIG_FILE)

        login = config['credentials']['login']
        password = config['credentials']['password']

        parser = SigaaParser::Parser.new
        parser.authenticate(login, password)

        SigaaParser::CurriculumParser.new.retrieve(parser.agent)
      end

      let(:course) { SigaaParser::Course.new('1101171', 'FISICA APLICADA A COMPUTACAO I', '1') }

      it 'should find one of the courses' do
        expect(subject.parse(page)).to include(course)
      end
    end
  end
end