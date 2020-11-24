# frozen_string_literal: true

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require './modules/company_name'
require './modules/instance_counter'

# 2 Класса - 1(ProgramData) - хранение данных, 2(MainMenu) - Интерфейс
# Класс MainMenu содержит подклассы - подменю

class ProgramData
  attr_accessor :all_stations, :all_routes, :all_trains, :all_wagons

  def initialize(all_stations = {}, all_routes = {}, all_wagons = {}, all_trains = {})
    @all_stations = all_stations # Нужна ли эта переменная, если в классе Station теперь присутствует метод all и перменная класса @@all_stations
    @all_routes = all_routes
    @all_wagons = all_wagons
    @all_trains = all_trains
  end

  # Метод сид создан для автоматизации создания и связывания объектов
  # Он создает:
  #
  # 3 станции (Moscow, Spb, Ekb)
  # 1 маршрут (Route) - Станции: Moscow | Ekb | Spb
  # 2 поезда (Грузовой 111Aa, Пассажирский 222Bb)

  def self.seed(data)
    moscow = Station.new('Moscow')
    data.all_stations.merge!({ 'Moscow' => moscow })
    spb = Station.new('Spb')
    data.all_stations.merge!({ 'Spb' => spb })
    ekb = Station.new('Ekb')
    data.all_stations.merge!({ 'Ekb' => ekb })

    route = Route.new('Route', moscow, spb)
    data.all_routes.merge!({ 'Route' => route })

    route.insert_station(ekb)

    cart1 = CargoTrain.new('111Aa')
    data.all_trains.merge!({ '111Aa' => cart1 })
    past2 = PassengerTrain.new('222Bb')
    data.all_trains.merge!({ '222Bb' => past2 })
    data.all_trains['111Aa'].take_route(route)
    data.all_trains['222Bb'].take_route(route)

    carwag1 = CargoWagon.new('01', 100)
    data.all_wagons.merge!({ '01' => carwag1 })
    cart1.add_wagon(carwag1)
    carwag2 = CargoWagon.new('02', 120)
    data.all_wagons.merge!({ '02' => carwag2 })
    cart1.add_wagon(carwag2)

    paswag1 = PassengerWagon.new('03', 30)
    data.all_wagons.merge!({ '03' => paswag1 })
    past2.add_wagon(paswag1)
    paswag2 = PassengerWagon.new('04', 35)
    data.all_wagons.merge!({ '04' => paswag2 })
    past2.add_wagon(paswag2)

    p 'Созданы:'
    p '3 станции (Moscow, Spb, Ekb)'
    p '1 маршрут (Route) - Станции: Moscow | Ekb | Spb'
    p '2 поезда (Грузовой 111Aa, Пассажирский 222Bb)'
    p '4 вагона (2 грузовых (01, 02) и 2 пассажирских(03,04))'
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
      p 'Введите 5, чтобы запустить сид'
      p 'Для выхода введите 0'
      choice = gets.chomp
      case choice
      when '0'
        abort 'Вы вышли из программы'
      when '1'
        StationMenu.new(@data).menu
      when '2'
        TrainMenu.new(@data).menu
      when '3'
        RouteMenu.new(@data).menu
      when '4'
        WagonMenu.new(@data).menu
      when '5'
        ProgramData.seed(@data)
      else
        p 'Вы ввели недопустимую команду!'
      end
    end
  end

  protected

  def valid?(object)
    object.validate!
    true
  rescue StandardError
    false
  end
end

class StationMenu < MainMenu
  def menu
    p 'МЕНЮ СТАНЦИЙ'
    p 'Введите 0, чтобы просмотреть список всех станций'
    p 'Введите 1, чтобы создать станцию'
    p 'Введите 2, чтобы посмотреть поезда на станции'
    p 'введите другой символ чтобы выйти'
    loop do
      choice = gets.chomp
      case choice
      when '0'
        p Station.all
      when '1'
        create_station
      when '2'
        show_trains
      end
      break
    end
  end

  private

  # Пользователь не дорлжен иметь доступ к редактированию этих методов

  def create_station
    p 'Введите название станции'
    name = gets.chomp
    @data.all_stations.merge!({ name => Station.new(name) })
  rescue StandardError
    p '!!! Название станции должно быть на английском языке и с заглавной буквы !!!'
    retry
  end

  def show_trains
    p 'Выберите станцию'
    station = gets.chomp
    @data.all_stations[station].show_trains do |train|
      p "Номер поезда: #{train.number}"
      p "Тип: #{train.train_type}"
      p "количество вагонов: #{train.wagon_list.length}"
    end
  end
end

