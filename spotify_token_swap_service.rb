require "sinatra"
require "net/http"
require "net/https"
require "base64"
require "json"
require "encrypted_strings"
require "dotenv/load"

module SpotifyTokenSwapService
  set :root, File.dirname(__FILE__)

  # SpotifyTokenSwapService::Config
  #
  # This deals with configuration, loaded through .env
  #
  class Config < Struct.new(:client_id, :client_secret,
                            :client_callback_url, :encryption_secret)
    def initialize
      @client_id = ENV["SPOTIFY_CLIENT_ID"]
      @client_secret = ENV["SPOTIFY_CLIENT_SECRET"]
      @client_callback_url = ENV["SPOTIFY_CLIENT_CALLBACK_URL"]
      @encryption_secret = ENV["ENCRYPTION_SECRET"]
    end
  end

  # SpotifyTokenSwapService::App
  #
  # The code needed to make it go all Sinatra, beautiful.
  #
  class App < Sinatra::Base
    post "/api/swap_for_access_token" do
      "Hi world"
    end

    post "/api/refresh_token" do
      "Hey world"
    end
  end
end