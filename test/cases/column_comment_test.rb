require 'cases/helper'
require 'support/schema_dumping_helper'

class ColumnCommentTest < ActiveRecord::TestCase
  include SchemaDumpingHelper

  class ColumnComment < ActiveRecord::Base
  end

  setup do
    @connection = ActiveRecord::Base.connection
    @connection.create_table("column_comments", force: true) do |t|
      t.string "string_non_comment"
      t.string "string_comment", comment: 'string_hoge'
      t.text "text_comment", comment: 'text_hoge'
    end
  end

  teardown do
    @connection.drop_table "column_comments"
  end

  def test_add_column
    @connection.add_column 'column_comments', 'title', :string, comment: 'string_hoge'
    comment = @connection.select_one("SHOW FULL COLUMNS FROM column_comments WHERE Field = 'title'")["Comment"]
    assert_equal 'string_hoge', comment
  end

  def test_change_column
    @connection.add_column 'column_comments', 'description', :string, comment: 'string_comment'
    @connection.change_column 'column_comments', 'description', :text, comment: 'text_comment'
    comment = @connection.select_one("SHOW FULL COLUMNS FROM column_comments WHERE Field = 'description'")["Comment"]

    assert_equal 'text_comment', comment
  end

  def test_schema_dump_column_collation
    schema = dump_table_schema "column_comments"
    assert_match %r{t.string\s+"string_non_comment"(?:,\s+limit: 255)?$}, schema
    assert_match %r{t.string\s+"string_comment",(?:\s+limit: 255,)?\s+comment: "string_hoge"$}, schema
    assert_match %r{t.text\s+"text_comment",(?:\s+limit: 65535,)?\s+comment: "text_hoge"$}, schema
  end
end
