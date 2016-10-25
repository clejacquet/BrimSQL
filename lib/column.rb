module Column
  TYPES = {
      :string => :to_s,
      :integer => :to_i,
      :float => :to_f
  }

  def Column.is_valid?(type)
    unless type.respond_to? :to_sym
      raise ArgumentError,
            "Incorrect type provided (#{type.class} instead of #{Symbol.class}"
    end

    not TYPES[type.to_sym].nil?
  end

  def Column.is_of_type?(value, type)
    unless Column.is_valid? type
      raise ArgumentError, 'Invalid type provided'
    end

    value.respond_to? TYPES[type.to_sym]
  end

  def Column.matches?(type_a, type_b)
    unless Column.is_valid? type_a and Column.is_valid? type_b
      raise ArgumentError, 'Invalid types provided'
    end

    type_a.to_sym.eql? type_b.to_sym
  end
end