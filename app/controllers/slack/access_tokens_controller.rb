class Slack::AccessTokensController < ApplicationController
  def show
    access_token_response = Slack::Api.access_token_request(code: params[:code], redirect_uri: slack_access_token_path)
    if access_token_response['ok']
      render json: { access_token: access_token_response['access_token'] }
    else
      render json: { error: access_token_response['error'] }, status: :bad_request
    end
  end
end
