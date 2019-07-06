require 'sinatra'
require 'json'
require_relative './lib/anagram'

ANAGRAM_FINDER = Anagram.new

get '/*' do
  content_type :json

  words = params[:splat].first.split(',')

  word_list = {}
  words.collect do |word|
    word_list.merge!(word => ANAGRAM_FINDER.solve(word))
  end

  JSON.dump(word_list)
end
