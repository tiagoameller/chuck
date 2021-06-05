# == Schema Information
#
# Table name: users
#
#  id                        :uuid             not null, primary key
#  email                     :string
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :inet
#  last_sign_in_ip           :inet
#  company_id                :uuid
#  name                      :string
#  first_name                :string
#  last_name                 :string
#  username                  :string
#  loginname                 :string
#  phone                     :string
#  comment                   :text
#  dark_theme                :boolean          default(FALSE)
#  role                      :integer          default("employee")
#  default_admin             :boolean          default(FALSE)
#  active                    :boolean          default(TRUE)
#  can_edit_images           :boolean          default(FALSE)
#  can_edit_geolocation      :boolean          default(FALSE)
#  can_edit_existing_gardens :boolean          default(FALSE)
#  can_create_delete_gardens :boolean          default(FALSE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  works_on_gardens          :boolean          default(TRUE)
#
# Indexes
#
#  index_users_on_company_id_and_email     (company_id,email) UNIQUE
#  index_users_on_company_id_and_username  (company_id,username) UNIQUE
#  index_users_on_email                    (email) UNIQUE
#  index_users_on_loginname                (loginname) UNIQUE
#  index_users_on_reset_password_token     (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should belong_to(:company) }
  it { should have_many(:visit_users) }

  it { should validate_presence_of(:company) }
  it { should validate_length_of(:name).is_at_least(3) }
  it { should validate_length_of(:username).is_at_least(3) }
  it { should allow_value('pepe@gmail.com').for(:email) }
  # cannot be done this way
  # it { should validate_uniqueness_of(:username).scoped_to(:company_id) }
  it { should define_enum_for(:role) }

  let(:company) { create(:company) }
  let(:company_b) { create(:company, name: 'Other company', vat_number: 'ESA07452436') }

  describe 'creates username from company nick' do
    context 'user name is a real user name entered by user' do
      it 'loginname should be "company.name"' do
        user = company.users.new(attributes_for(:user, name: 'Koldo Etxebarrietaaltaleorraga'))
        user.validate
        expect(user).to be_valid
        expect(user.loginname).to eq "#{company.nick}.#{user.username}"
      end
      it 'username should be at most 6 chars' do
        user = company.users.new(attributes_for(:user, name: 'Nominchuluunukhaanzayamunkherdeneenkhtuguldur Pons'))
        user.validate
        expect(user).to be_valid
        expect(user.loginname).to eq "#{company.nick}.#{user.username}"
      end
      it 'username should be at least 3 chars' do
        user = company.users.new(attributes_for(:user, name: 'Ot Pi'))
        user.validate
        expect(user).to be_valid
        expect(user.loginname).to eq "#{company.nick}.#{user.username}"
      end
      it 'username should be at least 3 chars' do
        user = company.users.new(attributes_for(:user, name: 'Pep'))
        user.validate
        expect(user).to be_valid
        expect(user.loginname).to eq "#{company.nick}.#{user.username}"
      end
    end
    context 'user name is "pepe"' do
      it 'loginname should be "company.name"' do
        user = company.users.new(attributes_for(:user, name: 'pepe'))
        user.validate
        expect(user).to be_valid
        expect(user.loginname).to start_with("#{company.nick}.")
        expect(user.loginname.size).to be > (company.nick.size + 1)
      end
    end
    context 'user name is "uno dos tres cuatro cinco seis"' do
      it 'loginname should be "company.name" with no spaces' do
        user = company.users.new(attributes_for(:user, name: 'uno dos tres cuatro cinco seis'))
        user.validate
        expect(user).to be_valid
        expect(user.loginname).to start_with("#{company.nick}.")
        expect(user.loginname.size).to be > (company.nick.size + 1)
        expect(user.loginname.count(' ')).to eq 0
      end
    end
    context 'user name is nil' do
      it 'loginname should be also nil' do
        user = company.users.new(attributes_for(:user, name: nil))
        user.validate
        expect(user).not_to be_valid
        expect(user.loginname).to be nil
      end
      it 'username should be also nil' do
        user = company.users.new(attributes_for(:user, name: nil))
        user.validate
        expect(user).not_to be_valid
        expect(user.username).to be nil
      end
    end
    context 'user name is " "' do
      it 'loginname should be nil' do
        user = company.users.new(attributes_for(:user, name: ' '))
        user.validate
        expect(user).not_to be_valid
        expect(user.loginname).to be nil
      end
    end
    context 'user has uppercases and acutes' do
      it 'loginname is converted to plain' do
        user = company.users.new(attributes_for(:user, name: 'Pepón'))
        user.validate
        expect(user).to be_valid
        username = 'pepon'
        expect(user.username).to eq username
        expect(user.loginname).to eq "#{company.nick}.#{username}"
      end
    end
    context 'user cannot be duplicated in same company' do
      context 'usernames are different' do
        it 'permits creation' do
          company.users.create!(FactoryBot.attributes_for(:user))
          user = company.users.new(FactoryBot.attributes_for(:employee))
          expect(user).to be_valid
        end
      end
      context 'username already exist' do
        context 'in creation' do
          it 'builds a different username' do
            user1 = company.users.create!(FactoryBot.attributes_for(:user))
            user = company.users.new(FactoryBot.attributes_for(:employee, name: user1.name))
            expect(user).to be_valid
            expect(user.loginname).to eq "#{user1.loginname}1"
          end
        end
        context 'in updating' do
          it 'does not permit duplicates' do
            user1 = company.users.create!(FactoryBot.attributes_for(:user))
            user = company.users.create!(FactoryBot.attributes_for(:employee, name: user1.name))
            user.username = user1.username
            expect(user).not_to be_valid
            expect(user.errors[:username].present?).to be true
          end
          it 'does not permit duplicates, case sensitive' do
            user1 = company.users.create!(FactoryBot.attributes_for(:user))
            user = company.users.create!(FactoryBot.attributes_for(:employee, name: user1.name))
            user.username = user1.username.upcase
            expect(user).not_to be_valid
            expect(user.errors[:username].present?).to be true
          end
        end
      end
    end
  end

  describe 'find_for_database_authentication' do
    before do
      @user_a = company.users.create!(attributes_for(:user, name: 'Paco Pons', email: 'paco@pons.com'))
      @user_b = company_b.users.create!(attributes_for(:user, name: 'Pepe Pons', email: 'pepe@pons.com'))
    end
    context 'given loginname' do
      it 'finds user' do
        subject = User.find_for_database_authentication(login: @user_a.loginname)
        expect(subject.id).to eq @user_a.id
      end
      it "finds company's user" do
        subject = User.find_for_database_authentication(login: @user_a.loginname)
        expect(subject.company_id).to eq company.id
      end
    end
    context 'given email as login' do
      it 'user is found' do
        subject = User.find_for_database_authentication(login: @user_b.email)
        expect(subject.id).to eq @user_b.id
      end
      it "finds company's user" do
        subject = User.find_for_database_authentication(login: @user_b.email)
        expect(subject.company_id).to eq company_b.id
      end
    end
    context 'given email as email' do
      it 'user is found' do
        subject = User.find_for_database_authentication(email: @user_b.email)
        expect(subject.id).to eq @user_b.id
      end
      it "finds company's user" do
        subject = User.find_for_database_authentication(email: @user_b.email)
        expect(subject.company_id).to eq company_b.id
      end
    end
    context 'given bad loginname' do
      it 'cannot find user' do
        subject = User.find_for_database_authentication(login: 'bad.bad')
        expect(subject).to be nil
      end
    end
    context 'given bad email' do
      it 'cannot find user' do
        subject = User.find_for_database_authentication(login: 'bad@email.com')
        expect(subject).to be nil
      end
    end
    context 'given bad parameters' do
      it 'cannot find user' do
        subject = User.find_for_database_authentication(bad: 'parameter')
        expect(subject).to be nil
      end
    end
  end

  describe 'full_name' do
    context 'name and loginname are mandatory' do
      before do
        @subject = company.users.new(attributes_for(:user, name: 'Paco Pons'))
        @subject.validate
      end
      it 'concatenate them' do
        expect(@subject.full_name).to eq @subject.name + ' (' + @subject.loginname + ')' # rubocop:disable Style/StringConcatenation
      end
      it 'starts with user.name ' do
        expect(@subject.full_name).to start_with @subject.name
      end
      it 'loginname is not empty' do
        expect(@subject.full_name).not_to include '()'
      end
    end
  end

  describe 'email is mandatory for all kind of users' do
    context 'email is unique at application level' do
      it 'does not permits creation' do
        company.users.create(attributes_for(:user, name: 'Paco Pons', email: 'same@email.com'))
        company_b.users.create(attributes_for(:user, name: 'Pepe Pons', email: 'same@email.com'))
        expect(company.users.count).to eq 1
      end
    end
  end
  describe 'email must be validated if exist' do
    context 'bad email' do
      it 'does not permits creation' do
        subject = company.users.create(attributes_for(:user, name: 'Paco Pons', email: 'bademail'))
        expect(subject).not_to be_valid
      end
    end
    context 'valid email' do
      it 'permits creation' do
        subject = company.users.create(attributes_for(:user, name: 'Paco Pons', email: 'good@email.com'))
        expect(subject).to be_valid
      end
    end
  end
  describe 'email is mandatory for admins' do
    context 'no email' do
      it 'does not permits creation' do
        subject = company.users.create(attributes_for(:user, name: 'Paco Pons', email: nil, role: :admin))
        expect(subject).not_to be_valid
      end
    end
    context 'valid email' do
      it 'permits creation' do
        subject = company.users.create(attributes_for(:user, name: 'Paco Pons', email: 'good@email.com', role: :admin))
        expect(subject).to be_valid
      end
    end
  end
end
