class FlickrPhoto < ActiveRecord::Base

  class FlickrResult
    attr_accessor :id, :farm, :isprimary, :server, :secret, :title
    
    def initialize(h)
      h.each_pair { |k, v| send("#{k}=", v) }
    end

  end

  attr_accessible :flickr_id, :farm, :isprimary, :secret, :server, :title

  belongs_to :mission

  def self.for_homepage(count = 30)
    limit(count).order('RAND()').includes(:mission).all
  end

  def self.for_archive(count = 10)
    limit(count).includes(:mission).all
  end

  def self.from_hash!(hash)
    create!({
      :farm      => hash["farm"],
      :title     => hash["title"],
      :isprimary => hash["isprimary"],
      :flickr_id => hash["id"],
      :server    => hash["server"],
      :secret    => hash["secret"]
    })
  end

  def self.from_photoset!(photoset_id, opts = {})
    flickr    = FlickRaw::Flickr.new
    photoset = flickr.photosets.getPhotos opts.merge(:photoset_id => photoset_id)
    photoset.photo.each { |photo| self.from_hash! photo }
  end

  def to_flickr_opts
    @flickr_opts ||= FlickrResult.new({
      :farm      => farm,
      :title     => title,
      :isprimary => isprimary,
      :id        => flickr_id,
      :server    => server,
      :secret    => secret
    })
  end

  def to_url(size = nil)
    method = size.nil? ? :url : :"url_#{size}"
    FlickRaw.send(method, to_flickr_opts)
  end

end


# == Schema Info
#
# Table name: flickr_photos
#
#  id         :integer(4)      not null, primary key
#  flickr_id  :string(255)
#  farm       :integer(4)
#  isprimary  :string(255)
#  secret     :string(255)
#  server     :string(255)
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
