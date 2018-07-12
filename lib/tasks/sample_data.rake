namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 introduction: "管理者の自己紹介スペース",
                 prefecture_code: 1,
                 birthday: Date.today,
                 avatar: 'roughlyIcon.png')
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      intr = "fake introduction"
      pf_code = 4
      bd = Date.today
      image = Faker::Avatar.image
      User.create!(name: name,
                   email: email,
                   password: password,
                   introduction: intr,
                   prefecture_code: pf_code,
                   birthday: bd,
                   avatar: image)
    end
    
    users = User.all(limit: 6)
    50.times do
      song = Faker::Lorem.word
      artist = Faker::RockBand.name
      users.each { |user| user.favorites.create!(song: song, artist: artist) }
    end
  end
end