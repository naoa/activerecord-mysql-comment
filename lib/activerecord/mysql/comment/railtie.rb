module ActiveRecord
  module Mysql
    module Comment
      class Railtie < Rails::Railtie
        initializer 'activerecord-mysql-comment' do
          ActiveSupport.on_load :active_record do
            require 'activerecord/mysql/comment/base'
          end
        end
      end
    end
  end
end
