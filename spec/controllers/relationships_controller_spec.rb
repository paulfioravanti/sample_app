require 'spec_helper'

describe RelationshipsController do

  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }

  before do
    visit signin_path
    valid_sign_in(user)
  end

  describe "creating a relationship with Ajax" do

    it "increments the Relationship count" do
      expect do
        xhr :post, :create, relationship: { followed_id: other_user.id }
      end.to change(Relationship, :count).by(1)
    end

    it "responds with success" do
      xhr :post, :create, relationship: { followed_id: other_user.id }
      response.should be_success
    end
  end

  describe "destroying a relationship with Ajax" do

    before { user.follow!(other_user) }
    let(:relationship) { user.active_relationships.find_by_followed_id(other_user) }

    it "decrements the Relationship count" do
      expect do
        xhr :delete, :destroy, id: relationship.id
      end.to change(Relationship, :count).by(-1)
    end

    it "responds with success" do
      xhr :delete, :destroy, id: relationship.id
      response.should be_success
    end
  end
end