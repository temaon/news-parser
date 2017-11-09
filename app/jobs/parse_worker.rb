class ParseWorker < ActiveJob::Base
  require 'nokogiri'
  require 'open-uri'
  require 'open_uri_redirections'
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::SanitizeHelper

  def perform(site_settings, url = nil, second_loop = false)
    # begin
      @settings = site_settings
      @free_proxy, @html = get_free_proxy(url || @settings.base_url)
      @html_doc = Nokogiri::HTML(@html)
      @html_doc.encoding = 'utf-8'
      second_loop.present? ? start_parse(url) : set_jobs
    # rescue
    #               return false
    # end
  end

  def set_jobs
    # link = @html_doc.css(@settings.base_links_selector)[0]
    # @formatted_url = (link[:href].include?(@settings.base_url) || link[:href] =~ /https?:\/\//)? link[:href] : URI.join(@settings.base_url, link[:href]).to_s
    # self.class.perform_later(@settings, @formatted_url, true)
    @html_doc.css(@settings.base_links_selector).map do |link|
      @formatted_url = (link[:href].include?(@settings.base_url) || link[:href] =~ /https?:\/\//)? link[:href] : URI.join(@settings.base_url, link[:href]).to_s
      self.class.perform_later(@settings, @formatted_url, true)
    end
  end

  def start_parse(url)
    @post_original_url = url
    # @settings.title_selector
    @post_title = @html_doc.css(@settings.title_selector)[0].content if @html_doc.css(@settings.title_selector)[0].present?
    # @settings.content_selector
    @post_content = @html_doc.css(@settings.content_selector)
    # @settings.gallery_selector
    @post_images = parse_images(@html_doc.css(@settings.gallery_selector))
    # @settings.date_selector
    @post_date = @html_doc.css(@settings.date_selector)[0].content if  @html_doc.css(@settings.date_selector)[0].present?
    # @settings.video_frame
    @post_video_link = @html_doc.css(@settings.video_frame)[0][:src] if @html_doc.css(@settings.video_frame)[0].present?
    @post_video_content = @html_doc.css(@settings.video_frame)[0] if @html_doc.css(@settings.video_frame)[0].present?

    # @settings.tags_selector
    @post_tags = parse_tags(@html_doc.css(@settings.tags_selector))
    # @settings.category_selector
    @post_category = @html_doc.css(@settings.category_selector)[0].content if @settings.category_selector.present? && @html_doc.css(@settings.category_selector)[0].present?
    prepare_and_save_post
  end

  def parse_images(post_images)
    post_images.map do |image|
      # @settings.base_url
      @site_url = URI(@settings.base_url)
      @url_for_images = "#{@site_url.scheme}://#{@site_url.host}"
      image[:src].include?(@url_for_images) ? image[:src] : URI.join(@url_for_images, image[:src]).to_s
    end
  end

  def parse_tags(post_tags)
    post_tags.map(&:content)
  end

  def prepare_and_save_post
    @post = Post.find_by(title: @post_title)
    return if @post.present? && @post.description == ActionController::Base.helpers.sanitize(@post_content.to_html.split.join(' '))
    @post = Post.new
    @post.title = @post_title
    @post.original_url = @post_original_url
    @post.video_link = @post_video_link
    @post.video_content = prepare_iframe(@post_video_content)
    @post.description = ActionController::Base.helpers.sanitize(@post_content.to_html.split.join(' '))
    @post.short_description = truncate(strip_tags(ActionController::Base.helpers.strip_tags(@post_content.to_html.split.join(' '))), length: 120, separator: ' ')
    @post_images.each do |image_url|
      @post.images.build data: URI.parse(image_url)
    end
    @post_tags.each do |tag|
      @post.tag_list.add tag
    end
    if @settings.category.present?
      @post.category = @settings.category
    elsif @post_category.present?
      @category = Category.find_or_initialize_by(title: @post_category)
      @category.save! if @category.new_record?
      @post.category = @category
    end
    @post.is_main = false
    @post.date = @post_date.present? ? Time.parse(@post_date.to_s) : Time.now
    @post.save! if @post.valid?
  end

  def prepare_iframe(content)
    content = content.gsub(/width="\d+"/, 'width="100%"' ).gsub(/height="\d+"/, 'height="100%"' ) if content.present?
    content
  end

  def get_free_proxy(url)
    begin
      uri_obj = URI.parse(URI.escape(url))
      random_proxy =  FreeProxy.all.sample
      html_content = open(uri_obj.to_s, proxy: random_proxy.url, read_timeout: 10).read
      return random_proxy, html_content
    end rescue get_free_proxy(url)
  end


end