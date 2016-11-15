class TimeEntriesController < ApplicationController
  before_filter :authenticate_user!

  def send_entries
    UserMailer.send_time_entries(current_user, params).deliver_later
    flash[:success] = "Time Entries were successfully sent to you."
    redirect_to root_path
  end
end
