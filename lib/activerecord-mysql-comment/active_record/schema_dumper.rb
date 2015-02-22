require 'active_record/schema_dumper'

module ActiveRecord
  module Mysql
    module Comment
      module SchemaDumper
        private
        def table(table, stream)
          @types = @types.merge(@connection.options_for_column_spec(table))
          super(table, stream)
        ensure
          @types = @connection.native_database_types
        end

        def indexes(table, stream)
          buf = StringIO.new
          super(table, buf)
          buf = buf.string
          output = add_index_comment(table, buf)
          stream.print output
          stream
        end

        def add_index_comment(table, buf)
          output = ""
          buf.each_line do |line|
            output << line
            if matched = line.match(/name: \"(?<name>.*)\", /)
              index_name = matched[:name]
            end
            if index_name.present?
              comment = @connection.select_one("SHOW INDEX FROM #{table} WHERE Key_name = '#{index_name}';")["Index_comment"]
              if comment.present?
                output = output.chop
                output << ", comment: #{comment.inspect}\n"
              end
            end
          end
          output
        end

      end
    end
  end

  class SchemaDumper #:nodoc:
    prepend Mysql::Comment::SchemaDumper
  end
end
