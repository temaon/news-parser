class NewsController <   ApplicationController
  before_action :prepare_data, only: [:show]

  add_breadcrumb 'Главная', :root_path

  def index

  end

  def  show
    @news = Post.friendly.includes(:images).find(params[:id])
    @prev_news = @news.prev.first.try(:decorate)
    @next_news = @news.next.first.try(:decorate)
    @related_news = @news.related_posts.limit(3).try(:decorate)
    add_breadcrumb @news.category.title, category_path(@news.category)
    commontator_thread_show(@news) if @news.is_commentable?
    impressionist @news, '', unique: [:session_hash] if @news.present?
    render 'news/show', locals: {news: @news.decorate}
  end


  def prepare_data
    @latest_news = Post.includes(:images).latest.limit(20).decorate
  end

end