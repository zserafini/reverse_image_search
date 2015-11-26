class Directory < ActiveRecord::Base

  def images
    @images ||= image_paths.map do |image_path|
      Image.find_or_initialize_by(path: File.join(path, image_path))
    end
  end

  def image_paths
    Dir.entries(path).
      keep_if { |x| (x.downcase =~ /\.jpg$|\.png$|\.jpeg$|\.bmp$/) }.
      sort { |x, y| x <=> y }
  end

  def image_count
    image_paths.length
  end

  def sub_directories
    Dir.entries(path).
      select { |f| File.directory? File.join(path, f) and !(f == '.' || f == '..') }.
      sort { |x, y| x <=> y }
  end

  def parent_directory
    Directory.find_or_initialize_by( path: File.join(path, '..'))
  end

  def next_directory
    File.join(parent_directory.path, parent_directory.sub_directories[(directory_position+1)%parent_directory.sub_directories.count])
  end

  def previous_directory
    File.join(parent_directory.path, parent_directory.sub_directories[directory_position-1])
  end

  def directory_position
    @directory_position ||= parent_directory.sub_directories.index(name) || 0
  end

  def name
    Pathname.new(path).basename.to_s
  end

  def dirname
    Pathname.new(path).cleanpath.dirname.to_s
  end

end
