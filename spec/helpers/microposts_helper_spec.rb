require 'spec_helper'

describe MicropostsHelper do

  describe "wrap" do
    context "short strings" do
      let(:short_string) { "a" * 5 }

      it "should not insert zero width spaces" do
        wrap(short_string).should_not =~ /&#8203;/
      end
    end

    context "long strings" do
      let(:long_string) { "a" * 50 }

      it "should insert zero width spaces" do
        wrap(long_string).should =~ /&#8203;/
      end
    end
  end
end