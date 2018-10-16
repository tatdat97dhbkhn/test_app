class LineItem < ApplicationRecord
  CSV_ATTRIBUTES = %w(name unit_price quantity order).freeze

  belongs_to :order

  def full_price
    unit_price * quantity
  end
end
