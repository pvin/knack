ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => "gmail.com",
    :user_name => "praaveen.ece@gmail.com",
    :password => "guruguru",
    :authentication => "plain",
    :enable_starttls_auto => true
}
