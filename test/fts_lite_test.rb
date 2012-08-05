# coding: utf-8
require 'test_helper'

class FtsLiteTest < Test::Unit::TestCase
  DB_FILE = File.expand_path(File.join(File.dirname(__FILE__), "test.sqlite3"))
  puts "RUBY_VERSION => #{RUBY_VERSION}"
  puts "SQLITE3_VERSION => #{FtsLite::Database.sqlite3_version}"
  puts "SQLITE_HAVE_FT4_REPLACE => #{FtsLite::Database.have_ft4_replace}"
  def setup
    if (File.exist?(DB_FILE))
      File.unlink(DB_FILE)
    end
  end
  def teardown
  end
  def test_update
    db = FtsLite::Database.new(DB_FILE, :tokenizer => :bigram)
    db.transaction do 
      db.delete_all

      assert_equal db.search("赤い").size, 0
      db.update(1, "なぜナポリタンは赤いのだろうか ？", 2)
      db.update(2, "昼飯のスパゲティナポリタンを眺めながら、積年の疑問を考えていた。 ", 1)
      
      assert_equal db.search("赤い").size, 1
      assert_equal db.search("ナポリタン", :order => :desc).size, 2
      assert_equal db.search("ナポリタン", :order => :desc)[0], 1
      assert_equal db.search("ナポリタン", :order => :desc)[1], 2
      
      db.update(1, "なぜナポリタンは青いのだろうか ？", 0)
      assert_equal db.search("赤い").size, 0
      assert_equal db.search("青い").size, 1

      assert_equal db.search("ナポリタン", :order => :desc).size, 2
      assert_equal db.search("ナポリタン", :order => :desc)[0], 2
      assert_equal db.search("ナポリタン", :order => :desc)[1], 1
    end
  end
  def test_bigram
    db = FtsLite::Database.new(DB_FILE, :tokenizer => :bigram)
    db.transaction do 
      db.delete_all
      p db.tokenize("なぜナポリタンは赤いのだろうか ？")
      db.update(1, "なぜナポリタンは赤いのだろうか ？", 2)
      db.update(2, "昼飯のスパゲティナポリタンを眺めながら、積年の疑問を考えていた。 ", 1)
      
      assert_equal db.search("赤い").size, 1
      assert_equal db.search("赤い")[0], 1
      
      assert_equal db.search("ナポリタン").size, 2
      assert_equal db.search("ナポリタン")[0], 1
      assert_equal db.search("ナポリタン")[1], 2
      
      assert_equal db.search("ナポリタン", :order => :desc).size, 2
      assert_equal db.search("ナポリタン", :order => :desc)[0], 1
      assert_equal db.search("ナポリタン", :order => :desc)[1], 2
      
      assert_equal db.search("ナポリタン", :order => :asc).size, 2
      assert_equal db.search("ナポリタン", :order => :asc)[0], 2
      assert_equal db.search("ナポリタン", :order => :asc)[1], 1
      
      db.update_sort_value(1, 1)
      db.update_sort_value(2, 2)
      
      assert_equal db.search("ナポリタン", :order => :desc).size, 2
      assert_equal db.search("ナポリタン", :order => :desc)[0], 2
      assert_equal db.search("ナポリタン", :order => :desc)[1], 1
      
      assert_equal db.search("ナポリタン", :order => :asc).size, 2
      assert_equal db.search("ナポリタン", :order => :asc)[0], 1
      assert_equal db.search("ナポリタン", :order => :asc)[1], 2
    end
  end
  def test_trigram
    db = FtsLite::Database.new(DB_FILE, :tokenizer => :trigram)
    db.transaction do 
      db.delete_all
      p db.tokenize("なぜナポリタンは赤いのだろうか ？")
      db.update(1, "なぜナポリタンは赤いのだろうか ？", 2)
      db.update(2, "昼飯のスパゲティナポリタンを眺めながら、積年の疑問を考えていた。 ", 1)
      
      assert_equal db.search("赤い").size, 0
      
      assert_equal db.search("ナポリタン").size, 2
      assert_equal db.search("ナポリタン")[0], 1
      assert_equal db.search("ナポリタン")[1], 2
      
      assert_equal db.search("ナポリタン", :order => :desc).size, 2
      assert_equal db.search("ナポリタン", :order => :desc)[0], 1
      assert_equal db.search("ナポリタン", :order => :desc)[1], 2
      
      assert_equal db.search("ナポリタン", :order => :asc).size, 2
      assert_equal db.search("ナポリタン", :order => :asc)[0], 2
      assert_equal db.search("ナポリタン", :order => :asc)[1], 1
      
      db.update_sort_value(1, 1)
      db.update_sort_value(2, 2)
      
      assert_equal db.search("ナポリタン", :order => :desc).size, 2
      assert_equal db.search("ナポリタン", :order => :desc)[0], 2
      assert_equal db.search("ナポリタン", :order => :desc)[1], 1
      
      assert_equal db.search("ナポリタン", :order => :asc).size, 2
      assert_equal db.search("ナポリタン", :order => :asc)[0], 1
      assert_equal db.search("ナポリタン", :order => :asc)[1], 2
    end
  end
  def test_wakachi_bigram
    db = FtsLite::Database.new(DB_FILE, :tokenizer => :wakachi_bigram)
    db.transaction do 
      db.delete_all
      p db.tokenize("なぜナポリタンは赤いのだろうか ？")
      db.update(1, "なぜナポリタンは赤いのだろうか ？", 2)
      db.update(2, "昼飯のスパゲティナポリタンを眺めながら、積年の疑問を考えていた。 ", 1)
      
      assert_equal db.search("赤い").size, 1
      assert_equal db.search("赤い")[0], 1
      
      assert_equal db.search("ナポリタン").size, 2
      assert_equal db.search("ナポリタン")[0], 1
      assert_equal db.search("ナポリタン")[1], 2
      
      assert_equal db.search("ナポリタン", :order => :desc).size, 2
      assert_equal db.search("ナポリタン", :order => :desc)[0], 1
      assert_equal db.search("ナポリタン", :order => :desc)[1], 2
      
      assert_equal db.search("ナポリタン", :order => :asc).size, 2
      assert_equal db.search("ナポリタン", :order => :asc)[0], 2
      assert_equal db.search("ナポリタン", :order => :asc)[1], 1
      
      db.update_sort_value(1, 1)
      db.update_sort_value(2, 2)
      
      assert_equal db.search("ナポリタン", :order => :desc).size, 2
      assert_equal db.search("ナポリタン", :order => :desc)[0], 2
      assert_equal db.search("ナポリタン", :order => :desc)[1], 1
      
      assert_equal db.search("ナポリタン", :order => :asc).size, 2
      assert_equal db.search("ナポリタン", :order => :asc)[0], 1
      assert_equal db.search("ナポリタン", :order => :asc)[1], 2
    end
  end
  def test_create
    db = FtsLite::Database.new(DB_FILE)
    db.drop_table!
    db.close
    db = FtsLite::Database.new(DB_FILE, :table_name => "hogehgoe")
    db.drop_table!
    db.close
  end
end
