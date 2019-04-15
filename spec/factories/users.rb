FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "sample#{n}@example.com" }
    password { Devise.friendly_token.first(8) }
    nickname { 'hogechan' }
    trait :skip_confirmation do
      confirmed_at { Time.zone.now }
    end
  end
end
