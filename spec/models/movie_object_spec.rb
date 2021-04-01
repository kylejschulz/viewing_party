require 'rails_helper'

RSpec.describe MovieObject, type: :model do
  describe 'attributes' do
    it 'attributes', :vcr do
      movie = MovieService.movie_object(100)

      description = "A card shark and his unwillingly-enlisted friends need to make a lot of cash quick after losing a sketchy poker match. To do this they decide to pull a heist on a small-time gang who happen to be operating out of the flat next door."

      expect(movie.description).to eq(description)
      expect(movie.id).to eq(100)
      expect(movie.title).to eq("Lock, Stock and Two Smoking Barrels")
      expect(movie.vote_count).to eq(4718)
      expect(movie.vote_average).to eq(8.2)
    end
  end

  describe 'instance methods' do
    it '#runtime', :vcr do
      movie = MovieService.movie_object(100)

      expect(movie.runtime).to eq('1:45')
    end

    it '#first_10_cast_members', :vcr do
      movie = MovieService.movie_object(100)

      cast = [
              {:actor=>"Jason Flemyng", :character=>"Tom"},
              {:actor=>"Dexter Fletcher", :character=>"Soap"},
              {:actor=>"Nick Moran", :character=>"Eddie"},
              {:actor=>"Jason Statham", :character=>"Bacon"},
              {:actor=>"Vinnie Jones", :character=>"Big Chris"},
              {:actor=>"Sting", :character=>"JD"},
              {:actor=>"Steven Mackintosh", :character=>"Winston"},
              {:actor=>"Nicholas Rowe", :character=>"J"},
              {:actor=>"Lenny McLean", :character=>"Barry the Baptist"},
              {:actor=>"P.H. Moriarty", :character=>"'Hatchet' Harry Lonsdale"}
            ]

      expect(movie.first_10_cast_members).to eq(cast)
    end

    it '#first_10_cast_members with less than 10 cast members', :vcr do
      movie = MovieService.movie_object(4520)

      cast = [
              {:actor=>"Michael Caine", :character=>"Andrew Wyke"},
              {:actor=>"Jude Law", :character=>"Milo Tindle"},
              {:actor=>"Harold Pinter", :character=>"Man on T.V."},
              {:actor=>"Carmel O'Sullivan", :character=>"Maggie"},
              {:actor=>"Kenneth Branagh", :character=>"Other Man on T.V."}
            ]

      expect(movie.first_10_cast_members).to eq(cast)
    end
  #
    it '#genres', :vcr do
      movie = MovieService.movie_object(100)

      genres = ["Comedy", "Crime"]

      expect(movie.genres).to eq(genres)
    end
  #
    it '#review_authors', :vcr do
      movie = MovieService.movie_object(100)

      reviews = [
                  {:content=>"I just plain love this movie!", :name=>"BradFlix"},
                  {:content=> "Far from being a good movie, with tons of flaws but already pointing to the pattern of the whole Ritchie's filmography.", :name=>"Andres Gomez"},
                  {:content=> "Genuinely one of my favorite movies of all time. Watched again recently and realised how well written, brilliantly shot, beautifully cast and cleverly produced this movie actually is!", :name=>"David Perkins"}
                ]

      expect(movie.review_authors).to eq(reviews)
    end

    it '#time_conversion', :vcr do
      movie = MovieService.movie_object(100)

      expect(movie.time_conversion(90)).to eq('1:30')
      expect(movie.time_conversion(125)).to eq('2:05')
    end

    it 'if genres are empty then we get N/A returned' do
      json_details = File.read('spec/fixtures/movie_details.json')
      json_reviews = File.read('spec/fixtures/movie_reviews.json')
      json_cast = File.read('spec/fixtures/movie_cast.json')

      stub_request(:get, "https://api.themoviedb.org/3/movie/155?api_key=ad4941ff23859e195ff1169f1ffc04fa&language=en-US").to_return(status: 200, body: json_details)
      stub_request(:get, "https://api.themoviedb.org/3/movie/155/reviews?api_key=ad4941ff23859e195ff1169f1ffc04fa&language=en-US&page=1").to_return(status: 200, body: json_reviews)
      stub_request(:get, "https://api.themoviedb.org/3/movie/155/credits?api_key=ad4941ff23859e195ff1169f1ffc04fa&language=en-US&page=1").to_return(status: 200, body: json_cast)
      movie = MovieService.movie_object(155)

      expect(movie.genres).to eq(["N/A"])
      expect(movie.genres.to_sentence).to eq("N/A")
    end

    it 'returns no reviews if a movie does not have any' do
      json_details = File.read('spec/fixtures/movie_details.json')
      json_reviews = File.read('spec/fixtures/movie_reviews.json')
      json_cast = File.read('spec/fixtures/movie_cast.json')

      stub_request(:get, "https://api.themoviedb.org/3/movie/155?api_key=ad4941ff23859e195ff1169f1ffc04fa&language=en-US").to_return(status: 200, body: json_details)
      stub_request(:get, "https://api.themoviedb.org/3/movie/155/reviews?api_key=ad4941ff23859e195ff1169f1ffc04fa&language=en-US&page=1").to_return(status: 200, body: json_reviews)
      stub_request(:get, "https://api.themoviedb.org/3/movie/155/credits?api_key=ad4941ff23859e195ff1169f1ffc04fa&language=en-US&page=1").to_return(status: 200, body: json_cast)

      movie = MovieService.movie_object(155)
      expect(movie.review_authors).to eq("No reviews for this movie")
    end
  end
end
