module GitParser
  class Author
    attr_accessor :name, :email, :date_commits, :commit_ratios

    def initialize(name, email)
      @name = name
      @email = email
      @date_commits = {}
      @commit_ratios = {}
    end

    def add_date(datetime)
      date_str = datetime.strftime("%Y%m%d")
      if !@date_commits[date_str]
        @date_commits[date_str] = GitParser::CommitDate.new
      end
      # impossible to have more than one commit for the same author at the exact same time right?
      @commit_ratios[datetime.to_s] = GitParser::CommitRatio.new(datetime)
    end

    def add_to_commit(datetime, added, deleted, file_path)
      date_str = datetime.strftime("%Y%m%d")
      @date_commits[date_str].add_file(file_path, added.to_i, deleted.to_i)
      if @name == "Tony"
        debug("#{added}:#{deleted} - #{file_path}")
      end
      @commit_ratios[datetime.to_s].add_line_count(file_path, added + deleted)
    end
  end
end
