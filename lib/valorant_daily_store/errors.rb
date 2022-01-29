module ValorantDailyStore
  class UnsupportedLanguage < StandardError
    def message
      "Unsupported language was specified"
    end
  end

  class AuthorizationCookiesError < StandardError
    def message
      "Couldn't get the authorization cookies"
    end
  end

  class AuthorizaionTokenError < StandardError
    def message
      "Couldn't get the authorization token"
    end
  end

  class EntitlementsTokenError < StandardError
    def message
      "Couldn't get the entitlements token"
    end
  end

  class PlayerIdError < StandardError
    def message
      "Couldn't get the player id"
    end
  end

  class SkinIdsError < StandardError
    def message
      "Couldn't get the skin ids"
    end
  end

  class OffersError < StandardError
    def message
      "Couldn't get the offers"
    end
  end

  class ValorantApiError < StandardError
    def message
      "Couldn't connect to Valorant API"
    end
  end
end
