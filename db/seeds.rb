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

config_serialized = URI.open('https://api.themoviedb.org/3/configuration',
                             'accept' => 'application/json',
                             'Authorization' => TMDB_TOKEN).read
config = JSON.parse(config_serialized)['images']

top_rated_serialized = URI.open('https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1',
                                'accept' => 'application/json',
                                'Authorization' => access_token).read
top_rated = JSON.parse(top_rated_serialized)

top_rated['results'].each do |r|
  if r['original_language'].eql?('en')
    Movie.create!(title: r['original_title'],
                  overview: r['overview'],
                  poster_url: "#{config['secure_base_url']}#{config['poster_sizes'][4]}#{r['poster_path']}",
                  rating: r['vote_average'])
  end
end
