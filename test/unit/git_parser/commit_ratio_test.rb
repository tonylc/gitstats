require 'test_helper'

class GitParser::CommitRatioTest < MiniTest::Unit::TestCase

  def setup
    @commit_ratio = GitParser::CommitRatio.new(DateTime.new(2013,1,1))
  end

  def test_add_line_count_for_source_files
    @commit_ratio.add_line_count("app/models/author.rb", 132)
    @commit_ratio.add_line_count("config/boot.rb", 21)
    assert_equal 153, @commit_ratio.src_lines
  end

  def test_add_line_count_for_test_files
    @commit_ratio.add_line_count("spec/models/author_spec.rb", 18)
    @commit_ratio.add_line_count("test/models/author_test.rb", 33)
    assert_equal 51, @commit_ratio.test_lines
  end

  def test_add_line_count_for_test_files_for_ruby_files_under_spec_or_test
    @commit_ratio.add_line_count("spec/spec_helper.rb", 18)
    @commit_ratio.add_line_count("test/test_helper.rb", 33)
    assert_equal 51, @commit_ratio.test_lines
  end

  def test_add_line_count_for_both
    @commit_ratio.add_line_count("app/models/author.rb", 132)
    @commit_ratio.add_line_count("test/models/author_test.rb", 33)
    assert_equal 132, @commit_ratio.src_lines
    assert_equal 33, @commit_ratio.test_lines
  end

  def test_is_empty_commit_when_lines_are_zero
    assert GitParser::CommitRatio.new(DateTime.new(2013,1,1)).empty_commit?
  end

  def test_is_not_empty_commit_when_lines_present
    @commit_ratio.add_line_count("app/models/author.rb", 15)
    assert !@commit_ratio.empty_commit?
  end
end
