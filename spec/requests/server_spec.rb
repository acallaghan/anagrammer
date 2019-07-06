require 'spec_helper'
require 'support/json_matchers'

RSpec.describe 'server requests', type: :request do
  context 'with nothing' do
    it 'returns an empty hash' do
      get '/'

      expect(last_response).to to_have_the_json({})
    end
  end

  context 'with one anagram' do
    it 'replies with that anagram' do
      get '/toast'

      expect(last_response).to to_have_the_json("toast": ['stoat'])
    end
  end

  describe 'with the readme examples' do
    context 'for crepitus' do
      it 'replies with the expected output' do
        get '/crepitus'

        expect(last_response)
          .to to_have_the_json("crepitus": %w[cuprites pictures piecrust])
      end
    end

    context 'for crepitus,paste,kinship,enlist,boaster,fresher,sinks,knits,sort' do
      it 'replies with the expected output' do
        get '/crepitus,paste,kinship,enlist,boaster,fresher,sinks,knits,sort'

        expect(last_response)
          .to to_have_the_json(
            "crepitus": %w[cuprites pictures piecrust],
            "paste": %w[pates peats septa spate tapes tepas],
            "kinship": ['pinkish'],
            "enlist": %w[elints inlets listen silent tinsel],
            "boaster": %w[boaters borates rebatos sorbate],
            "fresher": ['refresh'],
            "sinks": ['skins'],
            "knits": %w[skint stink tinks],
            "sort": %w[orts rots stor tors]
          )
      end
    end

    context 'for sdfwehrtgegfg' do
      it 'replies with the expected output' do
        get '/sdfwehrtgegfg'

        expect(last_response)
          .to to_have_the_json("sdfwehrtgegfg": [])
      end
    end
  end
end

RSpec.describe 'server responsiveness', type: :request do
  context 'using the real word list, with respect to performance', type: :benchmark do
    it 'responds with at least 100 anagrams per second' do
      sample_words = %w[hatpins Mappsville shopman physicalized
                        homesteadings incus scythe's etepimeletic Munford
                        parramatta intrusiveness's bullfighter Yahtzee's nonverbal
                        sootiness's potentate Coamo recentest unsparingness diabetic]

      expect do
        get("/#{sample_words.sample}")
      end.to perform_under(0.01).sample(10)
    end
  end
end
