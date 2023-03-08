# Wrapper around the report's payload.
# Provides interface to interact with the payload data.
class ReportPayload
  include ActiveModel::Validations

  attr_reader :payload

  validate :payload_correctness

  def initialize(payload)
    @payload = payload
  end

  def payload_correctness
    return if payload.key? 'Type'

    errors.add(:payload, 'Payload has to contain key Type')
  end

  def type_code
    payload['TypeCode'].to_s
  end

  def to_s
    payload.to_json.to_s
  end
end
