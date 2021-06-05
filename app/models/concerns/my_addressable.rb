module MyAddressable
  extend ActiveSupport::Concern

  module ClassMethods
  end

  included do
    validates :city, presence: true

    def full_address
      [city].tap do |result|
        result << address_one if address_one.present?
        result << address_two if address_two.present?
        result << zip_code if zip_code.present?
        result << state if state.present?
        result << country if country.present?
      end.join ' - '
    end
  end
end
