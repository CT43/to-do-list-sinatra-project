require 'rack-flash'

class ListsController < ApplicationController
  use Rack::Flash

  get '/create_list' do
    if logged_in?
      erb :'/lists/create_list'
    else
      redirect to '/login'
    end
  end

  post '/list' do
    @list = List.new(name: params[:name].to_s)
    @list.user_id = session[:user_id]
    @list.save

    ##iterate over task[name] to create all instances of tasks
    @tasks = params[:task][:name]
    @tasks = @tasks.reject { |c| c.empty? }
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

  get '/task/:id/edit' do
    @task = Task.find_by(id: params[:id])
    erb :'/lists/edit_list'
  end

  patch '/tasks/:id' do
      @task = Task.find_by(id: params[:id])
      if params[:name].empty?
        flash[:message] = "Task cannot be nameless, if you wish to delete the task, check it off in the list view"
        redirect to "/task/#{@task.id}/edit"
      else
        if @task.user == current_user
          @task.name = (params[:name])
          @task.save
          redirect to "/lists/#{@task.list_id}"
        end
      redirect to "/lists/#{@task.list_id}"
    end
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
      if @list.user == current_user
        @list.delete
      end
        redirect to '/show'
    else
      redirect to '/login'
    end
  end
end
