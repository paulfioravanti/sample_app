require 'spec_helper'

describe RelationshipsController do

  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }

  before do
    visit signin_path
    valid_sign_in(user)
  end

  describe "creating a relationship with Ajax" do
    let(:create_relationship) do
      xhr :post, :create, relationship: { followed_id: other_user.id }
    end

    describe "behaviour" do
      before { create_relationship }
      subject { response }
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
      subject { response }
      it { should be_success }
    end

    describe "result" do
      subject { -> { destroy_relationship } }
      it { should change(Relationship, :count).by(-1) }
    end
  end
end