class Image < ActiveRecord::Base

  def get_closest_matches limit=5
    Image.find_by_sql("SELECT id, p_hash, path FROM images WHERE path!='#{path}' ORDER BY BIT_COUNT(p_hash ^ #{p_hash.to_i}) LIMIT #{limit}")
  end

end
