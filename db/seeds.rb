(1..50).each do |i|
  qu = Question.create(
    kind: i % 3,
    question: "this is question #{i}",
    answer_count: i
  )

  qu.answers.create(
    [].tap do |answers|
      (1..i).each do |j|
        answers << {
          categories: 'a, b,c ',
          url: 'https://fake.com',
          value: 'blah ' * j
        }
      end
    end
  )
end
