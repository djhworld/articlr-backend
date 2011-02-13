require 'flickraw-cached'
class PhotoEngine
    def search_near_me(lat,long,rad,keywords)
        FlickRaw.api_key="283720505822a34d2ab61c92f98cfc09"
        FlickRaw.shared_secret="e6da9a52a9dcaed6"
        photos = flickr.photos.search(:lat => lat, :lon => long, :has_geo=>1, :radius=>5, :radius_units=>"mi", :accuracy => 12, :min_upload_date=> (DateTime.now-(60*60)), :text=>keywords.first) #, :tags=>"gsxsw")

        results = []

        photos = photos.take(20)

        photos.each do |ph|
            results << mkurl(ph.owner, ph.id)
        end
        results
    end

    def mkurl(photo_owner, photo_id)
        "http://www.flickr.com/photos/#{photo_owner}/#{photo_id}"
    end
end
