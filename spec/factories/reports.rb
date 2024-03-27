# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    association :user
    title { 'テストタイトル' }
    content { 'テストコンテント' }
  end
end
