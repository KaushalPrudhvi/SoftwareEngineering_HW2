class Movie < ActiveRecord::Base
    
    def self.movieRatings
        return self.pluck(:rating).uniq
    end
end
