require 'yaml'

describe SigaaParser::Scraper do
  describe '#authenticate', headless: true do
    context 'when authenticating' do
      let(:subject) do
        SigaaParser::Scraper.new
      end

      context 'with correct data' do
        it 'should find student information' do
          expect(subject.authenticate!.name).not_to be_empty
        end
      end

      context 'with incorrect data' do
        it 'should raise an error' do
          ENV['SIGAA_PASSWORD'] = 'wrong-password'
          expect { subject.authenticate! }.to raise_error(SigaaParser::AuthenticationFailed)
        end
      end
    end
  end
end
