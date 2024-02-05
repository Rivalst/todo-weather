# wat_do

The simplest layout just to interact with the screen/buttons

About the ToDo side:

- To save data between sessions, the Hive package is used and the box implemented with ToDoModel
Because Hive is a NoSQL database, the speed of extracting data is still O(n), which means that the more ToDos the database has, the longer the data will be captured. It is clear that on small volumes of data, it is better suited for the implementation of a simple addition.

- Implemented CRUD. ToDo models can be created, read, updated and deleted.

- To manage state, implemented ToDoBloc together with ToDoEvent and ToDoState

- Filtering of ToDos has also been implemented: with the done status ToDos, with the not done status ToDos, a list of all ToDos, and a filter by categories.

- The frequency of interest in all categories is equal to O(n) because the list of categories is taken from the list of all ToDos.

About the Weather side:

- To work with the api, selected the http package, which very simpl in implementation, supporting async and http methods such as GET, POST, PUT, DELETE.

- To manage the state, implemented WeatherBloc together with WeatherEvent and ToDoState

- To find the place for displaying the current weather, the geolocator package is used, which allows you to easily select the coordinates (location) of the device from which to ask.

About localization:

- For localization I used the flutter_localizations package

- For state control localization, cubit is used

- Implemented Ukrainian and English languages

Note: 

1. Works on both platform iOS and Android.
2. I hope that you are aware that the simulators indicate the wrong location for geodata

