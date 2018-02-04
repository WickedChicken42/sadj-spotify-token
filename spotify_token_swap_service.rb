require "sinatra"
require "sinatra/json"
require "sinatra/reloader" if File.exists?(".env")
require "dotenv/load" if File.exists?(".env")
require "active_support/all"
require "base64"
require "encrypted_strings"
require "httparty"

module SpotifyTokenSwapService

  # SpotifyTokenSwapService::ConfigHelper
  # SpotifyTokenSwapService::ConfigError
  # SpotifyTokenSwapService::Config
  #
  # This deals with configuration, loaded through .env
  #
  module ConfigHelper
    def config
      @config ||= Config.instance
    end
  end

  class ConfigError < StandardError
    def self.empty
      new("client credentials are empty")
    end
  end

  class Config < Struct.new(:client_id, :client_secret,
                            :client_callback_url, :encryption_secret)
    include Singleton

    def initialize
      self.client_id = ENV["SPOTIFY_CLIENT_ID"]
      self.client_secret = ENV["SPOTIFY_CLIENT_SECRET"]
      self.client_callback_url = ENV["SPOTIFY_CLIENT_CALLBACK_URL"]
      self.encryption_secret = ENV["ENCRYPTION_SECRET"]

      validate_client_credentials
    end

    def has_client_credentials?
      client_id.present? &&
      client_secret.present? &&
      client_callback_url.present?
    end

    def has_encryption_secret?
      encryption_secret.present?
    end

    private

    def validate_client_credentials
      raise ConfigError.empty unless has_client_credentials?
    end
  end

  # SpotifyTokenSwapService::HTTP
  #
  # Make the HTTP requests, as handled by our lovely host, HTTParty.
  #
  class HTTP
    include HTTParty,
            ConfigHelper
    base_uri 'https://accounts.spotify.com'

    def initialize(config:)
      @config = config
    end

    def token(auth_code:)
      options = default_options.deep_merge(query: {
      })

      self.class.post("/api/token", options)
    end

    private

    def default_options

    end

    # def authorization_header
    #   { Authorization: "Basic %s" % Base64.strict_encode64("%s:%s" % [client_id, client_secret]) }
    # end
  end

  # SpotifyTokenSwapService::App
  #
  # The code needed to make it go all Sinatra, beautiful.
  #
  class App < Sinatra::Base
    set :root, File.dirname(__FILE__)

    before do
      headers 'Access-Control-Allow-Origin' => '*',
              'Access-Control-Allow-Methods' => %w(OPTIONS GET POST)
    end

    helpers ConfigHelper

    get "/" do
      config.has_encryption_secret?.inspect
    rescue StandardError => e
      json error: e
    end

    post "/api/swap_for_access_token" do
      "Hi world"
    rescue StandardError => e
      json error: e
    end

    post "/api/refresh_token" do
      "Hey world"
    rescue StandardError => e
      json error: e
    end
  end
end
