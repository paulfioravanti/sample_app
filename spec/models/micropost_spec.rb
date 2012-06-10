# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Micropost do
  let(:user)      { FactoryGirl.create(:user) }
  let(:micropost) { valid_micropost(user) }

  subject { micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Micropost.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  context "when user id is not present" do
    before { micropost.user_id = nil }
    it { should_not be_valid }
  end

  context "with blank content" do
    before { micropost.content = " " }
    it { should_not be_valid }
  end

  context "with content that is too long" do
    before { micropost.content = "a" * 141 }
    it { should_not be_valid }
  end

end
