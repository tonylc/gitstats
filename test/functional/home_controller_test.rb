require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  def test_user_with_no_data
    author = FactoryGirl.create(:author)

    get :index, :u => author.email.split('@')[0]

    assert_template :index
    assert_equal author, assigns[:author]
    assert_equal [author.email.split('@')[0]], assigns[:author_handles]
    assert_empty assigns[:languages]
    assert_nil assigns[:first_date]
    assert_nil assigns[:last_date]
    assert_nil assigns[:num_days]
  end

  def test_user_with_data
    author1 = FactoryGirl.create(:author)
    author2 = FactoryGirl.create(:author)
    create_commit_date_with_lang(author2, DateTime.new(2013,1,1), [['rb',1,1],['html',2,3]])

    get :index, :u => author2.email.split('@')[0]

    assert_template :index
    assert_equal author2, assigns[:author]
    assert_equal [author1.email.split('@')[0], author2.email.split('@')[0]], assigns[:author_handles]
    assert_equal ["rb", "html"], assigns[:languages]
    assert_equal DateTime.new(2013,1,1), assigns[:first_date]
    assert_equal DateTime.new(2013,1,1), assigns[:last_date]
    assert_equal 1, assigns[:num_days]
  end
end