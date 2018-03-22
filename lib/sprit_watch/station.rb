# frozen_string_literal: true

module SpritWatch
  Station = Struct.new(:id, :brand, :street, :city, :closed, keyword_init: true) do
    def price=(price)
      prices[price.type] = price
    end

    def price(type)
      prices[type]
    end

    def closed?
      closed
    end

    def to_s
      "#{brand}, #{street}, #{city}"
    end

    private

    def prices
      @prices ||= {}
    end
  end
end
