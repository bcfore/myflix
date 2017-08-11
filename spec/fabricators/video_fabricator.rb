Fabricator(:video) do
  title { Faker::Lorem.words(rand(1..5)).join(' ') }
  description { Faker::Lorem.paragraph(rand(1..5)) }
end
