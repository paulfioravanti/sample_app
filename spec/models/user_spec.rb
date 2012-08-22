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

  let(:user) { FactoryGirl.create(:user) }

  subject { user }

  describe "database schema" do
    it do
      should have_db_column(:id).of_type(:integer)
                                .with_options(null: false)
    end
    it { should have_db_column(:name).of_type(:string)            }
    it { should have_db_column(:email).of_type(:string)           }
    it do
      should have_db_column(:created_at).of_type(:datetime)
                                        .with_options(null: false)
    end
    it do
      should have_db_column(:updated_at).of_type(:datetime)
                               .with_options(null: false)
    end
    it { should have_db_column(:password_digest).of_type(:string) }
    it { should have_db_column(:remember_token).of_type(:string)  }
    it do
      should have_db_column(:admin).of_type(:boolean)
                                   .with_options(default: false)
    end
    it { should have_db_index(:email).unique(true)                }
    it { should have_db_index(:remember_token)                    }
  end

  describe "associations" do
    it { should have_many(:microposts).dependent(:destroy)            }
    it { should have_many(:relationships).dependent(:destroy)         }
    it { should have_many(:followed_users).through(:relationships)    }
    it do
      should have_many(:reverse_relationships).class_name("Relationship")
                                              .dependent(:destroy)
    end
    it { should have_many(:followers).through(:reverse_relationships) }
  end

  describe "model attributes" do
    it { should respond_to(:name)                  }
    it { should respond_to(:email)                 }
    it { should respond_to(:password_digest)       }
    it { should respond_to(:remember_token)        }
    it { should respond_to(:admin)                 }
    it { should respond_to(:microposts)            }
    it { should respond_to(:relationships)         }
    it { should respond_to(:followed_users)        }
    it { should respond_to(:reverse_relationships) }
    it { should respond_to(:followers)             }
  end

  describe "virtual attributes and methods from has_secure_password" do
    it { should respond_to(:password)              }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:authenticate)          }
  end

  describe "accessible attributes" do
    it { should_not allow_mass_assignment_of(:password_digest) }
    it { should_not allow_mass_assignment_of(:remember_token)  }
    it { should_not allow_mass_assignment_of(:admin)           }
  end

  describe "instance methods" do
    it { should respond_to(:feed)       }
    it { should respond_to(:following?) }
    it { should respond_to(:follow!)    }
    it { should respond_to(:unfollow!)  }
  end

  describe "initial state" do
    it { should be_valid                       }
    it { should_not be_admin                   }
    its(:remember_token) { should_not be_blank }
    its(:email) { should_not =~ /\p{Upper}/    }
  end

  describe "validations" do
    context "for name" do
      it { should validate_presence_of(:name)            }
      it { should_not allow_value(" ").for(:name)        }
      it { should ensure_length_of(:name).is_at_most(50) }
    end

    context "for email" do
      it { should validate_presence_of(:email)                    }
      it { should_not allow_value(" ").for(:email)                }
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

  describe "return value of authenticate method" do
    let(:found_user) { User.find_by_email(user.email) }

    context "with valid password" do
      it { should == found_user.authenticate(user.password) }
    end

    context "with invalid password" do
      let(:user_with_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_with_invalid_password        }
      specify { user_with_invalid_password.should be_false }
    end
  end

  describe "micropost associations" do
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      subject.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = user.microposts
      user.destroy
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem Ipsum") }
      end

      its(:feed) { should include(newer_micropost)     }
      its(:feed) { should include(older_micropost)     }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }

    before { user.follow!(other_user) }

    it { should be_following(other_user)              }
    its(:followed_users) { should include(other_user) }

    describe "and unfollowing" do
      before { user.unfollow!(other_user) }

      it { should_not be_following(other_user)              }
      its(:followed_users) { should_not include(other_user) }
    end

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(user) }
    end
  end

  describe "relationship associations" do
    let(:other_user) { FactoryGirl.create(:user) }

    before do
      user.follow!(other_user)
      other_user.follow!(user)
    end

    it "should destroy associated relationships" do
      relationships = user.relationships
      user.destroy
      relationships.should be_empty
    end

    it "should destroy associated reverse relationships" do
      reverse_relationships = user.reverse_relationships
      user.destroy
      reverse_relationships.should be_empty
    end

    context "when a follower/followed user is destroyed" do
      subject { other_user }

      before { user.destroy }

      its(:relationships)         { should_not include(user) }
      its(:reverse_relationships) { should_not include(user) }
    end
  end

end
