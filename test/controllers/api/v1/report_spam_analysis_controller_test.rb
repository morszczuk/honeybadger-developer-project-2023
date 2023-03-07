require "test_helper"

class Api::V1::ReportSpamAnalysisControllerTest < ActionDispatch::IntegrationTest
  test "when payload is invalid, bad request is returned" do
    post api_v1_report_spam_analysis_path, params: { report: { incorrect: 'payload' } }
    assert_response :bad_request
  end
end
