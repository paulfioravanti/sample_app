require 'spec_helper'

describe "User Pages on UI" do

  subject { page }

  shared_examples_for "a user page" do
    it { should have_selector('h1', text: heading) }
    its(:source) { should have_selector('title', text: page_title) }
  end

  I18n.available_locales.each do |locale|

    describe "index" do
      let(:user)       { create(:user) }
      let(:page_title) { full_title(t('users.index.all_users')) }

      before(:all) { create_list(:user, 30) }
      after(:all)  { User.delete_all }

      before do
        visit signin_path(locale)
        sign_in_through_ui(user)
        visit users_path(locale)
      end

      its(:source) { should have_selector('title', text: page_title) }

      describe "pagination" do
        let(:first_page)  { User.paginate(page: 1) }
        let(:second_page) { User.paginate(page: 2) }
        let(:next_page) { t('will_paginate.next_label') }

        it { should have_selector('div.pagination') }
        it { should have_link(next_page) }
        its(:html) { should match('>2</a>') }

        describe "first page" do
          it "lists the first page of users" do
            first_page[0..2].each do |user|
              # Each name should be a link (li>a)
              page.should have_selector('li>a', text: user.name)
            end
          end

          it "does not list the second page of users" do
            second_page[0..2].each do |user|
              page.should_not have_selector('li>a', text: user.name)
            end
          end
        end

        describe "second page" do
          before { visit users_path(locale, page: 2) }

          it "should list the second page of users" do
            second_page[0..2].each do |user|
              page.should have_selector('li>a', text: user.name)
            end
          end
        end
      end

      describe "delete links" do
        let(:delete_link) { t('users.user.delete') }

        it { should_not have_link(delete_link) }

        context "as an admin user" do
          let(:admin) { create(:admin) }

          before do
            visit signin_path(locale)
            sign_in_through_ui(admin)
            visit users_path(locale)
          end

          specify "appearance" do
            should have_link(delete_link,
                             href: user_path(locale, User.first))
            # Shouldn't have delete link to himself
            should_not have_link(delete_link,
                                 href: user_path(locale, admin))
          end
        end
      end
    end

    describe "sign up page" do
      let(:heading)    { t('users.new.sign_up') }
      let(:page_title) { full_title(t('users.new.sign_up')) }

      before { visit signup_path(locale) }

      it_should_behave_like "a user page"
    end

    describe "profile page" do
      let(:user) { create(:user) }
      let!(:m1) { create(:micropost, user: user, content: "Foo") }
      let!(:m2) { create(:micropost, user: user, content: "Bar") }
      let(:heading)    { user.name }
      let(:page_title) { full_title(user.name) }

      before { visit user_path(locale, user) }

      it_should_behave_like "a user page"

      describe "microposts" do
        it { should have_content(m1.content) }
        it { should have_content(m2.content) }
        it { should have_content(user.microposts.count) }
      end

      describe "follow/unfollow buttons" do
        let(:other_user) { create(:user) }
        let(:follow)     { t('users.follow.follow') }
        let(:unfollow)   { t('users.unfollow.unfollow') }

        before do
          visit signin_path(locale)
          sign_in_through_ui(user)
        end

        describe "following a user" do
          before { visit user_path(locale, other_user) }

          describe "incrementing following/follower counts" do
            subject { -> { click_button follow } }
            it { should change(user.followed_users, :count).by(1) }
            it { should change(other_user.followers, :count).by(1) }
          end

          describe "toggling the button" do
            before { click_button follow }
            it { should have_button(unfollow) }
          end
        end

        describe "unfollowing a user" do
          before do
            user.follow!(other_user)
            visit user_path(locale, other_user)
          end

          describe "decrementing following/follower counts" do
            subject { -> { click_button unfollow } }
            it { should change(user.followed_users, :count).by(-1) }
            it { should change(other_user.followers, :count).by(-1) }
          end

          describe "toggling the button" do
            before { click_button unfollow }
            it { should have_button(follow) }
          end
        end
      end

      describe "user stats" do
        let(:other_user) { create(:user) }

        before do
          user.follow!(other_user)
          other_user.follow!(user)
          visit user_path(locale, user)
        end

        it { should have_selector('#following.stat', text: '1') }
        it { should have_selector('#followers.stat', text: '1') }

        context "after unfollowing other user" do
          before do
            user.unfollow!(other_user)
            visit user_path(locale, user)
          end

          it { should have_selector('#following.stat', text: '0') }
        end

        describe "after being unfollowed by other user" do
          before do
            other_user.unfollow!(user)
            visit user_path(locale, user)
          end

          it { should have_selector('#followers.stat', text: '0') }
        end
      end
    end

    describe "sign up" do
      let(:submit) { t('users.new.create_account') }
      let(:click_submit) { click_button submit }

      before { visit signup_path(locale) }

      context "with invalid information" do

        describe "appearance" do
          let(:heading)    { t('users.new.sign_up') }
          let(:page_title) { full_title(t('users.new.sign_up')) }

          before { click_submit }

          it_should_behave_like "a user page"
          it { should have_alert_message('error') }
        end

        describe "result" do
          subject { -> { click_submit } }
          it { should_not change(User, :count) }
        end
      end

      context "with valid information" do
        let(:new_user) { build(:user) }

        before { fill_in_fields(new_user) }

        describe "appearance" do
          let(:welcome)  { t('flash.welcome') }
          let(:sign_out) { t('layouts.account_dropdown.sign_out') }
          let(:user) { User.find_by_email("#{new_user.email.downcase}") }

          before { click_submit }

          # Redirect from signup page to signed in user profile page
          its(:source) { should have_selector('title', text: user.name) }
          it { should have_alert_message('success', welcome) }
          it { should have_link sign_out }
        end

        describe "result" do
          subject { -> { click_submit } }
          it { should change(User, :count).by(1) }
        end
      end
    end

    describe "edit" do
      let(:user)         { create(:user) }
      let(:save_changes) { t('users.edit.save_changes') }

      before do
        visit signin_path(locale)
        sign_in_through_ui(user)
        visit edit_user_path(locale, user)
      end

      describe "page" do
        let(:heading)    { t('users.edit.update_profile') }
        let(:page_title) { full_title(t('users.edit.edit_user')) }
        let(:change)     { t('users.edit.change') }

        it_should_behave_like "a user page"
        it { should have_link(change, href: gravatar_link) }
      end

      context "with invalid information" do
        before { click_button save_changes }

        it { should have_alert_message('error') }
      end

      context "with valid information" do
        let(:new_name)  { "New Name" }
        let(:new_email) { "new@example.com" }
        let(:sign_out)  { t('layouts.account_dropdown.sign_out') }

        before do
          fill_in_fields(user, new_name, new_email)
          click_button save_changes
        end

        its(:source) { should have_selector('title', text: new_name) }
        it { should have_alert_message('success') }
        it { should have_link(sign_out, href: signout_path(locale)) }

        context "after save" do
          subject { user.reload }
          its(:name) { should == new_name }
          its(:email) { should == new_email }
        end
      end
    end

    describe "following/followers" do
      let(:user)            { create(:user) }
      let(:user_link)       { user_path(locale, user) }
      let(:other_user)      { create(:user) }
      let(:other_user_link) { user_path(locale, other_user) }

      before { user.follow!(other_user) }

      describe "followed users" do
        let(:following) { t('users.show_follow.following') }

        before do
          visit signin_path(locale)
          sign_in_through_ui(user)
          visit following_user_path(locale, user)
        end

        its(:source) { should have_selector('title', text: following) }
        it { should have_selector('h3', text: following) }
        it { should have_link(other_user.name, href: other_user_link) }
      end

      describe "followers" do
        let(:followers) { t('users.show_follow.followers') }

        before do
          visit signin_path(locale)
          sign_in_through_ui(other_user)
          visit followers_user_path(locale, other_user)
        end

        its(:source) { should have_selector('title', text: followers) }
        it { should have_selector('h3', text: followers) }
        it { should have_link(user.name, href: user_link) }
      end
    end
  end
end