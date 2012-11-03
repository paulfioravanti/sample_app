require 'spec_helper'

describe "Authentication" do

  subject { page }

  I18n.available_locales.each do |locale|

    describe "signin page" do
      let(:heading)    { t('sessions.new.sign_in') }
      let(:page_title) { t('sessions.new.sign_in') }

      before { visit signin_path(locale) }

      it { should have_selector('h1',    text: heading) }
      it { should have_selector('title', text: page_title) }
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

      it { should have_selector('title',  text: page_title) }
      it { should_not have_link(users,    href: users_path(locale)) }
      it { should_not have_link(profile,  href: user_path(locale, user)) }
      it { should_not have_link(settings, href: edit_user_path(locale, user)) }
      it { should_not have_link(sign_out, href: signout_path(locale)) }

      context "with invalid information" do
        let(:invalid) { t('flash.invalid_credentials') }

        before { click_button sign_in }

        it { should have_selector('title',      text: page_title) }
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
          visit signin_path(locale)
          valid_sign_in(user)
        end

        it { should have_selector('title', text: user.name) }
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
            valid_sign_in(user)
          end

          context "after signing in" do
            let(:page_title) { t('users.edit.edit_user') }

            it "renders the desired protected page" do
              page.should have_selector('title', text: page_title)
            end

            context "when signing in again" do
              let(:sign_out) { t('layouts.account_dropdown.sign_out') }
              let(:sign_in)  { t('layouts.header.sign_in') }

              before do
                click_link sign_out
                click_link sign_in
                valid_sign_in user
              end

              it "renders the default (profile) page" do
                page.should have_selector('title', text: user.name)
              end
            end
          end
        end

        context "in the UsersController" do

          context "GET Users#edit" do
            let(:page_title) { t('sessions.new.sign_in') }
            let(:sign_in)    { t('flash.sign_in') }

            before { visit edit_user_path(locale, user) }

            it { should have_selector('title', text: page_title) }
            it { should have_alert_message('notice', sign_in) }
          end

          context "PUT Users#update" do
            before { put user_path(locale, user) }
            specify { response.should redirect_to(signin_url(locale)) }
          end

          context "GET Users#index" do
            let(:page_title) { t('sessions.new.sign_in') }

            before { visit users_path(locale) }
            it { should have_selector('title', text: page_title) }
          end

          context "GET Users#following" do
            let(:sign_in) { t('sessions.new.sign_in') }

            before { visit following_user_path(locale, user) }
            it { should have_selector('title', text: sign_in) }
          end

          context "GET Users#followers" do
            let(:sign_in) { t('sessions.new.sign_in') }

            before { visit followers_user_path(locale, user) }
            it { should have_selector('title', text: sign_in)}
          end
        end

        context "in the MicropostsController" do

          context "POST Microposts#create" do
            before { post microposts_path(locale) }
            specify { response.should redirect_to(signin_url(locale)) }
          end

          context "DELETE Microposts#destroy" do
            before do
              delete micropost_path(locale, create(:micropost))
            end
            specify { response.should redirect_to(signin_url(locale)) }
          end
        end

        context "in the RelationshipsController" do

          describe "POST Relationships#create" do
            before { post relationships_path(locale) }
            specify { response.should redirect_to(signin_url(locale)) }
          end

          describe "DELETE Relationships#destroy" do
            before { delete relationship_path(locale, 1) }
            specify { response.should redirect_to(signin_url(locale)) }
          end
        end
      end

      context "for signed-in users" do
        let(:user) { create(:user) }

        before do
          visit signin_path(locale)
          valid_sign_in(user)
        end

        context "GET Users#new" do
          before { get signup_path(locale) }

          specify { response.should redirect_to(locale_root_url(locale)) }
        end

        context "POST Users#create" do
          before { post users_path(locale) }

          specify { response.should redirect_to(locale_root_url(locale)) }
        end

      end

      context "as a wrong user" do
        let(:user)       { create(:user) }
        let(:wrong_user) { create(:user, email: "wrong@eg.com") }

        before do
          visit signin_path(locale)
          valid_sign_in(user)
        end

        context "GET Users#edit" do
          let(:page_title) { t('users.edit.edit_user') }

          before { visit edit_user_path(locale, wrong_user) }

          it do
            should_not have_selector('title', text: full_title(page_title))
          end
        end

        context "PUT Users#update" do
          before { put user_path(locale, wrong_user) }

          specify { response.should redirect_to(locale_root_url(locale)) }
        end
      end

      context "as a non-admin user" do
        let(:user)      { create(:user) }
        let(:non_admin) { create(:user) }

        before do
          visit signin_path(locale)
          valid_sign_in(non_admin)
        end

        context "DELETE Users#destroy" do
          before { delete user_path(locale, user) }
          specify { response.should redirect_to(locale_root_url(locale)) }
        end
      end

      context "as an admin user" do
        let(:admin) { create(:admin) }

        before do
          visit signin_path(locale)
          valid_sign_in(admin)
        end

        context "prevents admin users from destroying themselves" do
          let(:delete_admin) { delete user_path(locale, admin) }

          context "behaviour" do
            let(:no_suicide) { t('flash.no_admin_suicide', name: admin.name) }

            subject { response }

            before { delete_admin }

            it do
              should redirect_to(users_url(locale)),
                                 flash[:error].should == no_suicide
            end
          end

          describe "result" do
            subject { -> { delete_admin } }
            it { should_not change(User, :count) }
          end
        end
      end
    end
  end
end
