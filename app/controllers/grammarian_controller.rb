require './lib/pdf_generator/pdf_generator.rb'
require './lib/content_generator/content_generator'

class GrammarianController < ApplicationController
  include HTTParty
  include PdfGenerator
  include ContentGenerator
  before_filter :authenticate_user!

  rescue_from CustomExceptions::HandleIfError, with: :getoption

  def getoption
    render 'getoption.html.erb'
  end

  def elu_consumer
    begin
      begin
        elu_content_processor
        elu_pdf_responder
      rescue Exception => e
        puts 'Exception at elu starts * ' + e.message + '*' + e.backtrace.join("\n").to_s + ' for elu id ' + @user_id + ' * end up here'
        flash.now[:error] = "data not found."
        raise CustomExceptions::HandleIfError
      end
    rescue
      raise CustomExceptions::HandleIfError
    end
  end

end
