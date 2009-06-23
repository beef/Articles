module Beef
  module Articles
    def article_permalink(article, options = {})
      article_permalink_path(article.published_at.year,article.published_at.month,article.published_at.day,article.permalink,options)
    end
  end
end