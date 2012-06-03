# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#

require 'spec_helper'

describe User do
  
  let(:user) { valid_user }

  subject { user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  
  it { should respond_to(:authenticate) }
  it { should respond_to(:microposts) }

  it { should be_valid }
  it { should_not be_admin }

  describe "accessible attributes" do
    it "should not allow access to admin" do
      expect do
        User.new(admin: true)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  context "when admin attribute set to 'true'" do
    before { subject.toggle!(:admin) }
    it { should be_admin }
  end

  describe "remember token" do
    before { subject.save }
    its(:remember_token) { should_not be_blank }
  end

  context "when name is not present" do
    before { subject.name = " " }
    it { should_not be_valid }
  end

  context "when name is too long" do
    before { subject.name = "a" * 51 }
    it { should_not be_valid }
  end

  context "when email is not present" do
    before { subject.email = " "}
    it { should_not be_valid }
  end

  context "when email format is invalid" do
    it "should be invalid" do
      invalid_email_addresses.each do |invalid_address|
        subject.email = invalid_address
        subject.should_not be_valid
      end
    end
  end

  context "when email format is valid" do
    it "should be valid" do
      valid_email_addresses.each do |valid_address|
        subject.email = valid_address
        subject.should be_valid
      end
    end
  end

  context "when email address is already taken" do
    before { save_user(subject) }
    it { should_not be_valid }
  end

  context "when password is not present" do
    before { subject.password = subject.password_confirmation = " " }
    it { should_not be_valid }
  end

  context "when password doesn't match confirmation" do
    before { subject.password = "mismatch" }
    it { should_not be_valid }
  end

  context "when password is too short" do
    before { subject.password = "a" * 5 }
    it { should be_invalid }
  end

  context "when password confirmation is nil" do
    before { subject.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { subject.save }
    let(:found_user) { User.find_by_email(subject.email) }

    context "with valid password" do
      it { should == found_user.authenticate(subject.password) }
    end

    context "with invalid password" do
      let(:user_with_invalid_password) { found_user.authenticate("invalid") }
      it { should_not == user_with_invalid_password }
      specify { user_with_invalid_password.should be_false }
    end
  end

  describe "micropost associations" do
    before { subject.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: subject, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: subject, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      subject.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = subject.microposts
      subject.destroy
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end
  end

end
