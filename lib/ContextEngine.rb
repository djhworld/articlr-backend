require_relative './ContextProfile.rb'
require_relative './TwitterEngineManager.rb'
require_relative './PhotoEngine.rb'
class ContextEngine
    attr_accessor :context_profile


    def initialize
        @twitter_engine_manager = TwitterEngineManager.new
        @photo_engine = PhotoEngine.new
    end

    def setup_profile(location, keywords)
        @context_profile = ContextProfile.new(location, keywords)
    end

    def get_context
        raise ArgumentError, "You must setup a context profile!" if @context_profile.nil?
        puts "Getting twitter information for #{@context_profile}"
        tweets = get_twitter_stream
        photos = get_photo_stream
        { :context => { :tweets => tweets, :photos => photos } }
    end

    def get_twitter_stream
        tweets = @twitter_engine_manager.search_near_me(@context_profile.location[:latitude], @context_profile.location[:longitude], (5.to_s << "mi"), @context_profile.keywords)
        tweets
    end


    def get_photo_stream
        results = @photo_engine.search_near_me(@context_profile.location[:latitude], @context_profile.location[:longitude], (5.to_s << "mi"), @context_profile.keywords)
        results
    end

end
