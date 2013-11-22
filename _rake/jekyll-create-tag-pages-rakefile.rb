desc 'Generate Tag Pages'

# Inspiration: 
# http://gist.github.com/262512
# https://gist.github.com/pkazmierczak/1554185

task :tags do

  puts "Generating Tag Pages..."
  require 'rubygems'
  require 'jekyll'
  require 'yaml'
  require 'pp'
  include Jekyll::Filters
  
  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')

  products = YAML.load_file('_data/products.yml')

  # Index YML Front Matter  
  index_fm = "---\n";
  index_fm += "layout: default\n";
  index_fm += "title: Browse Tags\n";
  index_fm += "---\n\n";

  # Posts
  index_list = "<div class=\"list-group\">"
  site.tags.sort.each do |tag, posts|

    # Index
    index_list += "<a class=\"list-group-item\" href=\"" + site.baseurl + "/tags/" +  tag + "/index.html\">"
    index_list += "<span class=\"badge\">" + posts.length.to_s + "</span>" + tag + "</a>\n"

    # YML Front Matter
    html = "---\n";
    html += "layout: tags\n";
    html += "title: Browse " + tag + "\n";
    html += "---\n\n";

    # Posts
    html += "<div class=\"row\">\n\n"
    posts.reverse.each do |post|
      post_data = post.to_liquid
      pid = post_data['sku']
      html += "<div class=\"col-sm-6 col-md-3\">\n";
        html += "<div class=\"thumbnail alert alert-info\" style=\"margin-bottom:30px;max-width:300px\">\n";
          html += "<a href=\"" + site.baseurl + post_data["url"] + "\">";
          html += "<img src=\"" + products[pid]['image_url'] + "\" class=\"img-responsive\" />";
          html += "</a>\n"
          html += "<div class=\"caption\" style=\"height:124px;overflow:hidden\">\n"
            html += "<h4>" + post_data["title"] + "</h4>\n";
          html += "</div>\n";
        html += "</div>\n";
      html += "</div>\n\n";
    end
    html += "</div>\n\n"
    
    # Page
    file = 'tags/' + tag + '/index.html'
    FileUtils.mkdir_p(File.dirname(file)) unless File.exists?(File.dirname(file))
    File.open(file, 'w+') do |file|
      file.puts html
    end

  end
  index_list += "</div>\n\n"

  # Index Page
  File.open("tags/index.html", 'w+') do |file|
    file.puts index_fm
    file.puts index_list
  end

  puts 'Done.'

end