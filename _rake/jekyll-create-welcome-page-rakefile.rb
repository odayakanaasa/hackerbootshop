desc 'Generate Welcome Landing Page'

def thumbnail (baseurl, pageurl, image, title)
    index = "<div class=\"col-sm-6 col-md-3\">\n";
      index += "<div class=\"thumbnail alert alert-info\" style=\"margin-bottom:30px;max-width:300px\">\n";
        index += "<a href=\"" + baseurl + pageurl + "\">";
        index += "<img src=\"" + image + "\" class=\"img-responsive\" />";
        index += "</a>\n"
        index += "<div class=\"caption\" style=\"height:124px;overflow:hidden;\">\n"
          index += "<h4>" + title + "</h4>\n";
        index += "</div>\n";
      index += "</div>\n";
    index += "</div>\n\n";
end

task :welcome do

  puts "Generating Welcome Landing Page..."
  require 'rubygems'
  require 'jekyll'
  require 'yaml'
  include Jekyll::Filters
  
  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')

  products = YAML.load_file('_data/products.yml')

  # Index YML Front Matter  
  index = "---\n";
  index += "layout: default\n";
  index += "title: Welcome to Hacker Bootstrap Shop\n";
  index += "---\n\n";

  index += "<h2>Mess:</h2>"
  index += "<div class=\"row\">\n\n"
  site.tags['mess'].shuffle.first(4).each do |post|
    post_data = post.to_liquid
    pid = post_data['sku']
    index += thumbnail(site.baseurl, post_data["url"], products[pid]['image_url'], post_data["title"])
  end
  index += "</div>\n\n"

  index += "<h2>Coffee:</h2>"
  index += "<div class=\"row\">\n\n"
  site.tags['coffee'].shuffle.first(4).each do |post|
    post_data = post.to_liquid
    pid = post_data['sku']
    index += thumbnail(site.baseurl, post_data["url"], products[pid]['image_url'], post_data["title"])
  end
  index += "</div>\n\n"

  index += "<h2>Yoga Pants:</h2>"
  index += "<div class=\"row\">\n\n"
  site.tags['yoga-pants'].shuffle.first(4).each do |post|
    post_data = post.to_liquid
    pid = post_data['sku']
    index += thumbnail(site.baseurl, post_data["url"], products[pid]['image_url'], post_data["title"])
  end
  index += "</div>\n\n"

  # Index Page
  File.open("welcome.html", 'w+') do |file|
    file.puts index
  end

  puts 'Done.'

end