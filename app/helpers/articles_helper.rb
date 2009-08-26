module ArticlesHelper
  
  def article_categories
    tabs = Category.with( :articles ).collect do |category|
      content_tag :li, link_to( h(category.title), category_articles_path(category.permalink) )
    end
    content_tag( :h2, 'Categories' ) + content_tag( :ul, tabs.join, :class => "categories" )
  end
  
  def comments_link(article)
    if(article.comments.count!=0)
      "|&nbsp;&nbsp;#{link_to('Comment'.pluralize, [article, {:anchor => 'comments'}])} (#{article.comments.count.to_s})"
    else
      "#{(article.commentable?)? '|' : ''}&nbsp;&nbsp;#{link_to 'Comment', [article, {:anchor => 'comments'}] if article.commentable?}"
    end
  end

  def digg_link(options, html_options = {})
    link_to 'Digg', "http://digg.com/submit?phase=2&amp;url=#{server_url_for(options)}", html_options.reverse_merge(:class => 'share-link', :id => 'digg-submit', :title => 'Digg this!')
  end

  def delicious_link(options, html_options = {})
    link_to 'delicious', "http://del.icio.us/post?url=#{server_url_for(options)}", html_options.reverse_merge(:class => 'share-link', :id => 'delicious-submit', :title => 'Save to delicious')
  end
  
  def facebook_link(options, html_options = {})
    link_to 'Facebook', "http://www.facebook.com/sharer.php?u=#{server_url_for(options)}", html_options.reverse_merge(:class => 'share-link', :id => 'facebook-submit', :title => 'Share on Facebook')
  end
  
  def stumble_link(options, html_options = {})
    link_to 'Stumble Upon', "http://www.stumbleupon.com/submit?url=#{server_url_for(options)}", html_options.reverse_merge(:class => 'share-link', :id => 'stumble-submit', :title => 'Stumble on this')
  end
  
  def mail_link(options, html_options = {})
    mail_to nil, "Email", html_options.reverse_merge( :body => server_url_for(options), :class => 'share-link', :id => 'mail-link', :title => 'Email this to a friend')
  end
  
  def twitter_link(options, html_options = {})
    link_to 'Twitter', "http://twitter.com/home?status=#{server_url_for(options)}}", html_options.reverse_merge(:class => 'share-link', :id => 'twitter-submit', :title => 'Tweet this')
  end
  
  def reddit_link(options, html_options = {})
    link_to 'Reddit', "http://www.reddit.com/submit?url=#{server_url_for(options)}", html_options.reverse_merge(:class => 'share-link', :id => 'reddit-submit', :title => 'Reddit this!')
  end
    
  def technorati_link(options, html_options = {})
    link_to 'Technorati', "http://technorati.com/faves/?add=#{server_url_for(options)}", html_options.reverse_merge(:class => 'share-link', :id => 'technorati-submit', :title => 'Technorati this!')
  end
  
  def server_url_for(options = {})
    options ||= {}
    url = case options
    when Hash
      options = { :only_path => true }.update(options.symbolize_keys)
      escape  = options.key?(:escape) ? options.delete(:escape) : true
      @controller.send(:url_for, options)
    else
      escape = false
      polymorphic_url(options)
    end

    escape ? escape_once(url) : url
  end
  
  def archive(conditions = nil, html_options = {})
    this_year = params[:year] || Time.now.year
    html = ''
    all_articles = Article.published.all(:conditions => conditions, :select => 'published_at')
    grouped_by_year = all_articles.group_by{ |a| a.published_at.year  }.sort.reverse
    grouped_by_year.each do |year, articles|
      html << '<li>'
      html << link_to("#{year}", {:controller => '/articles', :action => 'index', :year => year, :month => nil, :day => nil})
      html << (" (#{articles.size})")
      if this_year.to_i == year
        grouped_by_month = articles.group_by{ |a| a.published_at.month  }.sort.reverse
        html << '<ul>'
        grouped_by_month.each do |month, articles|
          html << '<li>'
          html << link_to("#{Date::MONTHNAMES[month]}", {:controller => '/articles', :action => 'index', :year => year, :month => month, :day => nil})
          html << (" (#{articles.size})")
          html << '</li>'
        end
        html << '</ul>'
      end
      html << '</li>'
    end
    content_tag :ul, html, html_options.reverse_merge!( :class => 'archive' ) unless html.empty?
  end
  
  def related_articles(content_node, &block)
    articles = Article.find_tagged_with content_node.tag_list, :conditions => ['published_at <= ? AND content_nodes.id != ?', Time.now, content_node.id ], :limit => 3,  :include => :created_by
    if block_given?
      yield(articles)
    else
      articles_list(articles)
    end
  end
  
  def recent_articles(options = {}, &block)
    options.merge!(:order => 'published_at DESC')
    options.reverse_merge!(:limit => 3)
    articles =  Article.published.all(options)
    if block_given?
      yield(articles)
    else
      articles_list(articles)
    end
  end
  
  def articles_list(articles)
    return if articles.empty?
    articles.collect! { |article| content_tag( 'li', "#{link_to(article.title, article)}")    }
    content_tag( 'ul', articles.join, :class => 'article-list' )
  end
  
end
