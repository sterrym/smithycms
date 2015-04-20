# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setting, :class => 'Smithy::Setting' do
    name { FFaker::Lorem.words(5).join('_') }
    value { FFaker::Lorem.words(5).join('_') }
  end
end
