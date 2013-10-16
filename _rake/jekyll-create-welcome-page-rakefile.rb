desc 'Generate Welcome Landing Page'

def thumbnail (baseurl, pageurl, image, title)
    index = "<div class=\"col-sm-6 col-md-3\">\n";
      index += "<div class=\"thumbnail alert alert-info\" style=\"margin-bottom:30px;max-width:300px\">\n";
        index += "<a href=\"" + baseurl + pageurl + "\">";
        index += "<img src=\"" + image + "\" class=\"img-circle img-responsive\" />";
        index += "</a>\n"
        index += "<div class=\"caption\" style=\"min-height:124px;\">\n"
          index += "<h4>" + title + "</h4>\n";
        index += "</div>\n";
      index += "</div>\n";
    index += "</div>\n\n";
end

task :welcome do

  puts "Generating Welcome Landing Page..."
  require 'rubygems'
  require 'jekyll'
  include Jekyll::Filters
  
  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')

  # Index YML Front Matter  
  index = "---\n";
  index += "layout: default\n";
  index += "title: Welcome to Hacker Bootstrap Shop\n";
  index += "---\n\n";

  # Skiiing Posts
  index += "<h2>Ski:</h2>"
  index += "<div class=\"row\">\n\n"
  site.tags['ski'].shuffle.first(4).each do |post|
    post_data = post.to_liquid
    index += thumbnail(site.baseurl, post_data["url"], post_data["large_image"], post_data["title"])
  end
  index += "</div>\n\n"

  # Running Posts
  index += "<h2>Run:</h2>"
  index += "<div class=\"row\">\n\n"
  site.tags['running'].shuffle.first(4).each do |post|
    post_data = post.to_liquid
    index += thumbnail(site.baseurl, post_data["url"], post_data["large_image"], post_data["title"])
  end
  index += "</div>\n\n"

  # Commute Posts
  index += "<h2>Commute:</h2>"
  index += "<div class=\"row\">\n\n"
  site.tags['commute'].shuffle.first(4).each do |post|
    post_data = post.to_liquid
    index += thumbnail(site.baseurl, post_data["url"], post_data["large_image"], post_data["title"])
  end
  index += "</div>\n\n"

  # Index Page
  File.open("index.html", 'w+') do |file|
    file.puts index
  end

  puts 'Done.'

end