require_relative './mixins/sort_word_letters'

class WordList
  include SortWordLetters
  WORD_LIST_PATH = '../../data/wordlist.txt'

  attr_reader :list
  private :list

  def initialize
    @file = File.open(File.expand_path(WORD_LIST_PATH, __FILE__))
    @list = {}
  end

  def load
    @file.each do |line|
      word = line.chomp
      sorted_word = sort_word_letters(word)
      word_list = @list.fetch(sorted_word, []) << word
      @list.merge!(sorted_word => word_list)
    end

    @list
  end
end
