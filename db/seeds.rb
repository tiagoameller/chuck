Question.record_timestamps = false
begin
  (1..50).each do |i|
    kind = i % 3
    some_time_ago = rand(50).days.ago
    qu = Question.create(
      kind: kind,
      question: (kind < 2 ? Faker::Lorem.word : nil),
      answer_count: i,
      created_at: some_time_ago,
      updated_at: some_time_ago
    )

    qu.answers.create(
      [].tap do |answers|
        (1..i).each do |j|
          answers << {
            categories: Faker::Lorem.words(number: j).join('|'),
            url: Faker::Internet.url,
            icon_url: 'https://assets.chucknorris.host/img/avatar/chuck-norris.png',
            value: Faker::Lorem.sentence
          }
        end
      end
    )
  end
ensure
  Question.record_timestamps = true
end
