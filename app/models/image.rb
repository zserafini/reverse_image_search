class Image < ActiveRecord::Base

  attr :bitc

  def get_closest_matches limit=5
    Image.find_by_sql("SELECT id, p_hash, path from images ORDER BY BIT_COUNT(p_hash ^ #{p_hash.to_i})")
  end

  def one
    Image.find_by_sql("SELECT id, p_hash, path, (BIT_COUNT(p_hash X #{p_hash.to_i})) as bitc from images ORDER BY bitc")
  end

  def two
  end

end
