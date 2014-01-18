class GithubController < ApplicationController

  def cosumers

  end

  def consumer1
    #github = Github.new :client_id => "******", :client_secret => "************"
    #puts '**************************8'
    #puts github.repos.commits.all 'fdv', 'publify'
    #puts '*******************************'

    @firstname = request["userName"]
    @hash_values=Github.repos.list user: "#{@firstname}"
    puts '============================'
    puts     @hash_values
    puts '============================'
  end

end
