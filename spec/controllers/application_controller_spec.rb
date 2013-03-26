require 'spec_helper'

describe ApplicationController do
  controller do
    def test_signed_in?
      signed_in?
    end
  end

  let(:user) { create(:user) }

  before do
    # Substitute to actually logging in via sign_in_request.
    cookies[:remember_token] = user.remember_token
  end

  describe "#url_options" do
    subject { controller.url_options }
    it { should have_key(:locale) }
  end

  describe "session hijacking" do
    subject { controller.test_signed_in? }

    context "before #handle_unverified_request called" do
      it { should be_true }
    end

    context "after #handle_unverified_request called" do
      before { controller.handle_unverified_request }
      it { should be_false }
    end
  end
end