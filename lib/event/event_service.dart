import 'package:flutter_event_manager/event/event_model.dart';
import 'package:localstore/localstore.dart';
class EventService{
  final db = Localstore.getInstance(useSupportDir: true);
  final path ='events';

  //lấy ds từ local store
  Future<List<EventModel>> getAllEvents() async {
    final eventsMap = await db.collection(path).get();
    if(eventsMap != null){
      return eventsMap.entries.map((entry) {
        final eventData = entry.value as Map<String,dynamic>;
        if (!eventData.containsKey('id')){
          eventData['id'] =entry.key.split('/').last;
        }
        return EventModel.fromMap(eventData);

      }).toList();
    }
    return[];
  }
  Future<void> saveEvent(EventModel item) async{
    item.id ??=db.collection(path).doc().id;
    await db.collection(path).doc(item.id).set(item.toMap());


  }
  Future<void> deleteEvent(EventModel item) async{
    
    await db.collection(path).doc(item.id).delete();
    

  }
}