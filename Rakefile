require 'rubygems'
require 'yaml'
require 'pp'
require 'jekyll'
require 'json'
require 'nokogiri'

require_relative '_rake/helpers'
import '_rake/site-data.rb'
import '_rake/tag-data.rb'
import '_rake/tag-pages.rb'
import '_rake/product-pages.rb'
import '_rake/category-data.rb'
import '_rake/category-pages.rb'
import '_rake/related-data.rb'
import '_rake/producturlmap-data.rb'
import '_rake/404-page.rb'

task :default => [
  :products, 
  :producturlmap_data, 
  :category_data, 
  :category_pages,
  :tag_data,
  :tag_pages,
  :related, 
  :four
]

