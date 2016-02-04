shared_examples 'parses curriculum' do
  let(:course) { SigaaParser::Course.new('1101171', 'FISICA APLICADA A COMPUTACAO I', '1') }

  it 'code is parsed correctly' do
    expect(subject.code).to eq('162006')
  end

  it 'name is parsed correctly' do
    expect(subject.name).to include('CIÊNCIAS DA COMPUTAÇÃO')
  end

  it 'faculty is parsed correctly' do
    expect(subject.faculty).to include('CENTRO DE INFORMÁTICA')
  end

  it 'courses are parsed' do
    expect(subject.courses).to include(course)
  end
end

describe SigaaParser::CurriculumParser do
  describe '#parse' do
    context 'when parsing a (cached) page' do
      let(:html_code) { File.read(File.join(HTML_DIR, 'cc-curriculum.html')) }
      subject { SigaaParser::CurriculumParser.new.parse(html_code) }

      include_examples 'parses curriculum'
    end

    context 'when parsing a (live) page' do
      before(:all) do
        parser = SigaaParser::Parser.new
        parser.authenticate!

        @subject = SigaaParser::CurriculumParser.new(parser.browser).retrieve_and_parse('1626669')
      end

      subject { @subject }

      include_examples 'parses curriculum'
    end
  end
end