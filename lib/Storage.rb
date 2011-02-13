require 'redis'

class Storage
    def initialize
        @redis = Redis.new
    end

    def exists?(key)
        @redis.exists(key)
    end

    def get(key)
        @redis.get key
    end

    def set(key, val)
        @redis.set key, val
    end

    def set_list(key, list)
        list.each do |v|
            @redis.sadd(key, v)
        end
    end

    def get_list(key, list)
        @redis.smembers(key)
    end
end
