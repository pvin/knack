class NotificationsMailer < ActionMailer::Base
  default :from => "gmail.com"
  default :to => "praaveenranganathan@gmail.com"

  def new_message(message)
    @message = message
    mail(:subject => "[knacK.in] #{message.subject}")
  end
end