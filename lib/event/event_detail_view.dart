import 'package:flutter/material.dart';

import 'event_service.dart';
import 'event_model.dart';

class EventDetailView extends StatefulWidget {
  final EventModel event;
  const EventDetailView({super.key, required this.event});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  final subjectController = TextEditingController();
  final notesController = TextEditingController();
  final eventService = EventService();

  @override
  void initState() {
    super.initState();
    subjectController.text = widget.event.subject;
    notesController.text = widget.event.notes ?? '';
  }

  Future<void> _pickDatetime({required bool isStart}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? widget.event.startTime : widget.event.endTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      if (!mounted) return;
      final dateTime = isStart
          ? widget.event.startTime ?? DateTime.now()
          : widget.event.endTime ?? DateTime.now().add(Duration(hours: 1));

      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(dateTime),
      );

      if (pickedTime != null) {
        setState(() {
          final newDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (isStart) {
            widget.event.startTime = newDateTime;

            if (widget.event.endTime == null ||
                widget.event.endTime!.isBefore(newDateTime)) {
              widget.event.endTime = newDateTime.add(const Duration(hours: 1));
            }
          } else {
            widget.event.endTime = newDateTime;

            if (widget.event.startTime == null ||
                widget.event.startTime!.isAfter(newDateTime)) {
              widget.event.startTime = newDateTime.subtract(
                const Duration(hours: 1),
              );
            }
          }
        });
      }
    }
  }

  Future<void> _saveEvent() async {
    widget.event.subject = subjectController.text;
    widget.event.notes = notesController.text;
    await eventService.saveEvent(widget.event);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _deleteEvent() async {
    if (widget.event.id != null) {
      await eventService.deleteEvent(widget.event.id!);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.event.id == null ? 'Them su kien' : 'Chi tiet su kien',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(labelText: 'Ten su kien'),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('SU kien ca ngay'),
              trailing: Switch(
                value: widget.event.isAllDay,
                onChanged: (value) {
                  setState(() {
                    widget.event.isAllDay = value;
                  });
                },
              ),
            ),
            if (!widget.event.isAllDay) ...[
              const SizedBox(height: 16),
              ListTile(
                title: Text('Bat dau: ${widget.event.formatedStartTimeString}'),
                subtitle: Text(widget.event.startTime.toString()),
                onTap: () => _pickDatetime(isStart: true),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('Bat dau: ${widget.event.formatedEndTimeString}'),
                subtitle: Text(widget.event.endTime.toString()),
                onTap: () => _pickDatetime(isStart: false),
              ),
            ],
            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Ghi chu'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (widget.event.id != null)
                  FilledButton.tonalIcon(
                    onPressed: _deleteEvent,
                    label: const Text('Xoa su kien'),
                  ),
                FilledButton.icon(
                  onPressed: _saveEvent,
                  label: const Text('Luu su kien'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
