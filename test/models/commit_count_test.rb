require 'test_helper'

class TestCommitCount < MiniTest::Unit::TestCase
  def setup
    @cc = CommitCount.new("rb")
  end

  def test_by_default_has_no_line_count
    assert_equal 0, @cc.added_lines
    assert_equal 0, @cc.deleted_lines
  end

  def test_should_add_plus_lines_to_count
    @cc.add_plus_lines(5)
    assert_equal 5, @cc.added_lines
    @cc.add_plus_lines(3)
    assert_equal 8, @cc.added_lines
  end

  def test_should_add_minus_lines_to_count
    @cc.add_minus_lines(1)
    assert_equal 1, @cc.deleted_lines
    @cc.add_minus_lines(3)
    assert_equal 4, @cc.deleted_lines
  end

  def test_to_json
    @cc.add_plus_lines(5)
    @cc.add_minus_lines(2)
    assert_equal "[\"rb\",5,2]", @cc.to_json
  end
end
