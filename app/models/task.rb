class Task < ActiveRecord::Base
  belongs_to: project
  has_many :time_entries
  validates :project, presence: true
end
