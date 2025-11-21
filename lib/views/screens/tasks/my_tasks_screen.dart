import 'package:flutter/material.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';
import '../../widgets/cards/task_card.dart';

/// Student Tasks/Jobs Calendar Screen
class MyTasksScreen extends StatefulWidget {
  const MyTasksScreen({super.key});

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  int selectedDay = 22;
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Calendar week view
            _buildCompactCalendar(),

            // Filter tabs
            _buildFilterTabs(),

            // Task cards list
            Expanded(
              child: _buildTasksList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Schedule',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontFamily: 'Aclonica',
              letterSpacing: -0.5,
            ),
          ),
          Row(
            children: [
              Icon(Icons.search, color: AppColors.white, size: 24),
              const SizedBox(width: 15),
              Icon(Icons.filter_list, color: AppColors.white, size: 24),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactCalendar() {
    final days = [
      {'day': 'Mon', 'date': 20},
      {'day': 'Tue', 'date': 21},
      {'day': 'Wed', 'date': 22},
      {'day': 'Thu', 'date': 23},
      {'day': 'Fri', 'date': 24},
      {'day': 'Sat', 'date': 25},
      {'day': 'Sun', 'date': 26},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'November 2025',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontFamily: 'Acme',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.chevron_left, color: AppColors.white, size: 20),
                  const SizedBox(width: 15),
                  Icon(Icons.chevron_right, color: AppColors.white, size: 20),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Days row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((day) {
              final isSelected = day['date'] == selectedDay;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDay = day['date'] as int;
                  });
                },
                child: Container(
                  width: 46,
                  height: 65,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.purple6 : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day['day'] as String,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.black
                              : AppColors.white.withOpacity(0.6),
                          fontSize: 11,
                          fontFamily: 'Acme',
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${day['date']}',
                        style: TextStyle(
                          color: isSelected ? AppColors.black : AppColors.white,
                          fontSize: 16,
                          fontFamily: 'Aclonica',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['All', 'Upcoming', 'Completed'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: filters.map((filter) {
          final isSelected = filter == selectedFilter;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = filter;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.purple6
                    : AppColors.grey1.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? AppColors.black : AppColors.white,
                  fontSize: 13,
                  fontFamily: 'Acme',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTasksList() {
    // Filter tasks based on selected filter
    final allTasks = [
      {
        'title': 'Tutoring',
        'time': '09:00-12:30',
        'location': 'Online',
        'backgroundColor': AppColors.purple2,
        'earnings': '3,500 DA',
        'status': 'In Progress',
        'tasksCompleted': 1,
        'totalTasks': 3,
      },
      {
        'title': 'Video Editing',
        'time': '14:00-15:00',
        'location': 'Online',
        'backgroundColor': AppColors.orange1,
        'earnings': '5,000 DA',
        'status': 'Upcoming',
        'tasksCompleted': 0,
        'totalTasks': 3,
      },
      {
        'title': 'Food Delivery',
        'time': '15:30-17:30',
        'location': 'Bab Ezzouar',
        'backgroundColor': AppColors.electricLime3,
        'earnings': '2,800 DA',
        'status': 'Upcoming',
        'tasksCompleted': 0,
        'totalTasks': 2,
      },
      {
        'title': 'Graphic Design',
        'time': '18:00-20:00',
        'location': 'Online',
        'backgroundColor': AppColors.yellow2,
        'earnings': '4,500 DA',
        'status': 'Completed',
        'tasksCompleted': 5,
        'totalTasks': 5,
      },
    ];

    final filteredTasks = allTasks.where((task) {
      if (selectedFilter == 'All') return true;
      if (selectedFilter == 'Upcoming') {
        return task['status'] == 'Upcoming' || task['status'] == 'In Progress';
      }
      if (selectedFilter == 'Completed') {
        return task['status'] == 'Completed';
      }
      return true;
    }).toList();

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: filteredTasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return TaskCard(
          title: task['title'] as String,
          time: task['time'] as String,
          location: task['location'] as String,
          backgroundColor: task['backgroundColor'] as Color,
          earnings: task['earnings'] as String,
          status: task['status'] as String,
          tasksCompleted: task['tasksCompleted'] as int,
          totalTasks: task['totalTasks'] as int,
          onTap: () {
            // TODO: Navigate to task detail
          },
        );
      },
    );
  }
}
