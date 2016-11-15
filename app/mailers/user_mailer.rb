class UserMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def send_time_entries(user, time_entries)
    @recipient = user
    @time_entries = time_entries
    mail(to: @user.email, subject: 'Your Time Entries Summary')
  end
end
