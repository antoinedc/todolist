
class ApplicationController < ActionController::Base
  protect_from_forgery :with => :null_session

  protected
  def authenticate
  	authenticate_or_request_with_http_token do |token, options|
  		if ApiKey.exists?(:access_token => token)
    		api_key = ApiKey.find_by_access_token(token)
    		@current_user = api_key.user
    	else
    		head(:unauthorized) unless @current_user
    	end
  	end
  end
end
