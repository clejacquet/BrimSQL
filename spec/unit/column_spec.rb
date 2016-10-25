require_relative '../spec_helper'
require 'column'

describe '[UNIT] Column' do
  # Column#is_valid?
  it 'checks whether exception is risen' do
    expect { Column::is_valid? 5 }.to raise_error(ArgumentError)
  end

  it 'invalidates incorrect non-matching strings' do
    expect(Column::is_valid?('not a type')).to eq false
  end

  it 'validates strings and symbols' do
    expect(Column::is_valid?('string')).to eq true
    expect(Column::is_valid?(:string)).to eq true
  end


  # Column#is_of_type?
  it 'checks types corresponding' do
    expect(Column::is_of_type? 0, :integer).to eq true
    expect(Column::is_of_type? 0, :float).to eq true
    expect(Column::is_of_type? 0, :string).to eq true
    expect(Column::is_of_type? 'Jean', :string).to eq true
    expect(Column::is_of_type? 5.2, :float).to eq true
    expect(Column::is_of_type? 5.2, :integer).to eq true
    expect(Column::is_of_type? 5.2, :string).to eq true
  end

  it 'checks types non-corresponding' do
    expect(Column::is_of_type? Array.new, :integer).to eq false
    expect(Column::is_of_type? Array.new, :float).to eq false
  end

  it 'checks error is raised when an incorrect type is provided' do
    expect { Column::is_of_type? 0, :test }.to raise_error(ArgumentError)
  end


  # Column#matches?
  it 'checks whether exception is risen' do
    expect { Column::matches? 5, 5 }.to raise_error(ArgumentError)
    expect { Column::matches? 5, :string }.to raise_error(ArgumentError)
    expect { Column::matches? :string, 5 }.to raise_error(ArgumentError)
    expect { Column::matches? :not_type, :string }.to raise_error(ArgumentError)
    expect { Column::matches? :string, :not_type }.to raise_error(ArgumentError)
  end

  it 'matches correctly' do
    expect(Column::matches? :string, :string).to eq true
    expect(Column::matches? :string, 'string').to eq true
    expect(Column::matches? 'string', :string).to eq true
  end

  it 'does not match' do
    expect(Column::matches? :string, :integer).to eq false
    expect(Column::matches? :float, 'integer').to eq false
    expect(Column::matches? 'float', :string).to eq false
  end
end