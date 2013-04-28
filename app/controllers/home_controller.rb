class HomeController < ApplicationController
  def index
    author_handle = params[:u] || 'tonylc'
    @author = Author.where(Author.arel_table[:email].matches("%#{author_handle}@%")).first
    @commit_stats = {}
    @author.commit_dates.group_by(&:date).each do |date, commit_dates|
      commit_dates.each do |commit_date|
        JSON.parse(commit_date.data).each do |language, add_delete_count|
          if @commit_stats[language]
            cs = @commit_stats[language]
          else
            cs = CommitStats.new(language)
            @commit_stats[language] = cs
          end
          cs.add_count_for_date(date, add_delete_count.split(",")[0].to_i, add_delete_count.split(",")[1].to_i)
        end
      end
    end
  end
end
