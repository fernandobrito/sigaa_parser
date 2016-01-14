describe SigaaParser::CourseParser do
  describe '#parse' do
    context 'when parsing a (cached) page' do
      let(:page) do
        agent = Mechanize.new
        agent.get('file:///' + File.join(HTML_DIR, 'lp2-course.html'))
      end

      it 'should find the prerequisites' do
        expect(subject.parse(page).prerequisites.size).to be(5)
      end
    end

    context 'when parsing a (live) page' do
      let(:page) do
        config = YAML.load_file(CONFIG_FILE)

        login = config['credentials']['login']
        password = config['credentials']['password']

        parser = SigaaParser::Parser.new
        parser.authenticate(login, password)

        SigaaParser::CourseParser.new.retrieve(parser.agent, '1107148')
      end

      it 'should find the prerequisites' do
        expect(subject.parse(page).prerequisites.size).to be(5)
      end
    end
  end
end