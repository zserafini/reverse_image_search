class FileScanner
  include Sidekiq::Worker

  def perform scan_path, file_path
    p_hash = Phashion::Image.new(file_path).fingerprint
    Image.create(p_hash: p_hash, path: File.join(scan_path, file_path))
  end

end
