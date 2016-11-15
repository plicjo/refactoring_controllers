require 'rails_helper'

describe TimeEntriesController do
  describe '#send_entries' do
    it 'delivers an email'
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
