module SigaaParser
  module Cacheable
    CACHE_FOLDER = File.join(File.dirname(__FILE__), '..', '..', 'cache')
    EXTENSION = '.html'

    def has_cached?(name)
      File.exists?(file_path(name))
    end

    def retrieve_cache_path(name)
      file_path(name)
    end

    def store_cache(name, page)
      File.open(file_path(name), 'w') do |file|
        file.write(page)
      end
    end

  private
    def file_path(name)
      File.join(CACHE_FOLDER, "#{name}.html")
    end
  end
end