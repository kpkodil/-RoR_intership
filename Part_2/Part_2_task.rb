class Station

	attr_reader :trains_list, :name

	def initialize(name)
		@name = name
		@trains_list = []
	end	

	def show_trains
		self.trains_list.each {|train| p train.name }
		p ''
	end

	def show_trains_types
		types_list = []
		types_hash = Hash.new{0}
		self.trains_list.each { |train| types_list << train.train_type}
		types_list.each{ |type| types_hash[type] += 1 }
		p types_hash
	end

	def train_departure(train)
		if self.trains_list.include?(train)
			p "Куда хотите отправить поезд? (f/b)"
			answer = gets.chomp
			if answer == 'f'
				train.move_forward
			elsif answer == 'b'
				train.move_back
			end
		else
			p "Этого поезда нет на станции!"
		end	
	end
end

class Route

	attr_reader :name, :stations

	def initialize(base,terminal, stations = [])
		@base = base
		@terminal = terminal
		@stations = [@base, @terminal]
	end	

	def insert_station(station)
		unless @stations.include?(station) then
			@stations.insert(-2, station)
		end

	end

	def remove_station(station)
		if @stations.include?(station)
			return @stations.delete(station)
		end
	end

	def show_stations		
		@stations.each { |station| puts station.name}
		puts ''
	end
end

class Train

	attr_reader :name, :train_type, :car_quantity, :speed, :train_station

	def initialize(name, train_type, car_quantity = 0)
		@name = name
		@train_type = train_type
		@car_quantity = car_quantity
		@speed = 0
		@train_route = []
		@train_station = nil
	end	

	def accelerate(speed)
		if speed > 0 
			p @speed += speed
		else 
			p "Введите положительное число!"	
		end
	end

	def stop
		@speed= 0
	end

	def add_car		
		if @speed == 0 
			 @car_quantity += 1
		else
			p "Снизьте скорость до нуля!"
		end		
	end

	def remove_car
		if self.speed == 0
			if self.car_quantity > 0
				@car_quantity -= 1
			else
				p "В этом поезде уже нет вагонов!"
			end
		else
			p "Снизьте скорость до нуля!"
		end	 
	end	

	def take_route(route)
		@train_route = route
		@train_station = route.stations[0] 
		@train_route.stations[0].trains_list << self
	end

	def move_forward
		if self.speed > 0 
			i = @train_route.stations.index(@train_station)
				if i < (@train_route.stations.size - 1)
					@train_station = @train_route.stations[i += 1]
					@train_route.stations[i].trains_list << self
					@train_route.stations[i-1].trains_list.delete(self)
					puts "Поезд отправился на станцию #{@train_station.name}"	
				else
				p "Вы достигли конечной станции!"	
				end
		else
			p "Чтобы двигаться, увеличте скорость!"
		end	
	end

	def move_back
		if @speed > 0 
			i = @train_route.stations.index(@train_station)
			if i > 0
				@train_station = @train_route.stations[i -= 1]
				@train_route.stations[i].trains_list << self
				@train_route.stations[i+1].trains_list.delete(self)
				puts "Поезд отправился на станцию #{@train_station.name}"
			else
				p "Вы достигли начальной станции!"	
			end
		else
			p "Чтобы двигаться, увеличте скорость!"
		end	
	end

	def previous_station
		i = @train_route.stations.index(@train_station)
		if i > 0
			p "Предыдущая станция на маршруте поезда #{self.name}:  #{@train_route.stations[i-1].name}"
		else
			p "Вы находитесь на начальной станции!"
		end
	end

	def next_station
		i = @train_route.stations.index(@train_station)
		if i < (@train_route.stations.size - 1)
			p "Следующая станция на маршруте поезда #{self.name}:  #{@train_route.stations[i+1].name}"
		else
			p "Вы находитесь на конечной станции!"
		end
	end	
end