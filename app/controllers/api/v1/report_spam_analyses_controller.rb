class Api::V1::ReportSpamAnalysesController < ApplicationController
  def create
    report_payload = ReportPayload.new(params[:report])
    if report_payload.valid?
      if params[:report]['Type'] == 'SpamNotification'
        render json: { is_spam: true }
      else
        render json: { is_spam: false }
      end
    else
      render json: { errors: report_payload.errors.messages }, status: :bad_request
    end
  end
end
