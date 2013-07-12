FactoryGirl.define do
  factory :commit_date do
    association :author
    date Time.now
    data "{\"html\":\"2,2\"}"
  end
end
