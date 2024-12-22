```mermaid
classDiagram
    class UserEntity {
        +String userID
        +String email
        +String name
        +int tripsCount
        +int visitedPlacesCount
        +double spentMoney
        +int citiesCount
    }

    class TripEntity {
        +String userID
        +String tripID
        +double totalBudget
    }

    class CityEntity {
        +String cityID
        +String cityName
        +List~String~ placeIDs
        +List~String~ dishIDs
        +List~String~ accommodationIDs
        +double cityBudget
        +DateTime startDay
        +DateTime endDay
    }

    class DishEntity {
        +String? dishID
        +String name
        +String restaurant
    }

    class PlaceEntity {
        +String? placeID
        +String name
        +String address
    }

    class AccommodationEntity {
        +String accommodationID
        +String name
        +String address
        +DateTime startDay
        +DateTime endDay
    }

    class FileEntity {
        +String? id
        +String name
        +String fileUrl
        +String fileType
    }

    class UserBudgetEntity {
        +String userID
        +List~BudgetItem~ dishPrices
        +List~BudgetItem~ placePrices
        +List~BudgetItem~ accommodationPrices
        +double totalDishCost()
        +double totalPlacesCost()
        +double totalAccommodationCost()
        +double totalCost()
    }

    UserEntity --> TripEntity : "1 owns *"
    TripEntity --> CityEntity : "1 contains *"
    CityEntity --> PlaceEntity : "1 includes *"
    CityEntity --> DishEntity : "1 includes *"
    CityEntity --> AccommodationEntity : "1 includes *"
    UserEntity --> UserBudgetEntity : "1 manages 1"
