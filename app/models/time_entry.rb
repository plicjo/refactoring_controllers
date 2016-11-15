class TimeEntry < ActiveRecord::Base
  belongs_to :task
  belongs_to :user
  validates :task, :user, presence: true
end
