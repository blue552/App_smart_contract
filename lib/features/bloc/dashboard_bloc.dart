import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_contract/models/transaction_model.dart';
import 'package:web_socket_channel/io.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    // on<DashboardInitialFetchEvent>((event, emit) => dashboardInitialFetchEvent(event, emit));
    on<DashboardInitialFetchEvent>((dashboardInitialFetchEvent));
    on<DashboardDepositEvent>((dashboardDepositEvent));
    on<DashboardWithdrawEvent>((dashboardWithdrawEvent));
  }

  List<TransactionModel> transactions = [];
  Web3Client? _web3Client;
  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  int balance = 0;
  late EthPrivateKey _creds;
  //Funcion
  late DeployedContract _deployedContract;
  late ContractFunction _deposit;
  late ContractFunction _withdraw;
  late ContractFunction _getBalance;
  late ContractFunction _getAllTransactions;

  FutureOr<void> dashboardInitialFetchEvent(
      DashboardInitialFetchEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoadingState());
    try {
      final String rpcUrl = "http://127.0.0.1:7545";
      final String socketUrl = "ws://127.0.0.1:7545";
      final String privateKey =
          "0x4de0b3ea663ce1bed6c954697ff45124d68f145bb84b8ed9e002fef7b932d4a6";
      _web3Client = Web3Client(rpcUrl, http.Client(), socketConnector: () {
        return IOWebSocketChannel.connect(socketUrl).cast<String>();
      }); //Wen3Client

      log('Connecting to Ethereum node at $rpcUrl');

      //get ABI
      String abiFile = await rootBundle
          .loadString("build/contracts/ExpenseManagerContract.json");
          log('ABI file loaded successfully');
      var jsonDecoded = jsonDecode(abiFile);
      _abiCode = ContractAbi.fromJson(
          jsonEncode(jsonDecoded['abi']), 'ExpenseManagerContract');
          log('ABI code initialized successfully');
      _contractAddress =
          EthereumAddress.fromHex("0xF63d34fe02c439d49DD2A6D76f315441659A5542");

      _creds = EthPrivateKey.fromHex(privateKey);

      // get deployed contract
      _deployedContract = DeployedContract(_abiCode, _contractAddress);
      _deposit = _deployedContract.function('deposit');
      _withdraw = _deployedContract.function('withdraw');
      _getBalance = _deployedContract.function('getBalance');
      _getAllTransactions = _deployedContract.function('getAllTransactions');

      final transactionsData = await _web3Client!.call(
          contract: _deployedContract,
          function: _getAllTransactions,
          params: []);
      final balanceData = await _web3Client!
          .call(contract: _deployedContract, function: _getBalance, params: [
        EthereumAddress.fromHex("0x77c41C17dF6CC08454b04678E252F23B70a65a4c")
      ]);
      List<TransactionModel> trans = [];
      for (int i = 0; i < transactionsData[0].length; i++) {
        TransactionModel transactionModel = TransactionModel(
            transactionsData[0][i].toInt(),
            transactionsData[1][i],
            transactionsData[2][i],
            DateTime.fromMicrosecondsSinceEpoch(
                transactionsData[3][i].toInt()));
        trans.add(transactionModel);
      }
      transactions = trans;

      int bal = balanceData[0].toInt();
      balance = bal;
      await Future.delayed(const Duration(seconds: 2));
      emit(DashboardSuccessState(transactions: transactions, balance: balance));
    } catch (e) {
      log('Error: $e');
      log(e.toString());
      emit(DashboardErrorState());
    }
  }

  FutureOr<void> dashboardDepositEvent(
      DashboardDepositEvent event, Emitter<DashboardState> emit) async {
    try {
      // Đảm bảo rằng _deployedContract được khởi tạo đúng
      _deployedContract = DeployedContract(_abiCode, _contractAddress);

      // Tạo transaction cho chức năng deposit
      final transaction = Transaction.callContract(
          contract: _deployedContract,
          function: _deposit,
          parameters: [
            BigInt.from(event.transactionModel.amount),
            event.transactionModel.reason
          ],
          value: EtherAmount.inWei(BigInt.from(
              event.transactionModel.amount))); // Giá trị gửi vào hợp đồng

      // Gửi transaction
      final result = await _web3Client!.sendTransaction(_creds, transaction,
          chainId: null, fetchChainIdFromNetworkId: true);
      log(result.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  FutureOr<void> dashboardWithdrawEvent(
      DashboardWithdrawEvent event, Emitter<DashboardState> emit) async {}
}
