# frozen_string_literal: true

module SpritWatch
  Station = Struct.new(:id, :brand) do
    def price=(price)
      prices[price.type] = price.euros
    end

    def price(type)
      prices[type]
    end

    private

    def prices
      @prices ||= {}
    end
  end
end
