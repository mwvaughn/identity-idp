FactoryGirl.define do
  factory :profile do
    association :user, factory: [:user, :signed_up]
    transient do
      pii false
    end

    trait :active do
      active true
      activated_at Time.current
    end

    trait :verified do
      verified_at Time.current
    end

    after(:build) do |profile, evaluator|
      if evaluator.pii
        evaluator.pii.each { |key, val| profile.plain_pii[key] = val }
      end
    end
  end
end
