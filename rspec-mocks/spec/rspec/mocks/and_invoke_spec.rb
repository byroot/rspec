module RSpec
  module Mocks
    RSpec.describe 'and_invoke' do
      let(:obj) { double('obj') }

      context 'when a block is passed' do
        it 'raises ArgumentError' do
          expect {
            allow(obj).to receive(:foo).and_invoke('bar') { 'baz' }
          }.to raise_error(ArgumentError, /implementation block/i)
        end
      end

      context 'when no argument is passed' do
        it 'raises ArgumentError' do
          expect { allow(obj).to receive(:foo).and_invoke }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
