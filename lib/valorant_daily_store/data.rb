require "faraday"
require "faraday-cookie_jar"
require_relative "./skin"
require_relative "./consts"
require_relative "./errors"

module ValorantDailyStore
  class Data
    def initialize(region:, username:, password:, language: "en-US")
      @region = region
      @username = username
      @password = password

      if ValorantDailyStore::VALORANT_API_LANGUAGES.include?(language)
        @language = language
      else
        raise UnsupportedLanguage
      end
    end

    def get
      set_starting_cookies
      get_token
      get_entitlements_token
      get_player_id
      get_skin_ids
      get_offers
      prepare_skins
    end

    private

    def set_starting_cookies
      response = auth_conn.post("/api/v1/authorization", {
        nonce: "1",
        client_id: "play-valorant-web-prod",
        redirect_uri: "https://playvalorant.com/opt_in",
        response_type: "token id_token"
      })
      if response.status != 200
        raise AuthorizationCookiesError
      end
      nil
    end

    def get_token
      response = auth_conn.put("/api/v1/authorization", {type: "auth", username: username, password: password})

      @token = response.body&.dig("response", "parameters", "uri")&.match(/access_token=((?:[a-zA-Z]|\d|\.|-|_)*).*id_token=((?:[a-zA-Z]|\d|\.|-|_)*).*expires_in=(\d*)/i)&.captures&.dig(0)

      if response.status != 200 || token.nil?
        raise AuthorizaionTokenError
      end
      nil
    end

    def get_entitlements_token
      response = entitlements_conn.post("/api/token/v1", {})

      @entitlements_token = response.body&.dig("entitlements_token")

      if response.status != 200 || entitlements_token.nil?
        raise EntitlementsTokenError
      end
      nil
    end

    def get_player_id
      response = auth_conn.get("/userinfo", {}) do |req|
        req.headers["Authorization"] = "Bearer #{token}"
      end

      @player_id = response.body&.dig("sub")

      if response.status != 200 || player_id.nil?
        raise PlayerIdError
      end
      nil
    end

    def get_skin_ids
      response = store_conn.get("/store/v2/storefront/#{player_id}")

      @skin_ids = response.body&.dig("SkinsPanelLayout", "SingleItemOffers")

      if response.status != 200 || skin_ids.nil?
        raise SkinIdsError
      end
      nil
    end

    def get_offers
      response = store_conn.get("/store/v1/offers/", {})

      @offers = response.body&.dig("Offers")

      if response.status != 200 || offers.nil?
        raise OffersError
      end
      nil
    end

    def prepare_skins
      skins = []
      skin_ids.each do |skin_id|
        offer = offers.find { |o| o["OfferID"] == skin_id }

        continue if offer.nil?
        _, price = offer["Cost"].first

        response = valorant_api_conn.get("/v1/weapons/skinlevels/#{skin_id}/?language=#{language}")

        if response.status != 200 || response.body["status"] != 200
          raise ValorantApiError
        end

        name = response.body["data"]["displayName"]
        photo = response.body["data"]["displayIcon"]
        video = response.body["data"]["streamedVideo"]

        skins.push(Skin.new(name:, photo:, video:, price:))
      end
      skins
    end

    def auth_conn
      @auth_conn ||= Faraday.new(url: "https://auth.riotgames.com") do |builder|
        builder.use :cookie_jar
        builder.response :json
        builder.request :json
        builder.adapter Faraday.default_adapter
        builder.headers["Host"] = "auth.riotgames.com"
        builder.headers["Referer"] = "https://hoppscotch.io/"
        builder.headers["Origin"] = "https://hoppscotch.io"
      end
    end

    def entitlements_conn
      @entitlements_conn ||= Faraday.new("https://entitlements.auth.riotgames.com") do |builder|
        builder.response :json
        builder.request :json
        builder.adapter Faraday.default_adapter
        builder.headers["Authorization"] = "Bearer #{token}"
        builder.headers["User-Agent"] = "RiotClient/43.0.1.4195386.4190634 rso-auth (Windows;10;;Professional, x64)"
      end
    end

    def store_conn
      @store_conn ||= Faraday.new("https://pd.#{region}.a.pvp.net") do |builder|
        builder.response :json
        builder.request :json
        builder.adapter Faraday.default_adapter
        builder.headers["Authorization"] = "Bearer #{token}"
        builder.headers["User-Agent"] = "RiotClient/43.0.1.4195386.4190634 rso-auth (Windows;10;;Professional, x64)"
        builder.headers["X-Riot-Entitlements-JWT"] = entitlements_token
      end
    end

    def valorant_api_conn
      # v1/weapons/skinlevels/
      @valorant_api_conn ||= Faraday.new("https://valorant-api.com") do |builder|
        builder.response :json
        builder.request :json
        builder.adapter Faraday.default_adapter
      end
    end

    attr_reader :username, :password, :region, :token, :entitlements_token, :player_id, :skin_ids, :offers, :language
  end
end
