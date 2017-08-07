# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# To reset the sequences:
# ActiveRecord::Base.connection.tables.each do |t|
#   ActiveRecord::Base.connection.reset_pk_sequence!(t)
# end

User.all.delete_all
Category.all.delete_all
Video.all.delete_all

User.create(email: 'bcf@bcf', password: 'bcf', full_name: 'bcf')

Category.create([{ name: 'Comedies' }, { name: 'Dramas' }, { name: 'Reality TV' }])

url1 = '/tmp/monk.jpg'
url2 = '/tmp/monk_large.jpg'

Video.create(title: "The Simpsons",
             description: "A cartoon.",
             category: Category.find_by(name: "Comedies"),
             small_cover_url: url1,
             large_cover_url: url2)

Video.create(title: "Futurama",
             description: "A cartoon.",
             category: Category.find_by(name: "Comedies"),
             small_cover_url: url1,
             large_cover_url: url2)

Video.create(title: "Family Guy",
             description: "A cartoon.",
             category: Category.find_by(name: "Comedies"),
             small_cover_url: url1,
             large_cover_url: url2)

Video.create(title: "Cheers",
             description: "A sitcom.",
             category: Category.find_by(name: "Comedies"),
             small_cover_url: url1,
             large_cover_url: url2)

Video.create(title: "Friends",
             description: "A sitcom.",
             category: Category.find_by(name: "Comedies"),
             small_cover_url: url1,
             large_cover_url: url2)

Video.create(title: "Seinfeld",
             description: "A sitcom.",
             category: Category.find_by(name: "Comedies"),
             small_cover_url: url1,
             large_cover_url: url2)

Video.create(title: "Modern Family",
             description: "A sitcom.",
             category: Category.find_by(name: "Comedies"),
             small_cover_url: url1,
             large_cover_url: url2)

Video.create(title: "Survivor",
             description: "Not a cartoon.",
             category: Category.find_by(name: "Reality TV"),
             small_cover_url: url1,
             large_cover_url: url2)

Video.create(title: "Masterchef",
             description: "A competitive cooking show.",
             category: Category.find_by(name: "Reality TV"),
             small_cover_url: url1,
             large_cover_url: url2)

Video.create(title: "The Great British Bake-off",
             description: "A competitive baking show.",
             category: Category.find_by(name: "Reality TV"),
             small_cover_url: url1,
             large_cover_url: url2)

Video.create(title: "The Great British Sewing Bee",
             description: "A competitive sewing show.",
             category: Category.find_by(name: "Reality TV"),
             small_cover_url: url1,
             large_cover_url: url2)

Video.create(title: "The Bachelorette",
             description: "A competitive dating show.",
             category: Category.find_by(name: "Reality TV"),
             small_cover_url: url1,
             large_cover_url: url2)

Video.create(title: "Edwardian Farm",
             description: "A historical show.",
             category: Category.find_by(name: "Reality TV"),
             small_cover_url: url1,
             large_cover_url: url2)

Video.create(title: "Big Brother",
             description: "A boring show.",
             category: Category.find_by(name: "Reality TV"),
             small_cover_url: url1,
             large_cover_url: url2)

Video.create(title: "This Is Us",
             description: "A sappy family drama.",
             category: Category.find_by(name: "Dramas"),
             small_cover_url: url1,
             large_cover_url: url2)

Video.create(title: "Sherlock",
             description: "A crime-solving show that used to be good.",
             category: Category.find_by(name: "Dramas"),
             small_cover_url: url1,
             large_cover_url: url2)

# 6.times do |i|
#   Video.create(title: "Title #{i}", description: "Description #{i}", small_cover_url: url1, large_cover_url: url2)
# end

# Video.all.each_with_index { |v, i| v.update(category_id: 1 + (i % Category.all.size)) }
