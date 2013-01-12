# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_microposts_on_user_id_and_created_at  (user_id,created_at)
#

#  content    :string          in translations table

require 'spec_helper'

describe Micropost do
  let(:user)      { create(:user) }
  let(:micropost) { build(:micropost, user: user) }

  subject { micropost }

  specify "Globalize3 model attributes" do
    should respond_to(:translations)
    should respond_to(:content)
  end

  specify "accessible attributes" do
    should_not allow_mass_assignment_of(:user)
  end

  describe "associations" do
    it { should belong_to(:user) }
    its(:user) { should == user }
  end

  describe "initial state" do
    it { should be_valid }
  end

  specify "validations" do
    should validate_presence_of(:user)
    should validate_presence_of(:content)
    should_not allow_value(" ").for(:content)
    should ensure_length_of(:content).is_at_most(140)
  end

  # self.from_users_actively_followed_by(user) tested in user_spec status
end
