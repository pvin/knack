require './lib/pdf_generator/pdf_generator.rb'
require './lib/content_generator/content_generator'

class AdminsController < ApplicationController
  include HTTParty
  include PdfGenerator
  include ContentGenerator
  before_filter :authenticate_user!

  rescue_from CustomExceptions::HandleIfError, with: :getoption

  def getoption
    render 'getoption.html.erb'
  end

  def server_fault_consumer
    begin
      server_f_content_processor
      server_f_pdf_responder
    rescue Exception =>e
      puts 'Exception at ServerFaul starts * ' + e.message + '*' + e.backtrace.join("\n").to_s + ' for ServerFaul id ' + @user_id + ' * end up here'
      flash.now[:error] = "data not found."
      raise CustomExceptions::HandleIfError
    end
  end

  def super_user_consumer
    begin
      super_u_content_processor
      super_u_pdf_responder
    rescue Exception =>e
      puts 'Exception at SuperUser starts * ' + e.message + '*' + e.backtrace.join("\n").to_s + ' for SuperUser id ' + @user_id + ' * end up here'
      flash.now[:error] = "data not found."
      raise CustomExceptions::HandleIfError
    end
  end

  def ask_ubuntu_consumer
    begin
      ask_u_content_processor
      ask_u_pdf_responder
    rescue Exception =>e
      puts 'Exception at AskUbuntu starts * ' + e.message + '*' + e.backtrace.join("\n").to_s + ' for AskUbuntu id ' + @user_id + ' * end up here'
      flash.now[:error] = "data not found."
      raise CustomExceptions::HandleIfError
    end
  end
end
