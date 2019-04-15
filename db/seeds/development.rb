require 'csv'

csv_options = {headers: :true, header_converters: :symbol, converters: :numeric}

users = []
p "created user"
CSV.foreach('db/seeds/data/development/users.csv', csv_options) do |row|
  users << User.where(email: row[:email]).first_or_create!({
    password: row[:password],
    nickname: row[:nickname],
    confirmed_at: row[:confirmed_at]
  })
end

articles = []
p "created article"
CSV.foreach('db/seeds/data/development/articles.csv', csv_options) do |row|
  user = users.sample

  articles << Article.where(user_id: user).first_or_create!({
    user: user,
    todo: row[:todo],
    problem: row[:problem],
    shared_information: row[:shared_information],
    over_work: row[:over_work],
    status: row[:status],
    published_on: row[:published_on]
  })
end


p "created comment"
CSV.foreach('db/seeds/data/development/comments.csv', csv_options) do |row|
  user = users.sample
  article = articles.sample

  article.comments.create!({
    user: user,
    body: row[:body]
  })
end

p "created reaction"
CSV.foreach('db/seeds/data/development/reactions.csv', csv_options) do |row|
  user = users.sample
  article = articles.sample

  Reaction.where(user_id: user, code: row[:code]).first_or_create!({
    reactionable: article,
    registered: row[:registered]
  })
end
