require 'spec_helper'

describe "User pages" do
  
  subject { page }
  
  LANGUAGES.transpose.last.each do |locale|
    
    describe "sign up page" do
      before { visit signup_path(locale) }

      it { should have_selector('h1',    text: I18n.t('users.new.sign_up')) }
      it { should have_selector('title', text: full_title(I18n.t('users.new.sign_up'))) }
    end

    describe "profile page" do
      let(:user) { FactoryGirl.create(:user) }
      before { visit user_path(locale, user) }

      it { should have_selector('h1', text: user.name) }
      it { should have_selector('title', text: user.name) }
    end

    describe "signup page" do
      before { visit signup_path(locale) }
      let(:submit) { I18n.t('users.new.create_account') }

      context "with invalid information" do
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "error messages" do
          before { click_button submit }
          it { should have_selector('title', text: full_title(I18n.t('users.new.sign_up'))) }
          it { should have_selector('div.alert.alert-error') }
        end
      end

      context "with valid information" do
        before do
          fill_in I18n.t('users.new.name'), with: "Example User"
          fill_in I18n.t('users.new.email'), with: "user@example.com"
          fill_in I18n.t('users.new.password'), with: "foobar"
          fill_in I18n.t('users.new.confirmation'), with: "foobar"
        end

        it "should create a user" do
          expect { click_button submit }.to change(User, :count).by(1)
        end

        context "after saving the user" do
          before { click_button submit }
          let(:user) { User.find_by_email('user@example.com') }

          # Should have been redirected from signup page to profile page
          it { should have_selector('title', text: user.name) }
          it { should have_selector('div.alert.alert-success', text: I18n.t('flash.welcome'))}
        end
      end
    end
  end
end
