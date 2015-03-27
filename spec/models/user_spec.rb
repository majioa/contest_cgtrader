require 'spec_helper'

RSpec.describe CgtraderLevels::User do
  describe 'new user' do
    it 'has 0 reputation points' do
      @user = CgtraderLevels::User.create!
      expect(@user.reputation).to eq(0)
    end

    it "has assigned 'First level'" do
      @level = CgtraderLevels::Level.create!(experience: 0, title: 'First level', number: 0)
      @user = CgtraderLevels::User.create!

      expect(@user.level).to eq(@level)
    end
  end

  describe 'level up' do
    it "level ups from 'First level' to 'Second level'" do
      @level_1 = CgtraderLevels::Level.create!(experience: 0, title: 'First level', number: 0)
      @level_2 = CgtraderLevels::Level.create!(experience: 10, title: 'Second level', number: 1)
      @user = CgtraderLevels::User.create!

      expect {
        @user.update_attribute(:reputation, 10)
      }.to change { @user.reload.level }.from(@level_1).to(@level_2)
    end

    it "level ups from 'First level' to 'Second level' with noise" do
      @level_1 = CgtraderLevels::Level.create!(experience: 0, title: 'First level', number: 0)
      @level_2 = CgtraderLevels::Level.create!(experience: 10, title: 'Second level', number: 1)
      @level_3 = CgtraderLevels::Level.create!(experience: 13, title: 'Third level', number: 2)
      @user = CgtraderLevels::User.create!

      expect {
        @user.update_attribute(:reputation, 11)
      }.to change { @user.reload.level }.from(@level_1).to(@level_2)
    end
  end

  describe 'level up bonuses & privileges' do
    it 'gives 7 coins to user' do
      @user = CgtraderLevels::User.create!(coins: 1)

      expect {
        @user.update_attribute(:reputation, 10)
      }.to change { @user.reload.coins }.from(1).to(8)
    end

    it 'reduces tax rate by 1 per level' do
      CgtraderLevels::Level.create!(experience: 0, title: 'First level', number: 0)
      CgtraderLevels::Level.create!(experience: 10, title: 'Second level', number: 1)
      @user = CgtraderLevels::User.create!

      expect {
        @user.update_attribute(:reputation, 12)
      }.to change { @user.reload.tax }.from(30).to(29)
    end

    it 'reduces tax rate by 2 from 1' do
      CgtraderLevels::Level.create!(experience: 0, title: 'First level', number: 0)
      CgtraderLevels::Level.create!(experience: 10, title: 'Second level', number: 1)
      CgtraderLevels::Level.create!(experience: 13, title: 'Second level', number: 2)
      @user = CgtraderLevels::User.create!(tax: 1)

      expect {
        @user.update_attribute(:reputation, 14)
      }.to change { @user.reload.tax }.from(1).to(0)
    end
  end
end
