require 'active_record/connection_adapters/abstract/schema_dumper'

module ActiveRecord
  module ConnectionAdapters # :nodoc:
    module ColumnDumper
      def options_for_column_spec(table_name)
        { table_name: table_name }
      end
    end
  end
end
