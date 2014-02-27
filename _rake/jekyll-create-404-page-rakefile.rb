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
  available_products = YAML.load_file('_data/productmap.yml')

  # Index YML Front Matter  
  index = "---\n";
  index += "layout: default\n";
  index += "title: 404 Page Not Found\n";
  index += "---\n\n";

  # Title
  index += "<h1>404 Page Not Found.</h1>\n\n"
  index += "<p>Chances are the item you're looking for is no longer for sale. Here's a random sampling of gear with availability:</p>\n\n"

  # Posts
  index += '<div class="row">'+"\n\n"
  posts = site.posts.shuffle.first(128)
  start = 0
  stop = 48
  posts.each do |post|
    if start < stop
      post_data = post.to_liquid
      pid = post_data['sku']
      if available_products[pid]
        start = start + 1

        index += '<div class="col-xs-6 col-sm-3 col-md-2">'
          index += '<div class="thumbnail" style="margin-bottom:30px;max-width:300px;min-height:265px;">'
            index += '<a href="' + site.baseurl + post_data['url'] + '"><img data-original="' + post_data['lg_image'] + '" class="lazy img-responsive"></a>'
            index += '<div class="caption" style="height:100px;overflow:hidden">'
              index += '<p>'
                if post_data['sale_price']
                  index += '<span class="label label-success">$' + post_data['sale_price'] + '</span>&nbsp;<a href="' + site.baseurl + post_data['url'] + '">'
                end
                index += post_data['title'] + '</a>'
              index += '</p>'
            index += '</div>'
          index += '</div>'
        index += '</div>'


      end
    end
  end
  index += "</div>\n\n"

  # Index Page
  File.open("404.html", 'w+') do |file|
    file.puts index
  end

  puts 'Done.'

end