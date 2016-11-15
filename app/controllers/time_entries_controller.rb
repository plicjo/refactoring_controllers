class TimeEntriesController < ApplicationController
  before_filter :authenticate_user!

  def send_entries
    if params[:start_date].present?
      @start_date = Date.parse(params[:start_date])
    else
      @start_date = Time.zone.today
    end

    if params[:end_date].present?
      @end_date = Date.parse(params[:end_date])
    else
      @end_date = Time.zone.today
    end

    @time_entries = TimeEntry.order("actual_start_time DESC")
                             .where("(actual_hours IS NOT NULL OR bill_amount IS NOT NULL) AND actual_start_time >= ? AND actual_start_time <= ?", @start_date.beginning_of_day, @end_date.end_of_day)

    UserMailer.send_time_entries(current_user, @time_entries).deliver_now
    flash[:success] = "Time Entries were successfully sent to you."
    redirect_to root_path
  end
end
