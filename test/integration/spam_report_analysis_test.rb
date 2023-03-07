require "test_helper"

class SpamReportAnalysisTest < ActionDispatch::IntegrationTest
  test "report analysis identifies spam report" do
    post api_v1_report_spam_analysis_path, params: spam_payload
    assert_response :success
    assert JSON.parse(response.body)['is_spam']
  end

  private

  def spam_payload
    {
      "RecordType": "Bounce",
      "Type": "SpamNotification",
      "TypeCode": 512,
      "Name": "Spam notification",
      "Tag": "",
      "MessageStream": "outbound",
      "Description": "The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content.",
      "Email": "zaphod@example.com",
      "From": "notifications@honeybadger.io",
      "BouncedAt": "2023-02-27T21:41:30Z",
    }
  end
end
