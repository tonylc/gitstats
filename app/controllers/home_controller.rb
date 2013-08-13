class HomeController < ApplicationController
  def index
    author_handle = params[:u] || 'tonylc'
    @author_handles = Author.pluck(:email).map {|email| email.split("@").first }
    @author = Author.where(Author.arel_table[:email].matches("%#{author_handle}@%")).first
    @commit_stats = {}
    @commit_dates = @author.commit_dates.order("date asc")
    @languages = []
    @author.commit_dates.group_by(&:date).each do |date, commit_dates|
      commit_dates.each do |commit_date|
        JSON.parse(commit_date.data).each do |language, add_delete_count|
          @languages << language
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
    @languages.uniq!
    @first_date = @commit_dates.first.try(:date)
    @last_date = @commit_dates.last.try(:date)
    @num_days = ((@last_date - @first_date) / 86400).ceil + 1 if @first_date && @last_date
  end

  def ratio
    @authors = Author.all
    # TODO(tonylc) order by date desc, limit by 1000?
    @commit_ratios = Author.first.commit_ratios
    @first_date = @commit_ratios.first.try(:date)
    @last_date = @commit_ratios.last.try(:date)
    @num_days = ((@last_date - @first_date) / 86400).ceil + 1 if @first_date && @last_date
  end
end
