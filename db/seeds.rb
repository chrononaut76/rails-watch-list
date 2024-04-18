# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'open-uri'
require 'json'

access_token = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzYzY2YzI1YzYwODExYjljZjkwMjViOWIxMDY0N2Q3YyIsInN1YiI6IjY2MjA0NTllM2M0MzQ0MDE3YzA0YmI3NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.CLe0TbqCfIiOgpoJ-rwzCH2-X6KY9WL-zYeVxUI3sYc'
response_serialized = URI.open('https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1',
                               'accept' => 'application/json',
                               'Authorization' => access_token).read
response = JSON.parse(response_serialized)

response['results'].each do |r|
  if r['original_language'].eql?('en')
    Movie.create!(title: r['original_title'],
                  overview: r['overview'],
                  poster_url: "https://image.tmdb.org/t/p/w500#{r['poster_path']}",
                  rating: r['vote_average'])
  end
end
