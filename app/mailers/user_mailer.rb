class UserMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def send_time_entries(user, params)
    @recipient = user
    @time_entries = TimeEntryQuery.new(start_date: params[:start_date], end_date: params[:end_date]).time_entries
    mail(to: @user.email, subject: 'Your Time Entries Summary')
  end
end
