require 'spec_helper'

describe "Application Helper" do
  
  describe "full title" do
    
    it "should include the page name" do
      full_title("foo").should =~ /foo/
    end

    it "should include the base name" do
      full_title("foo").should =~ /^#{I18n.t('layouts.application.base_title')}/
    end

    it "should not include a bar for the home page" do
      full_title("").should_not =~ /\|/
    end
  end
end