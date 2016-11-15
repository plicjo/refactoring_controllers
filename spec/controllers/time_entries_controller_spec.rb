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
    let(:yesterday) { Time.current - 1.day }
    let(:tomorrow) { Time.current + 1.day }
    let!(:time_entry) do
      TimeEntry.create!(actual_start_time: Time.current, actual_end_time: Time.current, task: task, user: user)
    end
    let!(:yesterday_time_entry) do
      TimeEntry.create!(actual_start_time: yesterday, actual_end_time: Time.current, task: task, user: user, description: 'Time Entry From Yesterday')
    end
    let!(:tomorrow_time_entry) do
      TimeEntry.create!(actual_start_time: tomorrow, actual_end_time: tomorrow + 1.day, task: task, user: user, description: 'Time Entry From Tomorrow')
    end

    it 'delivers an email' do
      post :send_entries
      last_email = ActionMailer::Base.deliveries.last
      expect(last_email).to have_content time_entry.description
    end

    it 'flashes a success message' do
      post :send_entries
      expect(flash[:success]).to eq("Time Entries were successfully sent to you.")
    end

    it 'redirects to root path' do
      post :send_entries
      expect(response).to redirect_to(root_path)
    end
  end
end
