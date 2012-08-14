# Kbb

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'kbb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kbb

## Usage

### Basic Usage

Set up a client with your credentials:

settings:
  password: 'password'
  username: 'username'
  endpoint: 'http://209.67.183.60/3.0/VehicleInformationService.svc'
  host: 'sample.idws.syndication.kbb.com'

KelleyBlueBook = Kbb::Client.new(settings['username'], settings['password'], :endpoint => settings['endpoint'], :host => settings['host'])

Make calls:

KelleyBlueBook.get_makes_by_year(1999)
=> [{:make=>"Acura", :make_id=>"2"}, {:make=>"Audi", :make_id=>"4"}, {:make=>"BMW", :make_id=>"5"}, {:make=>"Buick", :make_id=>"7"} ...

### With Retries

The service occasionally times out or returns invalid data.  Use Kbb::Client.with_retries to try again when that happens:

Kbb::Client.with_retries(3) do
  KelleyBlueBook.get_makes_by_year(1999)
end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
