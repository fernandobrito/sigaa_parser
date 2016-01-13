require 'mechanize'

# Source https://gist.github.com/hakanensari/1315898

begin
  require 'launchy'

  class Mechanize::Page
    def open_in_browser
      if body
        file = File.new("/tmp/#{Time.now.to_i}.html", 'w')
        file.write body
        Launchy.open "file://#{file.path}"
        # system "sleep 1 && rm #{file.path} &"
        # sleep(1)
      end
    end
  end
rescue LoadError
end