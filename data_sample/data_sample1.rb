require 'table'

def build_data1
  Table.new({id: :integer, name: :string, city: :string }, [
      { id: 0, name: 'Clément',   city: 'Bordeaux' },
      { id: 1, name: 'Thomas',    city: 'Paris' },
      { id: 2, name: 'Margaux',   city: 'Lille' },
      { id: 3, name: 'Pierre',    city: 'Paris' },
      { id: 4, name: 'Guillaume', city: 'Bordeaux' },
      { id: 5, name: 'Antoine',   city: 'Paris' },
      { id: 6, name: 'Matthieu',  city: 'Toulouse' },
      { id: 7, name: 'Nicolas',   city: 'Toulouse' },
      { id: 8, name: 'Jeanne',    city: 'Paris' },
      { id: 9, name: 'Marie',     city: 'Paris' },
  ])
end