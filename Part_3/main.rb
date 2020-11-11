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
    p 'Введите 1, чтобы создать станцию'
    p 'Введите 2, чтобы просмотреть список всех станций'
    p 'введите другой символ чтобы выйти'
    loop do
      choice = gets.chomp
      if choice == '1'
        create_station
      elsif choice == '2'
        station_list
      end
      break
    end
  end

  def create_station
    p 'Введите название станции'
    name = gets.chomp
    @data.all_stations.merge!({ name => Station.new(name) })
    return @data
  end

  def station_list
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
        type = "notype"
        create_train(type)
      elsif choice == '2'
        type = "passenger"
        create_train(type)
      elsif choice == '3'
        type = "cargo"
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
    else type == 'notype'
      @data.all_trains.merge!({ name => Train.new(name) })
    end
  end

  def trains_list
    p "#{@data.all_trains.to_s}"
  end
end

data = ProgramData.new
main = MainMenu.new(data).menu
