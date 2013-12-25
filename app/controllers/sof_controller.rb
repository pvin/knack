
class SofController < ApplicationController
  include HTTParty
  base_uri "http://api.stackoverflow.com/1.1"

  def consumer

  end


  def consumer1
    @firstname = request["firstName"]


    puts @firstname

     puts '^^^^^^^^^^^^^^^^^^^^^^^^'
    response = self.class.get("/users/#{@firstname}")
    puts '++++++++++++'
    puts response  #response["users"][0]["badge_counts"]["gold"]
    puts '++++++++++++++'

    Prawn::Document.generate("hello.pdf") do
      text "#{response}"
    end

  end

end
