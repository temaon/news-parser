class ApiController < ApplicationController

  before_action :prepare_data, only: [:contact]

  def contact
    render 'home/index'
  end

  def prepare_data
    @latest_news = Post.eager_load(:images).latest.limit(20).decorate
    @latest_news_except = Post.eager_load(:images).latest.where.not(posts: {id: @latest_news.map(&:id)}).limit(10).decorate
    @top_ten_news = Post.eager_load(:images).top_ten.decorate
    @photos = Modules::Post::Image.references(:posts)
                  .joins( 'INNER JOIN `posts` ON `ckeditor_assets`.`assetable_id` = `posts`.`id`' )
                  .latest.sample(6)
    @main_categories = Category.references(:posts).joins(:posts).where('categories.is_main =?', true).uniq.all.to_a
    @other_news = Post.all.sample(6)
  end


end