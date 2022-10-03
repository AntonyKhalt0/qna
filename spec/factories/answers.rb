# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { 'AnswerBody' }
  end

  trait :invalid_body do
    body { nil }
  end
end
