require 'test_helper'

class TestCommitStats < MiniTest::Unit::TestCase
  def setup
    @cs = CommitStats.new(Date.new(2013,1,2))
  end

  def test_adds_rb_lines
    @cs.add_commit_stat("{\"rb\":\"25,43\"}")
    assert_equal "[\"2013-01-02\",[{\"rb\":\"25,43\"}]]", @cs.to_json
  end

  def test_adds_mutiple_languages
    @cs.add_commit_stat("{\"rb\":\"25,43\"}")
    @cs.add_commit_stat("{\"html\":\"11,2\"}")
    assert_equal "[\"2013-01-02\",[{\"rb\":\"25,43\"},{\"html\":\"11,2\"}]]", @cs.to_json
  end
end
