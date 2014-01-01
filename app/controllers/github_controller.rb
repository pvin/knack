class GithubController < ApplicationController

  def cosumers

  end

  def consumer1
    #github = Github.new :client_id => "4c21444eb7ecee26f806", :client_secret => "0bddb2dc36faba30a2ffc93241358ebcdc7682cf"
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
