(Date.new(2011,1,1)..(1.years.from_now).to_date).each do |d|
  DateDimension.new_from_date(d).save!
end

group_admins = Group.create!(name: 'Admins')
group_users  = Group.create!(name: 'Users')

admins = []
(1..3).each do |x|
  admins << User.create!(
    username: "admin_#{x}",
    group: group_admins
  )
end

(1..5).each do |x|
  user = User.create!(
    username: Faker::Internet.unique.user_name,
    group: group_users
  )

  Profile.create!(
    user: user,
    favorite_pokemon: Faker::Pokemon.name,
    favorite_color: Faker::Color.color_name
  )
end

Post.create!(
  title: Faker::Lorem.words.join(' '),
  body: Faker::Lorem.paragraph,
  state: 'draft',
  creator: User.find_by!(username: 'admin_1'),
  created_on: DateDimension.random
)

(1..20).each do |x|
  post = Post.create!(
    title: Faker::Lorem.words.join(' '),
    body: Faker::Lorem.paragraph,
    state: 'publish',
    creator: admins.sample,
    created_on: DateDimension.random
  )

  rand(10).times.each do
    post.comments.create!(
      user: User.offset(rand(User.count)).first,
      body: Faker::Lorem.paragraph
    )
  end
end
