require 'spec_helper'

describe "Authentication" do

  subject { page }

  LANGUAGES.transpose.last.each do |locale|

    describe "signin page" do
      before { visit signin_path(locale) }

      it { should have_selector('h1', text: t('sessions.new.sign_in')) }
      it { should have_selector('title', text: t('sessions.new.sign_in')) }
    end

    describe "signin" do
      before { visit signin_path(locale) }

      context "with invalid information" do
        before { click_button t('sessions.new.sign_in') }

        it { should have_selector('title', text: t('sessions.new.sign_in')) }
        it { should have_alert_message('error', t('flash.invalid_credentials')) }

        context "after visiting another page" do
          before { click_link t('layouts.header.home') }

          it { should_not have_alert_message('error') }
        end
      end

      context "with valid information" do
        let(:user) { FactoryGirl.create(:user) }
        before { valid_sign_in(user) }

        it { should have_selector('title', text: user.name) }
        it { should have_link(t('layouts.header.profile'), 
          href: user_path(locale, user)) }
        it { should have_link(t('layouts.header.sign_out'), 
          href: signout_path(locale)) }
        it { should_not have_link(t('layouts.header.sign_in'), 
          href: signin_path(locale)) }

        context "followed by sign out" do
          before { click_link t('layouts.header.sign_out') }
          it { should have_link(t('layouts.header.sign_in')) }
        end

      end
    end
  end
end
