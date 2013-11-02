require 'securerandom'
class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotUnique, :with => :record_not_unique

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
    nt1 = Integer(params[:nt1])
    nt2 = Integer(params[:nt2])
    nt3 = Integer(params[:nt3])

    # Checks if the user deserves a free ticket
    promo = (nt1 + nt2 + nt3) >= 10? 1 : 0;

    ActiveRecord::Base.transaction do
      # type 1 tickets with promotion
      (nt1 + promo).times do
        Ticket.create(
          ticket_type: 1,
          uuid: SecureRandom.uuid,
          user_id: params[:id])
      end

      #type 2 tickets
      nt2.times do
        Ticket.create(
          ticket_type: 2,
          uuid: SecureRandom.uuid,
          user_id: params[:id])
      end

      #type 3 tickets
      nt3.times do
        Ticket.create(
          ticket_type: 3,
          uuid: SecureRandom.uuid,
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

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      render :json => { status: :created, 
        #user: @user,
        :code => 1 }
    else
      render :json => { :msg => @user.errors, status: :unprocessable_entity }
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
      params.permit(:name, :email, :pw)
    end

    def record_not_unique
      # $! is the error
      render :json =>
        {
          :error => {
            :msg => 'email already exists', :code => '3' }
        }
      true
    end
end
