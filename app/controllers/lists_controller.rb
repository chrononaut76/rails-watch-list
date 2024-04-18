class ListsController < ApplicationController
  def index
    @lists = Lists.all
  end
end
