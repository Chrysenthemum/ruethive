import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Notification types ───────────────────────────────────────────
enum NotifType { schedule, urgentNotice, departmentNotice, crApproval, general }

// ── A single notification item ───────────────────────────────────
class AppNotification {
  final String id;
  final NotifType type;
  final String title;
  final String body;
  final DateTime time;
  bool isRead;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
  });

  AppNotification copyWith({bool? isRead}) => AppNotification(
    id: id,
    type: type,
    title: title,
    body: body,
    time: time,
    isRead: isRead ?? this.isRead,
  );
}

// ── Notification settings ────────────────────────────────────────
class NotifSettings {
  final bool enabled;
  final bool newSchedules;
  final bool urgentNotices;
  final bool departmentNotices;
  final bool crApprovalUpdates;

  const NotifSettings({
    this.enabled = true,
    this.newSchedules = true,
    this.urgentNotices = true,
    this.departmentNotices = true,
    this.crApprovalUpdates = true,
  });

  NotifSettings copyWith({
    bool? enabled,
    bool? newSchedules,
    bool? urgentNotices,
    bool? departmentNotices,
    bool? crApprovalUpdates,
  }) =>
      NotifSettings(
        enabled: enabled ?? this.enabled,
        newSchedules: newSchedules ?? this.newSchedules,
        urgentNotices: urgentNotices ?? this.urgentNotices,
        departmentNotices: departmentNotices ?? this.departmentNotices,
        crApprovalUpdates: crApprovalUpdates ?? this.crApprovalUpdates,
      );
}

// ── Combined state ───────────────────────────────────────────────
class NotificationState {
  final List<AppNotification> notifications;
  final NotifSettings settings;

  const NotificationState({
    required this.notifications,
    required this.settings,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationState copyWith({
    List<AppNotification>? notifications,
    NotifSettings? settings,
  }) =>
      NotificationState(
        notifications: notifications ?? this.notifications,
        settings: settings ?? this.settings,
      );
}

// ── Notifier ─────────────────────────────────────────────────────
class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier()
      : super(NotificationState(
    notifications: _dummyNotifications(),
    settings: const NotifSettings(),
  ));

  void markAsRead(String id) {
    state = state.copyWith(
      notifications: state.notifications
          .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
          .toList(),
    );
  }

  void markAllAsRead() {
    state = state.copyWith(
      notifications:
      state.notifications.map((n) => n.copyWith(isRead: true)).toList(),
    );
  }

  void clearAll() {
    state = state.copyWith(notifications: []);
  }

  void removeNotification(String id) {
    state = state.copyWith(
      notifications: state.notifications.where((n) => n.id != id).toList(),
    );
  }

  // Settings toggles
  void toggleAll(bool value) {
    state = state.copyWith(settings: state.settings.copyWith(enabled: value));
  }

  void toggleNewSchedules(bool value) {
    state = state.copyWith(
        settings: state.settings.copyWith(newSchedules: value));
  }

  void toggleUrgentNotices(bool value) {
    state = state.copyWith(
        settings: state.settings.copyWith(urgentNotices: value));
  }

  void toggleDepartmentNotices(bool value) {
    state = state.copyWith(
        settings: state.settings.copyWith(departmentNotices: value));
  }

  void toggleCRApprovalUpdates(bool value) {
    state = state.copyWith(
        settings: state.settings.copyWith(crApprovalUpdates: value));
  }
}

// ── Provider ─────────────────────────────────────────────────────
final notificationProvider =
StateNotifierProvider<NotificationNotifier, NotificationState>(
        (ref) => NotificationNotifier());

// Convenience provider for unread count only
final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).unreadCount;
});

// ── Dummy data ────────────────────────────────────────────────────
List<AppNotification> _dummyNotifications() {
  final now = DateTime.now();
  return [
    AppNotification(
      id: '1',
      type: NotifType.urgentNotice,
      title: '🚨 Urgent: Lab Rescheduled',
      body: "Tomorrow's SDP lab has been moved from 10:00 AM to 11:00 AM. Please update your schedule.",
      time: now.subtract(const Duration(minutes: 15)),
      isRead: false,
    ),
    AppNotification(
      id: '2',
      type: NotifType.schedule,
      title: '📅 New Schedule Posted',
      body: 'Data Structures class added for Monday 9:00 AM – 10:20 AM in Room 302.',
      time: now.subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    AppNotification(
      id: '3',
      type: NotifType.crApproval,
      title: '✅ CR Request Approved',
      body: 'Your Class Representative request for CSE 23 Section A has been approved by Admin.',
      time: now.subtract(const Duration(hours: 5)),
      isRead: false,
    ),
    AppNotification(
      id: '4',
      type: NotifType.departmentNotice,
      title: '📢 Mid-Term Exam Schedule',
      body: 'Mid-term exam schedule for all 2nd year students has been published. Check the notices section.',
      time: now.subtract(const Duration(days: 1)),
      isRead: true,
    ),
    AppNotification(
      id: '5',
      type: NotifType.schedule,
      title: '📅 OOP Extra Class',
      body: 'An extra OOP class has been scheduled for Saturday 11:00 AM – 12:00 PM in Room 401.',
      time: now.subtract(const Duration(days: 1, hours: 3)),
      isRead: true,
    ),
    AppNotification(
      id: '6',
      type: NotifType.departmentNotice,
      title: '📢 Project Submission Reminder',
      body: 'SDP project submission deadline is this Friday at 5:00 PM. Late submissions will not be accepted.',
      time: now.subtract(const Duration(days: 2)),
      isRead: true,
    ),
    AppNotification(
      id: '7',
      type: NotifType.general,
      title: '🎉 Welcome to RUETHive',
      body: 'Your account has been set up successfully. Stay updated with your class schedules and notices here.',
      time: now.subtract(const Duration(days: 7)),
      isRead: true,
    ),
  ];
}
