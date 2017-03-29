desc "Generate dummy data to populate DB with Faker gem."
task :gen_dummy_data => :environment do
  if Rails.env.development?
    # create users
    users = (1..100).map do
      user = User.where(email: Faker::Internet.email).first_or_create do |u|
          u.password            = Faker::Internet.password
          u.is_email_confirmed  = [true, false].sample
          u.created_at          = Faker::Time.between Date.today.at_beginning_of_month, Date.today
        end
      user.id
    end

    # create notes
    1000.times do
      Note.create(
        title:      Faker::Hipster.sentence,
        content:    Faker::Hipster.paragraphs.join("\n\n"),
        created_at: Faker::Time.between(Date.today.at_beginning_of_month, Date.today),
        tags:       Faker::Hipster.words,
        user_id:    users.sample
      )
    end
  end
end
