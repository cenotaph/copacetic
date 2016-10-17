class DirectorsDvd  < ActiveRecord::Base
    belongs_to :director
    belongs_to :dvd
end