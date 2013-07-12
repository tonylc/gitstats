require 'test_helper'

class CommitStatsTest < MiniTest::Unit::TestCase
  def setup
    @ls = CommitStats.new("rb")
  end

  def test_adds_rb_line
    @ls.add_count_for_date(Date.new(2013,1,1), 25, 43)
    assert_equal "[\"rb\",[[\"2013-01-01\",25,43]]]", @ls.to_json
  end

  def test_adds_rb_lines_for_the_same_date
    @ls.add_count_for_date(Date.new(2013,1,1), 25, 43)
    @ls.add_count_for_date(Date.new(2013,1,1), 11, 2)
    assert_equal "[\"rb\",[[\"2013-01-01\",36,45]]]", @ls.to_json
  end

  def test_adds_mutiple_dates
    @ls.add_count_for_date(Date.new(2013,1,1), 25, 43)
    @ls.add_count_for_date(Date.new(2013,1,2), 11, 2)
    assert_equal "[\"rb\",[[\"2013-01-01\",25,43],[\"2013-01-02\",11,2]]]", @ls.to_json
  end
end
