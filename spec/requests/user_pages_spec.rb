require 'spec_helper'

describe "User pages" do
  
  subject { page }

  shared_examples_for "all user pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end
  
  LANGUAGES.transpose.last.each do |locale|
  # locale = 'en'
    
    describe "sign up page" do
      let(:heading)    { t('users.new.sign_up') }
      let(:page_title) { t('users.new.sign_up') }

      before { visit signup_path(locale) }

      it_should_behave_like "all user pages"
    end

    describe "profile page" do
      let(:user) { FactoryGirl.create(:user) }
      let(:heading) { user.name }
      let(:page_title) { user.name }
      
      before { visit user_path(locale, user) }

      it_should_behave_like "all user pages"
    end

    describe "sign up" do
      let(:submit) { t('users.new.create_account') }
      
      before { visit signup_path(locale) }

      context "with invalid information" do
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        context "after submission" do
          let(:heading)    { t('users.new.sign_up') }
          let(:page_title) { t('users.new.sign_up') }

          before { click_button submit }

          it_should_behave_like "all user pages"
          it { should have_alert_message('error') }
        end
      end

      context "with valid information" do
        before { valid_sign_up }

        it "should create a user" do
          expect { click_button submit }.to change(User, :count).by(1)
        end

        context "after saving the user" do
          let(:welcome)  { t('flash.welcome') }
          let(:sign_out) { t('layouts.header.sign_out') }

          before { click_button submit }

          let(:user) { User.find_by_email('user@example.com') }

          # Redirect from signup page to signed in user profile page
          it { should have_selector('title', text: user.name) }
          it { should have_alert_message('success', welcome) }
          it { should have_link sign_out }
        end
      end
    end

    describe "index" do
      let(:user) { FactoryGirl.create(:user) }
      let(:page_title) { t('users.index.all_users') }

      before do
        visit signin_path(locale)
        valid_sign_in user
        visit users_path(locale)
      end

      it { should have_selector('title', text: page_title) }

      describe "pagination" do
        let(:next_page) { t('will_paginate.next_label') }

        before(:all) { 30.times { FactoryGirl.create(:user) } }
        after(:all)  { User.delete_all } 

        it { should have_link(next_page) }
        its(:html) { should match('>2</a>') }

        it "should list each user" do
          User.all[0..2].each do |user|
            page.should have_selector('li', text: user.name)
          end
        end
      end

      describe "delete links" do
        let(:delete) { t('users.user.delete') }
        it { should_not have_link(delete) }

        context "as an admin user" do
          let(:admin) { FactoryGirl.create(:admin) }

          before do
            visit signin_path(locale)
            valid_sign_in(admin)
            visit users_path(locale)
          end

          it { should have_link(delete, href: user_path(locale, User.first)) }
          it "should be able to delete another user" do
            expect { click_link(delete) }.to change(User, :count).by(-1)
          end
          # Shouldn't have delete link to himself
          it { should_not have_link(delete, href: user_path(locale, admin)) }
        end
      end

    end

    describe "edit" do
      let(:user) { FactoryGirl.create(:user) }
      let(:save_changes) { t('users.edit.save_changes') }

      before do
        visit signin_path(locale)
        valid_sign_in(user)
        visit edit_user_path(locale, user)
      end

      describe "page" do
        let(:heading) { t('users.edit.update_profile') }
        let(:page_title) { t('users.edit.edit_user') }
        let(:change) { t('users.edit.change') }

        it_should_behave_like "all user pages"
        it { should have_link(change, href: gravatar_link) }
      end

      context "with invalid information" do
        before { click_button save_changes }

        it { should have_alert_message('error') }
      end

      context "with valid information" do
        let(:new_name) { "New Name" }
        let(:new_email) { "new@example.com" }
        let(:sign_out) { t('layouts.header.sign_out') }
        
        before do
          valid_update(user, new_name, new_email)
          click_button save_changes
        end

        it { should have_selector('title', text: new_name) }
        it { should have_alert_message('success') }
        it { should have_link(sign_out, href: signout_path(locale)) }
        specify { user.reload.name.should == new_name }
        specify { user.reload.email.should == new_email }

      end
      
    end
  end
end
