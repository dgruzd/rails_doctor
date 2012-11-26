class Doctor
  def initialize
  end

  def analize
    indexes
    true
  end

  def associations
    hash = {}
    models = Dir.glob("#{Rails.root}/app/models/*.rb").map{|model_path| model_path.split('/').last[/.+(?=\.rb)/]}
    #models = ['patient', 'tooth_formula']
    models.each do |model_name|
      table = model_name.pluralize.to_sym
      hash[table]||=[]
      model = model_name.split('_').map(&:capitalize).join.constantize
      next unless model.respond_to?(:reflect_on_all_associations)
      belongs_to = model.reflect_on_all_associations.select{|s| s.macro == :belongs_to}
      ids = belongs_to.map{|a| "#{a.name}_id"}
      hash[table] += ids
    end
    hash
  end

  def indexes
    hash = {}
    #puts 'run associations'
    assoc = associations
    #puts "get #{assoc.inspect}"
    #puts 'run migrations'
    migrate = migrations
    #puts "get #{migrate.inspect}"

    tables = assoc.keys&migrate.keys
    tables.each do |table|
      columns = assoc[table]-migrate[table]
      unless columns.blank?
        hash[table] = columns
        puts "WARNING: in table:#{table} is no indexes in columns #{columns.join(', ')}"
      end
    end
    create_migration(hash)
    hash
  end

  def create_migration(hash)
    return false if hash.blank?
    puts "###### migrations #######"
    hash.each do |table, columns|
      columns.each do |column|
        puts "add_index #{table.inspect}, #{column.inspect}"
      end
    end
    puts "###### migrations end ###"
  end


  def migrations
    hash = {}
    file_list = Dir.glob("#{Rails.root}/db/migrate/*.rb")
    file_list.each do |file|
      parse = parse_migration(File.read(file))
      hash.merge! parse
    end
    hash
  end

  def parse_migration(text)
    hash = {}
    scan = text.match(/^\s*add_index\s+:?(?<table>\w+),\s*:?(?<column>\w+)/)
    if scan
      table = scan[:table].to_sym
      hash[table]||=[]
      hash[table] << scan[:column]
    end
    hash
  end

end
