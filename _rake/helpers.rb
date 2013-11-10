def build_post_link (post, baseurl) 
      post_data = post.to_liquid
      #pp post_data
      link = "<a class=\"list-group-item\" href=\"" + baseurl + post_data['url'] + "\">"
      if (post_data['sale_price'] != nil) 
        link += "<span class=\"label label-success\">" + post_data['sale_price'] + "</span>&nbsp;"
      end
      link += post_data['title'] + "</a>\n"
end

def build_category_path (path)
    category = path.gsub(' ','-').gsub('\'','').gsub('-/-','/').gsub(',','').gsub('----','-')
    category_path = category.gsub('-','/').gsub('///','/')
end

def build_category_name (path)
	category = path.gsub(' ','-').gsub('\'','').gsub('-/-','/').gsub(',','').gsub('----','-').gsub('///','/')
  category_name = category.gsub('-',' ').gsub('/','-')
end

def time_rand from = 0.0, to = Time.now
  Time.at(from + rand * (to.to_f - from.to_f))
end
