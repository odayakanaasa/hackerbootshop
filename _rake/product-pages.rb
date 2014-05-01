desc 'Generate Product Posts'

task :products do
  puts "Generating Product Posts"

  # Existing Product Map
  existing_product_map = YAML.load_file('_data/productmap.yml')
  $product_map = Hash.new

  # XML
  reader = Nokogiri::XML::Reader(File.open("_xml/Rei_81603_datafeed.xml"))

  # Products
  $products = Hash.new
  reader.each do |node|
    if node.name == "Product"
      fragment = Nokogiri::XML.fragment(node.inner_xml)
      pid = fragment.xpath('.//SKU').text
      next unless pid != ''
      brand = fragment.xpath('.//Brand_Name').text
      # Limit Products to REI or Novara ~1000 vs. ~15,000
      #next unless brand == 'Rei' or brand == 'Novara'
      $products[pid] = Hash.new
      fragment.children.each do |node|
        next if node.name == 'text'
        next if node.text == ''
        if node.name == 'Extended_Xml_Attributes'
          $products[pid]['variants'] = Hash.new
          node.xpath('./variants/variant').each do |variant|
            sku = variant.xpath('./sku').text
            $products[pid]['variants'][sku] = Hash.new
            variant.elements.each do |node|
              $products[pid]['variants'][sku][node.name.downcase] = node.text
            end
          end
        end
        next if node.children.size > 1
        $products[pid][node.name.downcase] = node.text
      end

      # Build Product Data as YAML Front Matter Hash
      product = build_product_front_matter($products[pid])
      $products[pid]['categories'] = product['categories']

      # Build Product File Name as Post
      if (existing_product_map[pid])
        file_name =  existing_product_map[pid]
      else       
        # initial run of products are set wayback in time...
        # random_time = time_rand Time.local(51, 1, 1), Time.local(51, 12, 31)
        random_time = time_rand
        random_year = random_time.strftime("%Y")
        random_month = random_time.strftime("%m")
        random_day = random_time.strftime("%d")
        file_name = "_posts/" + random_year.to_s + "-" + random_month.to_s + "-" +  random_day.to_s + "-" + pid + ".html"
      end
      $product_map[pid] = file_name
      
      # Build Product Filename as Page
      # puts product['categories'].to_yaml
      # file_name = product['categories'][0] + "/" + product['categories'][1] + "/" + product['categories'][2] + "/"  + pid + ".html"
      # $product_map[pid] = file_name

      # Save Product Page
      FileUtils.mkdir_p(File.dirname(file_name)) unless File.exists?(File.dirname(file_name))
      File.open(file_name, 'w+') do |file|
        file.puts product.to_yaml
        file.puts "---\n"
      end

      # JSON Product Data
      File.open("json/products/"+pid+".json", 'w+') do |file|
        file.puts $products[pid].to_json()
      end
      puts pid
    end
  end

  # Update Product Map
  File.open("_data/productmap.yml", 'w+') do |file|
    file.puts $product_map.to_yaml(line_width: -1)
  end

  # Jekyl Products Data
  File.open("_data/products.yml", 'w+') do |file|
    file.puts $products.to_yaml(line_width: -1)
  end

  # JSON Products Data
  File.open("json/products.json", 'w+') do |file|
    file.puts $products.to_json()
  end

end

