# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :template, :class => 'Smithy::Template' do
    name { FFaker::Lorem.words(5).join(' ') }
    content { FFaker::Lorem.paragraph }
    template_type 'template'
  end
end
