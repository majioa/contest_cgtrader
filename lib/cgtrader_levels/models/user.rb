class CgtraderLevels::User < ActiveRecord::Base
  belongs_to :level, class_name: 'CgtraderLevels::Level'

  after_initialize :set_new_level
  after_update :set_new_level

  private

  def set_new_level
    levels = CgtraderLevels::Level.arel_table
    matching_level =
    CgtraderLevels::Level.where(levels[:experience].lteq(reputation))
                         .order(levels[:experience].desc).first

    self.level = matching_level if matching_level
  end
end
