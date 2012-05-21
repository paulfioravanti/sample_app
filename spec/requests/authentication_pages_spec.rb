require 'spec_helper'

describe "Authentication" do

  subject { page }

  LANGUAGES.transpose.last.each do |locale|

    describe "signin page" do
      let(:sign_in) { t('sessions.new.sign_in') }

      before { visit signin_path(locale) }

      it { should have_selector('h1',    text: sign_in) }
      it { should have_selector('title', text: sign_in) }
    end

    describe "signin" do
      let(:sign_in) { t('sessions.new.sign_in') }  

      before { visit signin_path(locale) }

      context "with invalid information" do
        let(:invalid) { t('flash.invalid_credentials') }

        before { click_button sign_in }

        it { should have_selector('title',      text: sign_in) }
        it { should have_alert_message('error', invalid) }

        context "after visiting another page" do
          let(:home) { t('layouts.header.home') }

          before { click_link home }

          it { should_not have_alert_message('error') }
        end
      end

      context "with valid information" do
        let(:user)     { FactoryGirl.create(:user) }
        let(:sign_in)  { t('layouts.header.sign_in') }
        let(:sign_out) { t('layouts.header.sign_out') }
        let(:profile)  { t('layouts.header.profile') }
        
        before { valid_sign_in(user) }

        it { should have_selector('title', text: user.name) }
        it { should have_link(profile,     href: user_path(locale, user)) }
        it { should have_link(sign_out,    href: signout_path(locale)) }
        it { should_not have_link(sign_in, href: signin_path(locale)) }

        context "followed by sign out" do
          before { click_link sign_out }
          it { should have_link(sign_in) }
        end

      end
    end
  end
end
