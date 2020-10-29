namespace :bots do
  desc "start bots"
  task start: :environment do
    Telegram::Bot::UpdatesPoller.new(Telegram.bots[:baraholka], Bots::BaraholkaController).start
  end
end
