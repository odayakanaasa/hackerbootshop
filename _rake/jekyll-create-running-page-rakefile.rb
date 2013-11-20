desc 'Generate Running Landing Page'

task :running do

  puts "Generating Running Landing Page..."
  require 'rubygems'
  require 'jekyll'
  require 'pp'
  require 'yaml'
  include Jekyll::Filters
  
  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')

  products = YAML.load_file('_data/products.yml')

  # Index YML Front Matter  
  index = "---\n";
  index += "layout: default\n";
  index += "title: Welcome\n";
  index += "---\n\n";

  # Posts
  index += "<div class=\"row\">\n\n"
  site.tags['running'].shuffle.first(12).each do |post|
    post_data = post.to_liquid
    pid = post_data['sku']
    index += "<div class=\"col-sm-6 col-md-3\">\n";
      index += "<div class=\"thumbnail alert alert-info\" style=\"margin-bottom:30px;max-width:300px\">\n";
        index += "<a href=\"" + site.baseurl + post_data["url"] + "\">";
        index += "<img src=\"" + products[pid]['image_url'] + "\" class=\"img-responsive\" />";
        index += "</a>\n"
        index += "<div class=\"caption\" style=\"height:124px;overflow:hidden\">\n"
          index += "<h4>" + post_data["title"] + "</h4>\n";
        index += "</div>\n";
      index += "</div>\n";
    index += "</div>\n\n";
  end
  index += "</div>\n\n"

  # Index Page
  File.open("running.html", 'w+') do |file|
    file.puts index
  end

  puts 'Done.'

end