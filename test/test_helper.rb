ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# load factory_girl definitions
FactoryGirl.find_definitions

# awesome colorful output
require "minitest/pride"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  fixtures :all

  # [['rb', 3, 4], ['html', 1, 3]] => "{\"rb\":\"3,4\",\"html\":\"1,3\"}"
  def create_commit_date_with_lang(author, date, lang_counts)
    data = {}
    lang_counts.map do |lang_count|
      data[lang_count[0]] = "#{lang_count[1]},#{lang_count[2]}"
    end
    FactoryGirl.create(:commit_date, :author => author, :date => date, :data => data.to_json)
  end
end
