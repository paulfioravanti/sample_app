require 'spec_helper'

describe "Application Helper" do

  describe "full title" do

    it "should include the page name" do
      full_title("foo").should =~ /foo/
    end

    it "should include the base name" do
      full_title("foo").should =~ /^#{t('layouts.application.base_title')}/
    end

    it "should not include a bar for the home page" do
      full_title("").should_not =~ /\|/
    end
  end

  describe "gravatar link" do

    it "should return the correct link for gravatars" do
      gravatar_link.should == 'http://gravatar.com/emails'
    end
  end
end