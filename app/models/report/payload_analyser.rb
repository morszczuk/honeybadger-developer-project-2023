# Class responsible for performing a check on a report.
# If check is positive, a set of actions will be performed.
class Report
  class PayloadAnalyser
    SPAM_TYPE_CODE = '512'

    def initialize(payload)
      @payload = payload
    end

    def check(type:, actions:)
      check_outcome = perform_check(type)
      actions.each { |action| perform_action(action) } if check_outcome[:result]

      check_outcome
    rescue => e
      Rails.logger.error e
      { check: :fail, errors: e.message }
    end

    private

    attr_reader :payload

    def perform_check(type)
      case type
      when :spam then spam_check
      else
        raise "Check #{type} not supported!"
      end
    end

    def perform_action(action)
      case action
      when :slack_message then slack_spam_report_message
      else
        raise "Action #{action} not recognised!"
      end
    end

    def spam_check
      if payload.type_code == SPAM_TYPE_CODE
        { check: :ok, result: true, details: { is_spam: true }}
      else
        { check: :ok, result: false, details: { is_spam: false }}
      end
    end

    def slack_spam_report_message
      Slack::Client.new.message(text: "Spam Report!\nPayload: #{payload.to_s}",)
    end
  end
end
