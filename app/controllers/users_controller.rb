class UsersController < ApplicationController

  get "/signup" do
    erb :'/users/create_user'
  end

  get '/show' do
    @user = User.last
    erb :'/users/show'
  end

  post '/signup' do
    @user = User.new(username: params[:username], email: params[:email], password: params[:password])
    @user.save
    redirect to '/show'
  end




end
