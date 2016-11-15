class TimeEntriesController < ApplicationController
  before_filter :authenticate_user!

  def send_entries
    time_entries = TimeEntryQuery.new(start_date: params[:start_date], end_date: params[:end_date]).time_entries
    UserMailer.send_time_entries(current_user, time_entries).deliver_now
    flash[:success] = "Time Entries were successfully sent to you."
    redirect_to root_path
  end
end
