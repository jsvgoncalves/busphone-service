class PagesController < ApplicationController
  def index
    @message = ['msg' => 'Nothing to see here.']
    render json: @message
  end
end
