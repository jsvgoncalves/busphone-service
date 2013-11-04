class BusController < ApplicationController

  def all_lines
    lines = BusLine.find(:all)
    render :json => {
      :lines => lines
    }
  end

  def login

  end

  def validate

  end

  def create
    @bus_line = BusLine.new(bus_line_params)

    #respond_to do |format|
    if @bus_line.save
        ## format.html { redirect_to @bus_line, notice: 'Ticket was successfully created.' }
        ## format.json { render action: 'show', status: :created, line: bus_line_params[:line_number] }
        lines = BusLine.find(:all)
        render :json => {
          :line => bus_line_params[:line_number],
          :lines => lines
        }
      else
        format.html { render action: 'new' }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    #end
  end

  # all tickets from a bus used in the last hour/half hour/15 min
  # get 'bus/b/:line_number/'
  def all_tickets
    @bus = Bus.find_by_id(params[:bus_id])
    if !@bus
      render :json => { :msg => 'Bus not found.', :error => '1'}
      return
    end

    @used_tickets = UsedTicket.where(bus_id: @bus.id)
    if !@used_tickets
      render :json => { :msg => 'No Tickets found.', :error => '2'}
    else 
      render :json => {
        :used_tickets => @used_tickets
      }
    end
  end

  def bus_line_params
    params.permit(:line_number)
  end

end

