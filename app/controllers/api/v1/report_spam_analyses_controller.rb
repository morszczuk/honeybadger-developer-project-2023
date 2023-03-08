class Api::V1::ReportSpamAnalysesController < ApplicationController
  def create
    report_payload = ReportPayload.new(params[:report])
    if report_payload.valid?
      if params[:report]['Type'] == 'SpamNotification'
        token = 'xoxb-4902118330951-4916578303299-BNgsTDCsgvgxZe3wxLrNU5K6'
        client = Slack::Web::Client.new(token: token)
        client.chat_postMessage(text: "Spam Report!\nPayload: #{report_payload.payload.to_json}", channel: '#general', as_user: true)

        render json: { is_spam: true }
      else
        render json: { is_spam: false }
      end
    else
      render json: { errors: report_payload.errors.messages }, status: :bad_request
    end
  end
end
