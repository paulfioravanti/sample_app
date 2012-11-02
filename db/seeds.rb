def create_users
  puts "Creating Users..."
  admin = User.create!(name: "Example User",
                       email: "example@railstutorial.org",
                       password: "foobar",
                       password_confirmation: "foobar")
  admin.toggle!(:admin)

  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def create_microposts
  puts "Creating Microposts..."
  users = User.all(limit: 6)
  users.each do |user|
    50.times do
      I18n.locale = :en
      content = Faker::Lorem.sentence(5)
      micropost = user.microposts.create!(content: content)
      I18n.available_locales.each do |locale|
        next if locale == :en
        I18n.locale = locale
        translation = Faker::Lorem.sentence(5)
        micropost.translations.create!(locale: locale, content: translation)
      end
    end
  end
end

def create_relationships
  puts "Creating Relationships..."
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end

create_users
create_microposts
create_relationships