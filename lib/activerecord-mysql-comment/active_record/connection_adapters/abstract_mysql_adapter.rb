require 'active_record/connection_adapters/abstract_mysql_adapter'

module ActiveRecord
  module Mysql
    module Comment
      module SchemaStatements
        def add_index_options(table_name, column_name, options = {})
          if options.key?(:comment)
            comment = options[:comment]
            options.delete(:comment)
          end

          index_name, index_type, index_columns, index_options, algorithm, using = super

          if comment.present?
            if index_options
              index_options << " COMMENT '#{comment}'"
            else
              index_options = " COMMENT '#{comment}'"
            end
          end

          [index_name, index_type, index_columns, index_options, algorithm, using]
        end
      end

      class ChangeColumnDefinition < Struct.new(:column, :name) #:nodoc:
      end

      class ColumnDefinition < ActiveRecord::ConnectionAdapters::ColumnDefinition
        attr_accessor :comment
      end

      class TableDefinition < ActiveRecord::ConnectionAdapters::TableDefinition
        def initialize(types, name, temporary, options, as = nil)
          super(types, name, temporary, options)
          @as = as
        end

        def new_column_definition(name, type, options) # :nodoc:
          column = super
          column.comment = options[:comment]
          column
        end

        private
        def create_column_definition(name, type)
          ColumnDefinition.new(name, type)
        end
      end

      module SchemaCreation

        private
        def column_options(o)
          column_options = super
          column_options[:comment] = o.comment
          column_options
        end

        def add_column_options!(sql, options)
          if options[:comment]
            sql << " COMMENT '#{options[:comment]}'"
          end
          super
        end
      end

      public
      def prepare_column_options(column, options) # :nodoc:
        spec = super
        comment = select_one("SHOW FULL COLUMNS FROM #{options[:table_name]} WHERE Field = '#{column.name}'")["Comment"]
        if comment.present?
          spec[:comment] = comment.inspect
        end
        spec
      end

      def migration_keys
        super | [:comment]
      end

      private
      def create_table_definition(name, temporary = false, options = nil, as = nil) # :nodoc:
        TableDefinition.new(native_database_types, name, temporary, options, as)
      end
    end
  end

  module ConnectionAdapters
    class AbstractMysqlAdapter < AbstractAdapter
      prepend Mysql::Comment
      prepend Mysql::Comment::SchemaStatements
      
      class SchemaCreation < AbstractAdapter::SchemaCreation
        prepend Mysql::Comment::SchemaCreation
      end
    end
  end
end
