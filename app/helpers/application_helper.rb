# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def truncate_words(text, length = 100, end_string = '...')
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
  
  def frontitem_cat(frontitem)
     case frontitem.category 
  		when 1
  			cat = 'comics'
  		when 2
  			cat = 'books'
  		when 3
  			cat = 'dvds'
  		when 4
  			cat = 'cds'
  	end
  	return cat
  end
  
  def copacetic_price(item)
    out = ""
    unless item.listprice.blank?
      out += "<div class=\"retail_price\">retail price - #{number_to_currency(item.listprice)}</div>"
    end
    out += "<div class=\"copacetic_price"
    if item.instock == false
      out += " oos"
    end
    out += "\"><span style=\"color: #0cd424;\">copacetic</span> <span style=\"color: #e83209;\">price</span>"
    out += "<span style=\"color: #4d5ade\"> #{number_to_currency(item.price)}</span></div>"

    return out.html_safe
  end
  
  def get_description(item, style = :full)
    if item.description.blank? && item.shortdesc.blank? && item.tinydesc.blank?
      return "No description for this item."
    else
      case style 
        when :full
          item.description.blank? ? (item.shortdesc.blank? ? item.tinydesc.html_safe : item.shortdesc.html_safe) : item.description.html_safe
        when :short
          item.shortdesc.blank? ? (item.tinydesc.blank? ? item.description.html_safe : item.tinydesc.html_safe) : item.shortdesc.html_safe
        when :tiny
          item.tinydesc.blank? ? (item.shortdesc.blank? ? item.description.html_safe : item.shortdesc.html_safe) : item.tinydesc.html_safe
        else
          item.description
        end
    end
  end
  
  def is_admin?
    if current_admin_user
      if admin_user.role == 'admin'
        return true
      else
        return false
      end
    else
      return false
    end
  end
  
  def link_if_admin(*args)
    if current_admin_user
      if current_admin_user.role?('SuperAdmin')
        return link_to(args.shift, args.to_s)
      end
    end
  end

  def share_this(item)
    out = "<span class='st_sharethis' st_title='" + item.display_title + "' st_url='http://#{request.host}" + url_for(item) + "' displayText=''></span><span class='st_facebook' st_title='" + item.display_title + "' st_url='http://#{request.host}" + url_for(item) + "'  displayText=''></span>"
    out += "<span class='st_digg' st_title='" + item.display_title + "' st_url='http://#{request.host}" + url_for(item) + "'  displayText=''></span><span class='st_twitter' st_title='" + item.display_title + "' st_url='http://#{request.host}" + url_for(item) + "'  displayText=''></span>"
    out += "<span class='st_reddit' st_title='" + item.display_title + "' st_url='http://#{request.host}" + url_for(item) + "'  displayText=''></span><span class='st_plusone' st_title='" + item.display_title + "' st_url='http://#{request.host}" + url_for(item) + "'  displayText=''></span>"
    out += "<span class='st_email' st_title='" + item.display_title + "' st_url='http://#{request.host}" + url_for(item) + "'  displayText=''></span>"
    return out.html_safe
  end

  def twitter_status

    saved_tweet = Cash.where(:source => 'twitter').order(:link_url).limit(3)
    last_tweet = saved_tweet.first unless saved_tweet.empty?
    now = Time.now.to_i
    if saved_tweet.empty?
      begin
        regex = Regexp.new '((https?:\/\/|www\.)([-\w\.]+)+(:\d+)?(\/([\w\/_\.]*(\?\S+)?)?)?)'
        twit = Twitter.user_timeline("copcomco")[0..2]
        # out = [twit.text.gsub( regex, '<a href="\1">\1</a>').gsub(/\@([a-zA-Z0-9_]+)/, '<a href="http://www.twitter.com/#!/\1">@\1</a>'), twit.created_at, twit.id]
      rescue 
        twit =  ['Sorry, can\'t connect to Twitter right now - maybe you can <a href="http://www.twitter.com/hyksos">try</a>.', Time.now, 0]
      end
      twit.each_with_index do |out, index|
        s = Cash.new(:source => 'twitter', :content => out.text.gsub( regex, '<a href="\1">\1</a>').gsub(/\@([a-zA-Z0-9_]+)/, '<a href="http://www.twitter.com/#!/\1">@\1</a>'), :order => out.created_at.to_i, :title => out.id, :link_url => index)
        s.save!
      end
      return Cash.where(:source => 'twitter').order(:link_url)
    elsif now - last_tweet.updated_at.to_i < 930
      return saved_tweet
    else
      begin
        regex = Regexp.new '((https?:\/\/|www\.)([-\w\.]+)+(:\d+)?(\/([\w\/_\.]*(\?\S+)?)?)?)'
        twit = Twitter.user_timeline("copcomco")[0..2]
        # out = [twit.text.gsub( regex, '<a href="\1">\1</a>').gsub(/\@([a-zA-Z0-9_]+)/, '<a href="http://www.twitter.com/#!/\1">@\1</a>'), twit.created_at, twit.id]
        if twit.first.id == last_tweet.title
          return twit
        else
          saved_tweet.each{|x| x.destroy }
          twit.each_with_index do |out, index|
            s = Cash.new(:source => 'twitter', :content => out.text.gsub( regex, '<a href="\1">\1</a>').gsub(/\@([a-zA-Z0-9_]+)/, '<a href="http://www.twitter.com/#!/\1">@\1</a>'), :order => out.created_at.to_i, :title => out.id, :link_url => index)
            s.save!
          end
          return Cash.where(:source => 'twitter').order(:link_url)
        end
      rescue 
        return saved_tweet
      end
    end
  end
    
end
