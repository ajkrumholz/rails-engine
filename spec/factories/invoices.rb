FactoryBot.define do
  factory :invoice do
    traits_for_enum :status, %i(pending in_progess success)
  end
end
