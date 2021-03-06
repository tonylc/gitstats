require 'date'
require 'json'
Dir["#{Rails.root}/lib/git_parser/*.rb"].each {|file| require file }

# parses git log --numstat

namespace :git do
  task :parse => :environment do
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
        author = GitParser::Author.new(regex[1].strip, regex[2])
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
        date = DateTime.strptime(regex[1], "%a %b %e %H:%M:%S %Y %z")
        author.add_date(date)
        author_hash[author.name] = author
        next
      elsif line =~ /^\d+.+/ # store line count
        regex = line.match(/(\d+)\s+(\d+)\s+(.+(#{list_of_supported_file_types_regex}))$/)
        if !regex
          p "Line count regex /(\d+)\s+(\d+)\s+(.+(#{list_of_supported_file_types_regex}))$/ doesn't match #{line}"
          next
        end
        author.add_to_commit(date, regex[1].to_i, regex[2].to_i, regex[3])
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
      author.commit_ratios.each do |date_str, v|
        debug(v.to_s)
        next if v.empty_commit?
        a.commit_ratios << CommitRatio.new(:date => v.datetime, :src_lines => v.src_lines, :test_lines => v.test_lines)
      end
      a.save!
    end
  end
end
