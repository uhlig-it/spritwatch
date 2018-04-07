# frozen_string_literal: true

module SpritWatch
  FuelPrice = Struct.new(:type, :price) do
    TYPES = %i[diesel e10 e5].freeze
    include Comparable

    def <=>(other)
      raise ArgumentError, 'Cannot compare with something that does not have a type' unless other.respond_to?(:type)
      raise ArgumentError, "Cannot compare #{type} with #{other.type}" if type != other.type
      price <=> other.price
    end

    def to_s
      "#{type.to_s.capitalize}: #{price}"
    end
  end
end
