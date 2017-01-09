desc 'Generate Product URL Data'

task :producturlmap_data => [:site_data] do

  puts "Generating Product URL Data..."
  $product_url_map = Hash.new

  $site.posts.each do |post|
    data = post.to_liquid
    $product_url_map[data['sku']] = post.url if data['sku']
  end

  # YAML Product URL Data
  File.open("_data/producturlmap.yml", 'w+') do |file|
    file.puts $product_url_map.to_yaml({'line_width' => -1, 'canonical' => false})
  end

  # JSON Product URL Data
  File.open("json/producturlmap.json", 'w+') do |file|
    file.puts $product_url_map.to_json()
  end

  puts 'Done.'

end