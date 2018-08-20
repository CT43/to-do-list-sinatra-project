class UsersController < ApplicationController

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

  post '/signup' do
    if params[:username].empty? || params[:email].empty? || params[:password].empty?
      redirect to '/signup'
    else
      @user = User.new(username: params[:username], email: params[:email], password: params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect to '/show'
    end
  end




end
