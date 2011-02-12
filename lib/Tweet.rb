require 'json'
class Tweet
    attr_accessor :id, :user, :location, :message, :date, :photo
    def initialize(id, user, location, message, date, photo)
        @id, @user, @location, @message, @date, @photo = id, user, location, message, date, photo
    end

    def to_hash
        { :id => @id, :user => @user, :location => @location, :message => @message, :date => @date, :photo => @photo }
    end
end
