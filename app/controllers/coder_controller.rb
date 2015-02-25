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
      puts 'Exception at github starts * ' + e.message + '*' + e.backtrace.join("\n").to_s + ' for git user ' + @github_user_name + ' * end up here'
      flash.now[:error] = "data not found."
      raise CustomExceptions::HandleIfError
    end
  end

  def sof_consumer
    begin
      sof_content_processor
      sof_pdf_responder
    rescue Exception =>e
      puts 'Exception at SOF starts * ' + e.message + '*' + e.backtrace.join("\n").to_s + ' for sof id ' + @user_id + ' * end up here'
      flash.now[:error] = "data not found."
      raise CustomExceptions::HandleIfError
    end
  end

  def blog_consumer
    begin
      gblogger_content_processor
      blog_pdf_responder
    rescue Exception =>e
      puts 'Exception at gblog starts * ' + e.message + '*' + e.backtrace.join("\n").to_s + ' for blog id ' + @blogger_id + ' * end up here'
      flash.now[:error] = "data not found."
      raise CustomExceptions::HandleIfError
    end
  end

  def bit_b_consumer
    begin
      bit_b_content_processor
      bit_b_pdf_responder
    rescue Exception =>e
      puts 'Exception at bitbucket starts * ' + e.message + '*' + e.backtrace.join("\n").to_s + ' for bitbucket user ' + @bit_b_name + ' * end up here'
      flash.now[:error] = "data not found."
      raise CustomExceptions::HandleIfError
    end
  end

  def programmers_consumer
    begin
      prog_content_processor
      prog_pdf_responder
    rescue Exception =>e
      puts 'Exception at programmers starts * ' + e.message + '*' + e.backtrace.join("\n").to_s + ' for prog user ' + "#{@user_id}" + ' * end up here'
      flash.now[:error] = "data not found."
      raise CustomExceptions::HandleIfError
    end
  end

  def linked_in_consumer
    begin
      lin_pdf_responder
    rescue Exception =>e
      puts 'Exception at lin starts * ' + e.message + '*' + e.backtrace.join("\n").to_s + ' for linkedin url ' + "#{@github_user_name}" + ' * end up here'
      flash.now[:error] = "data not found."
      raise CustomExceptions::HandleIfError
    end
  end
end
