class Web::Superadmin::AdministratorsController < ApplicationController
  layout "superadmin_layout"

  def index
    @administrators = Admin.all
  end
end
