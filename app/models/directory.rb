class Directory < ActiveRecord::Base

  def images
    Dir.entries(path).
      keep_if { |x| (x =~ /\.jpg$|\.png$|\.jpeg$|\.bmp$/) }.
      sort { |x, y| x <=> y }
  end

  def sub_directories
    Dir.entries(path).
      select { |f| File.directory? File.join(path, f) and !(f == '.' || f == '..') }.
      sort { |x, y| x <=> y }
  end

end
