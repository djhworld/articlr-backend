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
        puts "Setting up twitter engines"
        if words.count < @twitter_engines.count
            keys = @twitter_engines.keys.dup
            keys.map! { |item| item.to_s }
            deleted_words = (keys | words) - (keys & words)
            deleted_words.each do |w|
                puts "Deleting keyword #{w}"
                @twitter_engines.delete(w.intern)
            end
        end

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
            puts "Getting retrieved tweets for #{engine.search_word}"
            tweets << engine.tweets
        end
        tweets.flatten!

        tweets.sort_by! { |tweet| tweet.date }
        tweets.map! { |item| item.to_hash }
    end
end
