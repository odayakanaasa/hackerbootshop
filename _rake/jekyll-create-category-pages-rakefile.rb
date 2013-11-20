desc 'Generate category pages'

task :categories do

  puts "Generating categories..."
  require 'rubygems'
  require 'jekyll'
  require 'fileutils'
  require 'pp'
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

    category_name = titleize(category)

    # Index
    index += "<a href=\"" + site.baseurl + "/browse/" + category + "/index.html\" class=\"list-group-item\">"
    index += "<span class=\"badge\">" + posts.length.to_s + "</span>" + category_name + "</a>\n"

    # YML Front Matter
    html = "---\n";
    html += "layout: default\n";
    html += "title: Browse " + category_name + "\n";
    html += "---\n\n";
 
    # List of Posts
    html += "<div class=\"list-group\">\n"
    posts.reverse.each_with_index do |post, i|
      html += build_post_link(post, site.baseurl)
    end
    html += "</div>\n\n"
    
    # Page
    file = "browse/#{category}/index.html"
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