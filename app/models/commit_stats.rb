class CommitStats
  def initialize(type)
    @type = type
    @stats = {}
  end

  # [date, add_count, delete_count]
  def add_count_for_date(date, add_count, delete_count)
    if @stats[date]
      @stats[date][1] += add_count
      @stats[date][2] += delete_count
    else
      @stats[date] = [date, add_count, delete_count]
    end
  end

  def as_json(options={})
    [@type, @stats.values.as_json(options)]
  end
end
