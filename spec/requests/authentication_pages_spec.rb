require 'spec_helper'

describe "Authentication" do

  subject { page }

  I18n.available_locales.each do |locale|

    describe "signin page" do
      let(:heading)    { t('sessions.new.sign_in') }
      let(:page_title) { t('sessions.new.sign_in') }

      before { visit signin_path(locale) }

      it { should have_selector('h1',    text: heading)    }
      it { should have_selector('title', text: page_title) }
    end

    describe "signin" do
      let(:user)       { FactoryGirl.create(:user)              }
      let(:users)      { t('layouts.header.users')              }
      let(:page_title) { t('sessions.new.sign_in')              }
      let(:sign_in)    { t('sessions.new.sign_in')              }
      let(:sign_out)   { t('layouts.account_dropdown.sign_out') }
      let(:profile)    { t('layouts.account_dropdown.profile')  }
      let(:settings)   { t('layouts.account_dropdown.settings') }

      before { visit signin_path(locale) }

      it { should have_selector('title',  text: page_title)                   }
      it { should_not have_link(users,    href: users_path(locale))           }
      it { should_not have_link(profile,  href: user_path(locale, user))      }
      it { should_not have_link(settings, href: edit_user_path(locale, user)) }
      it { should_not have_link(sign_out, href: signout_path(locale))         }

      context "with invalid information" do
        let(:invalid) { t('flash.invalid_credentials') }

        before { click_button sign_in }

        it { should have_selector('title',      text: page_title) }
        it { should have_alert_message('error', invalid)          }

        context "after visiting another page" do
          let(:home) { t('layouts.header.home') }

          before { click_link home }

          it { should_not have_alert_message('error') }
        end
      end

      context "with valid information" do
        let(:sign_in)  { t('layouts.header.sign_in') }

        before do
          visit signin_path(locale)
          valid_sign_in(user)
        end

        it { should have_selector('title', text: user.name)                   }
        it { should have_link(users,       href: users_path(locale))          }
        it { should have_link(profile,     href: user_path(locale, user))     }
        it { should have_link(settings,   href: edit_user_path(locale, user)) }
        it { should have_link(sign_out,    href: signout_path(locale))        }
        it { should_not have_link(sign_in, href: signin_path(locale))         }

        context "followed by sign out" do
          before { click_link sign_out }
          it { should have_link(sign_in) }
        end
      end
    end

    describe "authorization" do

      context "for non-signed-in users" do
        let(:user) { FactoryGirl.create(:user) }

        context "when attempting to visit a protected page" do
          before do
            visit edit_user_path(locale, user)
            valid_sign_in(user)
          end

          context "after signing in" do
            let(:page_title) { t('users.edit.edit_user') }

            it "should render to desired protected page" do
              subject.should have_selector('title', text: page_title)
            end

            context "when signing in again" do
              let(:sign_out)  { t('layouts.account_dropdown.sign_out') }
              let(:sign_in)   { t('layouts.header.sign_in')            }

              before do
                click_link sign_out
                click_link sign_in
                valid_sign_in user
              end

              it "should render the default (profile) page" do
                subject.should have_selector('title', text: user.name)
              end
            end
          end
        end

        context "in the Users controller" do

          context "visting the edit page" do
            let(:page_title) { t('sessions.new.sign_in') }
            let(:sign_in)    { t('flash.sign_in')        }

            before { visit edit_user_path(locale, user) }

            it { should have_selector('title', text: page_title) }
            it { should have_alert_message('notice', sign_in)    }
          end

          context "submitting to the update action" do
            before { put user_path(locale, user) }
            specify { response.should redirect_to(signin_url(locale)) }
          end

          context "visiting the user index" do
            let(:page_title) { t('sessions.new.sign_in') }

            before { visit users_path(locale) }
            it { should have_selector('title', text: page_title) }
          end

          context "visiting the following page" do
            let(:sign_in) { t('sessions.new.sign_in') }

            before { visit following_user_path(locale, user) }
            it { should have_selector('title', text: sign_in)}
          end

          context "visiting the followers page" do
            let(:sign_in) { t('sessions.new.sign_in') }

            before { visit followers_user_path(locale, user) }
            it { should have_selector('title', text: sign_in)}
          end
        end

        context "in the Microposts controller" do

          context "submitting to the create action" do
            before { post microposts_path(locale) }
            specify { response.should redirect_to(signin_url(locale)) }
          end

          context "submitting to the destroy action" do
            before do
              delete micropost_path(locale, FactoryGirl.create(:micropost))
            end
            specify { response.should redirect_to(signin_url(locale)) }
          end
        end

        context "in the Relationships controller" do

          describe "submitting to the create action" do
            before { post relationships_path(locale) }
            specify { response.should redirect_to(signin_url(locale)) }
          end

          describe "submitting to the destroy action" do
            before { delete relationship_path(locale, 1) }
            specify { response.should redirect_to(signin_url(locale)) }
          end
        end
      end

      context "for signed-in users" do
        let(:user) { FactoryGirl.create(:user) }

        before do
          visit signin_path(locale)
          valid_sign_in(user)
        end

        context "visiting the signup path" do
          before { get signup_path(locale) }

          specify { response.should redirect_to(locale_root_url(locale)) }
        end

        context "submitting a POST request to the Users#create action" do
          before { post users_path(locale) }

          specify { response.should redirect_to(locale_root_url(locale)) }
        end

      end

      context "as a wrong user" do
        let(:user)       { FactoryGirl.create(:user)                        }
        let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@eg.com") }

        before do
          visit signin_path(locale)
          valid_sign_in(user)
        end

        context "visiting Users#edit page" do
          let(:page_title) { t('users.edit.edit_user') }

          before { visit edit_user_path(locale, wrong_user) }

          it do
            should_not have_selector('title', text: full_title(page_title))
          end
        end

        context "submitting a PUT request to the Users#update action" do
          before { put user_path(locale, wrong_user) }

          specify { response.should redirect_to(locale_root_url(locale)) }
        end
      end

      context "as a non-admin user" do
        let(:user)      { FactoryGirl.create(:user) }
        let(:non_admin) { FactoryGirl.create(:user) }

        before do
          visit signin_path(locale)
          valid_sign_in(non_admin)
        end

        context "submitting a DELETE request to the Users#destroy action" do
          before { delete user_path(locale, user) }
          specify { response.should redirect_to(locale_root_url(locale)) }
        end
      end

      context "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }

        before do
          visit signin_path(locale)
          valid_sign_in(admin)
        end

        context "should prevent admin users from destroying themselves" do
          it "should not delete the user" do
            expect do
              delete user_path(locale, admin)
            end.not_to change(User, :count)
          end

          context "after failing to delete" do
            let(:no_suicide) { t('flash.no_admin_suicide', name: admin.name) }

            before { delete user_path(locale, admin) }
            specify do
              response.should redirect_to(users_url(locale)),
                                          flash[:error].should == no_suicide
            end
          end
        end
      end
    end
  end
end
