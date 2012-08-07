class Kbb::Client

  SERVICE_ENDPOINT = "https://idws.syndication.kbb.com/3.0/VehicleInformationService.svc"

  def initialize(username, password, opts = {})
    @savon_client ||= Savon::Client.new do |wsdl, http, wsse, wsa|
      endpoint = opts[:endpoint] || SERVICE_ENDPOINT
      wsdl.document = "#{endpoint}?wsdl"
      wsdl.endpoint = endpoint
      wsdl.namespace = "http://www.kbb.com/2011/01/25/VehicleInformationService"
      wsse.credentials(username, password)
      http.headers["Host"] = opts[:host] || URI(endpoint).host
      http.auth.ssl.verify_mode = :none
    end
  end
  
  def get_makes_by_year(*args)
    response = get_makes_by_year_request(*args)
    get_makes_by_year_response(response)
  end

  def get_models_by_year_and_make(*args)
    response = get_models_by_year_and_make_request(*args)
    get_models_by_year_and_make_response(response)
  end

  def get_trims_and_vehicle_ids_by_year_and_model(*args)
    response = get_trims_and_vehicle_ids_by_year_and_model_request(*args)
    get_trims_and_vehicle_ids_by_year_and_model_response(response)
  end

  def get_vehicle_values_by_vehicle_configuration_all_conditions(*args)
    response = get_vehicle_values_by_vehicle_configuration_all_conditions_request(*args)
    get_vehicle_values_by_vehicle_configuration_all_conditions_response(response)
  end

private

  # GetMakesByYear
  #
  def get_makes_by_year_request(year_id)
    @savon_client.request :wsdl, :get_makes_by_year do
      soap.body = {
        'wsdl:VehicleClass' => 'UsedCar',
        'wsdl:ApplicationCategory' => 'Consumer',
        'wsdl:YearId' => year_id,
        'wsdl:VersionDate' => Date.today }
    end
  end

  def get_makes_by_year_response(response)
    response = response[:get_makes_by_year_response]
    if response
      to_ary(response[:get_makes_by_year_result][:id_string_pair]).map do |make| 
        {:make => make[:value], :make_id => make[:id]}
      end
    else []
    end
  end

  # GetModelsByYearAndMake
  #   
  def get_models_by_year_and_make_request(year_id, make_id)
    @savon_client.request :wsdl, :get_models_by_year_and_make do
      soap.body = {
        'wsdl:VehicleClass' => 'UsedCar',
        'wsdl:ApplicationCategory' => 'Consumer',
        'wsdl:MakeId' => make_id,
        'wsdl:YearId' => year_id,
        'wsdl:VersionDate' => Date.today }
    end
  end

  def get_models_by_year_and_make_response(response)
    response = response[:get_models_by_year_and_make_response]
    if response
      to_ary(response[:get_models_by_year_and_make_result][:id_string_pair]).map do |model|
        {:model => model[:value], :model_id => model[:id]}
      end
    else []
    end
  end

  # GetTrimsAndVehicleIdsByYearAndModel
  #   
  def get_trims_and_vehicle_ids_by_year_and_model_request(year_id, model_id)
    @savon_client.request :wsdl, :get_trims_and_vehicle_ids_by_year_and_model do
      soap.body = {
        'wsdl:VehicleClass' => 'UsedCar',
        'wsdl:ApplicationCategory' => 'Consumer',
        'wsdl:ModelId' => model_id,
        'wsdl:YearId' => year_id,
        'wsdl:VersionDate' => Date.today }
    end
  end

  def get_trims_and_vehicle_ids_by_year_and_model_response(response)
    response = response[:get_trims_and_vehicle_ids_by_year_and_model_response]
    if response
      to_ary(response[:get_trims_and_vehicle_ids_by_year_and_model_result][:vehicle_trim]).each do |trim|
        {:trim => trim[:display_name], :trim_id => trim[:id], :vehicle_id => trim[:vehicle_id]}
      end
    else []
    end
  end

  # GetVehicleValuesByVehicleConfigurationAllConditions
  #   
  def get_vehicle_values_by_vehicle_configuration_all_conditions_request(vehicle_id, mileage, zip_code)
    @savon_client.request :wsdl, :get_vehicle_values_by_vehicle_configuration_all_conditions do
      soap.body = {
        'wsdl:VehicleConfiguration' => {
          'wsdl:Id' => vehicle_id,
          'wsdl:VIN' => '?',
          'wsdl:Year' => {},  # 'wsdl:Id' => '2010', 'wsdl:Value' => '2010'
          'wsdl:Make' => {},  # 'wsdl:Id' => '15', 'wsdl:Value' => 'Ford'
          'wsdl:Model' => {}, # 'wsdl:Id' => '842', 'wsdl:Value' => 'F150 SuperCrew Cab'
          'wsdl:Trim' => {},  # 'wsdl:Id' => '270010', 'wsdl:Value' => 'XL Pickup 4D 6 1/2 ft'
          'wsdl:Mileage' => mileage,
          'wsdl:OptionalEquipment' => {'wsdl:EquipmentOption' => []},
          'wsdl:ConfiguredDate' => Date.today },
       'wsdl:ApplicationCategory' => 'Consumer',
       'wsdl:ZipCode' => zip_code,
       'wsdl:VersionDate' => Date.today
      }
    end
  end

  def get_vehicle_values_by_vehicle_configuration_all_conditions_response(response)
    response = response[:get_vehicle_values_by_vehicle_configuration_all_conditions_response]
    if response
      result = response[:get_vehicle_values_by_vehicle_configuration_all_conditions_result]
      values = result[:valuation_prices][:valuation].inject({}) {|h, val| h[val[:price_type].underscore] = val[:value]; h}
      [:is_insufficient_market_data, :is_limited_production, :mileage_adjustment, :mileage_zero_point].each do |field|
        values[field.to_s] = result[field]
      end; values
    else {}
    end
  end

# helpers

  def to_ary(o)
    [o].flatten
  end

end