class TrainMenu < MainMenu
  def menu
    p 'Вы зашли в меню поездов'
    p 'Введите 0, чтобы посмотреть все поезда'
    p 'Нажмите 1, чтобы создать поезд без типа'
    p 'Введите 2, чтобы создать пассажирский поезд'
    p 'Введите 3, чтобы создать грузовой поезд'
    p 'Введите 4, чтобы назначить маршрут поезду'
    p 'Введите 5, чтобы поезд проследовал на следующую станцию'
    p 'Введите 6, чтобы поезд проследовал на предыдущую станцию'
    p 'Введите 7, чтобы просмотреть вагоны поезда'
    p 'введите другой символ чтобы выйти'

    loop do
      choice = gets.chomp
      case choice
      when '0'
        trains_list
      when '1'
        type = 'notype'
        create_train(type)
      when '2'
        type = 'passenger'
        create_train(type)
      when '3'
        type = 'cargo'
        create_train(type)
      when '4'
        take_route
      when '5'
        move_forward
      when '6'
        move_back
      when '7'
        show_wagons
      end
      break
    end
  end

  private

  # Пользователь не дорлжен иметь доступ к редактированию этих методов

  def trains_list
    p @data.all_trains.to_s
  end

  def create_train(type)
    begin
      p 'Введите номер поезда'
      number = gets.chomp
      case type
      when 'passenger'
        @data.all_trains.merge!({ number => PassengerTrain.new(number) })
      when 'cargo'
        @data.all_trains.merge!({ number => CargoTrain.new(number) })
      else
        type == 'notype'
        @data.all_trains.merge!({ number => Train.new(number) })
      end
    rescue StandardError
      p 'Допустимый формат:'
      p  'три буквы или цифры в любом порядке,'
      p  'необязательный дефис (может быть, а может нет)'
      p  'и еще 2 буквы или цифры после дефиса.'
      retry
    end
    begin
      p 'Введите название компании-производетеля'
      @data.all_trains[number].set_company_name
    rescue StandardError
      p '!!! Название компании должно быть на английском языке и с заглавной буквы !!!'
      retry
    end
    p "Создан поезд с номером №#{number}, от компании-производителя '#{@data.all_trains[number].get_company_name}'"
  end

  def take_route
    p 'Какой маршрут хотите добавить?'
    route_name = gets.chomp
    route = @data.all_routes[route_name]
    p 'Какому поезду хотите назначить этот маршрут?'
    train_name = gets.chomp
    @data.all_trains[train_name].take_route(route)
  end

  def move_forward
    p 'Выберите поезд'
    train_name = gets.chomp
    @data.all_trains[train_name].move_forward
  end

  def move_back
    p 'Выберите поезд'
    train_name = gets.chomp
    @data.all_trains[train_name].move_back
  end

  def show_wagons
    p 'Выберите поезд'
    train = gets.chomp
    @data.all_trains[train].show_wagons do |wagon|
      p "Номер вагона: #{wagon.number}"
      p "Тип: #{wagon.wagon_type}"
      case wagon.wagon_type
      when :passenger
        p "количество свободнх мест: #{wagon.vacant_seats}"
        p "Количество занятых мест: #{wagon.taken_seats}"
      when :cargo
        p "Свободный объем: #{wagon.free_volume}"
        p "Занятый объем: #{wagon.occupied_volume}"
      end
    end
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
      case choice
      when '0'
        routes_list
      when '1'
        create_route
      when '2'
        add_station
      when '3'
        remove_station
      end
      break
    end
  end

  private

  # Пользователь не дорлжен иметь доступ к редактированию этих методов

  def routes_list
    p @data.all_routes.to_s
  end

  def create_route
    p 'Задайте начальную станцию в маршруте'
    base = @data.all_stations[gets.chomp]
    p 'Задайте конечную станцию в маршруте'
    terminal = @data.all_stations[gets.chomp]
    begin
      p 'Введите название маршрута'
      name = gets.chomp
      @data.all_routes.merge!({ name => Route.new(name, base, terminal) })
    rescue StandardError
      p '!!! Название маршрута должно быть на английском языке и с заглавной буквы !!!'
      retry
    end
  end

  def add_station
    p 'К какому маршруту добавить станцию?'
    route_name = gets.chomp
    p 'Какую станцию добавить?'
    station_name = gets.chomp
    station = @data.all_stations[station_name]
    @data.all_routes[route_name].insert_station(station)
  end

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
    p 'Введите 5, чтобы занять место в пассажирском вагоне'
    p 'Введите 6, чтобы загрузить грузовой вагон'
    p 'введите другой символ чтобы выйти'

    loop do
      choice = gets.chomp
      case choice
      when '0'
        wagons_list
      when '1'
        type = 'passenger'
        create_wagon(type)
      when '2'
        type = 'cargo'
        create_wagon(type)
      when '3'
        add_to_train
      when '4'
        remove_from_train
      when '5'
        take_seat
      when '6'
        occupy_volume
      end
      break
    end
  end

  private

  def create_wagon(type)
    begin
      p 'Введите номер вагона'
      number = gets.chomp
      case type
      when 'passenger'
        p 'введите количество мест в вагоне'
        vacant_seats = gets.chomp.to_i
        @data.all_wagons.merge!({ number => PassengerWagon.new(number, vacant_seats) })
      when 'cargo'
        p 'введите объем вагона'
        free_volume = gets.chomp.to_i
        @data.all_wagons.merge!({ number => CargoWagon.new(number, free_volume) })
      end
    rescue StandardError
      p '!!! Номер должен состоять из 2 цифр !!!'
      retry
    end
    begin
      p 'Введите название компании-производетеля'
      @data.all_wagons[number].set_company_name
    rescue StandardError
      p '!!! Название компании должно быть на английском языке и с заглавной буквы !!!'
      retry
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

  def take_seat
    p 'введите номер пассажирского вагона, в котором хотите занять место'
    @data.all_wagons[gets.chomp].take_seat
  end

  def occupy_volume
    p 'введите номер грузовог вагона, в котором хотите поместить груз'
    wagon_number = gets.chomp
    begin
      p 'введите объем загрузки'
      load = gets.chomp.to_i
      @data.all_wagons[wagon_number].occupy_volume(load)
    rescue RuntimeError
      p '!!! Объем загрузки превышает свободный объем вагона !!!'
      retry
    end
  end
end

data = ProgramData.new
main = MainMenu.new(data).menu
