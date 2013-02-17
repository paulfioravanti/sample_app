require 'spec_helper'

describe "Authentication on UI" do

  subject { page }

  I18n.available_locales.each do |locale|

    describe "signin page" do
      let(:heading)    { t('sessions.new.sign_in') }
      let(:page_title) { t('sessions.new.sign_in') }

      before { visit signin_path(locale) }

      it { should have_selector('h1', text: heading) }
      it { should have_title(page_title) }
    end

    describe "signin" do
      let(:user)       { create(:user) }
      let(:users)      { t('layouts.header.users') }
      let(:page_title) { t('sessions.new.sign_in') }
      let(:sign_in)    { t('sessions.new.sign_in') }
      let(:sign_out)   { t('layouts.account_dropdown.sign_out') }
      let(:profile)    { t('layouts.account_dropdown.profile')  }
      let(:settings)   { t('layouts.account_dropdown.settings') }

      before { visit signin_path(locale) }

      it { should have_title(page_title) }
      it { should_not have_link(users,    href: users_path(locale)) }
      it { should_not have_link(profile,  href: user_path(locale, user)) }
      it { should_not have_link(settings, href: edit_user_path(locale, user)) }
      it { should_not have_link(sign_out, href: signout_path(locale)) }

      context "with invalid information" do
        let(:invalid) { t('flash.invalid_credentials') }

        before { click_button sign_in }

        it { should have_title(page_title) }
        it { should have_alert_message('error', invalid) }

        context "after visiting another page" do
          let(:home) { t('layouts.header.home') }
          before { click_link home }
          it { should_not have_alert_message('error') }
        end
      end

      context "with valid information" do
        let(:sign_in) { t('layouts.header.sign_in') }

        before do
          sign_in_through_ui(user)
        end

        it { should have_title(user.name) }
        it { should have_link(users, href: users_path(locale)) }
        it { should have_link(profile, href: user_path(locale, user)) }
        it { should have_link(settings, href: edit_user_path(locale, user)) }
        it { should have_link(sign_out, href: signout_path(locale)) }
        it { should_not have_link(sign_in, href: signin_path(locale)) }

        context "followed by sign out" do
          before { click_link sign_out }
          it { should have_link(sign_in) }
        end
      end
    end

    describe "authorization" do

      context "for non-signed-in users" do
        let(:user) { create(:user) }

        context "when attempting to visit a protected page" do
          before do
            visit edit_user_path(locale, user)
            sign_in_through_ui(user)
          end

          context "after signing in" do
            let(:page_title) { t('users.edit.edit_user') }

            it "renders the desired protected page" do
              page.should have_title(page_title)
            end

            context "when signing in again" do
              let(:sign_out) { t('layouts.account_dropdown.sign_out') }
              let(:sign_in)  { t('layouts.header.sign_in') }

              before do
                click_link sign_out
                click_link sign_in
                sign_in_through_ui(user)
              end

              it "renders the default (profile) page" do
                page.should have_title(user.name)
              end
            end
          end
        end

        context "in the UsersController" do

          context "visiting Users#edit" do
            let(:page_title) { t('sessions.new.sign_in') }
            let(:sign_in)    { t('flash.sign_in') }

            before { visit edit_user_path(locale, user) }

            it { should have_title(page_title) }
            it { should have_alert_message('notice', sign_in) }
          end

          context "visiting Users#index" do
            let(:page_title) { t('sessions.new.sign_in') }
            before { visit users_path(locale) }
            it { should have_title(page_title) }
          end

          context "visiting Users#following" do
            let(:sign_in) { t('sessions.new.sign_in') }
            before { visit following_user_path(locale, user) }
            it { should have_title(sign_in) }
          end

          context "visiting Users#followers" do
            let(:sign_in) { t('sessions.new.sign_in') }
            before { visit followers_user_path(locale, user) }
            it { should have_title(sign_in) }
          end
        end
      end

      context "as a wrong user" do
        let(:user)       { create(:user) }
        let(:wrong_user) { create(:user, email: "wrong@eg.com") }
        let(:sign_in)  { t('layouts.header.sign_in') }

        before do
          visit locale_root_path(locale)
          click_link sign_in
          sign_in_through_ui(user)
        end

        context "visiting Users#edit" do
          let(:page_title) { full_title(t('users.edit.edit_user')) }
          before { visit edit_user_path(locale, wrong_user) }
          it { should_not have_title(page_title) }
        end
      end
    end
  end
end
