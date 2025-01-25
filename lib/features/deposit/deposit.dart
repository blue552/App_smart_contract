import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smart_contract/features/ui/dashboard_page.dart';
import 'package:smart_contract/main.dart';
// ignore: unused_import
import 'package:smart_contract/utils/colors.dart';

class DepositPage extends StatefulWidget {
  const DepositPage({super.key});

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 220, 255),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Text("Desposit", style: TextStyle(fontSize: 30)),
            const SizedBox(height: 20),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: "Enter the Address",
              ),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                hintText: "Enter the Amount",
              ),
            ),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                hintText: "Enter the Reason",
              ),
            ),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWellWidget(
                    text: 'Deposit',
                    icon: Iconsax.convert,
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashBoardPage()),
                        (route) => false,
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
