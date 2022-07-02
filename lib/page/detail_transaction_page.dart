import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:si_pos/cubit/delete_product_transaction_cubit.dart';
import 'package:si_pos/cubit/detail_transaction_cubit.dart';
import 'package:si_pos/cubit/done_transaction_cubit.dart';
import 'package:si_pos/cubit/transaction_cubit.dart';
import 'package:si_pos/elements/custom.dart';
import 'package:si_pos/page/add_product_to_transaction_page.dart';

class DetailTransaction extends StatefulWidget {
  final String page;
  final String title;
  final int idTransaction;
  const DetailTransaction({
    Key key,
    @required this.idTransaction,
    @required this.title,
    @required this.page,
  }) : super(key: key);

  @override
  State<DetailTransaction> createState() => _DetailTransactionState();
}

class _DetailTransactionState extends State<DetailTransaction> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _bayarController = TextEditingController();

  @override
  void initState() {
    context
        .read<DetailTransactionCubit>()
        .getDetailTransaction(widget.idTransaction);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.page == 'list transaction') {
          Navigator.pop(context);
          return Future.value(true);
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
          return Future.value(true);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: customAppBar(widget.title),
        floatingActionButton:
            BlocBuilder<DetailTransactionCubit, DetailTransactionState>(
                builder: (_, state) => (state is DetailTransactionLoaded &&
                        state.transaction.data.status != 'done')
                    ? FloatingActionButton(
                        backgroundColor: Colors.blue,
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: AddProductToTransactionPage(
                                      idTransaction: widget.idTransaction),
                                  type: PageTransitionType.rightToLeft));
                        },
                        child: Icon(Icons.add, color: Colors.white),
                      )
                    : Container()),
        body: BlocBuilder<DetailTransactionCubit, DetailTransactionState>(
            builder: (_, state) => (state is DetailTransactionLoaded)
                ? SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16, 16, 16,
                        (state.transaction.data.status == 'done') ? 16 : 94),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            state.transaction.data.meja,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: (state.transaction.data
                                                        .status ==
                                                    'done')
                                                ? Colors.green
                                                : Colors.amber,
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                          child: Text(
                                            state.transaction.data.status,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      state.transaction.data.email ?? '-',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Daftar Barang',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        (state.transaction.data.transcation.isNotEmpty)
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    state.transaction.data.transcation.length,
                                itemBuilder: ((context, index) {
                                  var data =
                                      state.transaction.data.transcation[index];
                                  return Container(
                                    margin: EdgeInsets.only(
                                        bottom: (data ==
                                                state.transaction.data
                                                    .transcation.last)
                                            ? 0
                                            : 16),
                                    padding: EdgeInsets.all(16),
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
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.product.name,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                'Jumlah : ${data.count}',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                NumberFormat.currency(
                                                  locale: "id_ID",
                                                  decimalDigits: 0,
                                                  symbol: "Rp ",
                                                ).format(data.price),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (state.transaction.data.status !=
                                            'done')
                                          SizedBox(
                                            width: 16,
                                          ),
                                        if (state.transaction.data.status !=
                                            'done')
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  LoadingIndicator.show(
                                                      context);

                                                  await context
                                                      .read<
                                                          DeleteProductTransactionCubit>()
                                                      .deleteProductTransaction(
                                                          data.id);

                                                  DeleteProductTransactionState
                                                      state = context
                                                          .read<
                                                              DeleteProductTransactionCubit>()
                                                          .state;

                                                  if (state
                                                      is DeleteProductTransactionLoaded) {
                                                    await context
                                                        .read<
                                                            DetailTransactionCubit>()
                                                        .getDetailTransaction(
                                                            widget
                                                                .idTransaction);
                                                    Navigator.pop(_scaffoldKey
                                                        .currentContext);
                                                    ShowToast.show(
                                                        message:
                                                            'Berhasil dihapus');
                                                  } else {
                                                    ShowToast.show(
                                                        message: (state
                                                                as DeleteProductTransactionLoadingFailed)
                                                            .message);
                                                    Navigator.pop(_scaffoldKey
                                                        .currentContext);
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
                                  );
                                }),
                              )
                            : Text(
                                'Belum ada pesanan',
                              ),
                        SizedBox(
                          height: 24,
                        ),
                        if (state.transaction.data.transcation.isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(16),
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
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      NumberFormat.currency(
                                        locale: "id_ID",
                                        decimalDigits: 0,
                                        symbol: "Rp ",
                                      ).format(
                                        state.transaction.data.total != null
                                            ? state.transaction.data.total
                                            : state.transaction.data.transcation
                                                .map((e) => e.price)
                                                .reduce((value, element) =>
                                                    value + element),
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                if (state.transaction.data.bayar != null)
                                  SizedBox(
                                    height: 16,
                                  ),
                                if (state.transaction.data.bayar != null)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Bayar',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        state.transaction.data.bayar != null
                                            ? NumberFormat.currency(
                                                locale: "id_ID",
                                                decimalDigits: 0,
                                                symbol: "Rp ",
                                              ).format(
                                                state.transaction.data.bayar)
                                            : '-',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (state.transaction.data.kembalian != null)
                                  SizedBox(
                                    height: 16,
                                  ),
                                if (state.transaction.data.kembalian != null)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Kembalian',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        state.transaction.data.kembalian != null
                                            ? NumberFormat.currency(
                                                locale: "id_ID",
                                                decimalDigits: 0,
                                                symbol: "Rp ",
                                              ).format(state
                                                .transaction.data.kembalian)
                                            : '-',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        if (state.transaction.data.status != 'done' &&
                            state.transaction.data.transcation.isNotEmpty)
                          SizedBox(
                            height: 24,
                          ),
                        if (state.transaction.data.status != 'done' &&
                            state.transaction.data.transcation.isNotEmpty)
                          CustomTextField(
                            controller: _bayarController,
                            type: TextInputType.number,
                            hintText: 'Masukkan pembayaran',
                            obscureText: false,
                          ),
                        if (state.transaction.data.status != 'done' &&
                            state.transaction.data.transcation.isNotEmpty)
                          SizedBox(
                            height: 16,
                          ),
                        if (state.transaction.data.status != 'done' &&
                            state.transaction.data.transcation.isNotEmpty)
                          ButtonPrimary(
                              buttonPressed: () async {
                                LoadingIndicator.show(context);
                                await context
                                    .read<DoneTransactionCubit>()
                                    .doneTransaction(
                                      id: widget.idTransaction,
                                      bayar: _bayarController.text.trim(),
                                      kembalian: (int.parse(_bayarController
                                                  .text
                                                  .trim()) -
                                              state.transaction.data.transcation
                                                  .map((e) => e.price)
                                                  .reduce((a, b) => a + b))
                                          .toString(),
                                    );
                                DoneTransactionState doneState =
                                    context.read<DoneTransactionCubit>().state;

                                if (doneState is DoneTransactionLoaded) {
                                  await context
                                      .read<DetailTransactionCubit>()
                                      .getDetailTransaction(
                                          widget.idTransaction);
                                  await context
                                      .read<TransactionCubit>()
                                      .getTransaction();
                                  Navigator.pop(context);
                                  ShowToast.show(message: 'Berhasil');
                                } else {
                                  Navigator.pop(context);
                                  ShowToast.show(
                                      message: (doneState
                                              as DoneTransactionLoadingFailed)
                                          .message);
                                }
                              },
                              buttonText: "Submit"),
                      ],
                    ),
                  )
                : LinearProgressIndicator(
                    minHeight: 1,
                    backgroundColor: Colors.blue,
                  )),
      ),
    );
  }
}
