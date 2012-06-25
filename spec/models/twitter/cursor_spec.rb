require 'spec_helper'

describe Twitter::Cursor do

  describe "initialized with {ids: [1,2,3], previous_cursor: 4, next_cursor: 5}" do
    subject { Twitter::Cursor.new(ids: [1,2,3], previous_cursor: 4, next_cursor: 5) }
    its(:ids) { should have(3).items }
    its(:previous_cursor) { should == 4 }
    its(:next_cursor) { should == 5 }
  end

  context "when on single page" do
    subject { Twitter::Cursor.new(previous_cursor: 0, next_cursor: 0) }
    it { should be_first_page }
    it { should be_last_page }
  end

  context "when on page 1 of 3" do
    subject { Twitter::Cursor.new(previous_cursor: 0, next_cursor: 2) }
    it { should be_first_page }
    it { should_not be_last_page }
  end

  context "when on page 2 of 3" do
    subject { Twitter::Cursor.new(previous_cursor: 1, next_cursor: 3) }
    it { should_not be_first_page }
    it { should_not be_last_page }
  end

  context "when on page 3 of 3" do
    subject { Twitter::Cursor.new(previous_cursor: 2, next_cursor: 0) }
    it { should_not be_first_page }
    it { should be_last_page }
  end

end
