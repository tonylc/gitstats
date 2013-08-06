module GitParser
  class Author
    attr_accessor :name, :email, :date_commits

    def initialize(name, email)
      @name = name
      @email = email
      @date_commits = {}
    end

    def add_date(date)
      date_str = date.strftime("%Y%m%d")
      if @date_commits[date_str]
        return
      end
      @date_commits[date_str] = GitParser::Commit.new
    end

    def add_commits(date, added, deleted, file_type)
      date_str = date.strftime("%Y%m%d")
      commit = @date_commits[date_str]
      commit.add_file(file_type, added.to_i, deleted.to_i)
      if @name == "Tony"
        debug("#{added}:#{deleted} - #{file_type}")
      end
      @date_commits[date_str] = commit
    end
  end
end
