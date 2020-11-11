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
	def initialize(all_stations = {}, all_routes = [], all_wagons = {}, all_trains = {})
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
			p 'Введите 3, чтобы создать маршрут'
			p 'Для выхода введите 0'
			choice = gets.chomp
			case 
				when choice == '0'
					abort "Вы вышли из программы"
				when choice == '1'
					StationMenu.new(@data).menu
				when choice == '2' 
					TrainMenu.new.menu
				else
					p 'Вы ввели недопустимую команду!'
			end
		end
	end
end

class StationMenu < MainMenu
attr_reader 

	def menu
			p 'МЕНЮ СТАНЦИЙ'
			p 'Введите 1, чтобы создать станцию'
			p 'Введите 2, чтобы просмотреть список всех станций'
			p 'введите другой символ чтобы выйти'
		loop do
			choice = gets.chomp
			case 
			when choice == '1'
				self.create_station	
			when choice == '2'
				self.station_list		
			end	
			break
		end	
	end

	def create_station
		p 'Введите название станции'
		name = gets.chomp
		@data.all_stations.merge!({name => Station.new(name)})
		return menu
	end

	def station_list
		p "#{@data.all_stations}"
	end
end

class TrainMenu < MainMenu

	def menu
		p 'Вы зашли в меню поездов'
		p 'Нажмите 1, чтобы создать поезд без типа'
		p 'Введите 2, чтобы создать пассажирский поезд'
		p 'Введите 3, чтобы создать грузовой поезд'
		p 'введите другой символ чтобы выйти'
		choice = gets.chomp
		loop do
			case 
			when choice == '0'

			when choice == '1'

			when choice == '2'
			
			when choice == '3'	

			end
			break
		end
	end

	def create_train(type)

		return menu
	end
end


data = ProgramData.new
main = MainMenu.new(data).menu