module Slack
  class Client
    DEFAULT_CHANNEL = '#general'

    def initialize
      @client = Slack::Web::Client.new
    end

    def self.configure_token(token:)
      Slack::Web::Client.configure do |config|
        config.token = token
      end
    end

    def message(text:, channel: DEFAULT_CHANNEL)
      client.chat_postMessage(text: text, channel: channel, as_user: true)
    end

    private

    attr_reader :client
  end
end
