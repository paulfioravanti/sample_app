require 'spec_helper'

describe "User pages" do
  
  subject { page }
  
  LANGUAGES.transpose.last.each do |locale|
    
    describe "sign up page" do
      let(:heading)    { t('users.new.sign_up') }
      let(:page_title) { t('users.new.sign_up') }

      before { visit signup_path(locale) }

      it { should have_selector('h1',    text: heading) }
      it { should have_selector('title', text: full_title(page_title)) }
    end

    describe "profile page" do
      let(:user) { FactoryGirl.create(:user) }
      
      before { visit user_path(locale, user) }

      it { should have_selector('h1', text: user.name) }
      it { should have_selector('title', text: user.name) }
    end

    describe "signup page" do
      let(:submit) { t('users.new.create_account') }
      
      before { visit signup_path(locale) }

      context "with invalid information" do
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        context "after submission" do
          let(:page_title) { t('users.new.sign_up') }

          before { click_button submit }

          it { should have_selector('title', text: full_title(page_title)) }
          it { should have_alert_message('error') }
        end
      end

      context "with valid information" do
        before { valid_sign_up }

        it "should create a user" do
          expect { click_button submit }.to change(User, :count).by(1)
        end

        context "after saving the user" do
          let(:user)     { User.find_by_email('user@example.com') }
          let(:welcome)  { t('flash.welcome') }
          let(:sign_out) { t('layouts.header.sign_out') }

          before { click_button submit }

          # Redirect from signup page to signed in user profile page
          it { should have_selector('title', text: user.name) }
          it { should have_alert_message('success', welcome) }
          it { should have_link sign_out }
        end
      end
    end
  end
end
