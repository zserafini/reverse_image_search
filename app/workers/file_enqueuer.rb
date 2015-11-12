class FileEnqueuer
  include Sidekiq::Worker

  def perform scan_path
    Dir.chdir(scan_path)

    image_entries = Dir.glob(['**/*.jpg', '**/*.png', '**/*.bmp', '**/*.jpeg'])

    image_entries.each do |file_path|
      FileScanner.perform_async(scan_path, file_path)
    end
  end

end
