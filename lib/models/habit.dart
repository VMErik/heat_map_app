import 'package:isar/isar.dart';

// Corremos el comando en la consola : dart run build_runner build
part 'habit.g.dart';


// Lo marcamos como una coleccion para que se cree el modelo
@Collection()
class Habit{
  Id id = Isar.autoIncrement;
  late String name;
  // Formato
  // DateTime(year,month,day)
  List<DateTime> completedDays = [];
}