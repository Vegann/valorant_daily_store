require "thor"
require_relative "./data"
require_relative "./consts"
require "json"

module ValorantDailyStore
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "get", "Get your daily Valorant shop"
    option :username, type: :string, required: true, banner: "Riot username", aliases: ["-u"]
    option :password, type: :string, required: true, banner: "Riot password", aliases: ["-p"]
    option :region, type: :string, required: true, banner: "Account's region", aliases: ["-r"]
    option :language, type: :string, required: false, banner: "Language used to translate weapons name", default: "en-US", aliases: ["-l"], enum: ValorantDailyStore::VALORANT_API_LANGUAGES

    def get
      response = Data.new(username: options[:username], password: options[:password], region: options[:region], language: options[:language]).get
      puts JSON.pretty_generate(response)
    rescue => e
      puts "ERROR: #{e.message}"
    end
  end
end
