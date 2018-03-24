# frozen_string_literal: true

module SpritWatch
  Price = Struct.new(:amount, :currency) do
    include Comparable

    def <=>(other)
      raise ArgumentError, "Cannot compare #{currency} with #{other.currency}" if currency != other.currency
      amount.to_f <=> other.amount.to_f
    end

    def to_s
      [amount, currency].join(' ')
    end
  end
end
