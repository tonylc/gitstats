require 'test_helper'

class GitParser::AuthorTest < MiniTest::Unit::TestCase
  def setup
    @author = GitParser::Author.new("tony", "me@mail.com")
  end

  def test_add_to_commit_for_author
    assert @author.date_commits.empty?
    @author.add_date(Date.new(2013,1,1))
    assert_instance_of GitParser::CommitDate, @author.date_commits["20130101"]
  end

  def test_add_to_commit_on_same_date_aggregates
    @author.add_date(Date.new(2013,1,1))
    @author.add_to_commit(Date.new(2013,1,1), 1, 1, "config/initializer.rb")
    @author.add_to_commit(Date.new(2013,1,1), 2, 3, "app/models/author.rb")
    @author.add_to_commit(Date.new(2013,1,1), 30, 20, "app/assets/javascripts/checkout.js")

    assert_equal [{"20130101" => "rb:3|4 js:30|20 css:0|0 html:0|0 java:0|0 src:57 test:0"}], @author.date_commits.map {|k,v| {k => v.to_str}}
  end

  def test_add_to_commit_on_different_dates
    @author.add_date(Date.new(2013,1,1))
    @author.add_date(Date.new(2013,1,2))

    @author.add_to_commit(Date.new(2013,1,1), 1, 1, "config/initializer.rb")
    @author.add_to_commit(Date.new(2013,1,2), 2, 3, "app/models/author.rb")
    @author.add_to_commit(Date.new(2013,1,1), 30, 20, "app/assets/javascripts/checkout.js")

    assert_equal [
        {"20130101" => "rb:1|1 js:30|20 css:0|0 html:0|0 java:0|0 src:52 test:0"},
        {"20130102" => "rb:2|3 js:0|0 css:0|0 html:0|0 java:0|0 src:5 test:0"}],
      @author.date_commits.map {|k,v| {k => v.to_str}}
  end
end
