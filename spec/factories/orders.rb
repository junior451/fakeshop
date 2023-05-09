# == Schema Information
#
# Table name: orders
#
#  id         :bigint           not null, primary key
#  name       :string
#  address    :text
#  email      :string
#  paytype    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :order do
    name { "Jay Coleman" }
    address { "34 Spedhall Rd" }
    email { "colemanj@gmail.co" }
    paytype { 1 }
    ship_date { DateTime.now }
  end
end