class ApplicationController < ActionController::Base

	# raise an error when extra parameters are sent
	ActionController::Parameters.action_on_unpermitted_parameters = :raise

end
