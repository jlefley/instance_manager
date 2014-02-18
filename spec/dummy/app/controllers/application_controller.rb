class ApplicationController < ActionController::Base
  protect_from_forgery

  respond_to :json, :html

  before_filter :authenticate_private_instance_user!
end
