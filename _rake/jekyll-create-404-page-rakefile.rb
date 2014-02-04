desc 'Generate 404 Page'

task :four do

  puts "Generating 404 Page..."
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
  index += "title: 404 Page Not Found\n";
  index += "---\n\n";

  # Title
  index += "<h1>404 Page Not Found!</h1>\n\n"

  # Posts
  index += '<div class="row">'+"\n\n"
  site.categories['camping-hiking'].shuffle.first(48).each do |post|
    post_data = post.to_liquid
    pid = post_data['sku']
    index += "<div class=\"col-sm-6 col-md-3\">\n";
      index += "<div class=\"thumbnail\" style=\"margin-bottom:30px;max-width:300px\">\n"
        index += '<a href="' + site.baseurl + post_data["url"] + '"><img data-original="' + products[pid]['image_url'] + '" class="lazy img-responsive"></a>' + "\n"
        index += "<div class=\"caption\" style=\"height:100px;overflow:hidden\">\n"
          index += "<p>\n"
            if products[pid]['sale_price']
              index += '<span class="label label-success">' + products[pid]['sale_price'] + '</span>&nbsp;'
              index += '<a href="' + site.baseurl + post_data["url"] + '">' + products[pid]['product_name'] + "</a>\n"
            end
          index += "</p>\n"
        index += "</div>\n"
      index += "</div>\n";
    index += "</div>\n\n";
  end
  index += "</div>\n\n"

  # Index Page
  File.open("404.html", 'w+') do |file|
    file.puts index
  end

  puts 'Done.'

end