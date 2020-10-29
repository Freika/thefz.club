class MessageReader
  HASHTAGS = %w[#куплю #продам #покупка #продажа #отдам #обмен #меняю #вещи].freeze

  def initialize(message)
    @message = message
  end

  def call
    with_hashtag?
  end

  private

  def with_hashtag?
    HASHTAGS.any? { |word| @message['text'].include?(word) }
  end
end
