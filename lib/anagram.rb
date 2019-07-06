require_relative './mixins/sort_word_letters'
require_relative './word_list'

class Anagram
  include SortWordLetters

  def initialize
    load_word_list
  end

  def solve(word)
    sorted_letters = sort_word_letters(word)
    all_words = @word_list.fetch(sorted_letters, []).sort
    all_words.delete_if { |matched_word| matched_word == word }
  end

  private

  attr_reader :word_list

  def load_word_list
    @word_list = WordList.new.load
  end
end
