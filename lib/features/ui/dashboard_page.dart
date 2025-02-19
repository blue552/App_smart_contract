import 'package:fl_chart/fl_chart.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smart_contract/features/bloc/dashboard_bloc.dart';
import 'package:smart_contract/features/deposit/deposit.dart';
import 'package:smart_contract/utils/colors.dart';

import 'package:smart_contract/features/withdraw/withdraw.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final DashboardBloc dashboardBloc = DashboardBloc();
  @override
  void initState() {
    super.initState();
    dashboardBloc.add(DashboardInitialFetchEvent());
  }

  @override
  void dispose() {
    dashboardBloc.close();
    super.dispose();
  }

  int index = 0;
  PageController controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => dashboardBloc,
        child: Scaffold(
            body: SafeArea(
                child: BlocConsumer<DashboardBloc, DashboardState>(
                    listener: (context, state) {
          print('State changed: $state');
        }, builder: (context, state) {
          if (state is DashboardLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DashboardErrorState) {
            return const Center(
              child: Text('Error'),
            );
          } else if (state is DashboardSuccessState) {
            final successSate = state as DashboardSuccessState;
            return Stack(
              children: [
                PageView(
                  controller: controller,
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Wallet",
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text("Active",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                const CircleAvatar(
                                  radius: 26,
                                  backgroundImage: NetworkImage(
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeqG8b5R5jfp4Emf6_TVFUyqIywNhkiBoOTw&s'),
                                  backgroundColor: Colors.transparent,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 35,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 140,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: secondColor,
                                  borderRadius: BorderRadius.circular(24)),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/ethereum.png',
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.contain,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Ethereum",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ],
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Balance",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                          Text(
                                              successSate.balance.toString() +
                                                  ' ETH',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWellWidget(
                                  text: 'Deposit',
                                  icon: Iconsax.convert,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DepositPage(
                                          dashboardBloc: DashboardBloc(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                InkWellWidget(
                                  text: 'Withdraw',
                                  icon: Iconsax.export,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WithdrawPage(
                                            dashboardBloc: DashboardBloc(),
                                          ),
                                        ));
                                  },
                                ),
                                InkWellWidget(
                                  text: 'Pay out',
                                  icon: Iconsax.money_send,
                                  onTap: () {
                                    print('Pay out tapped!');
                                  },
                                ),
                                InkWellWidget(
                                  text: 'Top Up',
                                  icon: Iconsax.add,
                                  onTap: () {
                                    print('Top Up tapped!');
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Last Transactions",
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: secondColor),
                                ),
                                Text(
                                  "View All",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: secondColor),
                                ),
                              ],
                            ),
                            //
                            ListView.builder(
                              shrinkWrap:
                                  true, // Bắt buộc ListView tự tính chiều cao
                              physics:
                                  NeverScrollableScrollPhysics(), // Tắt cuộn cho ListView
                              itemCount: successSate.transactions.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 12,
                                  ),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundImage: NetworkImage(
                                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeqG8b5R5jfp4Emf6_TVFUyqIywNhkiBoOTw&s'),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            successSate
                                                .transactions[index].address,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        successSate.transactions[index].amount
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Text(
                              "Total balance",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: secondColor),
                            ),
                            Text(
                              r"$ 13.248",
                              style: GoogleFonts.poppins(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: secondColor),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Income Stas ",
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: secondColor),
                                ),
                                Text(
                                  "Oct - Feb",
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: secondColor),
                                ),
                              ],
                            ),
                            Container(
                                height: 200,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: LineChart(LineChartData(
                                        lineTouchData: const LineTouchData(
                                            handleBuiltInTouches: false),
                                        gridData: const FlGridData(show: false),
                                        borderData: FlBorderData(show: false),
                                        lineBarsData: [
                                          LineChartBarData(
                                            isCurved: true,
                                            barWidth: 2,
                                            isStrokeCapRound: true,
                                            dotData: const FlDotData(show: false),
                                            spots: const [
                                              FlSpot(0, 1),
                                              FlSpot(1, 1.2),
                                              FlSpot(3, 1.4),
                                              FlSpot(4, 3.4),
                                              FlSpot(5, 2),
                                            ],
                                            belowBarData: BarAreaData(
                                              show: true,
                                              gradient: LinearGradient(
                                                colors: [
                                                  secondColor.withAlpha(
                                                      (0.6 * 255).toInt()),
                                                  secondColor.withAlpha(
                                                      (0.0 * 255).toInt()),
                                                ],
                                                stops: const [0.5, 1.0],
                                                begin: const Alignment(0, 0),
                                                end: const Alignment(0, 1),
                                              ),
                                            ),
                                            color: primaryColor,
                                          )
                                        ],
                                        titlesData: FlTitlesData(
                                          leftTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                          rightTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                          topTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                                showTitles: true,
                                                interval: 1,
                                                getTitlesWidget: (value, meta) {
                                                  switch (value.toInt()) {
                                                    case 0:
                                                      return const Text('Oct');
                                                    case 1:
                                                      return const Text('Nov');
                                                    case 2:
                                                      return const Text('Dec');
                                                    case 3:
                                                      return const Text('Jan');
                                                    case 4:
                                                      return const Text('Feb');
                                                    case 5:
                                                      return const Text('Mar');
                                                    default:
                                                      return const Text('');
                                                  }
                                                }),
                                          ),
                                        ),
                                        minX: 0,
                                        maxX: 5,
                                        minY: 0,
                                        maxY: 4,
                                      )),
                                    ),
                                  ],
                                )),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Last Transactions",
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: secondColor),
                                ),
                                Text(
                                  "View All",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: secondColor),
                                ),
                              ],
                            ),
                            //
                            ListView.builder(
                              shrinkWrap:
                                  true, // Bắt buộc ListView tự tính chiều cao
                              physics:
                                  NeverScrollableScrollPhysics(), // Tắt cuộn cho ListView
                              itemCount: successSate.transactions.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 12,
                                  ),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundImage: NetworkImage(
                                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeqG8b5R5jfp4Emf6_TVFUyqIywNhkiBoOTw&s'),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            successSate
                                                .transactions[index].address,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        successSate.transactions[index].amount
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 110,
                    child: FloatingNavbar(
                      onTap: (i) {
                        setState(() {
                          index = i;
                          controller.jumpToPage(index);
                        });
                      },
                      currentIndex: index,
                      borderRadius: 24,
                      iconSize: 32,
                      selectedBackgroundColor: Colors.transparent,
                      selectedItemColor: Colors.white,
                      unselectedItemColor: Colors.white70,
                      backgroundColor: primaryColor,
                      items: [
                        FloatingNavbarItem(icon: Iconsax.home1),
                        FloatingNavbarItem(icon: Iconsax.dcube),
                        FloatingNavbarItem(icon: Iconsax.arrow_swap),
                        FloatingNavbarItem(icon: Iconsax.clock),
                        FloatingNavbarItem(icon: Iconsax.global_search),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('Unknown state'),
            );
          }
        }))));
  }
}

class InkWellWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const InkWellWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
              shape: const CircleBorder(),
              side: const BorderSide(color: Colors.black),
              padding: const EdgeInsets.all(16),
              elevation: 6,
              backgroundColor: Colors.white,
              shadowColor: Colors.purple.withAlpha((0.6 * 255).toInt())),
          child: Icon(
            icon,
            color: secondColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: GoogleFonts.poppins(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ],
    );
  }
}
