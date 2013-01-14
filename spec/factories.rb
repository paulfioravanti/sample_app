FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "Person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    sequence(:content) { |n| "Lorem Ipsum #{n}" }
    user

    factory :micropost_with_translations do
      after(:create) do |micropost|
        I18n.available_locales.each do |locale|
          next if locale == I18n.locale
          micropost.translations.create(locale: locale, content: micropost.content)
        end
      end
    end
  end
end