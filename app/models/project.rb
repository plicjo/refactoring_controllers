class Project < ActiveRecord::Base
  belongs_to :client
  has_many :tasks
  validates :client, presence: true
end
