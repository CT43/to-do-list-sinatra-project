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

  patch '/lists/:id/edit' do
    @list = List.find_by(id: params[:id])
    #binding.pry
    @completed_tasks = params[:list][:task_ids]
    @completed_tasks.each do |task|
      @task = Task.find_by(id: task)
      @task.destroy
    end
    redirect to "/lists/#{@list.id}"
  end

  delete '/lists/:id/delete' do
    if logged_in?
      @list = List.find_by(id: params[:id])
      if @list && @list.user == current_user
        @list.delete
      end
        redirect to '/show'
    else
      redirect to '/login'
    end
  end
end
