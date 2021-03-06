class EmergenciesController < ApplicationController
  before_action :set_emergency, only: [:show, :update]

  # GET /emergencies
  def index
    @emergencies = Emergency.all
    @response_report = ResponseReport.generate
  end

  # GET /emergencies/E-00000001
  def show
    render nothing: true, status: :not_found if @emergency.nil?
  end

  # POST /emergencies
  def create
    @emergency = Emergency.new(create_emergency_params)
    if @emergency.save
      DispatchRouter.notify_new(@emergency)
      render :show, status: :created, location: @emergency
    else
      render json: { message: @emergency.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /emergencies/E-00000001
  def update
    if @emergency.update(update_emergency_params)
      DispatchRouter.notify_update(@emergency)
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
end
