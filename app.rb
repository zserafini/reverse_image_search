require 'phashion'

puts "Base Image:"
base_path = gets.strip!

puts "Search Location:"
search_path = gets.strip!

base_image = Phashion::Image.new(base_path)

Dir.chdir(search_path)

image_entries = Dir.glob(['**/**.jpg', '**.png', '**.bmp', '**.jpeg'])

image_entries.each_with_index do |compair_path, index|
  puts "#{index}/#{image_entries.length} #{Time.now}" if index % 100 == 0
  other_image = Phashion::Image.new(compair_path)
  puts "#{compair_path} matches!" if base_image.duplicate?(other_image)
end
