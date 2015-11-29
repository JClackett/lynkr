class UserMailer < ActionMailer::Base 
  default :from => "jclackett@gmail.com"
    
  def invitation_to_share(shared_collection) 
    @shared_collection = shared_collection #setting up an instance variable to be used in the email template 
    mail( :to => @shared_collection.shared_email,  
          :subject => "#{@shared_collection.user.first_name} wants to share '#{@shared_collection.collection.title}' collection with you" ) 
  end
end