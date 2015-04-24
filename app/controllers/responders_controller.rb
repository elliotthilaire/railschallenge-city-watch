class RespondersController < ApplicationController
  before_action :set_responder, only: [:show, :edit, :update]

  # GET /responders
  def index
    if params[:show] == 'capacity'

      #############  This needs help. yikes. 
      @capacity_report = {}
      types = Responder.uniq.pluck(:type)
      types.each do |type|
        @capacity_report[type] = [
          Responder.by_type(type).sum(:capacity),
          Responder.by_type(type).available.sum(:capacity),
          Responder.by_type(type).on_duty.sum(:capacity),
          Responder.by_type(type).ready_for_dispatch.sum(:capacity)
        ]
      end
      #############

      render json: { capacity: @capacity_report } 
    end

    @responders = Responder.all
    render nothing: true, status: :not_found if @responders.nil?
  end

  # GET /responders/F-100
  def show
    render nothing: true, status: :not_found if @responder.nil?
  end

  # POST /responders/
  def create
    @responder = Responder.new(create_responder_params)

    if @responder.save
      render :show, status: :created, location: @responder
    else
      render json: { message: @responder.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /responders/F-100
  def update
    if @responder.update(update_responder_params)
      render :show, status: :ok, location: @responder
    else
      render json: @responder.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_responder
    @responder = Responder.find_by(name: params[:name])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def create_responder_params
    params.require(:responder).permit(:type, :name, :capacity)
  end

  def update_responder_params
    params.require(:responder).permit(:on_duty)
  end
end
