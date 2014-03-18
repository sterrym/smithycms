# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :image, :class => 'Smithy::Image' do
    asset
    alternate_text { Faker::Lorem.words(5).join(' ') }
    content { Faker::Lorem.sentence }
  end
end
