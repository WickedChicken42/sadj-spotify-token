require "sinatra"
require "base64"
require "json"
require "active_support/all"
require "encrypted_strings"
require "dotenv/load" if File.exists?(".env")
require "net/http"
require "net/https"

module SpotifyTokenSwapService
  # SpotifyTokenSwapService::Config
  #
  # This deals with configuration, loaded through .env
  #
  module ConfigHelper
    def config(*)
      @config ||= Config.new
    end
  end

  class Config < Struct.new(:client_id, :client_secret,
                            :client_callback_url, :encryption_secret)
    def initialize
      self.client_id = ENV["SPOTIFY_CLIENT_ID"]
      self.client_secret = ENV["SPOTIFY_CLIENT_SECRET"]
      self.client_callback_url = ENV["SPOTIFY_CLIENT_CALLBACK_URL"]
      self.encryption_secret = ENV["ENCRYPTION_SECRET"]
    end
  end

  # SpotifyTokenSwapService::App
  #
  # The code needed to make it go all Sinatra, beautiful.
  #
  class App < Sinatra::Base
    set :root, File.dirname(__FILE__)

    helpers ConfigHelper

    get "/" do
      config.to_json
    end

    post "/api/swap_for_access_token" do
      "Hi world"
    end

    post "/api/refresh_token" do
      "Hey world"
    end
  end
end
