class CsvReporter

  REPORTS = {
    'missions'               => ["Mission", %w(id name description)],
    'mission_participations' => ["MissionParticipation", %w(user_id state mission_id role_id partaking_with_friends)],
    'roles'                  => ["Role", %w(id name)],
    'users'                  => ["User", %w(id email admin display_name first_name last_name date_of_birth phone postcode volunteering_history.value gender.value)]

  }

  def initialize
    @values = {}
  end

  def self.generate
    report = new
    report.collate_values
    report.to_data
  end

  def collate_values
    REPORTS.each_pair do |name, details|
      csv = FasterCSV.generate do |c|
        extract_data(*details) { |row| c << row }
      end
      store_item name, csv
    end
  end

  def extract_data(klass, fields)
    klass.constantize.find_each do |record|
      value = fields.map do |field|
        field.split(".").inject(record) { |r, v| r.try v.to_sym }
      end
      yield value
    end
  end

  def store_item(name, data)
    @values["#{name}.csv"] = data
  end

  def to_data
    @values
  end

end