desc 'Generate Tag Data'

task :tag_data => [:site_data] do

  puts "Generating Tag Data..."

  # Empty Tag Data
  tags = Hash.new

  # Walk Thru Posts
  $site.posts.each do |post|
    data = post.to_liquid
    next if data['tags'].length < 1
    # Walk Thru Tags
    data['tags'].each do |tag|
      tag = seo_string(tag)
      if good_tag(tag)
        if (tags[tag].is_a?(Array)) 
          tags[tag].push(data['sku'])
        else
          tags[tag] = Array.new
          tags[tag].push(data['sku'])
        end
      end
    end
  end

  # Individual Tag JSON Files
  #tags.each do |tid, tag|
    # JSON Tag Data
  #  File.open("json/tags/"+tid+".json", 'w+') do |file|
  #    file.puts tag.to_json()
  #  end
  #end

  # YAML Tags Data
  File.open("_data/tags.yml", 'w+') do |file|
    file.puts tags.to_yaml({'line_width' => -1, 'canonical' => false})
  end

  # JSON Tags Data
  File.open("json/tags.json", 'w+') do |file|
    file.puts tags.to_json()
  end

  puts 'Done.'

end