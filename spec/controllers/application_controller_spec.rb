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

  describe "#handle_unverified_request" do
    let(:signed_in) { controller.test_signed_in? }

    context "before session hijack" do
      specify "user should be signed in" do
        signed_in.should be_true
      end
    end

    context "after session hijack" do
      before { controller.handle_unverified_request }
      specify "user should be signed out" do
        signed_in.should be_false
      end
    end
  end
end