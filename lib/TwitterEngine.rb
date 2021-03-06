require 'twitter'
require 'date'
require_relative './Tweet.rb'
require_relative './Constants.rb'

class TwitterEngine
    attr_reader :tweets, :search_word

    def initialize(word)
        @search_word = word
        @tweets = []
        @since_id = nil
        @cache_expires = Time.now
    end

    def gulp(lat, long, rad)
        if cache_expired
            puts "CACHE EXPIRED"
            search = Twitter::Search.new

            if(@search_word.equal?(EMPTY_SEARCH))
                puts "Not searching on word"
                if(@since_id.nil?)
                    results = search.per_page(TWEETS_PER_TOPIC).geocode(lat,long, (rad.to_s << "mi")).fetch
                else
                    puts "Getting tweets since #{@since_id}"
                    results = search.since_id(@since_id).per_page(TWEETS_PER_TOPIC).geocode(lat,long, (rad.to_s << "mi")).fetch
                end
            else
                if(@since_id.nil?)
                    results = search.per_page(TWEETS_PER_TOPIC).containing(@search_word).geocode(lat,long, (rad.to_s << "mi")).fetch
                else
                    puts "Getting tweets since #{@since_id}"
                    results = search.since_id(@since_id).per_page(TWEETS_PER_TOPIC).containing(@search_word).geocode(lat,long, (rad.to_s << "mi")).fetch
                end
            end

            results.each do |tweet|
                @tweets << (Tweet.new(tweet.id,
                                      tweet.from_user,
                                      tweet.location,
                                      tweet.text,
                                      DateTime.parse(tweet.created_at),
                                      URI.escape(tweet.profile_image_url)))
            end

            @since_id = @tweets.last.id if @tweets.size > 0
            @cache_expires = Time.now+(60*CACHE_EXPIRY)
        end
    end

    def cache_expired
        (@cache_expires < Time.now)
    end
end
