class EntryRepository
  include Enumerable
  
  def initialize(db)
    @db = db
  end
  
  def save(entry)
    columns = ['title', 'body']
    @db.prepare("INSERT INTO `entries` (#{columns.join(", ")}) VALUES (?, ?)").execute(entry.title, entry.body)
    return @db.last_id
  end

  def fetch(id)
    res = @db.prepare("SELECT * FROM `entries` WHERE `id` = ?").execute(id)

    data = res.first
    entry = Entry.new
    entry.title = data["title"]
    entry.body = data["body"]

    return entry
  end
  
  def each(&block)
    entries = []
    query = "SELECT * FROM `entries`"
    res = @db.query(query)

    res.each do |row|
      entry = Entry.new
      entry.title = row["title"]
      entry.body = row["body"]
      entries.push(entry)
    end

    entries.each(&block)
  end
end
