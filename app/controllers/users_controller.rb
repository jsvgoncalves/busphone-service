require 'securerandom'
class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotUnique, :with => :record_not_unique

  before_action :set_user, only: [:show, :edit, :update, :destroy]


  # GET /info
  def info
    render json: {
      :t1 => 1,
      :t2 => 1.5,
      :t3 => 2,
      :promo => 10
    }
  end

  # GET /login/:email/:pw
  def login
    @conditions = {:email => params[:email],:pw => params[:pw]}
    @user = User.find(:first, :conditions => @conditions)

    # Checks if a username/pw combination exists
    if !@user
      render json: {
        :status => 1,
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
        :status => 0,
        :token => @user.token,
        :expirationDate => @user.expirationDate.to_formatted_s(:db) ,
        :user_id => @user.id
      }
    else
      render json: {
        :status => 1,
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

    render json: {
      :status => 0,
      :msg => :ok}
  end


  # Gets all the tickets from a given user
  # GET /users/:id/tickets
  def getUserTickets
    @user = User.find(params[:id])
    render json: @user.tickets
  end

  def getUsedTickets
    @used_tickets = UsedTicket.where(user_id: params[:id]).limit(10).order(date_used: :desc)
    render json: @used_tickets
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


  # get bus/validate/:bus_id/:ticket_id/:user_id
  def useTicket
    @user = User.find_by_id(params[:user_id])

    if !@user
      render :json => { :msg => 'User not found.', :error => '1'}
      return
    end

    @ticket = Ticket.where(uuid: params[:ticket_id]).first
    if !@ticket
      render :json => { :msg => 'Ticket not found.', :error => '3'}
      return
    end

    if @user.id == @ticket.user_id

      @used_ticket = UsedTicket.new()
      @used_ticket.bus_id = params[:bus_id]
      @used_ticket.ticket_type = @ticket.ticket_type
      @used_ticket.user_id = @ticket.user_id
      @used_ticket.uuid = @ticket.uuid
      @used_ticket.date_used = DateTime.now.to_formatted_s(:db) # => "2007-01-18 06:10:17"

      if !@used_ticket.save()
        format.json { render json: @used_ticket.errors, status: :unprocessable_entity }
      end

      if !@ticket.destroy()
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
      
      render :json => { :msg => "Ticket used", :id => @used_ticket.id}
    else 
      render :json => 
        {
          :msg => 'this user has no access to that ticket',
          :user => params[:user_id],
          :ticket => params[:ticket_id],
          :error => '4'
        }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    # @tickets = @user.tickets
    @conditions = {user_id: @user.id, ticket_type: 1}
    @t1 = Ticket.find(:all, :conditions => @conditions, :limit => 10)
    @conditions = {user_id: @user.id, ticket_type: 2}
    @t2 = Ticket.find(:all, :conditions => @conditions, :limit => 10)
    @conditions = {user_id: @user.id, ticket_type: 3}
    @t3 = Ticket.find(:all, :conditions => @conditions, :limit => 10)
    render :json => 
      {
        :status => 0,
        :user => {
          :id => @user.id,
          :name => @user.name,
          :email => @user.email,
          :tickets => {
            :t1 => @t1,
            :t2 => @t2,
            :t3 => @t3
          }
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
      render :json => { :status => 0 }
    else
      render :json => { :status => 1, :msg => @user.errors}
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
          :status => 2,
          :msg => 'email already exists'
        }
      true
    end
end
