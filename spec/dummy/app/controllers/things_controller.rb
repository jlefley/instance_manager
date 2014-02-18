class ThingsController < ApplicationController

  before_filter :authenticate_public_instance_user!

  def index
    @things = Thing.all
  end

end
