module DirHelper

  def self.get_images path
    Dir.entries(path).
      keep_if { |x| (x =~ /\.jpg$|\.png$|\.jpeg$|\.bmp$/) }.
      sort { |x, y| x <=> y }
  end

  def self.get_dirs path
    Dir.entries(path).
      select { |f| File.directory? File.join(path, f) and !(f == '.' || f == '..') }.
      sort { |x, y| x <=> y }
  end

end
