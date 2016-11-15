require 'rails_helper'

describe TimeEntriesController do
  let(:client) { Client.create! }
  let(:project) { Project.create!(client: client) }
  let(:task) { Task.create!(:task, project: project) }
  let(:user) { User.create!(email: 'user@example.com', password: 'password') }

  before do
    sign_in(user)
  end

  describe '#send_entries' do
    it 'delivers an email' do
      time_entry = TimeEntry.create!(actual_start_time: Time.current, actual_end_time: Time.current, task: task, user: user)
      post :send_invoice

      last_email = ActionMailer::Base.deliveries.last
      expect(last_email).to have_content time_entry.description
    end

    it 'flashes a success message'
    it 'redirects to root path'

    context 'start date is present'
      context 'end date is present'
        it 'sends entries between start date and end date'

      context 'end date is not present'
        it 'sends entries between start date and today'

    context 'start date is not present'
      context 'end date is present'
        it 'sends entries between today and end date'

      context 'end date is not present'
        it 'sends entries only from today'
  end
end
