class TimeEntryQuery
  attr_reader :start_date, :end_date

  def initialize(start_date: nil, end_date: nil)
    @start_date = parse_date(start_date)
    @end_date   = parse_date(end_date)
  end

  def time_entries
    TimeEntry.order("actual_start_time DESC")
          .where("(actual_hours IS NOT NULL OR bill_amount IS NOT NULL) AND actual_start_time >= ? AND actual_start_time <= ?", start_date.beginning_of_day, end_date.end_of_day)
  end

  private

  def parse_date(date)
    if date
      Date.parse(date)
    else
      Time.zone.today
    end
  end
end
