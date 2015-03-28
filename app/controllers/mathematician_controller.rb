require './lib/pdf_generator/pdf_generator.rb'
require './lib/content_generator/content_generator'

class MathematicianController < ApplicationController
  include HTTParty
  include PdfGenerator
  include ContentGenerator
  before_filter :authenticate_user!

  rescue_from CustomExceptions::HandleIfError, with: :getoption

  def getoption
    render 'getoption.html.erb'
  end

  def maths_consumer
    begin
      begin
        maths_content_processor
        maths_pdf_responder
      rescue Exception => e
        puts 'Exception at Mathematics starts * ' + e.message + '*' + e.backtrace.join("\n").to_s + ' for Mathematics id ' + @user_id + ' * end up here'
        flash.now[:error] = "data not found."
        raise CustomExceptions::HandleIfError
      end
    rescue
      raise CustomExceptions::HandleIfError
    end
  end
end
