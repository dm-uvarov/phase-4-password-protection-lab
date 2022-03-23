class UsersController < ApplicationController
    before_action :authorize ,except: :create


    def index
        users = User.all
        render json: users
    end

    #create new user - sign up
    def create
        user = User.create(user_params)
        
        #byebug

        if user.valid? 
            # byebug
            session[:user_id] = user.id
            render json: user, status: :created
        else 
            render json:{errors: user.errors.full_messages}, status: :unprocessable_entity
        end
    end

    #show current user
    def show #
        user  = User.find_by(id: session[:user_id])
        render json: user
    end

    private
    def user_params
        params.permit(:username, :password, :password_confirmation)
    end

    def authorize
        return render json: {error: "Not authorized"},status: :unauthorized unless session.include? :user_id
    end

end
