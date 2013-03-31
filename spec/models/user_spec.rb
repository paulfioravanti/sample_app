# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_email           (email) UNIQUE
#  index_users_on_remember_token  (remember_token)
#

require 'spec_helper'

describe User do

  let(:user) { create(:user) }

  subject { user }

  specify "model attributes" do
    should respond_to(:name)
    should respond_to(:email)
    should respond_to(:password_digest)
    should respond_to(:remember_token)
    should respond_to(:admin)
  end

  specify "accessible attributes" do
    should_not allow_mass_assignment_of(:password_digest)
    should_not allow_mass_assignment_of(:remember_token)
    should_not allow_mass_assignment_of(:admin)
  end

  specify "associations" do
    should have_many(:microposts).dependent(:destroy)
    should have_many(:active_relationships)
                     .class_name("Relationship")
                     .dependent(:destroy)
    should have_many(:followed_users).through(:active_relationships)
    should have_many(:passive_relationships)
                     .class_name("Relationship")
                     .dependent(:destroy)
    should have_many(:followers).through(:passive_relationships)
  end

  specify "virtual attributes/methods from has_secure_password" do
    should respond_to(:password)
    should respond_to(:password_confirmation)
    should respond_to(:authenticate)
  end

  specify "instance methods" do
    should respond_to(:feed).with(0).arguments
    should respond_to(:following?).with(1).argument
    should respond_to(:follow!).with(1).argument
    should respond_to(:unfollow!).with(1).argument
  end

  describe "class level" do
    subject { user.class }
    specify "methods" do
      should respond_to(:authenticate).with(2).arguments
    end
  end

  describe "initial state" do
    it { should be_valid }
    it { should_not be_admin }
    its(:remember_token) { should_not be_blank }
    its(:email) { should_not =~ %r(\p{Upper}) }
  end

  describe "validations" do
    context "for name" do
      it { should validate_presence_of(:name) }
      it { should_not allow_value(" ").for(:name) }
      it { should ensure_length_of(:name).is_at_most(50) }
    end

    context "for email" do
      it { should validate_presence_of(:email) }
      it { should_not allow_value(" ").for(:email) }
      it { should validate_uniqueness_of(:email).case_insensitive }

      context "when email format is invalid" do
        invalid_email_addresses.each do |invalid_address|
          it { should_not allow_value(invalid_address).for(:email) }
        end
      end

      context "when email format is valid" do
        valid_email_addresses.each do |valid_address|
          it { should allow_value(valid_address).for(:email) }
        end
      end
    end

    context "for password" do
      it { should validate_presence_of(:password) }
      it { should ensure_length_of(:password).is_at_least(6) }
      it { should_not allow_value(" ").for(:password) }

      context "when password doesn't match confirmation" do
        it { should_not allow_value("mismatch").for(:password) }
      end
    end

    context "for password_confirmation" do
      it { should validate_presence_of(:password_confirmation) }
    end
  end

  context "when admin attribute set to 'true'" do
    before { user.toggle!(:admin) }
    it { should be_admin }
  end

  describe "#authenticate from has_secure_password" do
    let(:found_user) { User.find_by_email(user.email) }

    context "with valid password" do
      it { should == found_user.authenticate(user.password) }
    end

    context "with invalid password" do
      let(:user_with_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_with_invalid_password }
      specify { user_with_invalid_password.should be_false }
    end
  end

  describe "micropost associations" do
    let!(:older_micropost) do
      create(:micropost, user: user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      create(:micropost, user: user, created_at: 1.hour.ago)
    end

    context "ordered by microposts.created_at DESC" do
      subject { user.microposts }
      it { should == [newer_micropost, older_micropost] }
    end

    context "when user is destroyed" do
      subject { -> { user.destroy } }
      it { should change(Micropost, :count).by(-2) }
    end

    describe "status" do
      let(:unfollowed_post) { create(:micropost, user: create(:user)) }
      let(:followed_user) { create(:user) }

      before do
        user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem Ipsum") }
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end

  describe "#follow!" do
    let(:other_user) { create(:user) }

    before { user.follow!(other_user) }

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "#unfollow!" do
      before { user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(user) }
    end
  end

  describe "relationship associations" do
    let(:other_user) { create(:user) }

    before do
      user.follow!(other_user)
      other_user.follow!(user)
    end

    context "when user is destroyed" do

      describe "behaviour" do
        before { user.destroy }
        its(:active_relationships) { should be_empty }
        its(:passive_relationships) { should be_empty }
      end

      describe "result" do
        subject { -> { user.destroy } }
        it { should change(Relationship, :count).by(-2) }
      end

    end

    context "when a follower/followed user is destroyed" do

      describe "behaviour" do
        subject { other_user }

        before { user.destroy }

        its(:active_relationships) { should_not include(user) }
        its(:passive_relationships) { should_not include(user) }
      end

      describe "result" do
        subject { -> { user.destroy } }
        it { should change(Relationship, :count).by(-2) }
      end
    end
  end
end
