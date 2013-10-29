class User < ActiveRecord::Base
	has_many :tickets, order: 'ticket_type DESC'

end
