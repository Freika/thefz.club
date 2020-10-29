class ModeratorAnnouncementSender
  def initialize(ad)
    @ad = ad
  end

  def call
    Moderator.find_each do |moderator|
      client.send_message(chat_id: moderator.telegram_id, text: message_text, reply_markup: {
        inline_keyboard: [
          [
            { text: 'Approve ad', callback_data: "approve_ad_#{@ad.id}" }
          ]
        ],
      })
    end

    message_text
  end

  private

  def message_text
    "Объявление: #{@ad.content} \n Автор: @#{@ad.username}"
  end

  def client
    Telegram::Bot::Client.new(DEFAULT_BOT_TOKEN)
  end
end
