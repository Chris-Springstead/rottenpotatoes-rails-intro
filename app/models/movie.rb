class Movie < ActiveRecord::Base
    
    def self.with_ratings(supp_rating)
        Movie.where(:rating => supp_rating)
    end 
    
end
