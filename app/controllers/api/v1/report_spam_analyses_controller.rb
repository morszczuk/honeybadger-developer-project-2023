class Api::V1::ReportSpamAnalysesController < ApplicationController
  def create
    render json: { is_spam: true }
  end
end
