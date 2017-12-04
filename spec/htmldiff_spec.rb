# coding: utf-8
require File.dirname(__FILE__) + '/spec_helper'
require 'htmldiff'

class TestDiff
  extend HTMLDiff
end

describe "htmldiff" do
  it "should diff text" do
    diff = TestDiff.diff('a word is here', 'a nother word is there')
    expect(diff).to eq("a<ins class=\"diffins\"> nother</ins> word is <del class=\"diffmod\">here</del><ins class=\"diffmod\">there</ins>")
  end

  it "should insert a letter and a space" do
    diff = TestDiff.diff('a c', 'a b c')
    expect(diff).to eq("a <ins class=\"diffins\">b </ins>c")
  end

  it "should remove a letter and a space" do
    diff = TestDiff.diff('a b c', 'a c')
    expect(diff).to eq("a <del class=\"diffdel\">b </del>c")
  end

  it "should change a letter" do
    diff = TestDiff.diff('a b c', 'a d c')
    expect(diff).to eq("a <del class=\"diffmod\">b</del><ins class=\"diffmod\">d</ins> c")
  end

  it "should support Chinese" do
    diff = TestDiff.diff('这个是中文内容, Ruby is the bast', '这是中国语内容，Ruby is the best language.')
    expect(diff).to eq("<del class=\"diffmod\">这个是中文内容, Ruby</del><ins class=\"diffmod\">这是中国语内容，Ruby</ins> is the <del class=\"diffmod\">bast</del><ins class=\"diffmod\">best language.</ins>")
  end

  it "by default opening tags are duplicated breaking the dom" do
    a = 'a <a href="#c1"></a> b'
    b = 'a <a href="#c2"></a> c'
    diff = TestDiff.diff(a, b)
    expect(diff).to eq("a <a href=\"#c1\"><a href=\"#c2\"></a> <del class=\"diffmod\">b</del><ins class=\"diffmod\">c</ins>")
  end

  it "example from the library" do
    a = '<p>a</p>'
    b = '<p>ab</p><p>c</b>'
    diff = TestDiff.diff(a, b)
    expect(diff).to eq("<p><del class=\"diffmod\">a</del><ins class=\"diffmod\">ab</ins></p><p><ins class=\"diffins\">c</ins></b>")
  end

  describe "ignore_tags option" do
    describe "changes in properties should render balanced tags" do
      it "will render both versions of the start tag, but not end tag when disabled" do
        a = 'a <a href="#c1"></a> b'
        b = 'a <a href="#c2"></a> c'
        expected = 'a <a href="#c1"><a href="#c2"></a> <del class="diffmod">b</del><ins class="diffmod">c</ins>'
        diff = TestDiff.diff(a, b, ignore_tags: false)
        expect(diff).to eq(expected)
      end

      it "will produce valid html when enabled" do
        a = 'a <a href="#c1"></a> b'
        b = 'a <a href="#c2"></a> c'
        expected = 'a <a href="#c2"></a> <del class="diffmod">b</del><ins class="diffmod">c</ins>'
        diff = TestDiff.diff(a, b, ignore_tags: true)
        expect(diff).to eq(expected)
      end
    end

    describe "when jumping between tags and non tags" do
      it "will render both versions of the start tag, but not end tag when disabled" do
        a = 'a <a href="#c1"></a>b<a href="#c1"> c<a href="#c1">e'
        b = 'a <a href="#c2"></a>c<a href="#c3"> d<a href="#c4">e'
        expected = 'a <a href="#c1"><a href="#c2"></a><del class="diffmod">b</del><a href="#c1"><ins class="diffmod">c</ins><a href="#c3"> <del class="diffmod">c</del><a href="#c1"><ins class="diffmod">d</ins><a href="#c4">e'
        diff = TestDiff.diff(a, b, ignore_tags: false)
        expect(diff).to eq(expected)
      end

      it "will produce valid html when enabled" do
        a = 'a <a href="#c1"></a>b<a href="#c1"> c<a href="#c1">e'
        b = 'a <a href="#c2"></a>c<a href="#c3"> d<a href="#c4">e'
        expected = 'a <a href="#c2"></a><del class="diffmod">b</del><ins class="diffmod">c</ins><a href="#c3"> <del class="diffmod">c</del><ins class="diffmod">d</ins><a href="#c4">e'
        diff = TestDiff.diff(a, b, ignore_tags: true)
        expect(diff).to eq(expected)
      end
    end
  end

  describe "reduce_consecutive option" do
    it "should diff individual words, when not enabled" do
      a = '<p>Han går til samtaler ved en psykiater. Like a boss.</p>'
      b = '<p>Han drikker stærk spiritus. Like a boss.</p>'
      expected = '<p>Han <del class="diffmod">går</del><ins class="diffmod">drikker</ins> <del class="diffmod">til</del><ins class="diffmod">stærk</ins> <del class="diffmod">samtaler ved en psykiater.</del><ins class="diffmod">spiritus.</ins> Like a boss.</p>'
      diff = TestDiff.diff(a, b, reduce_consecutive: false)
      expect(diff).to eq(expected)
    end

    it "should reduce consecutive matches, when enabled" do
      a = '<p>Han går til samtaler ved en psykiater. Like a boss.</p>'
      b = '<p>Han drikker stærk spiritus. Like a boss.</p>'
      expected = '<p>Han <del class="diffmod">går til samtaler ved en psykiater.</del><ins class="diffmod">drikker stærk spiritus.</ins> Like a boss.</p>'
      diff = TestDiff.diff(a, b, reduce_consecutive: true)
      expect(diff).to eq(expected)
    end
  end
end
