class UsedTicket < ActiveRecord::Base
	belongs_to :user
	belongs_to :bus
end
