class CgtraderLevels::User < ActiveRecord::Base
  belongs_to :level, class_name: 'CgtraderLevels::Level'

  before_save :set_new_level, :give_coins

  RATE = 1.4

  def coins
    read_attribute(:coins).to_i
  end

  private

  def set_new_level
    levels = CgtraderLevels::Level.arel_table
    matching_level =
    CgtraderLevels::Level.where(levels[:experience].lteq(reputation))
                         .order(levels[:experience].desc).first

    self.level = matching_level if matching_level
  end

  def give_coins
    if self.changes[:reputation]
      reputation_diff = self.changes[:reputation][1] - self.changes[:reputation][0]
      self.coins += (reputation_diff.to_f / RATE).round
    end
  end

end
