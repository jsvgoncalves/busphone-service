require 'securerandom'
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  # GET /login/:email/:pw
  def login
    @conditions = {:email => params[:email],:pw => params[:pw]}
    @user = User.find(:first, :conditions => @conditions)

    # Checks if a username/pw combination exists
    if !@user
      render json: {
        :status => :failed,
        :msg => 'invalid username or password'
      }
      return
    end

    # Generate a new token and set expiration date
    #token = SecureRandom.hex
    @user.token = SecureRandom.urlsafe_base64(20)
    @user.expirationDate = DateTime.now.tomorrow.to_time
    
    if @user.save
      render json: {
        :status => :ok,
        :token => @user.token,
        :expirationDate => @user.expirationDate,
        :user_id => @user.id
      }
    else
      render json: {
        :status => :failed,
        :msg => 'something went wrong'
      }
    end
  end
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # Buy tickets of a given type
  # GET /users/:id/buy/:ticket_type/:amount
  def buyTickets
    ActiveRecord::Base.transaction do
      Integer(params[:amount]).times do
        Ticket.create(
          ticket_type: params[:ticket_type],
          uuid: 'n/a', # !TODO : generate an uuid
          user_id: params[:id])
      end
    end

    render json: {:msg => :ok}
  end


  # Gets all the tickets from a given user
  # GET /users/:id/tickets
  def getUserTickets
    @user = User.find(params[:id])
    render json: @user.tickets
  end


  # Gets all the tickets of a given type from a given user
  # GET /users/:id/tickets/:ticket_type
  def getUserTicketsByType
    @conditions = {user_id: params[:id], ticket_type: params[:ticket_type]}
    @tickets = Ticket.find(:all, :conditions => @conditions)

    # Handle empty results
    if @tickets.empty?
      raise(ActiveRecord::RecordNotFound)
    end

    render json: @tickets
  end

  def useTicket
    @user = User.find(params[:id])

    @ticket = Ticket.find(params[:ticket])
    if @user.id == @ticket.user_id
      render :json => { :msg => 'not implemented yet. thank you come again.'}
    else 
      render :json => 
        {
          :msg => 'this user has no access to that ticket',
          :user => params[:id],
          :ticket => params[:ticket],
          :error => '3'
        }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @tickets = @user.tickets
    render :json => 
      {
        :user => {
          :id => @user.id,
          :name => @user.name,
          :email => @user.email,
          :tickets => @tickets
        }
      }
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email)
    end
end
