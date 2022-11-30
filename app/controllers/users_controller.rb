class UsersController < ApplicationController
    skip_before_action :authorized, only: :create

    def create
        new_user = User.create(user_params)
        if new_user.valid?
            session[:user_id] = new_user.id
            render json: new_user,status: :created
        else
            render json: { error: "Invalid username or password" },status: :unprocessable_entity
        end
    end

    def show
        user = User.find_by(id: session[:user_id])
        if user
            render json: user
        else
            render json: { error: "Not authorized" }, status: :unauthorized
        end

    end

    private
    def user_params
        params.permit(:username, :password, :password_confirmation)
    end
end
