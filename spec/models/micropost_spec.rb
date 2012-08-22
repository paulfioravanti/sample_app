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
  let(:user)      { FactoryGirl.create(:user)                 }
  let(:micropost) { FactoryGirl.build(:micropost, user: user) }

  subject { micropost }

  describe "database schema" do
    it do
      should have_db_column(:id).of_type(:integer).with_options(null: false)
    end
    it do
      should have_db_column(:user_id).of_type(:integer)
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
    it { should have_db_index([:user_id, :created_at]) }
  end

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "model attributes" do
    it { should respond_to(:user) }
    its(:user) { should == user }

    context "for Globalize3 translations" do
      it { should respond_to(:translations) }
      it { should respond_to(:content)      }
    end
  end

  describe "accessible attributes" do
    it { should_not allow_mass_assignment_of(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:user)                }
    it { should validate_presence_of(:content)             }
    it { should_not allow_value(" ").for(:content)         }
    it { should ensure_length_of(:content).is_at_most(140) }
  end

  describe "initial state" do
    it { should be_valid }
  end

end
