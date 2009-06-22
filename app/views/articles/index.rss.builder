xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0") do
  xml.channel do
    xml.title("#{Settings.site_name} - #{page_title}")
    xml.link(url_for {} )
    xml.language('en-gb')
      for article in @articles
        xml.item do
          xml.title(article.title)
          xml.category(article.tag_list)
          xml.description(article.description)
          xml.pubDate(article.published_at.rfc822)
          xml.link(article_permalink(article, :only_path => false))
          xml.guid(article_permalink(article, :only_path => false))
        end
      end
  end
end