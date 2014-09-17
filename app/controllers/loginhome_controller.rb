#require "net/https"
#require "uri"
# require 'prawn'
# require 'gchart'
# require 'open-uri'
require './lib/pdf_generator/pdf_generator.rb'
require './lib/content_generator/content_generator'

class LoginhomeController < ApplicationController

  include HTTParty
  include PdfGenerator
  include ContentGenerator

  def getoption

  end

  def sof_consumer
    sof_content_processor
    respond_to do |format|
      format.pdf do
        sof_pdf_responder
      end
    end

  end

  def git_consumer

    @github_user_name = request["name"]

    #Retrieving a github details
    @github_details = HTTParty.get("https://api.github.com/users/#{@github_user_name}?client_id=4c21444eb7ecee26f806&client_secret=0bddb2dc36faba30a2ffc93241358ebcdc7682cf",:headers =>{"User-Agent" => "#{@github_user_name}"} )

    #organizations work
    @org_url = @github_details['organizations_url']
    @org_array =  Array.new()
    @org_name_array = Array.new()
    @org_array = HTTParty.get("#{@org_url}"+'?client_id=4c21444eb7ecee26f806&client_secret=0bddb2dc36faba30a2ffc93241358ebcdc7682cf', :headers =>{"User-Agent" => "#{@github_user_name}"})
    if @org_array != nil
      @org_array.each { |name| @org_name_array << name['login']}
    else
      @org_array = nil
    end

    # detailed repo info
    @repo_info_link = @github_details['repos_url']
    @repo_info_array = Array.new()
    @repo_info_array = HTTParty.get("#{@repo_info_link}"+'?client_id=4c21444eb7ecee26f806&client_secret=0bddb2dc36faba30a2ffc93241358ebcdc7682cf',
                                    :headers =>{"User-Agent" => "#{@github_user_name}"})
    @repo_req_info_array = Array.new()
    if @repo_info_array != nil
      @repo_info_array.each { |repo_info| @repo_req_info_array << "repo name : #{repo_info['name']},
                                                                   repo_url : #{repo_info['html_url']},
                                                                   repo description : #{repo_info['description']},
                                                                   forked? : #{repo_info['fork']},
                                                                   Stargazers Count : #{repo_info['stargazers_count']},
                                                                   Watchers Count : #{repo_info['watchers_count']},
                                                                   Forks Count : #{repo_info['forks_count']},
                                                                   Watchers : #{repo_info['watchers']},
                                                                   Language : #{repo_info['language']},
                                                                   Created At : #{repo_info['created_at']},
                                                                   Updated At : #{repo_info['updated_at']},
                                                                   Pushed At :#{repo_info['pushed_at']}"

                              #contributions list
                              @repo_contributor = Array.new()
                              @repo_contributor_details = Array.new()
                              @repo_contributor = HTTParty.get("#{repo_info['contributors_url']}"+
                                                                   '?client_id=4c21444eb7ecee26f806&client_secret=0bddb2dc36faba30a2ffc93241358ebcdc7682cf',
                                                               :headers =>{"User-Agent" => "#{@github_user_name}"})
                              @repo_contributor_count = JSON.parse(@repo_contributor.body).count if @repo_contributor.code == 200
                              @repo_contributor_count = "#{@repo_contributor_count}"+'+' if @repo_contributor_count >=30
                              @repo_req_info_array << "Contributors Count :#{@repo_contributor_count}"

                              #commits details
                              @repo_commits_url_process = repo_info['commits_url'].gsub('{/sha}','')
                              @repo_commits_details = HTTParty.get("#{@repo_commits_url_process}"+
                                                                       '?client_id=4c21444eb7ecee26f806&client_secret=0bddb2dc36faba30a2ffc93241358ebcdc7682cf',
                                                                   :headers =>{"User-Agent" => "#{@github_user_name}"})
                              @repo_commits_count = JSON.parse(@repo_commits_details.body).count
                              @repo_commits_count = "#{@repo_commits_count}"+'+' if @repo_commits_count >=30
                              @repo_req_info_array << "Commits Count :#{@repo_commits_count}"
                             }

    else
      @repo_info_array = nil
    end
    respond_to do |format|
      format.html
      format.pdf do
        git_pdf_responder
      end
     end
  end

  def blog_consumer
    @blogger_id = request["bloggerid"]

    #Retrieving a blog
    @blog_details = HTTParty.get("https://www.googleapis.com/blogger/v3/blogs/#{@blogger_id}?key=AIzaSyCmyA7TS_PMW-E42L4Fg75Lz5RZpaSpA5A")

    #Retrieving posts from a blog
    @post_details = HTTParty.get("https://www.googleapis.com/blogger/v3/blogs/#{@blogger_id}/posts?key=AIzaSyCmyA7TS_PMW-E42L4Fg75Lz5RZpaSpA5A")
    @post_comm_hash = Hash.new()

    if @post_details['items'] != nil
      @post_details['items'].each { |obj| @post_comm_hash["#{obj['title']}"] = ["#{obj['replies']['totalItems']}"] }
    else
      @post_comm_hash = nil
    end

    #Retrieving pages for a blog
    @page_details = HTTParty.get("https://www.googleapis.com/blogger/v3/blogs/#{@blogger_id}/pages?key=AIzaSyCmyA7TS_PMW-E42L4Fg75Lz5RZpaSpA5A")
    @page_array = Array.new()
    if @page_details['items'] != nil
      @page_details['items'].each { |obj| @page_array << obj['title'] }
    else
      @page_array = nil
    end

    respond_to do |format|
      format.html
      format.pdf do
        blog_pdf_responder
      end
    end

  end

  def bit_b_consumer
    @name = request["name"]
    # puts '++++++++++'
    # puts @name
    # puts '++++++++++'
    # response = HTTParty.get("https://bitbucket.org/api/1.0/users/#{@name}")
    # puts '-----------------'
    # puts response.body
    # puts '-----------------'
    #

    respond_to do |format|
      format.html
      format.pdf do
        pdf = Prawn::Document.new
        @logopath = "public/pie-chart-1.png"
        #@user_image = "#{@user_info["items"][0]["profile_image"]}"
        pdf.image @logopath, :width => 197, :height => 120
        #pdf.image open (@user_image)
        pdf.fill_color "0066FF"
        pdf.font_size 42
        pdf.text_box "Knack Reports", :align => :right

        pdf.move_down 20
        pdf.font_size 14
       # pdf.text "Below generated report for Google Blogger user #{@blog_details['name']}"

        pdf.move_down 20
        # to_show = [
        #     #Retrieving a blog
        #     ["Blog Id", "#{@blog_details['id']}"],
        #     ["Blog Name", "#{@blog_details['name']}"],
        #     ["Blog Url", "#{@blog_details['url']}"],
        #     ["Number of Posts", "#{@blog_details['posts']['totalItems']}"],
        #     ["Number of Pages", "#{@blog_details['pages']['totalItems']}"],
        #     ["Language", "#{@blog_details['locale']['language']}"] ,
        #
        #     #Retrieving posts from a blog
        #     ["Title and Comments(last 10 blogs)", "#{@post_comm_hash}"],
        #
        #     #Retrieving pages for a blog
        #     ["Pages", "#{@page_array}"]
        # ]
        # pdf.table(to_show) do |table|
        #   table.rows(1..2).width = 270
        # end

        send_data pdf.render, type: "application/pdf", disposition: "inline"
      end
    end


  end

  def cloud_forge_consumer

  end

  def linked_in_consumer

  end

end
