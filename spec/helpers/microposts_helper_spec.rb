require 'spec_helper'

describe MicropostsHelper do
  describe "#wrap" do
    let(:zero_width_space) { '&#8203;' }

    context "short strings" do
      let(:short_string) { "a" * 5 }
      subject { wrap(short_string) }
      it { should_not =~ /#{zero_width_space}/ }
    end

    context "long strings" do
      let(:long_string) { "a" * 50 }
      subject { wrap(long_string) }
      it { should =~ /#{zero_width_space}/ }
    end
  end
end