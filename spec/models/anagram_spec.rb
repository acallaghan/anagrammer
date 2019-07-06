require 'spec_helper'
require 'anagram'

RSpec.describe Anagram do
  describe '#solve' do
    context 'using a fake word list file' do
      before do
        stub_const('WordList::WORD_LIST_PATH', '../../spec/data/test_wordlist.txt')
      end

      context 'with a simple word' do
        let(:word) { 'crepitus' }

        it 'returns an array of anagrams' do
          expect(subject.solve(word)).to eq(%w[cuprites pictures piecrust])
        end
      end

      context 'with a word without anagrams' do
        let(:word) { 'ouihjbaeiuofsdhjb' }

        it 'returns an empty array' do
          expect(subject.solve(word)).to eq([])
        end
      end

      context 'with a word with punctuation' do
        let(:word) { 'he\'s' }
        it 'does not match with a word unless it also has punctuation' do
          expect(subject.solve(word)).to_not include('she')
        end
      end
    end
  end
end
