import 'package:flutter/material.dart';
import 'package:flutter_event_manager/event/event_data_source.dart';
import 'package:flutter_event_manager/event/event_detail_view.dart';
import 'package:flutter_event_manager/event/event_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'event_model.dart';



class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  final eventService= EventService();
  //danh sách sự kiện
  List <EventModel> items = [];
  //tạo calendar
  final calendarController = CalendarController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    calendarController.view =CalendarView.day;
    loadEvents();
  }

  Future<void> loadEvents() async{
    final events = await eventService.getAllEvents();
    setState(() {
      items =events;
    });
  }


  @override
  Widget build(BuildContext context) {
    
    final al = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(al.appTitle)),
      actions:[
        PopupMenuButton<CalendarView>(
          onSelected:(value) {
            setState(() {
              calendarController.view = value;
            });
          },
          itemBuilder: (context)=> CalendarView.values.map((view){
          return PopupMenuItem<CalendarView>(
            value: view,
            child: ListTile(
              title: Text(view.name),
            ),
            
            );

        }).toList(),
        
        icon: getCalendarViewIcon(calendarController.view!),
      ),
      IconButton(
        onPressed: () {
            calendarController.displayDate=DateTime.now();
      }, 
      icon: const Icon(Icons.today_outlined),
      ),
      IconButton(onPressed: loadEvents, icon: const Icon(Icons.refresh))
      ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SfCalendar (
          controller: calendarController,
          dataSource: EventDataSource(items),
          monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
            onLongPress: (details){
              if (details.targetElement==CalendarElement.calendarCell){
                final newEvent = EventModel(
                  startTime: details.date!,
                  endTime: details.date!.add(const Duration(hours:1)),
                  subject: 'Sự kiện mới');
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context){
                    return EventDetailView(event: newEvent);
                  },
                  )).then((value) async{
                    if (value ==true){
                      await loadEvents();
                    }
                  });
                  
              }
            },
            //chạm vào sk xem cập nhật
            onTap: (details){
              if(details.targetElement == CalendarElement.appointment){
                final EventModel event =details.appointments!.first;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context){
                    return EventDetailView(event: event);
                  },
                )).then((value) async {
                  if (value == true){
                    await loadEvents();
                  }
                } );
              }
            },
                  
        
                ),
      ));
            }
          

      
    
  }
  Icon getCalendarViewIcon(CalendarView view){
    switch (view) {
      case CalendarView.day:
      return const Icon(Icons.calendar_view_day_outlined);
      case CalendarView.week:
      return const Icon(Icons.calendar_view_week_outlined);
      case CalendarView.workWeek:
      return const Icon(Icons.work_history_outlined);
      case CalendarView.month:
      return const Icon(Icons.calendar_view_month_outlined);
       case CalendarView.schedule:
      return const Icon(Icons.schedule_outlined);
      
      default:
      return const Icon(Icons.calendar_today_outlined);



    }
  }
