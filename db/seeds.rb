5.times do |i|
  Book.create(
    title: "Title #{i + 1}",
    author: "Author #{i + 1}",
    price: 200.0 * (i + 1),
    published_year: 2023,
    genre: 'Drama'
  )
end

puts 'Book seeds have been planted.'
