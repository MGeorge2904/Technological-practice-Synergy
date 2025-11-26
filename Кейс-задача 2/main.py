def age_to_str(age: int) -> str:
    num = age % 10
    if num == 1 and age != 11:
        result = "год"
    elif 2 <= num <= 4 and age not in (12, 13, 14):
        result = "года"
    else:
        result = "лет"
    return result

class Animal:
    def __init__(self, name, age):
        self.name = name
        self.age = age
    
    def speak(self):
        return "Животное издаёт звук"
    
    def eat(self):
        return f"{self.name} кушает"
    
    def info(self):
        return f"Имя: {self.name}, Возраст: {self.age} {age_to_str(self.age)}"


class Dog(Animal):
    def __init__(self, name, age, breed):
        super().__init__(name, age)
        self.breed = breed
    
    def speak(self):
        return "Гав-гав!"
    
    def fetch(self):
        return f"{self.name} приносит игрушку"
    
    def info(self):
        base_info = super().info()
        return f"{base_info}, Порода: {self.breed}"


class Cat(Animal):    
    def __init__(self, name, age, color):
        super().__init__(name, age)
        self.color = color
    
    def speak(self):
        return "Мяу-мяу!"
    
    def climb(self):
        return f"{self.name} залезает на когтеточку"
    
    def info(self):
        return f"{super().info()}, Цвет: {self.color}"


def test_animals():
    print("ДЕМОНСТРАЦИЯ РАБОТЫ КЛАССОВ ЖИВОТНЫХ")
    
    animal = Animal("Неизвестное животное", 21)
    dog = Dog("Лучик", 6, "Немецкий шпиц")
    cat = Cat("Люся", 3, "Коричнево-рыжий")
    
    print("\n1. МЕТОДЫ БАЗОВОГО КЛАССА:")
    print(f"Animal.speak(): {animal.speak()}")
    print(f"Animal.eat(): {animal.eat()}")
    print(f"Animal.info(): {animal.info()}")
    
    print("\n2. МЕТОДЫ ПРОИЗВОДНОГО КЛАССА DOG:")
    print(f"Dog.speak(): {dog.speak()}")
    print(f"Dog.eat(): {dog.eat()}")
    print(f"Dog.info(): {dog.info()}")
    print(f"Dog.fetch(): {dog.fetch()}")
    
    print("\n3. МЕТОДЫ ПРОИЗВОДНОГО КЛАССА CAT:")
    print(f"Cat.speak(): {cat.speak()}")
    print(f"Cat.eat(): {cat.eat()}")
    print(f"Cat.info(): {cat.info()}")
    print(f"Cat.climb(): {cat.climb()}")
    
    print("\n4. ПОЛИМОРФИЗМ:")
    animals = [animal, dog, cat]
    for animal_obj in animals:
        print(f"{animal_obj.name}: {animal_obj.speak()}")


if __name__ == "__main__":
    test_animals()
