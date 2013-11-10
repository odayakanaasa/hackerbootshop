desc 'Generate Shop Pages'

task :products do

  puts "Generating pages..."
  require 'rubygems'
  require 'cgi'
  require 'rexml/document'
  include REXML
  require 'pp'
  require 'yaml'

  require_relative 'helpers.rb'

  # Load existing product map
  productmap = YAML.load_file('_data/productmap.yml')
  
  # XML Data
  # xmlfile = File.new("_xml/thenorthface.xml")
  xmlfile = File.new("_xml/avantlink.xml")
  xmldoc = Document.new(xmlfile)

  # Product filename data map
  yml_product_map = ''

  products = xmldoc.root

  # Parse Products
  products.each_element('Product') {
    |product|

    if ( (product.elements['Brand_Name'].text == 'Rei') or 
         (product.elements['Brand_Name'].text == 'The North Face') )

      # YML Front Matter  
      yml = "---\n";

      yml += "layout: post\n";
      yml += "product: true\n"
      yml += "title: \"" + CGI.escapeHTML(product.elements['Product_Name'].text) + "\"\n";
      yml += "sku: \"" + product.elements['SKU'].text + "\"\n";
      if (product.elements['Brand_Name'].text != nil) 
        yml += "brand: \"" + CGI.escapeHTML(product.elements['Brand_Name'].text) + "\"\n";
      end

      yml += "small_image: \"" + product.elements['Thumb_URL'].text + "\"\n";
      yml += "medium_image: \"" + product.elements['Medium_Image_URL'].text + "\"\n";
      yml += "large_image: \"" + product.elements['Image_URL'].text + "\"\n";

      yml += "buy_link: \"" + product.elements['Buy_Link'].text + "\"\n";
      yml += "retail_price: \"" + product.elements['Retail_Price'].text + "\"\n";
      yml += "sale_price: \"" + product.elements['Sale_Price'].text + "\"\n";

      yml += "categories:\n"
        category = product.elements['Category'].text.gsub(' ','-').gsub('\'','').gsub('&-','').gsub(',','').gsub('----','-').gsub(':','')
        sub_category = product.elements['SubCategory'].text.gsub(' ','-').gsub('\'','').gsub('&-','').gsub(',','').gsub('----','-').gsub(':','')
        product_group = product.elements['Product_Group'].text.gsub(' ','-').gsub('\'','').gsub('&-','').gsub(',','').gsub('----','-').gsub(':','')
        yml += " - \"" + category + "\"\n"
        yml += " - \"" + sub_category + "\"\n"
        yml += " - \"" + product_group + "\"\n"
      
      yml += "category_title: \"" + product.elements['Category'].text.gsub(':','') + "\"\n"
      yml += "sub_category_title: \"" + product.elements['SubCategory'].text.gsub(':','') + "\"\n"
      yml += "product_group_title: \"" + product.elements['Product_Group'].text.gsub(':','') + "\"\n"
      yml += "category_path: \"" + category + "\"\n"
      yml += "sub_category_path: \"" + category + "/" + sub_category + "\"\n"
      yml += "product_group_path: \"" + category + "/" + sub_category + "/" + product_group + "\"\n"

      yml += "breadcrumb: \n"
      yml += " - {title: \""+ product.elements['Category'].text.gsub(':','') + "\", url: /browse/" + build_category_path(category).downcase + "/}\n"
      yml += " - {title: \""+ product.elements['SubCategory'].text.gsub(':','') + "\", url: /browse/" + build_category_path(category).downcase + "/" + build_category_path(sub_category).downcase + "/}\n"

      if (product.elements['Keywords'].text != nil) 
        yml += "tags:\n"
        tags = product.elements['Keywords'].text.split(",")
        tags.each{
          |tag|
          yml += " - " + tag.gsub(' ','-').gsub('\'','').gsub('&-','').gsub(',','') + "\n"
          #yml += " - " + tag + "\n"
        }
      end
      
      yml += "---\n\n";

      # Description
      if (product.elements['Long_Description'].text != nil) 
        @description = product.elements['Long_Description'].text.split('.')
      elsif (product.elements['Short_Description'].text != nil)
        @description = product.elements['Short_Description'].text.split('.')
      end

      # Break the description up into a header and list
      description_header = ''
      description_list = '<ul class="description">'+"\n"
      @description.each_with_index do |item, index|
        if (index == 0)
          description_header += "<h3>"+item+"</h3>\n"
        else
          description_list += "<li>"+item+"</li>\n"
        end
      end
      description_list += "</ul>\n"
      body = ''
      body += description_header
      body += description_list+"\n"

      # Tracking
      body += '<div class="sellout">' + "\n" + product.elements['Product_Page_View_Tracking'].text + "\n</div>\n"

      # Page Year / Month / Day
      random_time = time_rand Time.local(0, 1, 1), Time.local(50, 12, 31)
      random_year = random_time.strftime("%Y")
      random_month = random_time.strftime("%m")
      random_day = random_time.strftime("%d")

      # Page File Name
      sku = product.elements['SKU'].text.to_i
      if (productmap[sku])
        file_name =  productmap[sku]
      else 
        file_name = "_posts/" + random_year.to_s + "-" + random_month.to_s + "-" +  random_day.to_s + "-" + product.elements['SKU'].text + ".html"
      end
      yml_product_map += product.elements['SKU'].text + ": " + file_name + "\n"
      
      # Save Page
      File.open(file_name, 'w+') do |file|
        file.puts yml
        file.puts body
      end

      puts product.elements['SKU'].text

    end
  }

  # Save Page Data Map
  File.open("_data/productmap.yml", 'w+') do |file|
    file.puts yml_product_map
  end

  puts 'Done.'

end