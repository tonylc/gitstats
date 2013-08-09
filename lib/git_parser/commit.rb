module GitParser
  class Commit
    #.rb|.scss|.coffee|.haml|.js|.css|.js.erb|.html.erb|.html
    attr_accessor :src_lines, :test_lines

    def initialize
      Gitstats::Application.config.languages.keys.each do |lang|
        self.instance_variable_set(("@" + lang + "_added").to_sym, 0)
        self.instance_variable_set(("@" + lang + "_deleted").to_sym, 0)
      end
      @src_lines = 0
      @test_lines = 0
    end

    # the file_path is assumed to be a matched file type
    def add_file(file_path, lines_added, lines_deleted)
      update_language_type_count(file_path, lines_added, lines_deleted)
      update_src_test_count(file_path, lines_added + lines_deleted)
    end

    def to_str
      Gitstats::Application.config.languages.keys.map do |lang|
        "#{lang}:#{self.instance_variable_get(("@" + lang + "_added").to_sym)}|#{self.instance_variable_get(("@" + lang + "_deleted").to_sym)}"
      end.join(" ").concat(" src:#{@src_lines} test:#{@test_lines}")
    end

    def to_json
      hash = {}
      Gitstats::Application.config.languages.keys.each do |lang|
        added = self.instance_variable_get(("@" + lang + "_added").to_sym)
        deleted = self.instance_variable_get(("@" + lang + "_deleted").to_sym)
        hash[lang] = "#{added},#{deleted}" if (added > 0 || deleted > 0)
      end
      hash.to_json
    end

  private

    def update_language_type_count(file_path, lines_added, lines_deleted)
      file_type = file_path.match(/#{list_of_supported_file_types_regex}$/)[0]
      # should always exist at this point, can consider throwing an exception or logging the file out later
      languages = Gitstats::Application.config.languages.select {|k,v| v.include?(file_type)}
      raise "Invalid file type #{file_type}" if languages.empty?
      # => {"js" => [".js", ".js.erb", ".coffee"]}
      lang = languages.keys.first
      cur_added = self.instance_variable_get(("@" + lang + "_added").to_sym)
      cur_deleted = self.instance_variable_get(("@" + lang + "_deleted").to_sym)
      self.instance_variable_set(("@" + lang + "_added").to_sym, cur_added + lines_added)
      self.instance_variable_set(("@" + lang + "_deleted").to_sym, cur_deleted + lines_deleted)
    end

    def update_src_test_count(file_path, line_count)
      if file_path.match(/#{Gitstats::Application.config.tests.map {|a| a.sub(".", "\\.")}.join("|")}$/)
        @test_lines += line_count
      else
        @src_lines += line_count
      end
    end
  end
end
