require_relative './TwitterEngine.rb'
require_relative './Storage.rb'
require_relative './Constants.rb'
require_relative './Tweet.rb'
class TwitterEngineManager
    def initialize
        @twitter_engines = {}
    end

    def search_near_me(lat, long, rad, words)
        setup_engines(words)

        threads = []

        @twitter_engines.values.map { |engine| engine.gulp(lat, long, rad) }
        collate_tweets
    end

    def setup_engines(words)
        words.each do |word|
            if !@twitter_engines.key?(word.intern)
                puts "Adding new Twitter Engine"
                @twitter_engines[word.intern] = TwitterEngine.new(word)
            end
        end
    end

    def collate_tweets
        tweets = []
        @twitter_engines.values.each do |engine|
            tweets << engine.tweets
        end
        tweets.flatten!

        tweets.sort_by! { |tweet| item.date }
        tweets.map! { |item| item.to_hash }
    end
end
