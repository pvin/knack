class MessageController < ApplicationController

  before_filter :authenticate_user!

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])

    if @message.valid?
      NotificationsMailer.new_message(@message).deliver
      flash[:success] = "Email sent successfully"
      redirect_to direction_redirect_url
    else
      flash[:error] = "Please fill the required fields."
      render :new
    end


  end

end
