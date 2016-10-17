# require 'rubygems'
# # require 'aws/s3'
# # require 'mechanize'
#
# class AmazonS3Asset
#
#   include AWS::S3
#   S3ID = "AKIAJXUWEHSAWB36DW6Q"
#   S3KEY = "z6UhW+xS5oIOP1Bd7LF/vD29sgdb/tzq4lM5l9IL"
#
#   def initialize
#     puts "connecting..."
#     AWS::S3::Base.establish_connection!(
#       :access_key_id     => S3ID,
#       :secret_access_key => S3KEY
#     )
#   end
#
#   def exists?(bucket,key)
#     begin
#       res = S3Object.find key, bucket
#     rescue
#       res = nil
#     end
#     return !res.nil?
#   end
#
#   def store_file(bucket, key, filename)
#      puts "Storing #{filename} in #{bucket}.#{key}"
#      return if filename.nil?
#
#      S3Object.store(
#       key,
#       File.open(filename),
#       bucket,
#       :access => :public_read
#       )
#   end
#
#   def download(url, save_as = nil)
#     if save_as.nil?
#       Dir.mkdir("amazon_s3_temp") if !File.exists?("amazon_s3_temp")
#       save_as = File.join("amazon_s3_temp",File.basename(url))
#     end
#     begin
#       puts "Saving #{url} to #{save_as}"
#       agent = Mechanize.new  #{|a| a.log = Logger.new(STDERR) }
#       img = agent.get(url)
#       img.save_as(save_as)
#       return save_as
#     rescue => e
#       puts "Failed on " + url + "  " + save_as + e.inspect
#     rescue Timeout::Error => e
#       puts "Timeout error"
#     end
#   end
#
# end
#
# namespace :copacetic do
#   desc "Copacetic"
#
#   task :move_images => [:environment] do
#     a = AmazonS3Asset.new
#     [Cd, Book,  Dvd, Comic].each do |c|
#       c.all.each do |comic|
#         next if comic[:image].blank?
#         if !a.exists?('copacetic-production', "catalog/#{c.to_s.downcase.pluralize}/#{comic.id.to_s}/#{comic[:image]}")
#           puts "looking for #{comic[:image]}...."
#           [2009, 2011, 2012].each do |year|
#             oldkey = "Images-#{year.to_s}/#{comic[:image]}"
#             if a.exists?('CopaceticComics', oldkey)
#               puts "found #{comic[:image]} in #{year.to_s}"
#               from = "http://s3.amazonaws.com/CopaceticComics/Images-#{year.to_s}/#{comic[:image]}"
#               newkey = "catalog/#{c.to_s.downcase.pluralize}/#{comic.id.to_s}/#{comic[:image]}"
#               if a.exists?('copacetic-production', newkey)
#                 puts "this already has been copied in " + newkey
#                 break
#               else
#                 filename = a.download(from)
#                 return if filename.nil?
#                 a.store_file('copacetic-production',newkey,filename.gsub(/\+/, '/-/'))
#                 File.delete(filename)
#                   comic.image.recreate_versions! rescue nil
#
#                 break
#               end
#             end
#           end
#         else
#           puts "id #{comic.id} already in place in new S3 bucket"
#         end
#         if a.exists?('copacetic-production', "catalog/#{c.to_s.downcase.pluralize}/#{comic.id.to_s}/#{comic[:image]}")
#           next
#         else
#           trynow = "http://copaceticcomics.com/catalog/#{c.to_s.downcase.pluralize}/#{comic[:image]}"
#           filename = a.download(trynow)
#           next if filename.nil?
#           a.store_file('copacetic-production',  "catalog/#{c.to_s.downcase.pluralize}/#{comic.id.to_s}/#{comic[:image]}", filename)
#           File.delete(filename)
#           comic.image.recreate_versions! rescue nil
#         end
#       end
#     end
#   end
# end
