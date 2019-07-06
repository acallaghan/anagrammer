require 'spec_helper'
require 'anagram'

RSpec.describe WordList do
  describe '#load' do
    subject do
      WordList.new.load
    end

    context 'when using the custom tiny wordlist' do
      before do
        stub_const('WordList::WORD_LIST_PATH', '../../spec/data/test_wordlist.txt')
      end

      it 'sorts the list characters in each word as keys' do
        expect(subject.keys).to eq(%w[ceiprstu aepst hiiknps ehs 'ehs])
      end

      it 'each sorted key value has the corresponding anagrams' do
        expect(subject.fetch('ceiprstu'))
          .to eq(%w[piecrust pictures cuprites crepitus])

        expect(subject.fetch('aepst'))
          .to eq(%w[paste pates peats septa spate tapes tepas])

        expect(subject.fetch('hiiknps'))
          .to eq(%w[kinship pinkish])
      end
    end
  end
end
