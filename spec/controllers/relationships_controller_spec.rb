require 'spec_helper'

describe RelationshipsController do

  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }

  subject { response }

  before do
    # Substitute to actually logging in via sign_in_request.
    # The scope of these tests are limited to the relationships
    # controller, so the sessions controller is not accessible
    cookies[:remember_token] = user.remember_token
  end

  describe "creating a relationship with Ajax" do
    let(:create_relationship) do
      xhr :post, :create, relationship: { followed_id: other_user.id }
    end

    describe "behaviour" do
      before { create_relationship }
      it { should be_success }
    end

    describe "result" do
      subject { -> { create_relationship } }
      it { should change(Relationship, :count).by(1) }
    end
  end

  describe "destroying a relationship with Ajax" do
    let(:relationship) do
      user.active_relationships.find_by_followed_id(other_user)
    end
    let(:destroy_relationship) do
      xhr :delete, :destroy, id: relationship.id
    end

    before { user.follow!(other_user) }

    describe "behaviour" do
      before { destroy_relationship }
      it { should be_success }
    end

    describe "result" do
      subject { -> { destroy_relationship } }
      it { should change(Relationship, :count).by(-1) }
    end
  end
end