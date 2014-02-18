class ItemsController < ApplicationController

  before_filter :authorize_admin!

end
