require_relative '../spec_helper'
require 'table'
require 'column'

describe '[INT] Table' do
  before :each do
    @table = Table.new Column, id: :integer, name: :string, value: :string
  end

  # Table#insert
  it 'checks wrong column type cause error at insertion' do
    expect { @table.insert id: Array.new, name: 'Clement', value: 'A student' }.to raise_error(ArgumentError)
  end

  it 'checks correct row does not cause error at insertion' do
    expect { @table.insert id: 5, name: 'Clement', value: 'A student'}.to_not raise_error
  end


  # Table#select
  it 'checks selection validation is correct' do
    @table.insert id: 1, name: 'Clement', value: 'A student'

    expect { @table.select :id, :firstname, :value }.to raise_error(ArgumentError)
    expect { @table.select :id, :name, :value }.to_not raise_error
  end


  # Table#where
  it 'checks filter validation is correct' do
    @table.insert id: 1, name: 'Clement', value: 'student'
    @table.insert id: 2, name: 'Thomas', value: 'student'
    @table.insert id: 3, name: 'Paul', value: 'teacher'

    expect(@table.where {|row| row[:value] == 'student'}.rows_count).to eq 2
    expect(@table.where {|row| row[:name] == 'Clement'}.rows_count).to eq 1
    expect(@table.where {|row| row[:id] == 4}.rows_count).to eq 0
  end
end