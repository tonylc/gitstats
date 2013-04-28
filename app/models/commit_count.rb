class CommitCount
  attr_reader :type, :added_lines, :deleted_lines

  def initialize(type)
    @type = type
    @added_lines = 0
    @deleted_lines = 0
  end

  def add_plus_lines(count)
    @added_lines += count
  end

  def add_minus_lines(count)
    @deleted_lines += count
  end

  def as_json(options={})
    [type,@added_lines,@deleted_lines]
  end
end
