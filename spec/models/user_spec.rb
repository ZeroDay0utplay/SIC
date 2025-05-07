require "rails_helper"

RSpec.describe User, type: :model do
  describe "database schema" do
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:encrypted_password).of_type(:string) }
    it { should have_db_column(:reset_password_token).of_type(:string) }
    it { should have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { should have_db_column(:remember_created_at).of_type(:datetime) }
    it { should have_db_column(:sign_in_count).of_type(:integer) }
    it { should have_db_column(:current_sign_in_at).of_type(:datetime) }
    it { should have_db_column(:last_sign_in_at).of_type(:datetime) }
    it { should have_db_column(:current_sign_in_ip).of_type(:string) }
    it { should have_db_column(:last_sign_in_ip).of_type(:string) }
    it { should have_db_column(:confirmation_token).of_type(:string) }
    it { should have_db_column(:confirmed_at).of_type(:datetime) }
    it { should have_db_column(:confirmation_sent_at).of_type(:datetime) }
    it { should have_db_column(:unconfirmed_email).of_type(:string) }
    it { should have_db_column(:first_name).of_type(:string) }
    it { should have_db_column(:last_name).of_type(:string) }
    it { should have_db_column(:phone).of_type(:string) }
    it { should have_db_column(:job).of_type(:string) }
    it { should have_db_column(:role).of_type(:integer) }
    it { should have_db_column(:platform).of_type(:integer) }
    it { should have_db_column(:photo).of_type(:string) }
    it { should have_db_column(:active).of_type(:boolean) }
    it { should have_db_column(:btp).of_type(:string) }
    it { should have_db_column(:cin).of_type(:string) }
    it { should have_db_column(:rib).of_type(:string) }
    it { should have_db_column(:driving_license).of_type(:string) }
    it { should have_db_column(:type).of_type(:string) }
    it { should have_db_column(:address).of_type(:string) }
    it { should have_db_column(:is_driver).of_type(:boolean) }
    it { should have_db_column(:is_teamleader).of_type(:boolean) }
    it { should have_db_column(:lat).of_type(:float) }
    it { should have_db_column(:long).of_type(:float) }
    it { should have_db_column(:match_ia).of_type(:integer) }
    it { should have_db_column(:identifier).of_type(:string) }
    it { should have_db_column(:current_position_lat).of_type(:float) }
    it { should have_db_column(:current_position_long).of_type(:float) }
  end

  describe "full_name" do
    let!(:user) { create :agent }
    it "return full name" do
      full_name = "#{user.first_name} #{user.last_name}"
      expect(user.full_name).to eq(full_name)
    end
  end
end
