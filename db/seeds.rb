# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

streets = %w(Aster Gladiola Howthorne Iris Larkspur Narcissus Marigold Primrose)
streets.each do |street|
  Street.find_or_create_by(name: street)
end

homeowners_data_file = Rails.root.join('data', 'homeowners.json')
puts "Building homeowners data"
if File.exist?(homeowners_data_file)
  contents = File.read(homeowners_data_file)
  parsed_data = JSON.parse(contents)
  parsed_data.each do |key, data|
    street = Street.find_by('LOWER(name) = ?', key.strip.downcase)
    if street
      data.each do |person|
        firstname, lastname = person.split(', ').map(&:titleize)
        if firstname && lastname
          Homeowner.create(street_id: street.id, firstname: firstname.strip, lastname: lastname)
        else
          puts 'Unable to store data for %s in street %s' % [person, street.name]
        end
      end
    end
  end
end