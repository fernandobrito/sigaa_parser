shared_examples 'parses course' do
  it 'should find the prerequisites' do
    expect(subject.prerequisites.size).to be(5)
  end
end

describe SigaaParser::CourseParser do
  describe '#parse' do
    context 'when parsing a (cached) page' do
      let(:html_code) { File.read(File.join(HTML_DIR, 'lp2-course.html')) }
      subject { SigaaParser::CourseParser.new.parse(html_code) }

      include_examples 'parses course'
    end

    context 'when parsing a (live) page' do
      before(:all) do
        parser = SigaaParser::Scraper.new
        @subject = SigaaParser::CourseParser.new(parser).retrieve_and_parse('1107148')
      end

      subject { @subject }

      include_examples 'parses course'
    end
  end
end