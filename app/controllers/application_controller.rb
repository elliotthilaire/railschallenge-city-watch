class ApplicationController < ActionController::Base

	# raise an error when extra parameters are sent
	ActionController::Parameters.action_on_unpermitted_parameters = :raise

    rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameters


	def not_found
      render json: {message: 'page not found'}, status: :not_found
    end

    def unpermitted_parameters(error)
      render json: {message: error.message}, status: :unprocessable_entity
    end

end
