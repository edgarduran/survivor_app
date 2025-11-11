require 'rails_helper'

RSpec.describe Pick, type: :model do
  let(:pool) { Pool.create(name: 'Test Pool', season: season) }
  let(:user) { User.create(first_name: 'Homer', last_name: 'Simpson', email: 'test@example.com')}
  let(:season) {
    Season.create(
      start_date: Date.new(Date.today.year - 1, Date.today.month, Date.today.day),
      end_date: Date.new(Date.today.year, Date.today.month + 1, Date.today.day + 1)
    )
  }
  let(:pool_membership) { PoolMembership.create(user:, pool:, role: 'member') }
  let(:week) { Week.create(week_number: 1, start_date: DateTime.now + 2.hour, season: season)}
  let!(:week2)  { Week.create!(week_number: 2, start_date: 2.weeks.from_now, season: season) }
  let!(:week3)  { Week.create!(week_number: 3, start_date: 3.weeks.from_now, season: season) }
  let!(:chicago_team) { Team.create(name: 'Chicago Bears') }
  let!(:denver_team) { Team.create!(name: 'Denver Broncos') }
  let!(:green_bay_team) { Team.create!(name: 'Green Bay Packers') }

  subject(:pick) { Pick.new(user: user, season: season, week: week, team: nil, pool: pool) }

  describe 'valid_pick' do
    context 'when pick is valid' do
      before { pick.team = chicago_team }

      it 'saves user pick' do
        expect(pick.valid?).to be(true)
        expect(pick.save).to be(true)
      end
    end

    context 'when user has 1 invalid pick' do
      before { Pick.create!(pool:, user:, season:, week:, team: denver_team, is_correct: false) }

      it 'allows another pick' do
        next_pick = Pick.new(pool:, user:, season:, week: week2, team: chicago_team)
        expect(next_pick).to be_valid
      end
    end
  end

  describe 'invalid pick' do
    context 'when pick is nil' do
      let(:team) { nil }
      it 'does not save user pick with no team' do
        expect(pick.valid?).to be(false)
        expect(pick.save).to be(false)
      end
    end

    context 'when pick is dup' do
      let(:team) { chicago_team }

      before do
        travel_to(week.start_date - 1.hour) do
          Pick.create!(pool: pool, user: user, season: season, week: week, team: team)
        end
      end

      it 'is invalid when the same user picks the same team again in the same season' do
        # Attempt same team in a different week of the same season
        new_pick = Pick.new(pool: pool, user: user, season: season, week: week2, team: team)

        expect(new_pick).to be_invalid
        expect(new_pick.errors[:team_id]).to include("You've already picked this team this season")
      end
    end


    context 'when user has 2 invalid picks' do
      before do
        Pick.create!(pool:, user:, season:, week: week, team: denver_team, is_correct: false)
        Pick.create!(pool:, user:, season:, week: week2, team: green_bay_team, is_correct: false)
      end

      it 'is invalid when a user has already made the allotted number of incorrect picks' do
        new_pick = Pick.new(pool: pool, user: user, season: season, week: week3, team: chicago_team)

        expect(new_pick).to be_invalid
        expect(new_pick.errors[:base]).to include("You have already made 2 incorrect picks this season and cannot make any more picks.")
      end
    end

    context 'when user attempts to submit pick after weekly deadline' do
      it 'does not save user pick when deadline passes' do
        travel_to(week.start_date + 1.minute) do
          late_pick = Pick.new(user: user, season: season, week: week, team: chicago_team)

          expect(late_pick).to be_invalid
          expect(late_pick.errors[:base]).to include("You cannot make or change a pick after the start of the week's first game.")
        end
      end
    end

    context 'when user tries to make more than one pick in the same week' do
      before do
        travel_to(week.start_date - 1.hour) do
          Pick.create!(pool:, user:, season:, week:, team: chicago_team)
        end
      end

      it 'is invalid to create a second pick in the same week' do
        duplicate_pick = Pick.new(pool:, user:, season:, week:, team: denver_team)
        expect(duplicate_pick).to be_invalid
        expect(duplicate_pick.errors[:base]).to include("You already have a pick for this week. You can change it until the week starts.")
      end
    end
  end
end
