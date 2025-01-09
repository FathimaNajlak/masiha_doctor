import 'package:flutter/material.dart';
import 'package:masiha_doctor/providers/reports_provider.dart';
import 'package:masiha_doctor/screens/home/revenue_card.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:masiha_doctor/widgets/bottom_nav_bar.dart';

class DoctorReportsScreen extends StatelessWidget {
  const DoctorReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingReportsProvider(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'My Reports',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black),
              onPressed: () {
                context.read<BookingReportsProvider>().refresh();
              },
            ),
          ],
        ),
        body: const DoctorReportsContent(),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }
}

class DoctorReportsContent extends StatelessWidget {
  const DoctorReportsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingReportsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(child: Text('Error: ${provider.error}'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Revenue Overview'),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  RevenueSummaryCard(
                    title: 'Weekly Revenue',
                    amount: provider.weeklyRevenue,
                    icon: Icons.calendar_today,
                    color: Colors.blue,
                  ),
                  RevenueSummaryCard(
                    title: 'Monthly Revenue',
                    amount: provider.monthlyRevenue,
                    icon: Icons.date_range,
                    color: Colors.green,
                  ),
                  // RevenueSummaryCard(
                  //   title: 'Total Revenue',
                  //   amount: provider.totalRevenue,
                  //   icon: Icons.account_balance_wallet,
                  //   color: Colors.purple,
                  // ),
                  // RevenueSummaryCard(
                  //   title: 'Consultation Fee',
                  //   amount: provider.consultationFee ?? 0,
                  //   icon: Icons.medical_services,
                  //   color: Colors.orange,
                  // ),
                ],
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Last Week Bookings'),
              const SizedBox(height: 16),
              WeeklyBookingsChart(data: provider.weeklyBookings),
              const SizedBox(height: 32),
              _buildSectionTitle('Last Month Bookings'),
              const SizedBox(height: 16),
              MonthlyBookingsChart(data: provider.monthlyBookings),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

class WeeklyBookingsChart extends StatelessWidget {
  final List<MapEntry<String, int>> data;

  const WeeklyBookingsChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final maxY = data.isEmpty
        ? 10.0
        : (data.map((e) => e.value.toDouble()).reduce((a, b) => a > b ? a : b) *
            1.2);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barGroups: List.generate(
            data.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: data[index].value.toDouble(),
                  color: Colors.blue.shade300,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value >= 0 && value < data.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        data[value.toInt()].key,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }
}

class MonthlyBookingsChart extends StatelessWidget {
  final List<MapEntry<String, int>> data;

  const MonthlyBookingsChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final maxY = data.isEmpty
        ? 10.0
        : (data.map((e) => e.value.toDouble()).reduce((a, b) => a > b ? a : b) *
            1.2);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barGroups: List.generate(
            data.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: data[index].value.toDouble(),
                  color: Colors.teal.shade300,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value >= 0 &&
                      value < data.length &&
                      value.toInt() % 5 == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        data[value.toInt()].key,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }
}
