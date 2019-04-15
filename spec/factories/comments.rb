FactoryBot.define do
  factory :comment do
    user { 1 }
    body { "MyText" }

    trait :with_user do
      after(:build) do |comment, eval|
        comment.user_id ||= eval.user_id
      end
      association :user, factory: :user
    end
  end
end
