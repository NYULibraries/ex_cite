require 'test_helper'

module ExCite
  class RecordTest < ActiveSupport::TestCase

    test "typeones fields should be records fields" do
      assert_equal "formatting", TypeOne.format_field
    end

    test "test a typetwos fields should be records fields" do
      assert_equal "from_format", TypeTwo.format_field
    end

    test "test typeones formatting should populate records fields" do
      typeone = TypeOne.new(:formatting => "csf", :raw => "itemType: book")
      assert_equal "csf", typeone.formatting
    end

    test "test typetwos formatting should populate records fields" do
      typetwo = TypeTwo.new(:from_format => "csf", :data => "itemType: book")
      assert_equal "csf", typetwo.from_format
    end
    
    test "test typeones ability to act as citable" do
      ExCite.acts_as_citable_class = "TypeOne"
      t = ExCite.acts_as_citable_class.new(:formatting => "csf", :raw => "itemType: book")
      t.id = 1
      assert_equal t.to_ris, "TY  - BOOK\nER  -\n\n"
      ExCite.acts_as_citable_class = "ExCite::Citation"
    end
  end
end