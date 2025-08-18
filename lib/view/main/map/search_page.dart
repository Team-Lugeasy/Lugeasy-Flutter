import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lugeasy/common/widgets/common_button.dart';
import 'package:lugeasy/view/main/map/components/host_time_slot_button.dart';
import 'package:lugeasy/models/host_time_slot.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lugeasy/common/extensions/context_extension.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _locationController = TextEditingController();

  DateTime? _dropOffDate;
  TimeSlot? _dropOffTimeSlot;
  DateTime? _findingDate;
  TimeSlot? _findingTimeSlot;

  String? _selectedLocation;

  late DateTime _focusedDay;
  bool _isDropOffCalendarVisible = false;
  bool _isFindingCalendarVisible = false;
  bool _isDropOffTimeVisible = false;
  bool _isFindingTimeVisible = false;
  bool _isLocationSheetVisible = false;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    // 모든 날짜와 시간을 null로 초기화하여 선택되지 않은 상태로 시작
    _dropOffDate = null;
    _dropOffTimeSlot = null;
    _findingDate = null;
    _findingTimeSlot = null;
    // 위치 입력 변경 시 버튼 활성화 상태 갱신
    _locationController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _onSearch() {
    // TODO: 검색 로직 구현
    print('Search with:');
    print('Location: ${_locationController.text}');
    print('Drop-off date: $_dropOffDate');
    print('Drop-off time: $_dropOffTimeSlot');
    print('Finding date: $_findingDate');
    print('Finding time: $_findingTimeSlot');

    // TODO: 추후 대체
    Navigator.of(context).pop();
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().substring(2); // YY 형식
    final month = date.month.toString(); // m 형식 (앞의 0 제거)
    final day = date.day.toString(); // d 형식 (앞의 0 제거)
    return '$year.$month.$day';
  }

  String _formatTimeSlot(TimeSlot slot) {
    final amPm = slot.isAm ? 'AM' : 'PM';
    return '$amPm ${slot.label}';
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_isDropOffCalendarVisible) {
        _dropOffDate = selectedDay;
        _isDropOffCalendarVisible = false;
      } else if (_isFindingCalendarVisible) {
        _findingDate = selectedDay;
        _isFindingCalendarVisible = false;
      }
      _focusedDay = focusedDay;
    });
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  void _toggleDropOffCalendar() {
    setState(() {
      _isDropOffCalendarVisible = !_isDropOffCalendarVisible;
      _isFindingCalendarVisible = false; // 다른 달력은 닫기
      _isDropOffTimeVisible = false; // 시간 선택도 닫기
      _isFindingTimeVisible = false; // 다른 시간 선택도 닫기
    });
  }

  void _toggleFindingCalendar() {
    setState(() {
      _isFindingCalendarVisible = !_isFindingCalendarVisible;
      _isDropOffCalendarVisible = false; // 다른 달력은 닫기
      _isDropOffTimeVisible = false; // 시간 선택도 닫기
      _isFindingTimeVisible = false; // 다른 시간 선택도 닫기
    });
  }

  void _toggleDropOffTime() {
    setState(() {
      _isDropOffTimeVisible = !_isDropOffTimeVisible;
      _isFindingTimeVisible = false; // 다른 시간 선택은 닫기
      _isDropOffCalendarVisible = false; // 달력도 닫기
      _isFindingCalendarVisible = false; // 다른 달력도 닫기
    });
  }

  void _toggleFindingTime() {
    setState(() {
      _isFindingTimeVisible = !_isFindingTimeVisible;
      _isDropOffTimeVisible = false; // 다른 시간 선택은 닫기
      _isDropOffCalendarVisible = false; // 달력도 닫기
      _isFindingCalendarVisible = false; // 다른 달력도 닫기
    });
  }

  void _closeAllCalendars() {
    setState(() {
      _isDropOffCalendarVisible = false;
      _isFindingCalendarVisible = false;
      _isDropOffTimeVisible = false;
      _isFindingTimeVisible = false;
    });
  }

  void _onTimeSlotSelected(TimeSlot slot, bool isDropOff) {
    setState(() {
      if (isDropOff) {
        _dropOffTimeSlot = slot;
        _isDropOffTimeVisible = false;
      } else {
        _findingTimeSlot = slot;
        _isFindingTimeVisible = false;
      }
    });
  }

  bool _isAnySelectionMade() {
    return (_selectedLocation != null &&
            _selectedLocation!.trim().isNotEmpty) ||
        _dropOffDate != null ||
        _dropOffTimeSlot != null ||
        _findingDate != null ||
        _findingTimeSlot != null;
  }

  Future<void> _openLocationSheet() async {
    setState(() {
      _isLocationSheetVisible = true;
    });

    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        final TextEditingController queryController = TextEditingController();
        final List<String> allItems = ['Songpa-gu, Seoul', 'Mapo-gu, Seoul'];
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = allItems
                .where((e) => e
                    .toLowerCase()
                    .contains(queryController.text.toLowerCase()))
                .toList();
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: queryController,
                          onChanged: (_) => setModalState(() {}),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            hintText: context.l10n.location,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const Divider(height: 0),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return ListTile(
                            title: Text(item),
                            onTap: () => Navigator.of(context).pop(item),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedLocation = selected;
      });
    }

    setState(() {
      _isLocationSheetVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _closeAllCalendars, // 화면 외부 탭 시 달력 닫기
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 상단 닫기 버튼
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x1A000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // 제목과 위치 검색을 하나의 상자로 묶기
                        _selectedLocation == null
                            ? GestureDetector(
                                onTap: _openLocationSheet,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x1A000000),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context.l10n.location_placeholder,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF5F5F5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 14),
                                            child: Row(
                                              children: [
                                                Icon(Icons.search,
                                                    color: Colors.grey),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                      context.l10n.location,
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: _openLocationSheet,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x1A000000),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_pin,
                                          size: 20,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          context.l10n.location,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              _selectedLocation!,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                        const SizedBox(height: 20),

                        // Drop-off date 섹션 (항상 표시)
                        GestureDetector(
                          onTap: _toggleDropOffCalendar,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x1A000000),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Drop-off date 헤더
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 20,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        context.l10n.drop_off_date,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const Spacer(),
                                      // 현재 선택된 날짜 표시
                                      if (_dropOffDate != null)
                                        Text(
                                          _formatDate(_dropOffDate!),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                    ],
                                  ),

                                  // 달력 (조건부 표시)
                                  if (_isDropOffCalendarVisible) ...[
                                    const SizedBox(height: 20),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TableCalendar(
                                        firstDay: DateTime.now(),
                                        lastDay: DateTime.now()
                                            .add(const Duration(days: 365)),
                                        focusedDay: _focusedDay,
                                        currentDay: DateTime.now(),
                                        selectedDayPredicate: (day) {
                                          return _dropOffDate != null &&
                                              isSameDay(day, _dropOffDate!);
                                        },
                                        onDaySelected: _onDaySelected,
                                        onPageChanged: _onPageChanged,
                                        headerStyle: const HeaderStyle(
                                          formatButtonVisible: false,
                                          titleCentered: true,
                                          leftChevronIcon:
                                              Icon(Icons.chevron_left),
                                          rightChevronIcon:
                                              Icon(Icons.chevron_right),
                                        ),
                                        calendarStyle: const CalendarStyle(
                                          todayDecoration: BoxDecoration(
                                            color: Colors.grey,
                                            shape: BoxShape.circle,
                                          ),
                                          selectedDecoration: BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          selectedTextStyle:
                                              TextStyle(color: Colors.white),
                                          outsideDaysVisible: false,
                                        ),
                                        daysOfWeekStyle: const DaysOfWeekStyle(
                                          weekdayStyle:
                                              TextStyle(color: Colors.grey),
                                          weekendStyle:
                                              TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Drop-off time 섹션 (항상 표시)
                        GestureDetector(
                          onTap: _toggleDropOffTime,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x1A000000),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Drop-off time 헤더
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 20,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        context.l10n.drop_off_time,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const Spacer(),
                                      // 현재 선택된 시간 표시
                                      if (_dropOffTimeSlot != null)
                                        Text(
                                          _formatTimeSlot(_dropOffTimeSlot!),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                    ],
                                  ),

                                  // 시간 슬롯 (조건부 표시)
                                  if (_isDropOffTimeVisible) ...[
                                    const SizedBox(height: 20),
                                    // AM 시간 슬롯
                                    Text(
                                      'AM',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final crossAxisCount = 2;
                                        final spacing = 16.0;
                                        final itemWidth =
                                            (constraints.maxWidth -
                                                    (crossAxisCount - 1) *
                                                        spacing) /
                                                crossAxisCount;

                                        return Wrap(
                                          spacing: spacing,
                                          runSpacing: 12,
                                          children: TimeSlot.values
                                              .where((slot) => slot.isAm)
                                              .map((slot) => SizedBox(
                                                    width: itemWidth,
                                                    child: TimeSlotButton(
                                                      label: slot.label,
                                                      state: _dropOffTimeSlot ==
                                                              slot
                                                          ? TimeSlotState
                                                              .selected
                                                          : TimeSlotState
                                                              .enabled,
                                                      onTap: () =>
                                                          _onTimeSlotSelected(
                                                              slot, true),
                                                    ),
                                                  ))
                                              .toList(),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    // PM 시간 슬롯
                                    Text(
                                      context.l10n.pm,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final crossAxisCount = 2;
                                        final spacing = 16.0;
                                        final itemWidth =
                                            (constraints.maxWidth -
                                                    (crossAxisCount - 1) *
                                                        spacing) /
                                                crossAxisCount;

                                        return Wrap(
                                          spacing: spacing,
                                          runSpacing: 12,
                                          children: TimeSlot.values
                                              .where((slot) => !slot.isAm)
                                              .map((slot) => SizedBox(
                                                    width: itemWidth,
                                                    child: TimeSlotButton(
                                                      label: slot.label,
                                                      state: _dropOffTimeSlot ==
                                                              slot
                                                          ? TimeSlotState
                                                              .selected
                                                          : TimeSlotState
                                                              .enabled,
                                                      onTap: () =>
                                                          _onTimeSlotSelected(
                                                              slot, true),
                                                    ),
                                                  ))
                                              .toList(),
                                        );
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Finding date 섹션 (항상 표시)
                        GestureDetector(
                          onTap: _toggleFindingCalendar,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x1A000000),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Finding date 헤더
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 20,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        context.l10n.finding_date,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const Spacer(),
                                      // 현재 선택된 날짜 표시
                                      if (_findingDate != null)
                                        Text(
                                          _formatDate(_findingDate!),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                    ],
                                  ),

                                  // 달력 (조건부 표시)
                                  if (_isFindingCalendarVisible) ...[
                                    const SizedBox(height: 20),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TableCalendar(
                                        firstDay: DateTime.now(),
                                        lastDay: DateTime.now()
                                            .add(const Duration(days: 365)),
                                        focusedDay: _focusedDay,
                                        currentDay: DateTime.now(),
                                        selectedDayPredicate: (day) {
                                          return _findingDate != null &&
                                              isSameDay(day, _findingDate!);
                                        },
                                        onDaySelected: _onDaySelected,
                                        onPageChanged: _onPageChanged,
                                        headerStyle: const HeaderStyle(
                                          formatButtonVisible: false,
                                          titleCentered: true,
                                          leftChevronIcon:
                                              Icon(Icons.chevron_left),
                                          rightChevronIcon:
                                              Icon(Icons.chevron_right),
                                        ),
                                        calendarStyle: const CalendarStyle(
                                          todayDecoration: BoxDecoration(
                                            color: Colors.grey,
                                            shape: BoxShape.circle,
                                          ),
                                          selectedDecoration: BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          selectedTextStyle:
                                              TextStyle(color: Colors.white),
                                          outsideDaysVisible: false,
                                        ),
                                        daysOfWeekStyle: const DaysOfWeekStyle(
                                          weekdayStyle:
                                              TextStyle(color: Colors.grey),
                                          weekendStyle:
                                              TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Finding time 섹션 (항상 표시)
                        GestureDetector(
                          onTap: _toggleFindingTime,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x1A000000),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Finding time 헤더
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 20,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        context.l10n.finding_time,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const Spacer(),
                                      // 현재 선택된 시간 표시
                                      if (_findingTimeSlot != null)
                                        Text(
                                          _formatTimeSlot(_findingTimeSlot!),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                    ],
                                  ),

                                  // 시간 슬롯 (조건부 표시)
                                  if (_isFindingTimeVisible) ...[
                                    const SizedBox(height: 20),
                                    // AM 시간 슬롯
                                    Text(
                                      context.l10n.am,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final crossAxisCount = 2;
                                        final spacing = 16.0;
                                        final itemWidth =
                                            (constraints.maxWidth -
                                                    (crossAxisCount - 1) *
                                                        spacing) /
                                                crossAxisCount;

                                        return Wrap(
                                          spacing: spacing,
                                          runSpacing: 12,
                                          children: TimeSlot.values
                                              .where((slot) => slot.isAm)
                                              .map((slot) => SizedBox(
                                                    width: itemWidth,
                                                    child: TimeSlotButton(
                                                      label: slot.label,
                                                      state: _findingTimeSlot ==
                                                              slot
                                                          ? TimeSlotState
                                                              .selected
                                                          : TimeSlotState
                                                              .enabled,
                                                      onTap: () =>
                                                          _onTimeSlotSelected(
                                                              slot, false),
                                                    ),
                                                  ))
                                              .toList(),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    // PM 시간 슬롯
                                    Text(
                                      context.l10n.pm,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final crossAxisCount = 2;
                                        final spacing = 16.0;
                                        final itemWidth =
                                            (constraints.maxWidth -
                                                    (crossAxisCount - 1) *
                                                        spacing) /
                                                crossAxisCount;

                                        return Wrap(
                                          spacing: spacing,
                                          runSpacing: 12,
                                          children: TimeSlot.values
                                              .where((slot) => !slot.isAm)
                                              .map((slot) => SizedBox(
                                                    width: itemWidth,
                                                    child: TimeSlotButton(
                                                      label: slot.label,
                                                      state: _findingTimeSlot ==
                                                              slot
                                                          ? TimeSlotState
                                                              .selected
                                                          : TimeSlotState
                                                              .enabled,
                                                      onTap: () =>
                                                          _onTimeSlotSelected(
                                                              slot, false),
                                                    ),
                                                  ))
                                              .toList(),
                                        );
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40), // 스크롤 내부에서는 Spacer 사용 금지
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Search 버튼을 바닥에 고정
            if (!_isLocationSheetVisible)
              SafeArea(
                minimum:
                    const EdgeInsets.fromLTRB(20, 12, 20, 16), // 내가 주고 싶은 여백만
                child: CommonButton(
                  text: context.l10n.search_button,
                  onPressed: _onSearch,
                  isEnabled: _isAnySelectionMade(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
