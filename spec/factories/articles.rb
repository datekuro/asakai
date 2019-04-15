FactoryBot.define do
  factory :article do
    user_id { 1 }
    todo { "サンプルTODO" }
    problem { "" }
    shared_information { "" }
    over_work { "残業しない" }
    status { "draft" }
    published_on { "2019-04-15" }

    trait :with_user do
      after(:build) do |article, eval|
        article.user_id ||= eval.user_id
      end
      association :user, factory: :user
    end
  end
end
