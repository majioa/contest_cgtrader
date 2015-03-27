require 'spec_helper'

RSpec.describe CgtraderLevels::User do
  let(:levels) do
    [
      CgtraderLevels::Level.create!(experience: 0, title: 'First level', number: 0),
      CgtraderLevels::Level.create!(experience: 10, title: 'Second level', number: 1),
      CgtraderLevels::Level.create!(experience: 13, title: 'Second level', number: 2)
    ]
  end

  let(:user) { levels ; CgtraderLevels::User.create! }

  let(:user_with_coin) { levels ; CgtraderLevels::User.create!(coins: 1) }

  let(:user_with_tax) { levels ; CgtraderLevels::User.create!(tax: 1) }

  describe 'new user' do
    it 'has 0 reputation points' do
      expect(user.reputation).to eq(0)
    end

    it "has assigned 'First level'" do
      expect(user.level).to eq(levels[0])
    end
  end

  describe 'level up' do
    it "level ups from 'First level' to 'Second level'" do
      expect {
        user.update_attribute(:reputation, 10)
      }.to change { user.reload.level }.from(levels[0]).to(levels[1])
    end

    it "level ups from 'First level' to 'Second level' with noise" do
      expect {
        user.update_attribute(:reputation, 11)
      }.to change { user.reload.level }.from(levels[0]).to(levels[1])
    end
  end

  describe 'level up bonuses & privileges' do
    it 'gives 7 coins to user' do
      expect {
        user_with_coin.update_attribute(:reputation, 10)
      }.to change { user_with_coin.reload.coins }.from(1).to(8)
    end

    it 'reduces tax rate by 1 per level' do
      expect {
        user.update_attribute(:reputation, 12)
      }.to change { user.reload.tax }.from(30).to(29)
    end

    it 'reduces tax rate by 2 from 1' do
      expect {
        user_with_tax.update_attribute(:reputation, 14)
      }.to change { user_with_tax.reload.tax }.from(1).to(0)
    end
  end
end
