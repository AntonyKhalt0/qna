FactoryBot.define do
  factory :answer do
    body { "MyText" }
  end

  trait :invalid_body do
    body { nil }
  end
end
