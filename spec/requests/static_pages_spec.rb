require 'spec_helper'

describe "Static Pages" do

  # full_title method referenced in spec/support/utilties.rb
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  shared_examples_for "all layout link verifications" do
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "layout" do
    before { visit root_path }
    
    context "About link" do
      before { click_link "About" }
      let(:page_title) { 'About Us' }
      
      it_should_behave_like "all layout link verifications"
    end

    context "Help link" do
      before { click_link "Help" }
      let(:page_title) { 'Help' }

      it_should_behave_like "all layout link verifications"
    end

    context "Contact link" do
      before { click_link "Contact" }
      let(:page_title) { 'Contact' }

      it_should_behave_like "all layout link verifications"
    end

    context "Home link" do
      before { click_link "Home" }
      let(:page_title) { '' }

      it_should_behave_like "all layout link verifications"
    end

    context "Sign up link" do
      before { click_link "Sign up now!" }
      let(:page_title) { 'Sign Up' }

      it_should_behave_like "all layout link verifications"
    end
  end
  
  describe "Home page" do
    before { visit root_path }
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector('title', text: '| Home') }
  end

  describe "Help Page" do
    before { visit help_path }
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About Page" do
    before { visit about_path }
    let(:heading) { 'About Us' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact Page" do
    before { visit contact_path }
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

end