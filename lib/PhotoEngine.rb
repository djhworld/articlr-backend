require 'flickraw-cached'
class PhotoEngine
    def initialize
        @cache_expires = Time.now
        @flickr_results = {}
    end

    def search_near_me(lat,long,rad,keywords)
        if cache_expired
            FlickRaw.api_key="283720505822a34d2ab61c92f98cfc09"
            FlickRaw.shared_secret="e6da9a52a9dcaed6"
            photos = flickr.photos.search(:lat => lat, :lon => long, :has_geo=>1, :radius=>5, :radius_units=>"mi", :accuracy => 12, :min_upload_date=> (DateTime.now-(60*60)), :text=>keywords.first) #, :tags=>"gsxsw")
            photos = photos.take(20)

            photos.each do |ph|
                owner = mk_owner_url(ph.owner)
                @flickr_results[owner] = [] if !@flickr_results.key?(owner)
                @flickr_results[owner] << mkurl(ph.id, ph.farm, ph.server, ph.secret)
            end

            @cache_expires = Time.now+(60*CACHE_EXPIRY)
        end
        @flickr_results
    end

    def mk_owner_url(owner_id)
       URI.escape("http://www.flickr.com/photos/#{owner_id}")
    end

    def mkurl(photo_id, photo_farm, photo_server, photo_secret)
       URI.escape("http://farm#{photo_farm}.static.flickr.com/#{photo_server}/#{photo_id}_#{photo_secret}_m.jpg")
    end

    def cache_expired
        (@cache_expires < Time.now)
    end
end
