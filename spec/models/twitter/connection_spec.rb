require 'spec_helper'

describe Twitter::Connection do
  let(:test_connection) { Class.new { include Twitter::Connection } }
  let(:connection) { test_connection.new }

  describe ".with_attributes" do

    context "with {oauth_consumer_key: 123}" do
      subject { Twitter::Connection.with_attributes(oauth_consumer_key: 123) }
      it { should be_a Twitter::Connection::Identified }
    end

    context "without attributes" do
      subject { Twitter::Connection.with_attributes() }
      it { expect { subject }.to raise_error }
    end

  end
  
  describe "#path" do

    context "with ('users/lookup')" do
      subject { connection.path('users/lookup') }
      it { should == "/1/users/lookup.json" }
    end
    
  end

  describe "#convert_ids" do

    context "with {ids: 123}" do
      subject { connection.convert_ids({ids: 123}) }
      it { should == { user_id: "123" } }
    end

    context "with {ids: 'twitter'}" do
      subject { connection.convert_ids({ids: 'twitter'}) }
      it { should == { screen_name: "twitter" } }
    end

    context "with {ids: [123,456]}" do
      subject { connection.convert_ids({ids: [123,456]}) }
      it { should == { user_id: "123,456" } }
    end

    context "with {ids: ['twitter','other']}" do
      subject { connection.convert_ids({ids: ['twitter','other']}) }
      it { should == { screen_name: "twitter,other" } }
    end

    context "with {ids: ['twitter',123]}" do
      subject { connection.convert_ids({ids: ['twitter',123]}) }
      it { should == { screen_name: "twitter", user_id: "123" } }
    end

    context "with {ids: User.new(id: 123)}" do
      subject { connection.convert_ids({ids: Twitter::User.new(id: 123)}) }
      it { should == { user_id: "123" } }
    end

    context "with {ids: User.new(screen_name: 'twitter')}" do
      subject { connection.convert_ids({ids: Twitter::User.new(screen_name: "twitter")}) }
      it { should == { screen_name: "twitter" } }
    end

  end

  describe "#uri" do

    context "with 'some/method" do
      subject { connection.uri("some/method") }
      its(:request_uri) { should == "/1/some/method.json" }
    end

    context "with 'some/method', {arg: 'value'}" do
      subject { connection.uri("some/method", {arg: "value"}) }
      its(:request_uri) { should == "/1/some/method.json?arg=value" }
    end

    context "with ('some/method', {arg: '123, 456'})" do
      subject { connection.uri('some/method', {arg: '123, 456'}) }
      its(:request_uri) { should == "/1/some/method.json?arg=123%2C+456" }
    end

  end

  describe "#get" do
    it "should call #make_request on the subclass with :get and pass additional parameters" do
      connection.should_receive(:make_request).with(:get, 'method', {arg: 'value'})
      connection.get('method', {arg: 'value'})
    end
  end

  describe "#post" do
    it "should call #make_request on the subclass with :post and pass additional parameters" do
      connection.should_receive(:make_request).with(:post, 'method', {arg: 'value'})
      connection.post('method', {arg: 'value'})
    end
  end

end
