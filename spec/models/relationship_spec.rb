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

  describe "database schema" do
    it do
      should have_db_column(:id).of_type(:integer).with_options(null: false)
    end
    it do
      should have_db_column(:follower_id).of_type(:integer)
                                         .with_options(null: false)
    end
    it do
      should have_db_column(:followed_id).of_type(:integer)
                                         .with_options(null: false)
    end
    it do
      should have_db_column(:created_at).of_type(:datetime)
                                        .with_options(null: false)
    end
    it do
      should have_db_column(:updated_at).of_type(:datetime)
                                        .with_options(null: false)
    end
    it { should have_db_index(:followed_id)                              }
    it { should have_db_index(:follower_id)                              }
    it { should have_db_index([:follower_id, :followed_id]).unique(true) }
  end

  describe "associations" do
    it { should belong_to(:follower).class_name("User") }
    it { should belong_to(:followed).class_name("User") }
  end

  describe "model attributes" do
    it { should respond_to(:follower)   }
    its(:follower) { should == follower }
    it { should respond_to(:followed)   }
    its(:followed) { should == followed }
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
