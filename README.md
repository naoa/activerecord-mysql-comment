# ActiveRecord::Mysql::Comment

[![Build Status](https://travis-ci.org/naoa/activerecord-mysql-comment.png?branch=master)](https://travis-ci.org/naoa/activerecord-mysql-comment)

Adds column comment and index comment to migrations for ActiveRecord MySQL adapters

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-mysql-comment'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-mysql-comment

## Usage

```ruby
bundle exec rails g migration CreatePosts
```

```ruby
class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts, options: 'ENGINE=Mroonga COMMENT="default_tokenizer=TokenMecab"' do |t|
      t.string :title
      t.text   :content, comment: 'flags "COLUMN_SCALAR|COMPRESS_ZLIB"'
      t.timestamps
    end
    add_index :posts, :content, type: 'fulltext', comment: 'parser "TokenBigram", normalizer "NormalizerAuto"'
  end
end
```

```ruby
bundle exec rake db:migrate
```

```ruby
  create_table "posts", force: :cascade, options: "ENGINE=Mroonga DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='default_tokenizer=TokenMecab'" do |t|
    t.string   "title",      limit: 255
    t.text     "content",    limit: 65535, comment: "flags \"COLUMN_SCALAR|COMPRESS_ZLIB\""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["content"], name: "index_posts_on_content", type: :fulltext, comment: "parser \"TokenBigram\", normalizer \"NormalizerAuto\""
```

## Note

* Table options need [activerecord-mysql-awesome](https://github.com/kamipo/activerecord-mysql-awesome). If you use ``rake db:reset``, you should install it.

* If you use [activerecord-mysql-awesome](https://github.com/kamipo/activerecord-mysql-awesome), please loading it before load activerecord-mysql-comment.

## Contributing

1. Fork it ( https://github.com/naoa/activerecord-mysql-comment/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Thanks

* [@kamipo](https://github.com/kamipo)

This library is made by referring to [activerecord-mysql-awesome](https://github.com/kamipo/activerecord-mysql-awesome).
