require 'rack-flash'

class UsersController < ApplicationController
  use Rack::Flash

  get '/signup' do
    if logged_in?
      redirect to '/show'
    else
      erb :'/users/create_user'
    end
  end

  get '/show' do
    @user = User.find_by(id: session[:user_id])
    erb :'/users/show'
  end

  get '/login' do
    if logged_in?
      redirect to '/show'
    else
      erb :'/users/login'
    end
  end

  get '/logout' do
    session.clear
    redirect to "/"
  end

  post '/signup' do
    if params[:username].empty? || params[:email].empty? || params[:password].empty?
      flash[:message] = "Username, email, or password cannot be empty"
      redirect to '/signup'
    else
      # User.find_by(username: fsfsd) || ...
      User.all.each do |user|
        if user.username == (params[:username]) || user.email == params[:email]
          flash[:message] = "Username or Email already taken"
          redirect to '/signup'
        end
      end
      @user = User.new(username: params[:username], email: params[:email], password: params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect to '/show'
    end
  end

  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to "/show"
    else
      flash[:message] = "incorrect username or password"
      redirect to "/login"
    end
  end
end
