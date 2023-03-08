module Slack
  class Api
    require 'faraday/follow_redirects'

    BASE_URL = 'https://slack.com/'.freeze
    AUTHORIZATION_ENDPOINT = 'oauth/v2/authorize'.freeze
    ACCESS_TOKEN_ENDPOINT = 'api/oauth.v2.access'.freeze

    def self.authorization_url(redirect_uri:)
      uri = URI(BASE_URL + AUTHORIZATION_ENDPOINT)
      uri.query = { client_id: client_id, scope: 'incoming-webhook', redirect_uri: app_host_url + redirect_uri }.to_query
      uri.to_s
    end

    def self.access_token_request(code:, redirect_uri:)
      conn = Faraday.new(url: BASE_URL) do |faraday|
        faraday.request :url_encoded
        faraday.response :follow_redirects
        faraday.response :json
      end

      response = conn.post(
        ACCESS_TOKEN_ENDPOINT,
        client_id: client_id,
        client_secret: client_secret,
        code: code,
        redirect_uri: app_host_url + redirect_uri
      )

      response.body
    end

    def self.client_id
      '4900954890887.4939178333648'
    end

    def self.client_secret
      '98bc473f227a7d5b586dcbb35e1acdd6'
    end

    def self.app_host_url
      'https://72a4-2a02-a31a-c143-b780-8587-bb97-bfc7-dd69.eu.ngrok.io'
    end
  end
end
