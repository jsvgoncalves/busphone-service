class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

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
