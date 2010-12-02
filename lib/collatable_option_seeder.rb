class CollatableOptionSeeder
  
  @@default_options = {
    'user.volunteering_history' => [
      ["What habit? (I haven't really volunteered before)", "never"],
      ["I volunteered 3 times or less in the last 12 months", "3-or-less-times"],
      ["I volunteer once a month", "once-per-month"],
      ["I volunteer once a week", "once-per-week"],
      ["I've practically got a degree in volunteering (I volunteer more than twice a week)", "two-plus-per-week"]
    ],
    'user.gender' => [
      ['Male', 'male'],
      ['Female', 'female'],
      ['Transgender', 'transgender'],
      ['Other', 'other']
    ]
  }
  
  
  def self.seed(name)
    options = @@default_options[name]
    return if options.blank?
    options.each do |set|
      next if CollatableOption.where(:scope_key => name, :value => set[1]).exists?
      CollatableOption.create! :scope_key => name, :name => set[0], :value => set[1]
    end
  end
  
  def self.unseed(name)
    options = @@default_options[name]
    return if options.blank?
    CollatableOption.where(:scope_key => name, :value => options.map(&:last)).delete_all
  end
  
end