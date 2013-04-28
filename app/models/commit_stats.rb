class CommitStats
  def initialize(date)
    @date = date
    @stats = {}
  end

  def add_commit_stat(json_str)
    json = JSON.parse(json_str)
    json.each do |lang, add_del_count|
      if @stats[lang]
        cc = @stats[lang]
      else
        cc = CommitCount.new(lang)
        @stats[lang] = cc
      end
      cc.add_plus_lines(add_del_count.split(",")[0].to_i)
      cc.add_minus_lines(add_del_count.split(",")[1].to_i)
    end
  end

  def as_json(options={})
    [@date.strftime("%Y-%m-%d"),@stats.values.as_json(options)]
  end
end
