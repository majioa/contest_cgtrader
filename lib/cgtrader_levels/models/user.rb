class CgtraderLevels::User < ActiveRecord::Base
  attr_reader :level

  after_initialize :set_new_level
  after_update :set_new_level

  private

  def set_new_level
    levels = CgtraderLevels::Level.arel_table
    matching_level =
    CgtraderLevels::Level.where(levels[:experience].lteq(reputation))
                         .order(levels[:experience].desc).first

    if matching_level
      self.level_id = matching_level.id
      @level = matching_level
    end
  end
end
