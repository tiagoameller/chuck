# == Schema Information
#
# Table name: companies
#
#  id          :uuid             not null, primary key
#  name        :string
#  nick        :string
#  vat_number  :string
#  address_one :string
#  address_two :string
#  city        :string
#  zip_code    :string
#  state       :string
#  country     :string           default("ES")
#  email       :string
#  website     :string
#  phone       :string
#  admin_name  :string
#  active      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_companies_on_nick        (nick) UNIQUE
#  index_companies_on_vat_number  (vat_number) UNIQUE
#

require 'rails_helper'

RSpec.describe Company, type: :model do
  it { should have_many(:users) }

  it { should validate_presence_of(:vat_number) }
  it { should validate_length_of(:name).is_at_least(6).is_at_most(60) }
  it { should validate_length_of(:nick).is_at_least(3) }
  it { should validate_length_of(:admin_name).is_at_least(3) }
  # cannot be tested this way
  # it { should validate_uniqueness_of(:nick) }

  describe 'website' do
    context 'is blank' do
      it 'is valid' do
        company = build(:company, website: nil)
        expect(company).to be_valid
      end
    end
    context 'http://notsecure.com' do
      it 'is valid' do
        company = build(:company, website: 'http://notsecure.com')
        expect(company).to be_valid
      end
    end
    context 'https://tsecure.com' do
      it 'is valid' do
        company = build(:company, website: 'https://secure.com')
        expect(company).to be_valid
      end
    end
    context 'secure.com' do
      it 'is not valid' do
        company = build(:company, website: 'secure.com')
        expect(company).not_to be_valid
      end
    end
    context 'badsite' do
      it 'is not valid' do
        company = build(:company, website: 'badsite')
        expect(company).not_to be_valid
      end
    end
  end

  describe 'creates nick from name' do
    context 'name is just one word' do
      it 'nick should be thant word' do
        company = build(:company, name: 'PISCINASCM')
        company.validate
        expect(company.nick).to eq company.name.downcase
      end
    end
    context 'name is "abc de"' do
      it 'nick should be abcde' do
        company = build(:company, name: 'abc de')
        company.validate
        expect(company.nick).to eq 'abcde'
      end
    end
    context 'name is "a    b' do
      it 'nick should be abcde' do
        company = build(:company, name: 'a    b')
        company.validate
        expect(company.nick).to eq 'ab1'
      end
    end
    context 'name is nil' do
      it 'nick also is null' do
        company = build(:company, name: nil)
        company.validate
        expect(company.nick).to be nil
      end
    end
    context 'name is "    "' do
      it 'nick also is null' do
        company = build(:company, name: '    ')
        company.validate
        expect(company.nick).to be nil
      end
    end
    context 'name has non ascii chars' do
      it 'nick is also calculated' do
        company = build(:company, name: 'áaéeíi')
        company.validate
        expect(company.nick).to eq 'aaeeii'
      end
    end
    context 'name is as expected' do
      it 'nick is calculated' do
        company = build(:company, name: 'Piscinas Isla Azul, S.L.')
        company.validate
        expect(company.nick).to eq 'pisisl'
      end
    end
    context 'name should be unique' do
      it 'despite of case' do
        company1 = build(:company, name: 'Piscinas Isla Azul, S.L.')
        company1.save!
        company = build(:company, name: 'Piscinas Isla Azul, S.L.', vat_number: 'ESG07682735')
        company.save!
        expect(company.nick).to eq 'pisisl1'
        company.nick = 'PISISL'
        expect(company).not_to be_valid
        expect(company.errors[:nick].present?).to be true
      end
    end
  end

  describe 'full_name' do
    it 'returns name + nick' do
      subject = build(:company, name: 'Piscinas Isla Azul, S.L.')
      subject.validate
      expect(subject.full_name).to include(subject.nick)
    end
  end

  describe 'full_address' do
    context 'address_two exist' do
      it 'full_address should contain it' do
        subject = build(
          :company,
          address_two: 'la villa',
          zip_code: nil,
          city: nil,
          state: nil,
          country: nil
        )
        expect(subject.full_address).to eq "#{subject.city} - #{subject.address_one} - #{subject.address_two}"
      end
    end
    context 'all address fields are nil' do
      it 'full_address = city' do
        subject = build(
          :company,
          address_one: nil,
          address_two: nil,
          zip_code: nil,
          state: nil,
          country: nil
        )
        expect(subject.full_address).to eq subject.city
      end
    end
    context 'some address fields are nil' do
      it 'full_address is built' do
        subject = build(
          :company,
          country: nil
        )
        expect(subject.full_address).to start_with(subject.city)
        expect(subject.full_address).to include(subject.zip_code)
      end
    end
  end

  context 'vat_number' do
    it 'Should not validate a blank vat_number' do
      company = build(:company, vat_number: '')
      expect(company).not_to be_valid
    end
    it 'Should not validate a nil vat_number' do
      company = build(:company, vat_number: nil)
      expect(company).not_to be_valid
    end
    it 'Should fail with invalid vat_number' do
      company = build(:company, vat_number: '07079999')
      expect(company).not_to be_valid
      expect(company.errors[:vat_number].present?).to be true
    end
    it 'Should have a valid vat_number' do
      company = build(:company, vat_number: 'ESB07079999')
      expect(company.valid?).to be true
    end
    it 'vat_numbers are normalized on setting' do
      company = build(:company, vat_number: '41.495.761-n')
      expect(company.vat_number).to eq '41495761N'
    end
    context 'vat_numbers are added "ES" if necessary' do
      describe 'with valid vat' do
        it 'validates' do
          company = build(:company, vat_number: 'B07079999')
          company.validate
          expect(company.vat_number).to eq 'ESB07079999'
        end
      end
      describe 'with not valid vat' do
        it 'does not validate' do
          company = build(:company, vat_number: 'B07079998')
          company.validate
          expect(company).not_to be_valid
          expect(company.errors[:vat_number].present?).to be true
        end
      end
    end
    context 'vat_number should be unique' do
      it 'does not validate' do
        company1 = build(:company)
        company1.save!
        company = build(:company)
        expect(company).not_to be_valid
        expect(company.errors[:vat_number].present?).to be true
      end
    end
  end
end
