# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :content_block, :class => 'Smithy::ContentBlock' do
    name { Faker::Lorem.words(5).join(' ') }
    description { Faker::Lorem.paragraph }
  end
end
