class EntryRepository
  include Enumerable
  
  def initialize(db)
    @db = db
  end
  
  def save(entry)
    columns = Entry::COLUMNS.reject {|key| key == :id}
    values = columns.map {|key| entry.instance_variable_get("@#{key}")}
    @db.prepare("INSERT INTO `entries` (#{columns.join(", ")}) VALUES (#{columns.map { '?' }.join(', ')})").execute(*values)
    entry.id = @db.last_id
    return entry.id
  end

  def fetch(id)
    res = @db.prepare("SELECT * FROM `entries` WHERE `id` = ?").execute(id)

    data = res.first

    return Entry.new(data)
  end
  
  def each(&block)
    entries = []
    query = "SELECT * FROM `entries`"
    res = @db.query(query)

    res.each do |row|
      entries.push(Entry.new(row))
    end

    entries.each(&block)
  end
end
