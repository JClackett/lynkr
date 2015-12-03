ActionMailer::Base.smtp_settings = { 
 :address              => "smtp.hotmail.com", 
 :port                 => 587, 
 :domain               => "gmail.com", 
 :user_name => "jclackett",
 :password => "/////////",
 :authentication       => "plain", 
 :enable_starttls_auto => true
}