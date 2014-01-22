require 'net/http'

class GbloggerController < ApplicationController

  def consumer
    response = HTTParty.get('https://www.googleapis.com/blogger/v3/blogs/3891960319537892971/posts?key=***')
    puts '-----------------'
    puts response.body
    puts '-----------------'


  end
end