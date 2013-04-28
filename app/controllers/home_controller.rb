class HomeController < ApplicationController
  def index
    author_handle = params[:u] || 'tonylc'
    @author = Author.where(Author.arel_table[:email].matches("%#{author_handle}@%")).first
    @commit_stats = []
    @author.commit_dates.group_by(&:date).each do |date, commit_dates|
      cs = CommitStats.new(date)
      commit_dates.each do |commit_date|
        cs.add_commit_stat(commit_date.data)
      end
      @commit_stats << cs
    end
  end
end
