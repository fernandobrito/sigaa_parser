shared_examples_for String do
  it { expect(subject.remove_tabulation).to be_eql(clean) }
end

describe String do
  describe '#remove_tabulation' do
    let(:clean) { 'Curso 1' }

    context 'when it has \t and \n chars' do
      subject { "Curso \t\t\n1" }
      it_behaves_like String
    end

    context 'when it has multiple    spaces' do
      subject { 'Curso     1' }
      it_behaves_like String
    end
  end
end
