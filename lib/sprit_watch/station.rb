# frozen_string_literal: true

require 'securerandom'

module SpritWatch
  Station = Struct.new(:id, :brand, :street, :city, :closed, keyword_init: true) do
    def initialize_copy(original)
      members.each do |member|
        self[member] = original[member]
      end

      self.id = SecureRandom.uuid
    end

    def price=(price)
      prices[price.type] = price
    end

    def price(type)
      prices[type]
    end

    def closed?
      closed
    end

    def ==(other)
      id == other.id
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
