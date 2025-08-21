require 'rails_helper'

RSpec.describe Pick, type: :model do
  describe 'valid_pick' do
    let(:user) { User.create(first_name: 'Homer', last_name: 'Simpson', email: 'test@example.com')}
    let(:season) {
      Season.create(
        start_date: Date.new(Date.today.year - 1, Date.today.month, Date.today.day),
        end_date: Date.new(Date.today.year, Date.today.month + 1, Date.today.day + 1)
      )
    }
    let(:week) { Week.create(week_number: 1, start_date: DateTime.now + 1.hour, season: season)}
    let(:team) { Team.create(name: 'Chicago Bears') }

    subject(:pick) { Pick.new(user: user, season: season, week: week, team: team) }

    context 'when pick is valid' do
      it 'saves user pick' do
        expect(pick.valid?).to be(true)
        expect(pick.save).to be(true)
      end
    end
    context 'when pick is not valid' do
      # it 'does not save usr pick' do
      # end
    end
  end
end
