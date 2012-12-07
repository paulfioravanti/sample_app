require 'spec_helper'

describe "Locale switching" do

  subject { page }

  I18n.available_locales.each do |locale|

    I18n.available_locales.each do |target_locale|
      next if locale == target_locale

      context "to another language", type: :feature do
        let(:page_title)      { t('layouts.application.base_title') }
        let(:target_language) { t("locale_selector.#{target_locale}") }
        let(:new_language)    { t("locale_selector.#{I18n.locale}") }

        before do
          visit locale_root_path(locale)
          click_link target_language
        end

        it { should have_title(page_title) }
        specify { I18n.locale.should == target_locale.to_sym }
      end

      context "during pagination", type: :feature do
        let(:user)            { create(:user) }
        let(:next_page)       { t('will_paginate.next_label') }
        let(:target_language) { t("locale_selector.#{target_locale}") }

        before(:all) { create_list(:user, 30) }
        after(:all)  { User.delete_all }

        before do
          visit signin_path(locale)
          valid_sign_in(user)
          visit users_path(locale)
          click_link next_page
          click_link target_language
        end

        # it { should have_link('2', class: 'active') }
        it { should have_css("li.active a", text: '2') }
        its(:current_url) { should =~ /\?page/ }

      end

      context "after a validation error" do
        context "when failing to create a micropost" do
          let(:user)            { create(:user) }
          let(:page_title)      { t('layouts.application.base_title') }
          let(:post_button)     { t('shared.micropost_form.post') }
          let(:target_language) { t("locale_selector.#{target_locale}") }

          context "appearance", type: :feature do
            before do
              visit signin_path(locale)
              valid_sign_in(user)
              visit locale_root_path(locale)
              click_button post_button
              click_link target_language
            end
            it { should have_title(page_title) }
          end

          context "behaviour" do
            before do
              sign_in_request(locale, user)
              post microposts_path(locale)
              get locale_root_url(set_locale: target_locale)
            end
            subject { response }
            it { should redirect_to(locale_root_url(target_locale)) }
          end
        end

        context "when failing to create a user" do
          let(:page_title)      { t('users.new.sign_up') }
          let(:submit)          { t('users.new.create_account') }
          let(:target_language) { t("locale_selector.#{target_locale}") }

          context "appearance", type: :feature do
            before do
              visit signup_path(locale)
              click_button submit
              click_link target_language
            end
            it { should have_title(page_title) }
          end

          context "behaviour" do
            before do
              post users_path(locale)
              get signup_path(set_locale: target_locale)
            end
            subject { response }
            it { should redirect_to(signup_url(target_locale)) }
          end
        end

        context "when failing to update a user" do
          let(:user)            { create(:user) }
          let(:page_title)      { t('users.edit.edit_user') }
          let(:submit)          { t('users.edit.save_changes') }
          let(:target_language) { t("locale_selector.#{target_locale}") }

          context "appearance", type: :feature do
            before do
              visit signin_path(locale)
              valid_sign_in(user)
              visit edit_user_path(locale, user)
              click_button submit
              click_link target_language
            end
            it { should have_title(page_title) }
          end

          context "behaviour" do
            before do
              sign_in_request(locale, user)
              put user_path(locale, user)
              get edit_user_path(user, set_locale: target_locale)
            end
            subject { response }
            it { should redirect_to(edit_user_url(target_locale, user)) }
          end
        end
      end
    end
  end
end
