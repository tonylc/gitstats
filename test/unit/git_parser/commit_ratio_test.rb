require 'test_helper'

class GitParser::CommitRatioTest < MiniTest::Unit::TestCase

  def setup
    @commit_ratio = GitParser::CommitRatio.new(DateTime.new(2013,1,1))
  end

  def test_add_line_count_for_source_files
    @commit_ratio.add_line_count("app/models/author.rb", 132)
    @commit_ratio.add_line_count("config/boot.rb", 21)
    @commit_ratio.src_lines = 153
  end

  def test_add_line_count_for_test_files
    @commit_ratio.add_line_count("spec/models/author_spec.rb", 18)
    @commit_ratio.add_line_count("test/models/author_test.rb", 33)
    @commit_ratio.test_lines = 51
  end

  def test_add_line_count_for_both
    @commit_ratio.add_line_count("app/models/author.rb", 132)
    @commit_ratio.add_line_count("test/models/author_test.rb", 33)
    @commit_ratio.src_lines = 132
    @commit_ratio.test_lines = 33
  end
end
