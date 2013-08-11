module GitParser
  class CommitRatio
    attr_reader :datetime
    attr_accessor :src_lines, :test_lines

    def initialize(datetime)
      @datetime = datetime
      @src_lines = 0
      @test_lines = 0
    end

    def add_line_count(file_path, line_count)
      if file_path.match(/#{Gitstats::Application.config.tests.map {|a| a.gsub(".", "\\.")}.join("|")}$/)
        @test_lines += line_count
      else
        @src_lines += line_count
      end
    end

    def empty_commit?
      @src_lines == 0 && @test_lines == 0
    end
  end
end
