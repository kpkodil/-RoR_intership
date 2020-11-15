class CargoTrain < Train

#Модули наследуются , а перменная @instance - нет

  def initialize(name)
    super
    @train_type = :cargo
  end
end