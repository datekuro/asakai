FactoryBot.define do
  factory :reaction do
    user_id { 1 }
    code { :thumbs_up }
    registered { false }
    reactionable { nil }

    trait :with_user do
      after(:build) do |reaction, eval|
        reaction.user_id ||= eval.user_id
      end
      association :user, factory: :user
    end
  end
end
