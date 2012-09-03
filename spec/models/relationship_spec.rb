# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer          not null
#  followed_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#

require 'spec_helper'

describe Relationship do

  let(:follower)     { FactoryGirl.create(:user)                              }
  let(:followed)     { FactoryGirl.create(:user)                              }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

  describe "associations" do
    it { should belong_to(:follower).class_name("User") }
    its(:follower) { should == follower                 }
    it { should belong_to(:followed).class_name("User") }
    its(:followed) { should == followed                 }
  end

  describe "model attributes" do

  end

  describe "accessible attributes" do
    it { should_not allow_mass_assignment_of(:follower_id) }
  end

  describe "validations" do
    it { should validate_presence_of(:follower) }
    it { should validate_presence_of(:followed) }
  end

  describe "initial state" do
    it { should be_valid }
  end

end
