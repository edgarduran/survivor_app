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
    let(:week) { Week.create(week_number: 2, start_date: DateTime.now + 2.hour, season: season)}

    subject(:pick) { Pick.new(user: user, season: season, week: week, team: team) }

    context 'when pick is valid' do
      let(:team) { Team.create(name: 'Chicago Bears') }

      it 'saves user pick' do
        expect(pick.valid?).to be(true)
        expect(pick.save).to be(true)
      end
    end
    context 'when pick is not valid' do
      let(:team) { nil }
      it 'does not save user pick with no team' do
        expect(pick.valid?).to be(false)
        expect(pick.save).to be(false)
      end
      # it 'does not save user pick when deadline passes' do
      # end
      it 'does not save user pick when team picked more than once' do
        before {
          let(:last_week) { Week.create(week_number: 1, start_date: DateTime.now - 7.days, season: season)}
          let(:last_week__team_pick) { Team.create(name: 'Chicago Bears') }

         }

         expect(pick.save).to eq(false)
        #  assert error message
      end
      # it 'does not save user pick with when user has 2 incorrect picks' do
      # end
    end
  end
end
