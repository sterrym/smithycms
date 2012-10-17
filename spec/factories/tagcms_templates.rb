# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tagcms_template, :class => 'Template' do
    name { Faker::Lorem.words(5).join(' ') }
    content { Faker::Lorem.paragraph }
  end
end
