class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)

    sign_in_url = "http://localhost:3000/loginhome/getoption"

  end

end
