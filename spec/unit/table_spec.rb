require_relative '../spec_helper'
require 'table'

describe '[UNIT] Table' do
  before :each do
    @column_provider = double('column_provider')
    allow(@column_provider).to receive(:is_of_type?).and_return(true)
    @table = Table.new @column_provider, id: :integer, name: :string, value: :string
  end

  # Table#initialize
  it 'checks wrong initialization cause error' do
    expect { Table.new 5, id: :integer, name: :string }.to raise_error(ArgumentError)
    expect { Table.new @column_provider, 5 }.to raise_error(ArgumentError)
    expect { Table.new @column_provider, { id: :integer, name: :string }, 5 }.to raise_error(ArgumentError)
    expect { Table.new @column_provider, { id: :integer, name: :string } , [
        { num: 1, name: 'Clément' },  # 'num' instead of 'id'
        { id: 2, fullname: 'Jean' }   # 'fullname' instead of 'name'
    ] }.to raise_error(ArgumentError)
  end

  it 'checks correct initialization does not cause error' do
    expect { Table.new @column_provider, id: :integer, name: :string }.to_not raise_error
    expect { Table.new @column_provider, { id: :integer, name: :string } , [
        { id: 1, name: 'Clément' },
        { id: 2, name: 'Jean' }
    ] }.to_not raise_error
  end


  # Table#insert
  it 'checks missing column cause error at insertion' do
    expect { @table.insert id: 5, name: 'Clement' }.to raise_error(ArgumentError)
  end

  it 'checks undefined column cause error at insertion' do
    expect { @table.insert id: 5, username: 'Clement' }.to raise_error(ArgumentError)
  end

  it 'checks wrong column type cause error at insertion' do
    allow(@column_provider).to receive(:is_of_type?).and_return(false)

    expect { @table.insert id: Array.new, name: 'Clement', value: 'A student' }.to raise_error(ArgumentError)
  end

  it 'checks correct row does not cause error at insertion' do
    expect { @table.insert id: 5, name: 'Clement', value: 'A student'}.to_not raise_error
  end

  it 'inserts a row and check it exists in table' do
    @table.insert id: 5, name: 'Clement', value: 'A student'
    expect(@table.rows_count).to be > 0
  end

  it 'inserts some rows and checks the row count is correct' do
    @table.insert id: 1, name: 'Clement', value: 'A student'
    @table.insert id: 2, name: 'Thomas', value: 'Another student'
    @table.insert id: 3, name: 'Paul', value: 'A teacher'

    expect(@table.rows_count).to eq 3
  end


  # Table#select
  it 'checks columns are correctly selected' do
    new_table = @table.select :id, :name
    expect(new_table.column_schema).to eq(id: :integer, name: :string)
  end

  it 'checks rows are correctly copied' do
    @table.insert id: 1, name: 'Clement', value: 'A student'
    new_table = @table.select :id, :name
    expect(new_table.rows_count).to eq 1
    expect(new_table.rows[0][:id]).to eq 1
    expect(new_table.rows[0][:name]).to eq 'Clement'
  end


  # Table#where
  it 'checks rows are correctly filtered' do
    @table.insert id: 1, name: 'Clement', value: 'student'
    @table.insert id: 2, name: 'Thomas', value: 'student'
    @table.insert id: 3, name: 'Paul', value: 'teacher'

    expect(@table.where {|row| row[:value] == 'student'}.rows_count).to eq 2
    expect(@table.where {|row| row[:name] == 'Clement'}.rows_count).to eq 1
    expect(@table.where {|row| row[:id] == 4}.rows_count).to eq 0
  end
end
