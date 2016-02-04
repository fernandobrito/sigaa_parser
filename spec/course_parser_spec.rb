describe SigaaParser::CourseParser do
  describe '#parse' do
    context 'when parsing a (cached) page' do
      let(:html_code) do
        File.read(File.join(HTML_DIR, 'lp2-course.html'))
      end

      it 'should find the prerequisites' do
        expect(subject.parse(html_code).prerequisites.size).to be(5)
      end
    end

    context 'when parsing a (live) page' do
      let(:page) do
        parser = SigaaParser::Parser.new
        parser.authenticate!

        SigaaParser::CourseParser.new(parser.browser).retrieve('1107148')
      end

      it 'should find the prerequisites' do
        expect(subject.parse(page).prerequisites.size).to be(5)
      end
    end
  end
end