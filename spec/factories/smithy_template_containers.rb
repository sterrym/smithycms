# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :template_container, :class => 'Smithy::TemplateContainer' do
    name { FFaker::Lorem.words(5).join(' ') }
    template
  end
end
