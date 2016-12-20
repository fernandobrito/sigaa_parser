describe SigaaParser::CourseResults::Progress do
  it 'should calculate the percentage values' do
    subject.compulsory.set(100, 200)
    expect(subject.compulsory.percentage_completed).to eq(50)
  end

  context 'when has done all credits' do
    it 'should calculate the percentage values' do
      subject.flexible.set(100, 100)
      expect(subject.flexible.percentage_completed).to eq(100)
    end
  end

  context 'when has done no credits' do
    it 'should calculate the percentage values' do
      subject.optional.set(0, 100)
      expect(subject.optional.percentage_completed).to eq(0)
    end
  end
end
