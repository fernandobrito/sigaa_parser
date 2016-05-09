describe SigaaParser::CourseResults do
  let(:file) { File.open(File.join(TRANSCRIPT_DIR, '11111309.pdf')) }
  subject { SigaaParser::TranscriptParser.new(file).course_results }

  describe '#average_up_to' do
    it 'should calculate average for first semester with all courses by default' do
      expect(subject.average_up_to(subject.semesters.first)).to be(7.73)
    end

    it 'should calculate average for first semester only approved' do
      expect(subject.average_up_to(subject.semesters.first, only_approved: true)).to be(7.73)
    end
  end

  describe '#average' do
    it 'should calculate average for all semesters with all courses by default' do
      expect(subject.average).to be(8.12)
    end

    it 'should calculate average for all semesters only approved' do
      expect(subject.average(only_approved: true)).to be(8.12)
    end
  end

end