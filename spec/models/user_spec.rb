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
#

require 'spec_helper'

describe User do
  
  let(:user) { User.new(name: "Example User", email: "user@example.com",
                        password: "foobar", password_confirmation: "foobar") }

  subject { user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

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
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |invalid_address|
        subject.email = invalid_address
        subject.should_not be_valid
      end
    end
  end

  context "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        subject.email = valid_address
        subject.should be_valid
      end
    end
  end

  context "when email address is already taken" do
    before do
      user_with_same_email = subject.dup
      user_with_same_email.email.upcase!
      user_with_same_email.save
    end
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

end
