FactoryBot.define do
  factory :article do
    title { Faker::DcComics.title }
    content {
      Faker::Lorem.paragraphs(
        number: rand(5..50),
        supplemental: true,
      ).join("\n")
    }
  end
end
