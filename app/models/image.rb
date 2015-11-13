class Image < ActiveRecord::Base

  def get_closest_matches limit=5
    Image.find_by_sql("SELECT id, p_hash, path FROM images WHERE path!='#{path}' ORDER BY BIT_COUNT(p_hash ^ #{p_hash.to_i}) LIMIT #{limit}")
  end

  def next_image
    File.join(directory.path, directory.images[directory_position-1])
  end

  def previous_image
    File.join(directory.path, directory.images[(directory_position%(directory.images.count-1))+1])
  end

  def directory_position
    @directory_position ||= directory.images.index(path_object.basename.to_s)
  end

  def directory
    @directory ||= Directory.find_or_initialize_by(path: path_object.dirname.to_s)
  end

  def path_object
    Pathname.new(path).cleanpath
  end

end
