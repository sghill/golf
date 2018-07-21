require 'csv'
require 'fileutils'
require 'json'

FileUtils.mkdir_p('out')

specs = {}
Dir["clubs/*.json"].each do |path|
    data = /clubs\/(\w+)\.json$/.match(path)
    manufacturer = data[1]

    json = JSON.parse(File.read(path))
    specs[manufacturer] = json
end

CSV.open("out/combined.csv", "wb") do |csv|
    csv << ['BallSpeedInMPH',
            'ClubSpeedInMPH',
            'Smash',
            'CarryDistanceInYards',
            'LaunchAngleVInDegrees',
            'SpinRPM',
            'HeightInFeet',
            'TimeInSeconds',
            'Club',
            'ClubModel',
            'ClubLoft',
            'ClubLengthInInches',
            'ClubLieAngle',
            'Date',
            'SessionHittingOrder']

    Dir["range/**/*.csv"].each do |path|
        data = /\/(\S+)\/(\d)_([^_]+)_(\S+)\.csv$/.match(path)
        date = data[1]
        order = data[2]
        manufacturer = data[3]
        model = data[4]

        CSV.foreach(path, headers: true) do |row|
            club = row[-1]
            row << "#{manufacturer}_#{model}"
            row << specs.dig(manufacturer, model, club, "loft")
            row << specs.dig(manufacturer, model, club, "length")
            row << specs.dig(manufacturer, model, club, "lie")
            row << date
            row << order
            csv << row
        end
    end
end
