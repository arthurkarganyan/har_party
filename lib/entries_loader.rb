module HarParty
  class EntriesLoader
    def initialize(path)
      file = File.read(path)
      @entries = JSON.parse(file)["log"]["entries"].map do |i|
        Entry.new(i)
      end
    end

    def entries
      @entries.select do |i|
        i
      end.reject do |i|
        i.url.path[/\.js\z/] || i.url.path[/\.css\z/] || i.url.path[/\.svg\z/] || i.url.path[/\.woff2\z/] || i.url.path[/\.ttf\z/] || i.url.path[/\.json\z/]
      end.reject do |i|
        i.pic? || i.type['font-woff'] || i.request["method"] == "OPTIONS" || i.type == 'text/html'
      end.reject(&:font?)
    end
  end
end
