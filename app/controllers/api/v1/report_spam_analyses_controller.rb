class Api::V1::ReportSpamAnalysesController < ApplicationController
  def create
    # TODO: Apart form the testing purposes, access token shouldn't be set at this level.
    Slack::Client.configure_token(token: params.dig(:slack, :access_token))

    report_payload = ReportPayload.new(params[:report])
    if report_payload.valid?
      result = Report::PayloadAnalyser.new(report_payload).check(type: :spam, actions: [:slack_message])

      if result[:check] == :ok
        render json: result[:details]
      else
        render json: { errors: result[:errors] }, status: :bad_request
      end
    else
      render json: { errors: report_payload.errors.messages }, status: :bad_request
    end
  end
end
