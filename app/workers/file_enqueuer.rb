class FileEnqueuer
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform scan_path
    directory = Directory.find_or_initialize_by(path: scan_path)

    directory.images.each do |file_path|
      FileScanner.perform_async(File.join(scan_path, file_path))
    end

    directory.sub_directories.each do |directory_path|
      FileEnqueuer.perform_async(File.join(scan_path, directory_path))
    end
  end

end
