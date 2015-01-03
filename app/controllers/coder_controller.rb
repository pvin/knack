require './lib/pdf_generator/pdf_generator.rb'
require './lib/content_generator/content_generator'


class CoderController < ApplicationController

  include HTTParty
  include PdfGenerator
  include ContentGenerator

  before_filter :authenticate_user!

  rescue_from CustomExceptions::HandleIfError, with: :getoption

  def getoption
    render 'getoption.html.erb'
  end

  def git_consumer
    begin
      git_content_processor
      git_pdf_responder
    rescue Exception =>e
      puts 'Exception at github starts * ' + e.message + ' for git user ' + "#{@github_user_name}" + ' * end up here'
      flash[:error] = "data not found."
      raise CustomExceptions::HandleIfError
    end
  end

  def sof_consumer
    begin
      sof_content_processor
      sof_pdf_responder
    rescue Exception =>e
      puts 'Exception at SOF starts * ' + e.message + ' for sof id ' + "#{@user_id}" + ' * end up here'
      flash[:error] = "data not found."
      raise CustomExceptions::HandleIfError
    end
  end

  def blog_consumer
    begin
      gblogger_content_processor
      blog_pdf_responder
    rescue Exception =>e
      puts 'Exception at gblog starts * ' + e.message + ' for blog id ' + "#{@blogger_id}" + ' * end up here'
      flash[:error] = "data not found."
      raise CustomExceptions::HandleIfError
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
    begin
      lin_pdf_responder
    rescue Exception =>e
      puts 'Exception at lin starts * ' + e.message + ' for linkedin url ' + "#{@github_user_name}" + ' * end up here'
      flash[:error] = "data not found."
      raise CustomExceptions::HandleIfError
    end
  end
end
