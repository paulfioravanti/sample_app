require 'spec_helper'

describe "UserPages" do
  
  subject { page }
  
  LANGUAGES.each do |lang, locale|
    describe "sign up page" do
      before { visit signup_path(I18n.locale) }

      it { should have_selector('h1',    text: I18n.t('users.new.sign_up')) }
      it { should have_selector('title', text: full_title(I18n.t('users.new.sign_up'))) }
    end
  end
end
