FactoryBot.define do
  factory :order do
    name { "MyString" }
    address { "MyText" }
    email { "MyString" }
    paytype { 1 }
  end
end
