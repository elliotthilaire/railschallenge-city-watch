class RespondersController < ApplicationController
  before_action :set_responder, only: [:show, :update]

  # GET /responders
  def index
    # GET /responders/?show=capacity
    if params[:show] == 'capacity'
      @capacity_report = CapacityReport.generate
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

  def set_responder
    @responder = Responder.find_by(name: params[:name])
  end

  def create_responder_params
    params.require(:responder).permit(:type, :name, :capacity)
  end

  def update_responder_params
    params.require(:responder).permit(:on_duty)
  end
end
