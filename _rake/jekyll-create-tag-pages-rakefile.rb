desc 'Generate tag pages'

# Inspiration: 
# http://gist.github.com/262512
# https://gist.github.com/pkazmierczak/1554185

task :tags do

  puts "Generating tags..."
  require 'rubygems'
  require 'jekyll'
  include Jekyll::Filters
  
  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')

  # Index YML Front Matter  
  index = "---\n";
  index += "layout: default\n";
  index += "title: Browse Tags\n";
  index += "---\n\n";

  # Posts
  index += "<div class=\"list-group\">"
  site.tags.sort.each do |tag, posts|

    # Index
    index += "<a class=\"list-group-item\" href=\"" + site.baseurl + "/tags/" +  tag + ".html\">"
    index += "<span class=\"badge\">" + posts.length.to_s + "</span>" + tag + "</a>\n"

    # YML Front Matter
    html = "---\n";
    html += "layout: default\n";
    html += "title: Browse " + tag + "\n";
    html += "---\n\n";
 
    # List of Posts
    html += "<div class=\"list-group\">\n"
    posts.reverse.each_with_index do |post, i|
      post_data = post.to_liquid
      html += "<a class=\"list-group-item\" href=\"" + site.baseurl + post.url + "\">"
      html += "<span class=\"label label-success\">" + post_data['sale_price'] + "</span>&nbsp;" + post_data['title'] + "</a>\n"
    end
    html += "</div>\n\n"
    
    # Page
    File.open("tags/#{tag}.html", 'w+') do |file|
      #file.puts html
    end

  end
  index += "</div>\n\n"

  # Index Page
  File.open("tags/index.html", 'w+') do |file|
    #file.puts index
  end

  puts 'Done.'

end