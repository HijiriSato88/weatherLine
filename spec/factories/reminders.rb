FactoryBot.define do
  factory :reminder do
    user { nil }
    reminder_time { "2025-03-30 03:17:52" }
    location { "MyString" }
    is_receive_reminder { false }
  end
end
