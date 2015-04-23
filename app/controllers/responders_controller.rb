class RespondersController < ApplicationController
  before_action :set_responder, only: [:show, :edit, :update]
  rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameters

  # GET /responders
  # GET /responders.json
  def index
    @responders = Responder.all
    if @responders.nil?
      render :nothing => true, status: :not_found
    end
  end

  # GET /responders/1
  # GET /responders/1.json
  def show
    if @responder.nil?
      render :nothing => true, status: :not_found
    end
  end
  
  # POST /responders
  # POST /responders.json
  def create
    @responder = Responder.new(responder_params)

    respond_to do |format|
      if @responder.save
        format.html { redirect_to @responder, notice: 'Responder was successfully created.' }
        format.json { render :show, status: :created, location: @responder }
      else
        format.html { render :new }
        format.json { render json: {message: @responder.errors}, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /responders/1
  # PATCH/PUT /responders/1.json
  def update
    respond_to do |format|
      if @responder.update(responder_params)
        format.html { redirect_to @responder, notice: 'Responder was successfully updated.' }
        format.json { render :show, status: :ok, location: @responder }
      else
        format.html { render :edit }
        format.json { render json: @responder.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_responder
      @responder = Responder.find_by(name: params[:name])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def responder_params
      params.require(:responder).permit(:type, :name, :capacity)
    end

    def unpermitted_parameters(error)
      render json: {message: error.message}, status: :unprocessable_entity
    end


end
