class MainDecorator < Draper::Decorator
  delegate_all
  delegate :current_page, :per_page, :offset, :total_entries, :total_pages

  delegate :url_helpers, to: 'Rails.application.routes'

end