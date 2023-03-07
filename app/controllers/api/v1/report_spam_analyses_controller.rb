class Api::V1::ReportSpamAnalysesController < ApplicationController
  def create
    debugger
    if params[:report]['Type'] == 'SpamNotification'
      render json: { is_spam: true }
    else
      render json: { is_spam: false }
    end
  end
end
