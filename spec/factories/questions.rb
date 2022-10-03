FactoryBot.define do
  factory :question do
    title { "MyQuestionTitle" }
    body { "MyQuestionBody" }
  end

  trait :invalid do
    title { nil }
  end
end
