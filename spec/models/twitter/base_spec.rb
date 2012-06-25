require 'spec_helper'

describe Twitter::Base do

  let(:test_class) { Class.new(Twitter::Base) { attr_accessor :test_attribute } }

  describe ".initialize" do

    context "initialized with {test_attribute: 123, missing_attribute: 456}" do
      subject { test_class.new(test_attribute: 123, missing_attribute: 456) }
      it { should_not respond_to :missing_attribute }
      it { should respond_to :test_attribute }
      its(:test_attribute) { should == 123 }
    end

  end

end
