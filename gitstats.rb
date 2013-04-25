require 'date'

def debug(line)
  return if true
  p "********* #{line}"
end

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
    @date_commits[date_str] = Commit.new
  end

  def add_commits(date, added, deleted, line)
    date_str = date.strftime("%Y%m%d")
    commit = @date_commits[date_str]
    commit.added += added.to_i
    commit.deleted += deleted.to_i
    if @name == "Tony"
      debug("#{added}:#{deleted} - #{line}")
    end
    @date_commits[date_str] = commit
  end
end

class CommitDate
  attr_accessor :author

  def initialize(author)
    @author = author
  end
end

class Commit
  attr_accessor :added, :deleted

  def initialize
    @added = 0
    @deleted = 0
  end

  def to_str
    "#{added}:#{deleted}"
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
      p "Author regex /Author\:\s*([^<]*)<([^>]*)>/ doesn't match #{line}"
      next
    end
    author = Author.new(regex[1].strip, regex[2])
    # store author if they don't already exist
    if author_hash[author.name]
      # get the last stored author
      author = author_hash[author.name]
    else
      author_hash[author.name] = author
    end
   next
  elsif line.start_with?('Date:')
    regex = line.match(/Date:\s+(.+)/)
    if !regex
      p "Date regex /Date:\s+(.+)/ doesn't match #{line}"
    end
    date = Date.strptime(regex[1], "%a %b %e")
    author.add_date(date)
    author_hash[author.name] = author
    next
  elsif line =~ /^\d+.+/ # store line count
    regex = line.match(/(\d+)\s+(\d+)\s+(.+)$/)
    if !regex
      p "Line count regex /(\d+)\s+(\d+)\s+(.+)$/ doesn't match #{line}"
      next
    end
    author.add_commits(date, regex[1], regex[2], line)
    author_hash[author.name] = author
    next
  end
end

author_hash["Tony"].date_commits.each {|k,v| p "*** #{v.to_str}"}
