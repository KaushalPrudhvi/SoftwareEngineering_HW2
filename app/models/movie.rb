class Movie < ActiveRecord::Base
    
    def self.movieRatings
        return Array.new(['G','PG','PG-13','R'])
    end
end
