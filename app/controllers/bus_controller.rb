class BusController < ApplicationController

  def all_lines
    lines = BusLine.find(:all)
    render :json => {
      :status => 0,
      :lines => lines
    }
  end

  # get 'bus/login/:bus_id/:line'
  def login
    @bus = Bus.find_by_id(params[:bus_id])
    if !@bus
      @bus = Bus.new()
    end

    @bus_line = BusLine.where(line_number: params[:line]).first
    if !@bus_line
      # If the @bus_line was not found, just create it, for simplicity's sake
      @bus_line = BusLine.new(params[:line])
    end

    @bus.bus_line_id = @bus_line.id
    @bus.save
    render :json => {
        :status => 0,
        :msg => "Bus updated",
        :bus_id => @bus.id,
        :bus_line_id => @bus.bus_line_id,
        :line_number => @bus_line.line_number
      }
  end

  def create
    @bus_line = BusLine.new(bus_line_params)
    if @bus_line.save
      lines = BusLine.find(:all)
      render :json => {
        :status => 0,
        :line => bus_line_params[:line_number],
        :lines => lines
      }
    else
      format.html { render action: 'new' }
      format.json { render json: @ticket.errors, status: :unprocessable_entity }
    end
  end

  # all tickets from a bus used in the last hour/half hour/15 min
  # get 'bus/b/:line_number/'
  def all_tickets
    @bus = Bus.find_by_id(params[:bus_id])
    if !@bus
      render :json => { :msg => 'Bus not found.', :status => '1'}
      return
    end

    @used_tickets = UsedTicket.where(bus_id: @bus.id)
    if !@used_tickets
      render :json => { :msg => 'No Tickets found.', :status => '2'}
    else 
      render :json => {
        :status => 0,
        :used_tickets => @used_tickets
      }
    end
  end

  def bus_line_params
    params.permit(:line_number)
  end

end

