class Slack::AuthorizationsController < ApplicationController
  def show
    redirect_to Slack::Api.authorization_url(redirect_uri: slack_access_token_path), allow_other_host: true
  end
end
