require 'spec_helper'

describe ApplicationHelper do
  describe "full title" do
    it "includes the page name" do
      full_title("foo").should =~ /foo/
    end

    it "includes the base name" do
      full_title("foo").should =~ /^#{t('layouts.application.base_title')}/
    end

    it "does not include a bar for the home page" do
      full_title("").should_not =~ /\|/
    end
  end

  describe "gravatar link" do
    it "returns the correct link for gravatars" do
      gravatar_link.should == 'http://gravatar.com/emails'
    end
  end
end