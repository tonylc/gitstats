require 'test_helper'

class GitParser::CommitTest < MiniTest::Unit::TestCase
  def setup
    @commit = GitParser::Commit.new
  end

  def test_add_commits_of_same_file_type_will_sum
    @commit.add_file(".rb", 35, 62)

    assert_equal 35, @commit.instance_variable_get("@rb_added")
    assert_equal 62, @commit.instance_variable_get("@rb_deleted")

    @commit.add_file(".rb", 3, 2)

    assert_equal 38, @commit.instance_variable_get("@rb_added")
    assert_equal 64, @commit.instance_variable_get("@rb_deleted")
  end

  def test_add_commits_of_different_file_type_will_be_independent
    @commit.add_file(".rb", 35, 62)

    assert_equal 35, @commit.instance_variable_get("@rb_added")
    assert_equal 62, @commit.instance_variable_get("@rb_deleted")

    @commit.add_file(".js", 3, 2)

    assert_equal 35, @commit.instance_variable_get("@rb_added")
    assert_equal 62, @commit.instance_variable_get("@rb_deleted")
    assert_equal 3, @commit.instance_variable_get("@js_added")
    assert_equal 2, @commit.instance_variable_get("@js_deleted")
  end

  def test_to_json
    @commit.add_file(".rb", 1, 2)
    @commit.add_file(".js", 3, 4)
    @commit.add_file(".css", 5, 6)
    @commit.add_file(".html", 7, 8)

    assert_equal "{\"rb\":\"1,2\",\"js\":\"3,4\",\"css\":\"5,6\",\"html\":\"7,8\"}", @commit.to_json
  end
end
