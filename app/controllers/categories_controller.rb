class CategoriesController <  ApplicationController

  before_action :prepare_data, only: [:show]

  add_breadcrumb 'Главная', :root_path

  def show

  end

  def prepare_data
    @category = Category.friendly.find(params[:id])
    @posts = @category.posts.latest.page(params[:page])
    @posts_modify = @posts.map(&:decorate).each_slice((@posts.size > 1) ? @posts.size / 2 : 1)
    @latest_news_except = Post.eager_load(:images).latest.limit(10).decorate
    @top_ten_news = Post.eager_load(:images).top_ten.decorate
    @photos = Modules::Post::Image.references(:posts)
                  .joins( 'INNER JOIN `posts` ON `ckeditor_assets`.`assetable_id` = `posts`.`id`' )
                  .latest.sample(6)
    @other_news = Post.all.sample(6)
  end

end