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

  #
  # Метод сид создан для автоматизации создания объектов
  # Он создает:
  #
  # 3 станции (st1, st2, st3)
  # 1 маршрут (rt1)
  # 1 поезд грузовой поезд (tr1) - скорость поезда при создании = 1
  # 1 грузовой вагон (carwag)
  #

  def self.seed(data)
    st1 = Station.new('st1')
    data.all_stations.merge!({ 'st1' => st1 })
    st2 = Station.new('st2')
    data.all_stations.merge!({ 'st2' => st2 })
    st3 = Station.new('st3')
    data.all_stations.merge!({ 'st3' => st3 })

    rt1 = Route.new('rt1', st2, st1)
    data.all_routes.merge!({ 'rt1' => rt1 })

    rt1.insert_station(st3)

    tr1 = CargoTrain.new('tr1')
    data.all_trains.merge!({ 'tr1' => tr1 })

    carwag = CargoWagon.new('carwag')
    data.all_wagons.merge!({ 'carwag' => carwag })
    data.all_trains['tr1'].take_route(rt1)
    p Station.all
    Train.find
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
      elsif choice == '5'
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
      if choice == '0'
        p Station.all
      elsif choice == '1'
        create_station
      elsif choice == '2'
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
    @data.all_stations[station].trains_list.each { |train| p train.name.to_s }
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
      elsif choice == '4'
        take_route
      elsif choice == '5'
        move_forward
      elsif choice == '6'
        move_back
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
      if type == 'passenger'
        @data.all_trains.merge!({ number => PassengerTrain.new(number) })
      elsif type == 'cargo'
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

  private

  def create_wagon(type)
    begin
      p 'Введите номер вагона'
      number = gets.chomp
      if type == 'passenger'
        @data.all_wagons.merge!({ number => PassengerWagon.new(number) })
      elsif type == 'cargo'
        @data.all_wagons.merge!({ number => CargoWagon.new(number) })
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
end

data = ProgramData.new
main = MainMenu.new(data).menu
