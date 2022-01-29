require "pry"
module ValorantDailyStore
  class Skin
    def initialize(name:, price:, photo:, video:)
      @name = name
      @price = price
      @photo = photo
      @video = video
    end

    def to_hash
      {
        name:,
        price:,
        photo:,
        video:
      }
    end

    def to_json(...)
      to_hash.to_json(...)
    end

    attr_reader :name, :price, :photo, :video
  end
end
