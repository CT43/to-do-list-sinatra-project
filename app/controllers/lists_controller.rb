class ListsController < ApplicationController

  get '/create_list' do
    erb :'/lists/create_list'
  end

  post '/list' do
    @list = List.new(name: params[:name])
    @list.user_id = session[:user_id]
    @list.save
    binding.pry

    ##iterate over task[name] to create all isntance of tasks
    @tasks = params[:task][:name]
    @tasks.each do |task|
      @task = Task.new(name: task)
      @task.list_id = @list.id
      @task.save
    end
    binding.pry
    redirect to '/show'
  end

  get '/lists/:id' do
    @list = List.find_by(id: params[:id])
    erb :'lists/show_list'
  end
end
