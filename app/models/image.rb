class Image < ActiveRecord::Base

  def duplicates
    Image.find_by_sql("SELECT id, p_hash, path FROM images WHERE path!='#{path}' AND BIT_COUNT(p_hash ^ #{p_hash.to_i}) < 2")
  end

  def get_closest_matches limit=5
    Image.find_by_sql("SELECT id, p_hash, path FROM images WHERE path!='#{path}' ORDER BY BIT_COUNT(p_hash ^ #{p_hash.to_i}) LIMIT #{limit}")
  end

  def next_image
    File.join(directory.path, directory.image_paths[(directory_position+1)%directory.image_paths.count])
  end

  def previous_image
    File.join(directory.path, directory.image_paths[directory_position-1])
  end

  def directory_position
    @directory_position ||= directory.image_paths.index(name)
  end

  def directory
    @directory ||= Directory.find_or_initialize_by(path: dirname)
  end

  def pathname
    Pathname.new(path).cleanpath
  end

  def name
    pathname.basename.to_s
  end

  def dirname
    pathname.dirname.to_s
  end

  def relative_path(other_image)
    other_image.pathname.relative_path_from(pathname)
  end
end
