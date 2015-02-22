require 'active_support'

begin
  require 'rails'
rescue LoadError
  # nothing to do! yay!
end

if defined? Rails
  require 'activerecord/mysql/comment/railtie'
else
  ActiveSupport.on_load :active_record do
    require 'activerecord/mysql/comment/base'
  end
end
