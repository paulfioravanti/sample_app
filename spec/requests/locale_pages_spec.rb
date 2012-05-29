require 'spec_helper'

describe "Locale switching" do

  subject { page }

  let(:locale_selector) { 'set_locale' }
  let(:locale_submit)   { 'submit' }

  LANGUAGES.transpose.last.each do |locale|

    LANGUAGES.each do |target_language, target_locale|
      next if locale == target_locale

      context "to another language" do
        let(:page_title) { t('layouts.application.base_title') }

        it "should go to the same page in the target language" do
          visit root_path(locale)
          select target_language, from: locale_selector
          click_button locale_submit
          subject.should have_selector('select', text: target_language)
          subject.should have_selector('title', text: page_title)
        end

        specify { I18n.locale.should == target_locale.to_sym }
      end

      context "during pagination" do
        let(:user)      { FactoryGirl.create(:user) }
        let(:next_page) { t('will_paginate.next_label') }

        before(:all) { 30.times { FactoryGirl.create(:user) } }
        after(:all)  { User.delete_all } 

        before do
          visit signin_path(locale)
          valid_sign_in(user)
        end

        it "should go to the same paginated page" do
          visit users_path(locale)
          click_link next_page
          select target_language, from: locale_selector
          click_button locale_submit
          subject.current_url.should =~ /\?page/
          subject.should have_link('2', class: 'active')
        end

      end

      context "after a validation error" do
        context "when failing to create a user" do
          let(:page_title) { t('users.new.sign_up') }
          let(:submit) { t('users.new.create_account') }

          it "should render the new user page in the target language" do
            visit signup_path(locale)
            click_button submit
            select target_language, from: locale_selector
            click_button locale_submit
            expect { response.should redirect_to(signup_path(target_locale)) }
            subject.should have_selector('title', text: page_title)
          end
        end

        context "when failing to update a user" do
          let(:user)   { FactoryGirl.create(:user) }
          let(:page_title) { t('users.edit.edit_user') }
          let(:submit) { t('users.edit.save_changes') }

          before do
            visit signin_path(locale)
            valid_sign_in(user)
          end

          it "should render the edit user page in the target language" do
            visit edit_user_path(locale, user)
            click_button submit
            select target_language, from: locale_selector
            click_button locale_submit
            expect { response.should redirect_to(edit_user_path(target_locale, user)) }
            subject.should have_selector('title', text: page_title)
          end
        end
      end
    end
  end
end
