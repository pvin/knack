require './lib/custom_exceptions/handle_if_error'
class ApplicationController < ActionController::Base
  include CustomExceptions
  protect_from_forgery

  before_filter :set_no_cache

  def after_sign_in_path_for(resource)
    sign_in_url = "http://knack-codebeats.herokuapp.com/direction/redirect"
    #sign_in_url = "/direction/redirect"
  end

  def set_no_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end


end
