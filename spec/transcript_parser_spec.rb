describe SigaaParser::TranscriptParser do
  let(:file) { File.open(File.join(TRANSCRIPT_DIR, '11111309.pdf')) }
  subject { SigaaParser::TranscriptParser.new(file) }

  describe '#new' do
    context 'when file is a PDF and a transcript of records' do
      it 'finds student data' do
        expect(subject.course_results.student.name).to be_eql('FERNANDO SANTOS DE MATTOS BRITO')
      end


      it 'finds all courses' do
        expect(subject.course_results.results.size).to be_eql(31)
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


end