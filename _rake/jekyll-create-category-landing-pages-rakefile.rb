desc 'Generate category landing pages'

task :category_landing do

  puts "Generating category landing pages..."
  require 'rubygems'
  require 'jekyll'
  require 'fileutils'
  require 'pp'
  require 'yaml'
  require_relative 'helpers.rb'
  include Jekyll::Filters
  
  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')

  #pp site

  #Build Nested Taxonomy Hash Based on Posts
  taxonomy = {}
  site.posts.sort.each_with_index do |id, i|  
    post = id.to_liquid
    if (post["categories"].length == 3)
      category_id = post['categories'][0]
      sub_category_id = post['categories'][1]
      product_group_id = post['categories'][2]

      # Primary Category
      if (!taxonomy[category_id])
        taxonomy[category_id] = {'title' => post['category_title']}
      end

      # Primary Category Products
      if (!taxonomy[category_id]['products']) 
        taxonomy[category_id]['products'] = []
      end
      taxonomy[category_id]['products'].push(i)

      # Secondary Category
      if (!taxonomy[category_id]['subcategories'])
        taxonomy[category_id]['subcategories'] = {}
      end
      if (!taxonomy[category_id]['subcategories'][sub_category_id]) 
        taxonomy[category_id]['subcategories'][sub_category_id] =  {'title' => post['sub_category_title']}
      end

      # Secondary Category Products
      if (!taxonomy[category_id]['subcategories'][sub_category_id]['products']) 
        taxonomy[category_id]['subcategories'][sub_category_id]['products'] = []
      end
      taxonomy[category_id]['subcategories'][sub_category_id]['products'].push(i)

      # Product Group
      if (!taxonomy[category_id]['subcategories'][sub_category_id]['product_groups'])
        taxonomy[category_id]['subcategories'][sub_category_id]['product_groups'] = {}
      end
      if (!taxonomy[category_id]['subcategories'][sub_category_id]['product_groups'][product_group_id]) 
        taxonomy[category_id]['subcategories'][sub_category_id]['product_groups'][product_group_id] = {'title' => post['product_group_title']}
      end

      # Product Group Products
      if (!taxonomy[category_id]['subcategories'][sub_category_id]['product_groups'][product_group_id]['products']) 
        taxonomy[category_id]['subcategories'][sub_category_id]['product_groups'][product_group_id]['products'] = []
      end
      taxonomy[category_id]['subcategories'][sub_category_id]['product_groups'][product_group_id]['products'].push(i)

    end
  end
  #pp taxonomy

  #Browse Nav Include
  nav = '<ul class="dropdown-menu">'+"\n"
  taxonomy.sort.each do |id,cat|
    nav += '<li><a href="' + site.baseurl + '/browse/' + build_category_path(id) + '/">' + cat['title'] + '</a></li>' + "\n"
  end
  nav += "</ul>\n"
  File.open('_includes/top_nav_browse.html', 'w+') do |file|
    file.puts nav
  end

  #Sidebar Nav Include
  nav = '<div class="list-group">'+"\n"
  taxonomy.sort.each do |id,cat|
    nav += '<a href="' + site.baseurl + '/browse/' + build_category_path(id) + '/" class="list-group-item">' + cat['title'] + '</a>' + "\n"
  end
  nav += "</div>\n"
  File.open('_includes/sidebar_browse.html', 'w+') do |file|
    file.puts nav
  end

  #Primary Landing Page
  index = "---\n";
  index += "layout: sidebar\n";
  index += "title: Browse\n";
  index += "breadcrumb: \n"
  index += " - {title: Home, url: / }\n"
  index += "secondary_nav: \n"
  taxonomy.sort.each do |id,cat|
    index += " - /browse/" + build_category_path(id) + ": \"" + cat['title'] + "\"\n"
  end
  index += "---\n\n";

  #Secondary Landing Page
  taxonomy.sort.each do |id,tax|

    #Secondary Landing Page Front Matter
    landing = "---\n";
    landing += "layout: sidebar\n";
    landing += "title: "+ tax['title'] + "\n";
    landing += "breadcrumb: \n"
    landing += " - {title: Home, url: / }\n"
    landing += " - {title: Browse, url: /browse/ }\n"
    landing += "secondary_nav: \n"
    tax['subcategories'].sort.each do |cat_id,subcat|
      landing += " - /browse/" + build_category_path(id) + "/" + build_category_path(cat_id) + "/: \"" + subcat['title'] + "\"\n"
    end
    landing += "---\n\n";

    #List of Posts
    landing += "<div class=\"list-group\">\n"
    tax['products'].reverse.each_with_index do |post_id, i|
      landing += build_post_link(site.posts[post_id], site.baseurl)
    end
    landing += "</div>\n\n"
    
    #Secondary Landing Page
    file = "browse/" + build_category_path(id) + "/index.html"
    FileUtils.mkdir_p(File.dirname(file)) unless File.exists?(File.dirname(file))
    File.open(file, 'w+') do |file|
      file.puts landing
    end

    #Product Group Landing Pages
    tax['subcategories'].sort.each do |cat_id,sub_cat|

      #Product Group Landing Page Front Matter
      landing = "---\n";
      landing += "layout: default\n";
      landing += "title: "+ sub_cat['title'] + "\n";
      landing += "breadcrumb: \n"
      landing += " - {title: Home, url: / }\n"
      landing += " - {title: Browse, url: /browse/ }\n"
      landing += " - {title: \""+ tax['title'] + "\", url: /browse/" + build_category_path(id) + "/}\n"
      landing += "---\n\n";

      #List of Posts
      landing += "<div class=\"list-group\">\n"
      sub_cat["product_groups"].sort.each do |pg_id, pg|
        pp pg['products']
        pg['products'].reverse.each_with_index do |post_id, i|
          landing += build_post_link(site.posts[post_id], site.baseurl)
        end
      end
      landing += "</div>\n\n"
      
      #Product Group Landing Page
      file = "browse/" + build_category_path(id) + "/" + build_category_path(cat_id)+ "/index.html"
      puts file
      FileUtils.mkdir_p(File.dirname(file)) unless File.exists?(File.dirname(file))
      File.open(file, 'w+') do |file|
        file.puts landing
      end

    end

  end
   
  #Primary Landing Page
  file = "browse/index.html"

  # Posts
  index += "<div class=\"row\">\n\n"
  taxonomy.sort.each do |id,cat|
    site.categories[id].shuffle.first(2).each do |post|
      post_data = post.to_liquid
      index += "<div class=\"col-sm-6 col-md-4\">\n";
      index += "<div class=\"thumbnail alert alert-info\" style=\"margin-bottom:30px;max-width:300px\">\n";
        index += "<a href=\"" + site.baseurl + post_data["url"] + "\">";
        index += "<img src=\"" + post_data["large_image"] + "\" class=\"img-responsive\" />";
        index += "</a>\n"
        index += "<div class=\"caption\" style=\"height:124px;overflow:hidden;\">\n"
          index += "<h4>" + post_data["title"] + "</h4>\n";
        index += "</div>\n";
      index += "</div>\n";
    index += "</div>\n\n";
    end
  end
  index += "</div>\n\n"

  FileUtils.mkdir_p(File.dirname(file)) unless File.exists?(File.dirname(file))
  File.open(file, 'w+') do |file|
    file.puts index
  end

  puts 'Done.'
  
end