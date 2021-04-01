class MovieService
  def self.movie_search_get(name, _page_num)
    response = connection.get('/3/search/movie') do |f|
      f.params['query'] = name.gsub(' ', '+')
    end
    parse(response)
  end

  def self.movie_search_objects(name)
    movies = []
    page_num = 1
    if movie_search_get(name, page_num)[:total_results] != 0
      until movies.size >= 40 || movies.size == movie_search_get(name, page_num)[:total_results]
        movie_search_get(name, page_num)[:results].map do |result|
          movies << MovieObject.new(id: result[:id], title: result[:title], vote_average: result[:vote_average])
        end
        page_num += 1
      end
    end
    movies.first(40)
  end

  def self.top_forty_get(page_num)
    response = connection.get('/3/movie/top_rated') do |f|
      f.params['page'] = page_num
    end
    parse(response)
  end

  def self.top_forty_objects
    movies = []
    page_num = 1
    until movies.size >= 40
      top_forty_get(page_num)[:results].each do |result|
        movies << MovieObject.new(id: result[:id], title: result[:title], vote_average: result[:vote_average])
      end
      page_num += 1
    end
    movies.first(40)
  end

  def self.movie_details_get(movie_id)
    response = connection.get("/3/movie/#{movie_id}")
    parse(response)
  end

  def self.movie_object(movie_id)
    initialize_object(movie_id)
  end

  def self.movie_cast_get(movie_id)
    response = connection.get("/3/movie/#{movie_id}/credits")
    parse(response)
  end

  def self.reviews_get(movie_id)
    response = connection.get("/3/movie/#{movie_id}/reviews?page=1")
    parse(response)
  end

  def self.no_movies?(name)
    return 'no_movies' if movie_search_get(name, 1)[:total_results].zero?

    'movies'
  end

  def self.top_forty_partial
    'movies'
  end

  def self.initialize_object(movie_id)
    details = movie_details_get(movie_id)
    reviews = reviews_get(movie_id)
    cast = movie_cast_get(movie_id)[:cast].first(10)
    hash = {
      description: details[:overview],
      id: details[:id],
      title: details[:title],
      vote_count: details[:vote_count],
      vote_average: details[:vote_average],
      runtime: details[:runtime],
      cast: cast,
      reviews: reviews[:results],
      genres: details[:genres],
      poster: details[:poster_path]
    }

    MovieObject.new(hash)
  end

  def self.connection
    Faraday.new(url: 'https://api.themoviedb.org', params: { "api_key": ENV['mdb_key'], "language": 'en-US' })
  end

  def self.parse(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
