FactoryGirl.define do
  factory :commit_ratio do
    association :author
    date Time.now
    src_lines { (rand * 100).round }
    test_lines { (rand * 100).round }
  end
end
