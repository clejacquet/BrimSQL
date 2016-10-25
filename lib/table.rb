class Table
  attr_writer :column_provider
  attr_reader :rows

  def initialize(column_provider, columns, rows = [])
    @column_provider = column_provider
    @columns = columns
    @rows = rows

    validate_column_provider @column_provider
    validate_columns @columns
    validate_rows
  end

  def insert(row)
    validate_row row
    @rows << row
  end

  def where
    rows = @rows.select do |row|
      yield row
    end

    Table.new @column_provider, @columns.clone, rows
  end

  def select(*fields)
    validate_field_list fields

    columns = @columns.select do |key|
      fields.include? key
    end

    rows = @rows.map do |row|
      row.select {|field| fields.include? field }
    end

    Table.new @column_provider, columns, rows
  end

  def rows_count
    @rows.size
  end

  def column_schema
    @columns.clone
  end

  private

  def validate_field_list(fields)
    fields.each do |field|
      unless @columns.keys.include? field
        raise ArgumentError,
              "Cannot find (#{field}) column name"
      end
    end
  end

  def validate_column_provider(column_provider)
    unless column_provider.respond_to? :is_of_type?
      raise ArgumentError,
            'The column provider do not provide :is_of_type? method'
    end
  end

  def validate_columns(columns)
    unless columns.is_a? Hash
      raise ArgumentError,
            'columns provided are not an Hash'
    end

    columns.each do |key, value|
      unless key.is_a? Symbol and value.is_a? Symbol
        raise ArgumentError,
          "Column (#{key}:#{value}) is not composed of symbols"
      end
    end
  end

  def validate_rows
    unless @rows.is_a? Array
      raise ArgumentError,
            'Rows provided are not provided through an Array instance'
    end

    @rows.each do |row|
      validate_row row
    end
  end

  def validate_row(row)
    unused_columns = @columns.clone

    # Check that each value of the row respects column types
    row.each do |key, value|
      if @columns[key].nil?
        raise ArgumentError,
              "Column (#{key}) does not exist"
      end

      unless @column_provider.is_of_type? value, @columns[key]
        raise ArgumentError,
              "Column (#{key}) type is \"#{@columns[key]}\", can't convert (#{value}) to this"
      end

      unused_columns.delete key
    end

    unless unused_columns.size == 0
      raise ArgumentError,
            'Some columns are not filled by the row'
    end
  end
end