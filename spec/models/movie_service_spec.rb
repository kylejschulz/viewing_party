require 'rails_helper'

RSpec.describe MovieService, type: :model do
  describe 'class methods' do
    it '#movie_service_get', :vcr do
      result = MovieService.movie_search_get('Jack Reacher', 1)[:results]
      expect(result.first[:title]).to eq("Jack Reacher")

      expect(result.size).to eq(2)
    end

    it '#movie_search_objects', :vcr do
      result = MovieService.movie_search_objects('Jack Reacher')

      expect(result.first.class).to eq(MovieObject)

      expect(result.first.title).to eq('Jack Reacher')
      expect(result.last.title).to eq('Jack Reacher: Never Go Back')

      expect(result.size).to eq(2)
    end

    it '#top_forty_get', :vcr do
      result = MovieService.top_forty_get(1)[:results]

      expect(result.first[:title]).to eq("Dilwale Dulhania Le Jayenge")
      expect(result.size).to eq(20)
    end

    it '#top_forty_objects', :vcr do
      result = MovieService.top_forty_objects

      expect(result.first.class).to eq(MovieObject)
      expect(result.first.title).to eq("Dilwale Dulhania Le Jayenge")
      expect(result.last.title).to eq("City of God")
      expect(result.size).to eq(40)
    end

    it '#movie_details_get', :vcr do
      result = MovieService.movie_details_get(155)

      expect(result[:title]).to eq("The Dark Knight")
      expect(result[:id]).to eq(155)
    end

    it '#movie_objects', :vcr do
      result = MovieService.movie_object(155)

      expect(result.class).to eq(MovieObject)

      expect(result.title).to eq("The Dark Knight")
      expect(result.id).to eq(155)
    end

    it '#movie_cast_get', :vcr do
      expect(MovieService.movie_cast_get(155)[:cast].first[:name]).to eq("Christian Bale")
    end

    it '#reviews_get', :vcr do
      expect(MovieService.reviews_get(155)[:results].first[:author]).to eq("tricksy")
    end
  end
end
