if ActiveRecord::VERSION::MAJOR == 4
  require 'activerecord-mysql-comment/active_record/schema_dumper'
  require 'activerecord-mysql-comment/active_record/connection_adapters/abstract/schema_dumper'
  require 'activerecord-mysql-comment/active_record/connection_adapters/abstract_mysql_adapter'
else
  raise "activerecord-mysql-comment supports activerecord ~> 4.x"
end
