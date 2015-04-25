class EmergenciesController < ApplicationController
  before_action :set_emergency, only: [:show, :edit, :update, :destroy]

  # GET /emergencies
  def index
    @emergencies = Emergency.all
  end

  # GET /emergencies/E-00000001
  def show
    render nothing: true, status: :not_found if @emergency.nil?
  end

  # POST /emergencies
  def create
    @emergency = Emergency.new(create_emergency_params)

    if @emergency.save
      DispatchRouter.new(@emergency)
      render :show, status: :created, location: @emergency
    else
      render json: { message: @emergency.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /emergencies/E-00000001
  def update
    if @emergency.update(update_emergency_params)
      free_responders if @emergency.resolved_at
      render :show, status: :ok, location: @emergency
    else
      render json: @emergency.errors, status: :unprocessable_entity
    end
  end

  private

  def set_emergency
    @emergency = Emergency.find_by(code: params[:code])
  end

  def create_emergency_params
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
  end

  def update_emergency_params
    params.require(:emergency).permit(:fire_severity, :police_severity, :medical_severity, :resolved_at)
  end

  def free_responders
    @emergency.responders.each do |responder|
      responder.emergency_code = nil
      responder.save!
    end
  end
end
