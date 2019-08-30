require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    unless @cols
      @cols = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      SQL
      @cols = @cols[0].map { |col| col.to_sym }
    else
      @cols
    end
  end

  def self.finalize!
    self.columns.each do |column|
      define_method("#{column}") do
        self.attributes[column]
    end
      define_method("#{column}=") do |arg|
        self.attributes[column] = arg
    end
  end
  end


  def self.table_name=(table_name)
    # ...
    @table_name = table_name
  end

  def self.table_name
    # ...
    unless @table_name
      self.to_s.tableize
    else
      @table_name
    end
  end

  def self.all
    DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
  end

  def self.parse_all(results)
    obj_arr = []
    results.each do |hash|
      obj_arr << self.new(hash)
    end
    obj_arr
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    # ...
    params.each do |param, val|
      symbolized_param = param.to_sym
      unless self.class.columns.include?(symbolized_param)
        raise Exception.new("unknown attribute '#{param}'")
      end
      self.send("#{param.to_s}=", val)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
