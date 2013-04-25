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
      attr_accessor :rb_added, :rb_deleted,
        :html_added, :html_deleted,
        :css_added, :css_deleted,
        :js_added, :js_deleted
      #.rb|.scss|.coffee|.haml|.js|.css|.js.erb|.html.erb|.html

      def initialize
        @rb_added = 0
        @rb_deleted = 0
        @html_added = 0
        @html_deleted = 0
        @css_added = 0
        @css_deleted = 0
        @js_added = 0
        @js_deleted = 0
      end

      def add_file(file_type, lines_added, lines_deleted)
        case file_type.to_sym
          when :".rb"
            @rb_added += lines_added
            @rb_deleted += lines_deleted
          when :".html", :".html.erb", :".haml"
            @html_added += lines_added
            @html_deleted += lines_deleted
          when :".css", :".css.erb", :".scss"
            @css_added += lines_added
            @css_deleted += lines_deleted
          when :".js", :".js.erb", :".coffee"
            @js_added += lines_added
            @js_deleted += lines_deleted
          else
            raise "Invalid file type #{file_type}"
        end
      end

      def to_str
        "rb - #{rb_added}:#{rb_deleted}\nhtml - #{html_added}:#{html_deleted}\njs - #{js_added}:#{js_deleted}\ncss - #{css_added}:#{css_deleted}\n"
      end

      def to_json
        {:rb_added => @rb_added,
          :rb_deleted => @rb_deleted,
          :html_added => @html_added,
          :html_deleted => @html_deleted,
          :css_added => @css_added,
          :css_deleted => @css_deleted,
          :js_added => @js_added,
          :js_deleted => @js_deleted}.to_json
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
        date = Date.strptime(regex[1], "%a %b %e")
        author.add_date(date)
        author_hash[author.name] = author
        next
      elsif line =~ /^\d+.+/ # store line count
        regex = line.match(/(\d+)\s+(\d+)\s+.+(\.rb|\.scss|\.coffee|\.haml|\.js|\.css|\.css.erb|\.js.erb|\.html.erb|\.html)$/)
        if !regex
          p "Line count regex /(\d+)\s+(\d+)\s+(.+)$/ doesn't match #{line}"
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
