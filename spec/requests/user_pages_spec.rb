require 'spec_helper'

describe "User pages" do
  
  subject { page }

  shared_examples_for "all user pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end
  
  I18n.available_locales.each do |locale|

    describe "index" do
      let(:user)       { FactoryGirl.create(:user) }
      let(:page_title) { t('users.index.all_users') }

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all } 

      before do
        visit signin_path(locale)
        valid_sign_in user
        visit users_path(locale)
      end

      it { should have_selector('title', text: page_title) }

      describe "pagination" do
        let(:next_page) { t('will_paginate.next_label') }

        it { should have_link(next_page) }
        its(:html) { should match('>2</a>') }

        it "should list each user" do
          User.all[0..2].each do |user|
            # Each name should be a link (li>a)
            page.should have_selector('li>a', text: user.name)
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
    
    describe "sign up page" do
      let(:heading)    { t('users.new.sign_up') }
      let(:page_title) { t('users.new.sign_up') }

      before { visit signup_path(locale) }

      it_should_behave_like "all user pages"
    end

    describe "profile page" do
      let(:user)       { FactoryGirl.create(:user) }
      let!(:m1)        { FactoryGirl.create(:micropost, 
                                            user: user, 
                                            content: "Foo") }
      let!(:m2)        { FactoryGirl.create(:micropost, 
                                            user: user, 
                                            content: "Bar") }
      let(:heading)    { user.name }
      let(:page_title) { user.name }
      
      before { visit user_path(locale, user) }

      it_should_behave_like "all user pages"

      describe "microposts" do
        it { should have_content(m1.content) }
        it { should have_content(m2.content) }
        it { should have_content(user.microposts.count) }
      end

      describe "follow/unfollow buttons" do
        let(:other_user) { FactoryGirl.create(:user) }
        let(:follow) { t('users.follow.follow') }
        let(:unfollow) { t('users.unfollow.unfollow') }
        
        before do
          visit signin_path(locale)
          valid_sign_in(user)
        end

        describe "following a user" do
          before { visit user_path(locale, other_user) }

          it "should increment the followed user count" do
            expect do
              click_button follow
            end.to change(user.followed_users, :count).by(1)
          end

          it "should increment the other user's followers count" do
            expect do
              click_button follow
            end.to change(other_user.followers, :count).by(1)
          end

          describe "toggling the button" do
            before { click_button follow }
            it { should have_selector('input', value: unfollow) }
          end
        end

        describe "unfollowing a user" do
          before do
            user.follow!(other_user)
            visit user_path(locale, other_user)
          end

          it "should decrement the followed user count" do
            expect do
              click_button unfollow
            end.to change(user.followed_users, :count).by(-1)
          end

          it "should decrement the other user's followers count" do
            expect do
              click_button unfollow
            end.to change(other_user.followers, :count).by(-1)
          end

          describe "toggling the button" do
            before { click_button unfollow }
            it { should have_selector('input', value: follow) }
          end
        end
      end

      describe "user stats" do
        let(:other_user) { FactoryGirl.create(:user) }
        
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

    describe "edit" do
      let(:user) { FactoryGirl.create(:user) }
      let(:save_changes) { t('users.edit.save_changes') }

      before do
        visit signin_path(locale)
        valid_sign_in(user)
        visit edit_user_path(locale, user)
      end

      describe "page" do
        let(:heading)    { t('users.edit.update_profile') }
        let(:page_title) { t('users.edit.edit_user') }
        let(:change)     { t('users.edit.change') }

        it_should_behave_like "all user pages"
        it { should have_link(change, href: gravatar_link) }
      end

      context "with invalid information" do
        before { click_button save_changes }

        it { should have_alert_message('error') }
      end

      context "with valid information" do
        let(:new_name)  { "New Name" }
        let(:new_email) { "new@example.com" }
        let(:sign_out)  { t('layouts.header.sign_out') }
        
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

    describe "following/followers" do
      let(:user)       { FactoryGirl.create(:user) }
      let(:other_user) { FactoryGirl.create(:user) }
      
      before { user.follow!(other_user) }

      describe "followed users" do
        let(:following) { t('users.show_follow.following') }

        before do
          visit signin_path(locale)
          valid_sign_in(user)
          visit following_user_path(locale, user)
        end

        it { should have_selector('title', text: full_title(following)) }
        it { should have_selector('h3', text: following) }
        it { should have_link(other_user.name, 
                              href: user_path(locale, other_user)) }
      end

      describe "followers" do
        let(:followers) { t('users.show_follow.followers') }

        before do
          visit signin_path(locale)
          valid_sign_in(other_user)
          visit followers_user_path(locale, other_user)
        end

        it { should have_selector('title', text: full_title(followers)) }
        it { should have_selector('h3', text: followers) }
        it { should have_link(user.name, href: user_path(locale, user)) }
      end
    end
  end
end
