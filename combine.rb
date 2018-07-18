require 'csv'
require 'fileutils'

FileUtils.mkdir_p('out')

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
            'Date',
            'SessionHittingOrder']

    Dir["range/**/*.csv"].each do |path|
        data = /\/(\S+)\/(\d)_(\S+)\.csv$/.match(path)
        date = data[1]
        order = data[2]
        model = data[3]

        CSV.foreach(path, headers: true) do |row|
            row << model
            row << date
            row << order
            csv << row
        end
    end
end
