# frozen_string_literal: true

module SpritWatch
  Station = Struct.new(:id, :brand, :street, :closed, keyword_init: true) do
    def price=(price)
      prices[price.type] = price
    end

    def price(type)
      prices[type]
    end

    def closed?
      # rubocop:disable Style/DoubleNegation
      !!closed
      # rubocop:enable Style/DoubleNegation
    end

    def to_s
      "#{brand}, #{street}"
    end

    private

    def prices
      @prices ||= {}
    end
  end
end
