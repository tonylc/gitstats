require 'date'
require 'json'

namespace :git do
  task :parse => :environment do
    def debug(line)
      return if true
      p "********* #{line}"
    end

    class AuthorStruct
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
        @date_commits[date_str] = Commit.new
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

    class Commit
      #.rb|.scss|.coffee|.haml|.js|.css|.js.erb|.html.erb|.html

      def initialize
        Gitstats::Application.config.languages.keys.each do |lang|
          self.instance_variable_set(("@" + lang + "_added").to_sym, 0)
          self.instance_variable_set(("@" + lang + "_deleted").to_sym, 0)
        end
      end

      def add_file(file_type, lines_added, lines_deleted)
        languages = Gitstats::Application.config.languages.select {|k,v| v.include?(file_type)}
        raise "Invalid file type #{file_type}" if languages.empty?
        # => {"jb" => [".js", ".js.erb", ".coffee"]}
        lang = languages.keys.first
        cur_added = self.instance_variable_get(("@" + lang + "_added").to_sym)
        cur_deleted = self.instance_variable_get(("@" + lang + "_deleted").to_sym)
        self.instance_variable_set(("@" + lang + "_added").to_sym, cur_added + lines_added)
        self.instance_variable_set(("@" + lang + "_deleted").to_sym, cur_deleted + lines_deleted)
      end

      def to_str
        Gitstats::Application.config.languages.keys.map do |lang|
          "#{lang}:#{self.instance_variable_get(("@" + lang + "_added").to_sym)}|#{self.instance_variable_get(("@" + lang + "_deleted").to_sym)}"
        end.join(" ")
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
    end

    gitlog = `cat sample_git.txt`#`git log --numstat`

    author_hash = {}
    author = nil
    date = nil

    gitlog.split(/\n/).each do |line|
      if line.start_with?('Author:') # store author
        regex = line.match(/Author\:\s*([^<]*)<([^>]*)>/)
        if !regex
          raise "Author regex /Author\:\s*([^<]*)<([^>]*)>/ doesn't match #{line}"
        end
        author = AuthorStruct.new(regex[1].strip, regex[2])
        # store author if they don't already exist
        if author_hash[author.name]
          # get the last stored author
          author = author_hash[author.name]
        else
          author_hash[author.name] = author
        end
       next
      elsif line.start_with?('Date:') # store date of commit
        regex = line.match(/Date:\s+(.+)/)
        if !regex
          raise "Date regex /Date:\s+(.+)/ doesn't match #{line}"
        end
        date = Date.strptime(regex[1], "%a %b %e %H:%M:%S %Y %z")
        author.add_date(date)
        author_hash[author.name] = author
        next
      elsif line =~ /^\d+.+/ # store line count
        regex = line.match(/(\d+)\s+(\d+)\s+.+(#{Gitstats::Application.config.languages.values.flatten.flatten.map {|a| a.sub(".", "\\.")}.join("|")})$/)
        if !regex
          p "Line count regex /(\d+)\s+(\d+)\s+.+(#{Gitstats::Application.config.languages.values.flatten.flatten.map {|a| a.sub(".", "\\.")}.join("|")})$/ doesn't match #{line}"
          next
        end
        author.add_commits(date, regex[1], regex[2], regex[3])
        author_hash[author.name] = author
        next
      end
    end

    author_hash["Tony"].date_commits.each {|k,v| debug(v.to_str)}

    author_hash.values.each do |author|
      a = Author.new(:name => author.name, :email => author.email)
      author.date_commits.each do |date_str, v|
        debug("#{v.to_str}")
        a.commit_dates << CommitDate.new(:date => Date.parse(date_str), :data => v.to_json)
      end
      a.save!
    end
  end
end
