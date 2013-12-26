require 'prawn'

class SofController < ApplicationController
  include HTTParty
  base_uri "http://api.stackoverflow.com/1.1"

  def consumer

  end


  def consumer1
    @firstname = request["firstName"]
    @response = self.class.get("/users/#{@firstname}")
    respond_to do |format|
      format.html
      format.pdf do
        pdf = Prawn::Document.new
        pdf.text "#{@response}"
        send_data pdf.render, type: "application/pdf", disposition: "inline"
      end
    end
  end

end
