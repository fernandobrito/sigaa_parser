describe SigaaParser::TranscriptParser do
  let(:file) { File.open(File.join(TRANSCRIPT_DIR, '11111309.pdf')) }
  subject { SigaaParser::TranscriptParser.new(file).course_results }

  describe '#new' do
    context 'when file is a PDF and a transcript of records' do
      it 'finds student data' do
        expect(subject.student.name).to be_eql('FERNANDO SANTOS DE MATTOS BRITO')
        expect(subject.student.program).to be_eql('CIÊNCIAS DA COMPUTAÇÃO (BACHARELADO) - CI/João Pessoa')
      end

      it 'finds all courses' do
        expect(subject.results.size).to be_eql(52)
      end
    end

    context 'when file is a PDF but not a transcript of records' do
      let(:file) { File.open(File.join(TRANSCRIPT_DIR, 'old_11111309.pdf')) }

      it 'should raise exception' do
        expect { subject }.to raise_error(SigaaParser::TranscriptParser::InvalidFileFormat)
      end
    end

    context 'when file has wrong extension' do
      let(:file) { File.open(File.join(TRANSCRIPT_DIR, 'invalid_extension.txt')) }

      it 'should raise exception' do
        expect { subject }.to raise_error(SigaaParser::TranscriptParser::InvalidFileExtension)
      end
    end
  end

  describe "#results" do
    it 'parses the data correctly' do
      expect(subject.progress.compulsory.completed).to be(97)
      expect(subject.progress.compulsory.total).to be(190)

      expect(subject.progress.optional.completed).to be(14)
      expect(subject.progress.optional.total).to be(16)

      expect(subject.progress.flexible.completed).to be(4)
      expect(subject.progress.flexible.total).to be(12)
    end
  end
end