desc 'Generate category pages'

task :categories do

  puts "Generating categories..."
  require 'rubygems'
  require 'jekyll'
  require 'fileutils'
  include Jekyll::Filters
  
  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')

  # Index YML Front Matter  
  index = "---\n";
  index += "layout: default\n";
  index += "title: Browse Product Categories\n";
  index += "---\n\n";

  # Category Pages
  index += "<div class=\"list-group\">\n"
  site.categories.sort.each do |category, posts|

    category = category.gsub(' ','-').gsub('\'','').gsub('-/-','/').gsub(',','').gsub('----','-')
    category_path = category.gsub('-','/')
    category_name = category.gsub('-',' ').gsub('/','-')

    # Index
    index += "<a href=\"" + category_path + ".html\" class=\"list-group-item\">"
    index += "<span class=\"badge\">" + posts.length.to_s + "</span>" + category_name + "</a>\n"

    # YML Front Matter
    html = "---\n";
    html += "layout: default\n";
    html += "title: Browse " + category_name + "\n";
    html += "---\n\n";
 
    # List of Posts
    html += "<div class=\"list-group\">\n"
    posts.reverse.each_with_index do |post, i|
      post_data = post.to_liquid
      html += "<a class=\"list-group-item\" href=\"" + post.url + "\">"
      if (post_data['sale_price'] != nil) 
        html += "<span class=\"label label-success\">" + post_data['sale_price'] + "</span>&nbsp;"
      end
      html += post_data['title'] + "</a>\n"
    end
    html += "</div>\n\n"
    
    # Page
    file = "browse/#{category_path}.html"
    FileUtils.mkdir_p(File.dirname(file)) unless File.exists?(File.dirname(file))
    File.open(file, 'w+') do |file|
      file.puts html
    end

  end
  index += "</div>\n\n"

  # Index Page
  File.open("browse/index.html", 'w+') do |file|
    file.puts index
  end

  puts 'Done.'
  
end