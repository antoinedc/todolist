module Api
  module V1
    class UsersController < ApplicationController
      require 'bcrypt'

      respond_to :json
      before_filter :authenticate, :only => [:show]

      def show
      	return head(:unauthorized) unless @current_user
      	user = @current_user
      	return render :json => {:id => user.id, :username => user.username, :api_key => user.api_key.access_token}
      end

      def create
      	if params[:username] && params[:password] && params[:password_confirmation]
      		if params[:password] != params[:password_confirmation]
      			return render :json => {:code => 0, :message => "Passwords mismatch."}
      		end

      		user = User.new
      		user.username = params[:username]
      		user.password = BCrypt::Password.create(params[:password])
      		if user.save
      			@current_user = user
      			return render :json => {:code => 1, :token => user.api_key.access_token}
      		else
      			return render :json => {:code => 0, :message => "Error while creating account"}
      		end
      	else
      		render :json => {:code => 0, :message => "Wrong parameters."}
      	end
      end

      def login
      	if params[:username] && params[:password]
      		begin
      			user = User.find_by_username(params[:username])
      			if user && BCrypt::Password.new(user.password).is_password?(params[:password])
      				return render :json => {:code => 1, :token => user.api_key.access_token}
      			else
      				return render :json => {:code => 0, :message => "Wrong username or password."}
      			end
      		rescue ActiveRecord::RecordNotFound => e
      			return render :json => {:code => 0, :message => "Wrong username or password."}
      		end
      	else
      		render :json => {:code => 0, :message => "Wrong parameters."}
      	end
      end

    end
  end
end