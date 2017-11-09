class MainJob < ActiveJob::Base
  def perform
    # begin
      ParserSetting.all.each do |site_settings|
        ParseWorker.new.perform site_settings
      end
    # rescue
    #   return false
    # end
  end
end
