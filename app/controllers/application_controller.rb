class ApplicationController < ActionController::Base
  # Raise an error when extra parameters are received and handle it here.
  ActionController::Parameters.action_on_unpermitted_parameters = :raise
  rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameters

  def unpermitted_parameters(error)
    render json: { message: error.message }, status: :unprocessable_entity
  end

  def not_found
    # FIXME: Work out how to use public 404.json.
    render json: { message: 'page not found' }, status: :not_found
  end
end
