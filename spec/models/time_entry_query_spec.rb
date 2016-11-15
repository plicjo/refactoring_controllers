require 'rails_helper'

describe TimeEntryQuery do
  let(:client) { Client.create! }
  let(:project) { Project.create!(client: client) }
  let(:task) { Task.create!(:task, project: project) }
  let(:user) { User.create!(email: 'user@example.com', password: 'password') }

  describe '#time_entries' do
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

    context 'start date and end date are supplied' do
      subject { described_class.new(start_date: yesterday.to_s, end_date: tomorrow.to_s).time_entries }
      it 'returns time_entries between start date and end date' do
        expect(subject).to include time_entry
        expect(subject).to include yesterday_time_entry
        expect(subject).to include tomorrow_time_entry
      end
    end

    context 'only start date is present' do
      subject { described_class.new(start_date: yesterday.to_s).time_entries }
      it 'returns time_entries between start date and today' do
        expect(subject).to include time_entry
        expect(subject).to include yesterday_time_entry
        expect(subject).not_to include tomorrow_time_entry
      end
    end

    context 'only end date is present' do
      subject { described_class.new(end_date: tomorrow.to_s).time_entries }
      it 'returns time_entries between today and end date' do
        expect(subject).to include time_entry
        expect(subject).not_to include yesterday_time_entry
        expect(subject).to include tomorrow_time_entry
      end
    end

    context 'no start date and no end date' do
      subject { described_class.new.time_entries }
      it 'returns time_entries from today' do
        expect(subject).to include time_entry
        expect(subject).not_to include yesterday_time_entry
        expect(subject).not_to include tomorrow_time_entry
      end
    end
  end
end
