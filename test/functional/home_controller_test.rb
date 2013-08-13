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
    create_commit_date_with_lang(author2, DateTime.new(2013, 1, 1), [['rb', 1, 1],['html', 2, 3]])

    get :index, :u => author2.email.split('@')[0]

    assert_template :index
    assert_equal author2, assigns[:author]
    assert_equal [author1.email.split('@')[0], author2.email.split('@')[0]], assigns[:author_handles]
    assert_equal ["rb", "html"], assigns[:languages]
    assert_equal DateTime.new(2013, 1, 1), assigns[:first_date]
    assert_equal DateTime.new(2013, 1, 1), assigns[:last_date]
    assert_equal 1, assigns[:num_days]
  end

  def test_user_with_data_with_3_days_in_between
    author = FactoryGirl.create(:author)
    create_commit_date_with_lang(author, Time.utc(2013, 2, 19, 8), [['rb', 1, 1]])
    create_commit_date_with_lang(author, Time.utc(2013, 3, 1), [['rb', 1, 1]])
    create_commit_date_with_lang(author, Time.utc(2013, 4, 2, 7), [['rb', 1, 1]])

    get :index, :u => author.email.split('@')[0]

    assert_template :index
    assert_equal author, assigns[:author]
    assert_equal DateTime.new(2013, 2, 19, 8), assigns[:first_date]
    assert_equal DateTime.new(2013, 4, 2, 7), assigns[:last_date]
    assert_equal 43, assigns[:num_days]
  end

  def test_get_all_commit_ratios
    cr1 = FactoryGirl.create(:commit_ratio, :date => DateTime.new(2013,2,1))
    cr2 = FactoryGirl.create(:commit_ratio, :date => DateTime.new(2013,1,1))

    get :ratio

    assert_template :ratio
    assert_equal DateTime.new(2013,1,1), assigns[:first_date]
    assert_equal DateTime.new(2013,2,1), assigns[:last_date]
    # jan has 31 days + 1
    assert_equal 32, assigns[:num_days]
  end
end