FactoryGirl.define do
  factory :author do
    sequence(:name) {|n| "#{n} name"}
    sequence(:email) {|n| "#{n}_name@mail.com"}
  end
end
