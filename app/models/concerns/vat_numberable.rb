module VatNumberable
  extend ActiveSupport::Concern

  module ClassMethods
  end

  included do
    validates :vat_number,
              valvat: {
                checksum: true
              },
              presence: true

    # override attributes setter to clean user entered data
    def vat_number=(value)
      self[:vat_number] = Valvat::Utils.normalize(value)
    end

    before_validation do |rec|
      rec.vat_number = "ES#{rec.vat_number}" if (rec.vat_number&.size == 9) && rec.vat_number&.index('ES').nil?
    end

    # unncomment if needed

    # def same_vat_numbers
    #   self.class.where('vat_number = ?', vat_number).map { |c| [c.id, c.name] }.delete_if { |c| c[0] == id }
    # end
  end
end
