class FileEnqueuer
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform scan_path
    images = DirHelper.get_images(scan_path)
    directories = DirHelper.get_dirs(scan_path)

    images.each do |file_path|
      FileScanner.perform_async(File.join(scan_path, file_path))
    end

    directories.each do |directory_path|
      FileEnqueuer.perform_async(File.join(scan_path, directory_path))
    end
  end

end
