class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  # use callbacks like in any other controllers
  around_action :with_locale
  self.session_store = :file_store

  # Every update can have one of: message, inline_query, chosen_inline_result,
  # callback_query, etc.
  # Define method with same name to respond to this updates.
  def message(message)
    if ad?(message)
      ad = Ad.create(content: message['text'], username: from['username'], author_telegram_id: from['id'])

      if ad.persisted?
        # send_to_moderators
        send_to_moderators(ad)
        respond_with :message, text: 'Бездушная машина отправила ваше объявление модераторам.'
      end
    end
  end

  # This basic methods receives commonly used params:
  #
  #   message(payload)
  #   inline_query(query, offset)
  #   chosen_inline_result(result_id, query)
  #   callback_query(data)

  # Define public methods ending with `!` to handle commands.
  # Command arguments will be parsed and passed to the method.
  # Be sure to use splat args and default values to not get errors when
  # someone passed more or less arguments in the message.
  def start!(data = nil, *)
    # do_smth_with(data)

    # There are `chat` & `from` shortcut methods.
    # For callback queries `chat` if taken from `message` when it's available.
    response = from ? "Hello #{from['username']}!" : 'Hi there!'
    # There is `respond_with` helper to set `chat_id` from received message:
    respond_with :message, text: response
    # `reply_with` also sets `reply_to_message_id`:
    # reply_with :photo, photo: File.open('party.jpg')
  end

  def admin!(data = nil, *)
    return unless Owner.find_by(telegram_id: from['id'])

    if data.to_i > 0
      Moderator.create(telegram_id: data)

      respond_with :message, text: 'Moderator created.' and return
    end

    respond_with :message, text: t('.prompt'), reply_markup: {
      inline_keyboard: [
        [
          { text: 'Add moderator', callback_data: 'add_moderator' }
        ]
      ],
    }
  end

  def callback_query(data)
    if data.include?('approve_ad')
      ad_id = data.split('_').last()
      approve_ad!(ad_id)
    elsif data == 'add_moderator'
      save_context :admin!
      respond_with :message, text: 'Enter moderator telegram id'
    elsif data == 'alert'
      # answer_callback_query 'Alert', show_alert: true
      respond_with :message, text: 'lala'
    else
      answer_callback_query 'No alert'
    end
  end

  def approve_ad!(ad_id)
    Ad.find(ad_id).update(approved: true)

    respond_with :message, text: 'Ad approved.'
  end

  private

  def with_locale(&block)
    I18n.with_locale(locale_for_update, &block)
  end

  def locale_for_update
    if from
      # locale for user
    elsif chat
      # locale for chat
    end
  end

  def ad?(message)
    MessageReader.new(message).call
  end

  def send_to_moderators(ad)
    ModeratorAnnouncementSender.new(ad).call
  end
end
