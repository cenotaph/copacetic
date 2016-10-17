# index.rss.builder
xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Copacetic Blog"
    xml.description "Here is a blog where we will post our latest thoughts, news or other comments."
    xml.link formatted_posts_url(:rss)
    
    for article in @posts
      xml.item do
        xml.title article.title
        xml.description article.body
        xml.pubDate article.created_at.to_s(:rfc822)
        xml.link formatted_article_url(article, :rss)
        xml.guid formatted_article_url(article, :rss)
      end
    end
  end
end

