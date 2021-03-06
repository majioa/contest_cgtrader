class CgtraderLevels::User < ActiveRecord::Base
  belongs_to :level, class_name: 'CgtraderLevels::Level'

  before_save :set_new_level, :give_coins

  RATE = 1.4

  def coins
    read_attribute(:coins).to_i
  end

  def tax
    read_attribute(:tax).to_i
  end

  private

  def set_new_level
    levels = CgtraderLevels::Level.arel_table
    matching_level =
    CgtraderLevels::Level.where(levels[:experience].lteq(reputation))
                         .order(levels[:experience].desc).first

    if matching_level
      add_bonus_to(matching_level) if self.level
      self.level = matching_level
    end
  end

  def give_coins
    if self.changes[:reputation]
      reputation_diff = self.changes[:reputation][1] - self.changes[:reputation][0]
      self.coins += (reputation_diff.to_f / RATE).round
    end
  end

  def add_bonus_to level
    self.tax -= [ level.number - self.level.number, self.tax ].min
  end

end
