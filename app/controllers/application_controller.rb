class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  before_action :require_login
  skip_before_action :require_login, only: [:new, :create, :login, :info, :all_lines, :useTicket, :all_tickets, :types]

  
  def require_login
    @user = User.find(params[:id])

    # Get the user token
    if @user and (params[:token] == @user.token)
      # Check for expiration date
      if @user.expirationDate < DateTime.now.to_time
        render json: {
          :status => 1,
          :msg => 'token expired.'
        }
      end
    else
      render json: {
        :status => 2,
        :msg => 'invalid token.'
      }
    end
    true
  end

  def record_not_found
    # $! is the error
    render :json =>
      {
        :error => {
          :msg => 'record not found', :code => '2' }
      }
    true
  end
end
