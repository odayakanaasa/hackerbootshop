desc 'Generate Recently Viewed Products Data'

task :related => [:site_data] do
  puts "Generating Recently Viewed Products Data..."

  if !defined?($products)
    $products = YAML.load_file('_data/products.yml')
  end

  if !defined?($categories)
    $categories = YAML.load_file('_data/categories.yml')
  end

  if !defined?($relationships)
    $relationships = YAML.load_file('_data/relationships.yml')
  end

  $products.each do |pid, product|
  	#pid = product['sku'].to_s

    next if product['categories'].length != 3

    # Only process products without relationships
    next if $relationships[pid]

  	$relationships[pid] = Hash.new
		$relationships[pid]['bought'] = Hash.new
		$relationships[pid]['viewed'] = Hash.new
		$relationships[pid]['together'] = Hash.new

    cat = product['categories'][0]
    subcat = product['categories'][1]
    tcat = product['categories'][2]
    product_url = '/' + cat + '/' + subcat + '/' + tcat + '/' + pid + '.html'

  	# Frequently Purchased Together
  	samples = $categories[cat]['children'][subcat]['products'].sample(2)
  	count = 0
  	max = 1
  	samples.each_with_index do |spid, i|
  		if count < max and spid != pid
	  		$relationships[pid]['together'][spid] = Hash.new
	  		$relationships[pid]['together'][spid]['title'] = $products[spid]['product_name']
	  		$relationships[pid]['together'][spid]['sale_price'] = $products[spid]['sale_price']
	  		$relationships[pid]['together'][spid]['url'] = '/' + $products[spid]['categories'][0] + '/' + $products[spid]['categories'][1] + '/' + $products[spid]['categories'][2] + '/' + spid + '.html'
  			count = count + 1
  		end
  	end

  	# People Also Viewed
  	samples = $products.keys.sample(6)
  	count = 0
  	max = 4
    samples.each_with_index do |spid, i|
  		if count < max and spid != pid and not $relationships[pid]['together'][spid]
        $relationships[pid]['viewed'][spid] = Hash.new
        $relationships[pid]['viewed'][spid]['title'] = $products[spid]['product_name']
        $relationships[pid]['viewed'][spid]['sale_price'] = $products[spid]['sale_price']
        $relationships[pid]['viewed'][spid]['url'] = '/' + $products[spid]['categories'][0] + '/' + $products[spid]['categories'][1] + '/' + $products[spid]['categories'][2] + '/' + spid + '.html'
  			count = count + 1
  		end
  	end

  	# People Also Bought 
  	samples = $categories[cat]['products'].sample(9)
  	count = 0
  	max = 4
  	samples.each_with_index do |spid, i|
  		if count < max and spid != pid and not $relationships[pid]['together'][spid] and not $relationships[pid]['viewed'][spid]
        $relationships[pid]['bought'][spid] = Hash.new
        $relationships[pid]['bought'][spid]['title'] = $products[spid]['product_name']
        $relationships[pid]['bought'][spid]['sale_price'] = $products[spid]['sale_price']
        $relationships[pid]['bought'][spid]['url'] = '/' + $products[spid]['categories'][0] + '/' + $products[spid]['categories'][1] + '/' + $products[spid]['categories'][2] + '/' + spid + '.html'
 			count = count + 1
  		end
  	end

  	#puts "\tbought: " + $relationships[pid]['bought'].length.to_s 
  	#puts "\tviewed: " + $relationships[pid]['viewed'].length.to_s 
  	#puts "\ttogether: " + $relationships[pid]['together'].length.to_s 

	  # JSON Relationship Data
	  File.open("json/relationships/"+ pid +".json", 'w+') do |file|
	    file.puts $relationships[pid].to_json()
	  end
    puts pid
  end

  # YAML Relationships Data
  File.open("_data/relationships.yml", 'w+') do |file|
    file.puts $relationships.to_yaml(line_width: -1)
  end

  # JSON Relationships Data
  File.open("json/relationships.json", 'w+') do |file|
    file.puts $relationships.to_json()
  end

  puts 'Done.'

end