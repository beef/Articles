module Beef
  module Articles
    def article_path(article, options = {})
      article_permalink_path(article.published_at.year,article.published_at.month,article.published_at.day,article.permalink,options)
    end
    
    def article_url(article, options = {}) 
      article_path(article, options.merge(:only_path => false)) 
    end
  end
end