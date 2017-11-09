module ApplicationHelper
  #Asset helpers
  def controller_js
    "controllers/#{controller_name}.js"
  end

  def controller_css
    "controllers/#{controller_name}.css"
  end

  def asset_exists? asset
    !!Rails.application.assets.find_asset(asset)
  end

  def format_query_url(url)
    query_hash = Rack::Utils.parse_nested_query(url)
    query_hash.present? ? '?' + query_hash.to_query : ''
  end

  def social_share_button_tag(title = "", opts = {})
    opts[:allow_sites] ||= SocialShareButton.config.allow_sites

    extra_data = {}
    rel = opts[:rel]
    html = []
    html << "<div class='social_area social-share-button' data-title='#{h title}' data-img='#{opts[:image]}'"
    html << "data-url='#{opts[:url]}' data-desc='#{opts[:desc]}' data-via='#{opts[:via]}'><ul class='social_nav'>"

    opts[:allow_sites].each do |name|
      extra_data = opts.select { |k, _| k.to_s.start_with?('data') } if name.eql?('tumblr')
      special_data = opts.select { |k, _| k.to_s.start_with?('data-' + name) }

      special_data["data-wechat-footer"] = t "social_share_button.wechat_footer" if name == "wechat"

      link_title = t "social_share_button.share_to", :name => t("social_share_button.#{name.downcase}")
      html << "<li class='#{name.gsub(/_/, '')}'>"
      html << link_to("", "#", { :rel => ["nofollow", rel],
                                 "data-site" => name,
                                 :class => "ssb-icon ssb-#{name}",
                                 :onclick => "return SocialShareButton.share(this);",
                                 :title => h(link_title) }.merge(extra_data).merge(special_data))
      html << "</li>"
    end
    html << "</ul></div>"
    raw html.join("\n")
  end

  def social_share_button_tag_news_page(title = "", opts = {})
    opts[:allow_sites] ||= SocialShareButton.config.allow_sites

    extra_data = {}
    rel = opts[:rel]
    html = []
    html << "<div class='social_link social-share-button' data-title='#{h title}' data-img='#{opts[:image]}'"
    html << "data-url='#{opts[:url]}' data-desc='#{opts[:desc]}' data-via='#{opts[:via]}'><ul class='sociallink_nav'>"

    opts[:allow_sites].each do |name|
      extra_data = opts.select { |k, _| k.to_s.start_with?('data') } if name.eql?('tumblr')
      special_data = opts.select { |k, _| k.to_s.start_with?('data-' + name) }

      special_data["data-wechat-footer"] = t "social_share_button.wechat_footer" if name == "wechat"

      link_title = t "social_share_button.share_to", :name => t("social_share_button.#{name.downcase}")
      html << "<li>"
      html << link_to("<i class='fa fa-#{name.gsub(/_/, '-')}'></i>".html_safe, "#", { :rel => ["nofollow", rel],
                                 "data-site" => name,
                                 :class => "ssb-icon ssb-#{name}",
                                 :onclick => "return SocialShareButton.share(this);",
                                 :title => h(link_title) }.merge(extra_data).merge(special_data))
      html << "</li>"
    end
    html << "</ul></div>"
    raw html.join("\n")
  end

end
