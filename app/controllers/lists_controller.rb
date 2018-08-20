class ListsController < ApplicationController

  get '/create_list' do
    erb :'/lists/create_list'
  end

  post '/list' do
    @list = List.new(name: params[:name])
    @list.save

    ##iterate over task[name] to create all isntance of tasks
    @tasks = params[:task[name]]
    @tasks.each do |task|
      @task = Task.new(name: params[:task[name]], list_id: @list.id)
      @task.save
    end
  end
end
