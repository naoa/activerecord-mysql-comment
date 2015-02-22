require 'cases/helper'
require 'support/schema_dumping_helper'

class IndexCommentTest < ActiveRecord::TestCase
  include SchemaDumpingHelper

  class IndexComment < ActiveRecord::Base
  end

  setup do
    @connection = ActiveRecord::Base.connection
    @connection.create_table("index_comments", force: true) do |t|
      t.string "string"
      t.text "text"
    end
    @connection.add_index :index_comments, :string, comment: 'no_named_index_comment'
    @connection.add_index :index_comments, :string, name: 'named_column', comment: 'named_index_comment'
    @connection.add_index :index_comments, :string, name: 'no_index_comment'
  end

  teardown do
    @connection.drop_table "index_comments"
  end

  def test_schema_dump_index_comment
    schema = dump_table_schema "index_comments"
    result = @connection.execute "show create table index_comments;"
    assert_match %r{add_index\s+"index_comments",\s+\[\"string\"\],\s+name:\s+\"index_index_comments_on_string\",\s+using:\s+:btree,\s+comment:\s+\"no_named_index_comment\"$}, schema
    assert_match %r{add_index\s+"index_comments",\s+\[\"string\"\],\s+name:\s+\"named_column\",\s+using:\s+:btree,\s+comment:\s+\"named_index_comment\"$}, schema
    assert_match %r{add_index\s+"index_comments",\s+\[\"string\"\],\s+name:\s+\"no_index_comment\",\s+using:\s+:btree$}, schema
  end
end
