import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:si_pos/cubit/delete_transaction_cubit.dart';
import 'package:si_pos/cubit/transaction_cubit.dart';
import 'package:si_pos/elements/custom.dart';
import 'package:si_pos/page/add_transaction_page.dart';
import 'package:si_pos/page/detail_transaction_page.dart';
import 'package:si_pos/page/edit_transaction_page.dart';
import '../elements/custom.dart' as custom;

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({Key key}) : super(key: key);

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    context.read<TransactionCubit>().getTransaction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: custom.customAppBar("List Transaction"),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  child: AddTransactionPage(),
                  type: PageTransitionType.rightToLeft));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
          builder: (_, state) => (state is TransactionLoaded)
              ? ListView.builder(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 94),
                  itemCount: state.transaction.data.length,
                  itemBuilder: (context, index) {
                    var data = state.transaction.data[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: DetailTransaction(
                                  title: data.meja,
                                  page: 'list transaction',
                                  idTransaction: data.id,
                                ),
                                type: PageTransitionType.rightToLeft));
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.only(
                            bottom:
                                data == state.transaction.data.last ? 0 : 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'images/table.png',
                              width: 70,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.meja,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          data.email ?? '-',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          data.total == null
                                              ? '-'
                                              : NumberFormat.currency(
                                                  locale: "id_ID",
                                                  decimalDigits: 0,
                                                  symbol: "Rp ",
                                                ).format(data.total),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: (data.status == 'done')
                                              ? Colors.green
                                              : Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        child: Text(
                                          data.status,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      if (data.status == 'draft')
                                        SizedBox(
                                          height: 16,
                                        ),
                                      if (data.status == 'draft')
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child:
                                                            EditTransactionPage(
                                                                idTransaction:
                                                                    data.id,
                                                                table:
                                                                    data.meja,
                                                                email:
                                                                    data.email),
                                                        type: PageTransitionType
                                                            .rightToLeft));
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.amber,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                LoadingIndicator.show(context);
                                                await context
                                                    .read<
                                                        DeleteTransactionCubit>()
                                                    .deleteTransaction(data.id);
                                                DeleteTransactionState
                                                    deleteState = context
                                                        .read<
                                                            DeleteTransactionCubit>()
                                                        .state;
                                                if (deleteState
                                                    is DeleteTransactionLoaded) {
                                                  await context
                                                      .read<TransactionCubit>()
                                                      .getTransaction();
                                                  Navigator.pop(_scaffoldKey
                                                      .currentContext);
                                                  ShowToast.show(
                                                      message:
                                                          'Berhasil dihapus');
                                                } else {
                                                  Navigator.pop(context);
                                                  ShowToast.show(
                                                      message: (deleteState
                                                              as DeleteTransactionLoadingFailed)
                                                          .message);
                                                }
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : LinearProgressIndicator(
                  minHeight: 1,
                  backgroundColor: Colors.blue,
                )),
    );
  }
}
