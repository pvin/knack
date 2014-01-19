require 'net/http'

class GbloggerController < ApplicationController

  def consumer
    response = HTTParty.get('https://www.googleapis.com/blogger/v3/blogs/3891960319537892971/posts?key=AIzaSyCmyA7TS_PMW-E42L4Fg75Lz5RZpaSpA5A')
    puts '-----------------'
    puts response.body
    puts '-----------------'


  end
end