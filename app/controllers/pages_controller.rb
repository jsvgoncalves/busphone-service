class PagesController < ApplicationController
	def index
		@message = ['msg' => 'Nothing to see here.']
	    respond_to do |format|
	      format.json { render json: @message }
	    end
	end
end
