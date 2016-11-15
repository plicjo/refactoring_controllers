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


    context 'start date is present' do
      let(:query_params) do
        { start_date: yesterday }
      end

      context 'end date is present' do
        before do
          query_params.merge!(end_date: tomorrow)
        end

        it 'sends time entries between start date and end date' do
          post :send_entries, query_params
          last_email = ActionMailer::Base.deliveries.last
          expect(last_email).to have_content time_entry.description
          expect(last_email).to have_content yesterday_time_entry.description
          expect(last_email).to have_content tomorrow_time_entry.description
        end
      end

      context 'end date is not present' do
        before do
          query_params.merge!(end_date: nil)
        end

        it 'sends entries between start date and today' do
          post :send_entries, query_params
          last_email = ActionMailer::Base.deliveries.last
          expect(last_email).to have_content time_entry.description
          expect(last_email).to have_content yesterday_time_entry.description
          # The tomorrow time entry is not in the query range
          expect(last_email).not_to have_content tomorrow_time_entry.description
        end
      end
    end

    context 'start date is not present' do
      let(:query_params) do
        { start_date: nil }
      end
      context 'end date is present' do
        before do
          query_params.merge!(end_date: tomorrow)
        end

        it 'sends entries between today and end date' do
          post :send_entries, query_params
          last_email = ActionMailer::Base.deliveries.last
          expect(last_email).to have_content time_entry.description
          # The yesterday time entry is not in the query range
          expect(last_email).not_to have_content yesterday_time_entry.description
          expect(last_email).to have_content tomorrow_time_entry.description
        end
      end

      context 'end date is not present' do
        before do
          query_params.merge!(end_date: nil)
        end

        it 'sends entries only from today' do
          post :send_entries, query_params
          last_email = ActionMailer::Base.deliveries.last
          expect(last_email).to have_content time_entry.description
          # Both the tomorrow and yesterday time entries are not in the query range
          expect(last_email).not_to have_content yesterday_time_entry.description
          expect(last_email).not_to have_content tomorrow_time_entry.description
        end
      end
    end
  end
end
