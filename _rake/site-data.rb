desc 'Jekyll Site Data'

task :site_data do
  puts 'Loading Jekyll Site Data'
  include Jekyll::Filters
  options = Jekyll.configuration({})
  $site = Jekyll::Site.new(options)
  $site.read_posts('')
end