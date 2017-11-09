class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :prepare_main_info

  def prepare_main_info
    @categories = Category.roots.eager_load(:children).references(:posts).joins(:posts).uniq.all
    @footer_categories = Category.eager_load(:children).references(:posts).joins(:posts).uniq.all
  end

end
