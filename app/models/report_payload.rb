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
end
