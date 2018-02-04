require "sinatra"
require "net/http"
require "net/https"
require "base64"
require "json"
require "encrypted_strings"
require "dotenv/load"

module SpotifyTokenSwapService
  class App < Sinatra::Base
    post "/api/swap_for_access_token" do
      "Hi world"
    end

    post "/api/refresh_token" do
      "Hey world"
    end
  end
end
