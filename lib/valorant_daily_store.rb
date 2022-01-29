# frozen_string_literal: true

require_relative "valorant_daily_store/version"
require_relative "valorant_daily_store/data"

module ValorantDailyStore
  def self.get_data(username:, password:, region:, language: "en-US")
    Data.new(username:, password:, region:, language:).get
  end
end
