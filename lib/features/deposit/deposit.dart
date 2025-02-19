import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smart_contract/features/bloc/dashboard_bloc.dart';
import 'package:smart_contract/features/ui/dashboard_page.dart';
import 'package:smart_contract/main.dart';
import 'package:smart_contract/models/transaction_model.dart';
// ignore: unused_import
import 'package:smart_contract/utils/colors.dart';

class DepositPage extends StatefulWidget {
  final DashboardBloc dashboardBloc;
  const DepositPage({super.key, required this.dashboardBloc});

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  bool isLoading = false;

   late FocusNode _firstFocusNode;
  late FocusNode _secondFocusNode;

  
  @override
  void initState() {
    super.initState();
    _firstFocusNode = FocusNode();
    _secondFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _firstFocusNode.dispose();
    _secondFocusNode.dispose();
    super.dispose();
  }

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
            // TextField(
            //   controller: addressController,
            //   focusNode: _focusNode,
            //   decoration: InputDecoration(
            //     hintText: "Enter the Address",
            //   ),
            // ),
            TextField(
             focusNode: _firstFocusNode,
              controller: amountController,
              decoration: InputDecoration(
                hintText: "Enter the Amount",
              ),
               onSubmitted: (value) {
                // Chuyển focus sang TextField thứ hai
                _secondFocusNode.requestFocus();
              },
            ),
            TextField(
              focusNode: _secondFocusNode,
              controller: reasonController,
              decoration: InputDecoration(
                hintText: "Enter the Reason",
              ),
            ),
            const SizedBox(height: 80),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              isLoading
                  ? CircularProgressIndicator() // Hiển thị chỉ báo đang tải trong khi xử lý
                  : InkWell(
                      onTap: () {
                        double? amount = double.tryParse(amountController.text);
                        if (amount == null) {
                          // Xử lý số tiền không hợp lệ
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Số tiền không hợp lệ")),
                          );
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        // Gửi sự kiện deposit
                        widget.dashboardBloc.add(DashboardDepositEvent(
                          transactionModel: TransactionModel(
                            addressController.text,
                            amount,
                            reasonController.text,
                            DateTime.now(),
                          ),
                        ));
                      },
                      child: Icon(Iconsax.convert),
                    ),
            ]),
          ],
        ),
      ),
    );
  }
}
