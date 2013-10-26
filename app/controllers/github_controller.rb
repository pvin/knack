class GithubController < ApplicationController

  def index
    github = Github.new :client_id => "", :client_secret => ""
    puts '**************************8'
    puts github.repos.commits.all 'fdv', 'publify'
    puts '*******************************'
  end

end
