require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'

# Реализация через подклассы(подменю)
#
#
class ProgramData
  attr_accessor :all_stations, :all_routes, :all_trains, :all_wagons

  def initialize(all_stations = {}, all_routes = {}, all_wagons = {}, all_trains = {})
    @all_stations = all_stations
    @all_routes = all_routes
    @all_wagons = all_wagons
    @all_trains = all_trains
  end
end

class MainMenu
  attr_reader :choice, :data

  def initialize(data)
    @data = data
  end

  def menu
    loop do
      p 'Введите 1, чтобы зайти в меню станций'
      p 'Введите 2, чтобы зайти в меню поездов'
      p 'Введите 3, в меню маршрутов'
      p 'Введите 4, в меню вагонов'
      p 'Для выхода введите 0'
      choice = gets.chomp
      if choice == '0'
        abort 'Вы вышли из программы'
      elsif choice == '1'
        StationMenu.new(@data).menu
      elsif choice == '2'
        TrainMenu.new(@data).menu
      elsif choice == '3'
        RouteMenu.new(@data).menu
      elsif choice == '4'
        WagonMenu.new(@data).menu
      else
        p 'Вы ввели недопустимую команду!'
      end
    end
  end
end

class StationMenu < MainMenu
  def menu
    p 'МЕНЮ СТАНЦИЙ'
    p 'Введите 0, чтобы просмотреть список всех станций'
    p 'Введите 1, чтобы создать станцию'
    p 'введите другой символ чтобы выйти'
    loop do
      choice = gets.chomp
      if choice == '0'
        stations_list
      elsif choice == '1'
        create_station
      end
      break
    end
  end

  def create_station
    p 'Введите название станции'
    name = gets.chomp
    @data.all_stations.merge!({ name => Station.new(name) })
  end

  def stations_list
    p @data.all_stations.to_s
  end
end

class TrainMenu < MainMenu
  def menu
    p 'Вы зашли в меню поездов'
    p 'Введите 0, чтобы посмотреть все поезда'
    p 'Нажмите 1, чтобы создать поезд без типа'
    p 'Введите 2, чтобы создать пассажирский поезд'
    p 'Введите 3, чтобы создать грузовой поезд'
    p 'введите другой символ чтобы выйти'

    loop do
      choice = gets.chomp
      if choice == '0'
        trains_list
      elsif	choice == '1'
        type = 'notype'
        create_train(type)
      elsif choice == '2'
        type = 'passenger'
        create_train(type)
      elsif choice == '3'
        type = 'cargo'
        create_train(type)
      end
      break
    end
  end

  def create_train(type)
    p 'Введите название поезда'
    name = gets.chomp
    if type == 'passenger'
      @data.all_trains.merge!({ name => PassengerTrain.new(name) })
    elsif type == 'cargo'
      @data.all_trains.merge!({ name => CargoTrain.new(name) })
    else
      type == 'notype'
      @data.all_trains.merge!({ name => Train.new(name) })
    end
  end

  def trains_list
    p @data.all_trains.to_s
  end
end

class RouteMenu < MainMenu
  def menu
    p 'Вы зашли в меню маршрутов'
    p 'Введите 0, чтобы посмотреть все маршруты'
    p 'Нажмите 1, чтобы создать маршрут'
    p 'Введите 2, чтобы добавить станцию на маршрут'
    p 'Введите 3, чтобы удалить станцию из маршрута'
    p 'введите другой символ чтобы выйти'

    loop do
      choice = gets.chomp
      if choice == '0'
        routes_list
      elsif	choice == '1'
        create_route
      elsif choice == '2'
        add_station
      elsif choice == '3'
        remove_station
      end
      break
    end
  end

  def routes_list1
    p @data.all_routes.to_s
  end

  def create_route
    # НУЖНО СДЕЛАТЬ ПРОВЕРКУ НА СОВПАДЕНИЕ base и terminal в файле route.rb!!!
    p 'Введите название маршрута'
    name = gets.chomp
    p 'Задайте начальную станцию в маршруте'
    base = @data.all_stations[gets.chomp]
    p 'Задайте конечную станцию в маршруте'
    terminal = @data.all_stations[gets.chomp]
    @data.all_routes.merge!({ name => Route.new(name, base, terminal) })
  end

  def add_station
    p 'К какому маршруту добавить станцию?'
    route_name = gets.chomp
    p 'Какую станцию добавить?'
    station_name = gets.chomp
    station = @data.all_stations[station_name]
    @data.all_routes[route_name].insert_station(station)
  end

  # Можно ли называть метод в главном файле таким же как в методе в остальных файлах?

  def remove_station
    p 'Из какого маршрута удалить станцию?'
    route_name = gets.chomp
    p 'Какую станцию удалить?'
    station_name = gets.chomp
    station = @data.all_stations[station_name]
    @data.all_routes[route_name].remove_station(station)
  end
end

class WagonMenu < MainMenu
  def menu
    p 'Вы зашли в меню вагонов'
    p 'Введите 0, чтобы посмотреть все вагоны'
    p 'Введите 1, чтобы создать пассажирский вагон'
    p 'Введите 2, чтобы создать грузовой вагон'
    p 'Введите 3, чтобы прицепить вагон к поезду'
    p 'Введите 4, чтобы отцепить вагон от поезда'
    p 'введите другой символ чтобы выйти'

    loop do
      choice = gets.chomp
      if choice == '0'
        wagons_list
      elsif	choice == '1'
        type = 'passenger'
        create_wagon(type)
      elsif choice == '2'
        type = 'cargo'
        create_wagon(type)
      elsif choice == '3'
      	add_to_train
      elsif choice == '4'
       	remove_from_train 	  	  
      end
      break
    end
  end

  def create_wagon(type)
    p 'Введите название вагона'
    name = gets.chomp
    if type == 'passenger'
      @data.all_wagons.merge!({ name => PassengerWagon.new(name) })
    elsif type == 'cargo'
      @data.all_wagons.merge!({ name => CargoWagon.new(name) })
    end
  end

  def wagons_list
    p @data.all_wagons.to_s
  end

  def add_to_train
    p 'К какому поезду хотите прицепить вагон?'
    train_name = gets.chomp
    p 'Какой вагон прицепить?'
    wagon_name = gets.chomp
    wagon = @data.all_wagons[wagon_name]
    @data.all_trains[train_name].add_wagon(wagon)
  end

  def remove_from_train
    p 'От какого поезда хотите отцепить вагон?'
    train_name = gets.chomp
    p 'Какой вагон отцепить?'
    wagon_name = gets.chomp
    wagon = @data.all_wagons[wagon_name]
    @data.all_trains[train_name].remove_wagon(wagon)
  end  	
end

data = ProgramData.new
main = MainMenu.new(data).menu
