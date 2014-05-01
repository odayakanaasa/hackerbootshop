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

  available_products = YAML.load_file('_data/productmap.yml')

   # Posts
  site.tags.each do |tag, posts|

    next if tag == ''
    next if tag == '-'

    # YML Front Matter
    html = "---\n";
    html += "layout: tags\n";
    html += "title: " + tag + "\n";
    html += "---\n\n";

    # Posts
    html += "<div class=\"row\">\n\n"

    posts.reverse.each do |post|
      post_data = post.to_liquid
      pid = post_data['sku']
      if available_products[pid]
        html += '<div class="col-xs-6 col-sm-3 col-md-2">'
          html += '<div class="thumbnail" style="margin-bottom:30px;max-width:300px;min-height:265px;">'
            html += '<a href="' + site.baseurl + post_data['url'] + '"><img data-original="' + post_data['lg_image'] + '" class="lazy img-responsive"></a>'
            html += '<div class="caption" style="height:100px;overflow:hidden">'
              html += '<p>'
                if post_data['sale_price']
                  html += '<span class="label label-success">$' + post_data['sale_price'] + '</span>&nbsp;<a href="' + site.baseurl + post_data['url'] + '">'
                end
                html += post_data['title'] + '</a>'
              html += '</p>'
            html += '</div>'
          html += '</div>'
        html += '</div>'
      end
    end

    html += "</div>\n\n"
    
    # Page
    file = 'tags/' + tag + '/index.html'
    FileUtils.mkdir_p(File.dirname(file)) unless File.exists?(File.dirname(file))
    File.open(file, 'w+') do |file|
      file.puts html
    end

  end

  puts 'Done.'

end