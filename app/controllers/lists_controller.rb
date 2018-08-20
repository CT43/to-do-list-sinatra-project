class ListsController < ApplicationController

  get '/create_list' do
    if logged_in?
      erb :'/lists/create_list'
    else
      redirect to '/login'
    end
  end

  post '/list' do
    @list = List.new(name: params[:name])
    @list.user_id = session[:user_id]
    @list.save

    ##iterate over task[name] to create all instances of tasks
    binding.pry
    @tasks = params[:task][:name]
    @tasks.reject { |c| c.empty? }
    @tasks.each do |task|
      @task = Task.new(name: task)
      @task.list_id = @list.id
      @task.save
    end

    redirect to '/show'
  end

  get '/lists/:id' do
    @list = List.find_by(id: params[:id])
    erb :'lists/show_list'
  end
end
