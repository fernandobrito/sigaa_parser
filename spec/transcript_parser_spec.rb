describe SigaaParser::TranscriptParser do
  let(:file) { File.read(File.join(TRANSCRIPT_DIR, '1111309.pdf')) }
  subject { SigaaParser::TranscriptParser.new(file) }

  describe '#new' do
    context 'when file is a PDF and a transcript of records' do

    end

    context 'when file is a PDF but not a transcript of records' do

    end

    context 'when file has wrong extension' do
      let(:file) { File.read(File.join(TRANSCRIPT_DIR, 'invalid_extension.txt')) }

      it 'should raise exception' do
        expect { subject }.to raise_error(SigaaParser::TranscriptParser::InvalidFileExtension)
      end
    end
  end


end