class HomeController < ApplicationController
  def index
    @ompany = current_user.company
  end
end
