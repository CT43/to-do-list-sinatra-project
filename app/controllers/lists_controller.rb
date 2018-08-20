class ListsController < ApplicationController

  get '/create_list' do
    erb :'/lists/create_list'
  end

end
