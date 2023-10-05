# frozen_string_literal: true

10.times do
  article = Article.create!(
    title: Faker::DcComics.title,
    content: Faker::Lorem.paragraphs(
      number: rand(5..50),
      supplemental: true,
      #random_sentences_to_add: rand(25..100)
    ).join("\n")
  )

  rand(1..10).times do
    article.comments.create!(
      content: Faker::Lorem.paragraph(
        sentence_count: rand(2..10),
        supplemental: true,
        random_sentences_to_add: rand(5..20)
      )
    )
  end
end
