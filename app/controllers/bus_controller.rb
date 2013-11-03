class BusController < ApplicationController

  def lines

  end

  def login

  end

  def validate

  end

  def create

    @bus = Bus.new(bus_params)
    bus_plate = params[:bus_plate]
    bus_id = @bus[:id]

    respond_to do |format|
      if @bus.save
        format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
        format.json { render action: 'show', status: :created, id: bus_id, plate: bus_plate }
      else
        format.html { render action: 'new' }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  def all_tickets

  end

  def bus_params
      params.permit(:bus_plate)
    end

end

