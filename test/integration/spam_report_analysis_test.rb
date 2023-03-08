require "test_helper"
require "minitest/mock"

class SpamReportAnalysisTest < ActionDispatch::IntegrationTest
  test "report analysis identifies spam report" do
    post api_v1_report_spam_analysis_path, params: { report: spam_payload }
    assert_response :success
    assert JSON.parse(response.body)['is_spam']
  end

  test "report analysis posts message about the spam report to Slack" do
    slack_mock = Minitest::Mock.new
    slack_mock.expect(:chat_postMessage, true, text: "Spam Report!\nPayload: #{spam_payload.to_json}", channel: "#general", as_user: true)

    Slack::Web::Client.stub :new, slack_mock do
      post api_v1_report_spam_analysis_path, params: { report: spam_payload }
    end
    assert_mock slack_mock
  end

  test "report analysis identifies valid report" do
    post api_v1_report_spam_analysis_path, params: { report: valid_payload }
    assert_response :success
    refute JSON.parse(response.body)['is_spam']
  end

  private

  def spam_payload
    {
      "RecordType": "Bounce",
      "Type": "SpamNotification",
      "TypeCode": '512',
      "Name": "Spam notification",
      "Tag": "",
      "MessageStream": "outbound",
      "Description": "The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content.",
      "Email": "zaphod@example.com",
      "From": "notifications@honeybadger.io",
      "BouncedAt": "2023-02-27T21:41:30Z",
    }
  end

  def valid_payload
    {
      "RecordType": "Bounce",
      "MessageStream": "outbound",
      "Type": "HardBounce",
      "TypeCode": '1',
      "Name": "Hard bounce",
      "Tag": "Test",
      "Description": "The server was unable to deliver your message (ex: unknown user, mailbox not found).",
      "Email": "arthur@example.com",
      "From": "notifications@honeybadger.io",
      "BouncedAt": "2019-11-05T16:33:54.9070259Z",
    }
  end
end
