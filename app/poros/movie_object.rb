class MovieObject
  attr_reader :description,
              :id,
              :title,
              :vote_count,
              :vote_average,
              :runtime_minutes,
              :cast,
              :reviews,
              :poster_path

  def initialize(results)
    @description = results[:description]
    @id = results[:id]
    @title = results[:title]
    @vote_count = results[:vote_count]
    @vote_average = results[:vote_average]
    @runtime_minutes = results[:runtime]
    @cast = results[:cast]
    @reviews = results[:reviews]
    @genres = results[:genres]
    @poster_path = results[:poster]
  end

  def runtime
    time_conversion(@runtime_minutes)
  end

  def genres
    if !@genres.empty?
      @genres.map do |genre|
        genre[:name]
      end
    else
      ["N/A"]
    end
  end

  def review_authors
    reviews_array = []
    @reviews.map do |review|
      review_hash = Hash.new
      review_hash[:name] = review[:author]
      review_hash[:content] = review[:content]
      reviews_array << review_hash
    end
    reviews_array
  end

  def first_10_cast_members
    credits_array = []
    @cast.map do |actor|
      credits_hash = Hash.new
      credits_hash[:actor] = actor[:name]
      credits_hash[:character] = actor[:character]
      credits_array << credits_hash
    end
    credits_array.first(10)
  end

  def time_conversion(minutes)
    hours = minutes / 60
    rest = minutes % 60
    "#{hours}:#{sprintf '%02d', rest}"
  end
end
