require 'yaml'

describe SigaaParser::Parser do
  let(:student) {
    SigaaParser::Student.new('11111309', 'FERNANDO SANTOS DE MATTOS BRITO',
                             'CIÊNCIAS DA COMPUTAÇÃO (BACHARELADO)/CI - João Pessoa - MT')
  }

  describe '#authenticate' do
    context 'when authenticating' do
      let(:subject) do
        config = YAML.load_file(CONFIG_FILE)

        @login = config['credentials']['login']
        @password = config['credentials']['password']

        SigaaParser::Parser.new
      end

      context 'with correct data' do
        it 'should find student information' do
          expect(subject.authenticate(@login, @password)).to be == student
        end
      end

      context 'with incorrect data' do
        it 'should raise an error' do
          expect { subject.authenticate('a', 'b') }.to raise_error(SigaaParser::AuthenticationFailed)
        end
      end
    end
  end
end