import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:si_pos/cubit/report_cubit.dart';
import 'package:si_pos/cubit/send_report_to_email_cubit.dart';
import 'package:si_pos/elements/custom.dart';
import 'package:si_pos/page/detail_transaction_page.dart';

class ReportTransactionPage extends StatefulWidget {
  const ReportTransactionPage({Key key}) : super(key: key);

  @override
  State<ReportTransactionPage> createState() => _ReportTransactionPageState();
}

class _ReportTransactionPageState extends State<ReportTransactionPage> {
  final _fromDateController = TextEditingController();
  final _untilDateController = TextEditingController();
  DateTime from;
  DateTime until;

  @override
  void initState() {
    super.initState();
    context.read<ReportCubit>().getReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Report Transaction'),
      backgroundColor: Colors.white,
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (_, state) => (state is ReportLoaded)
            ? SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ButtonPrimary(
                      buttonText: 'Send Report To Email',
                      buttonPressed: () async {
                        LoadingIndicator.show(context);
                        await context
                            .read<SendReportToEmailCubit>()
                            .sendReportToEmail();

                        SendReportToEmailState sendReportState =
                            context.read<SendReportToEmailCubit>().state;

                        if (sendReportState is SendReportToEmailLoaded) {
                          Navigator.pop(context);
                          ShowToast.show(message: 'Berhasil dikirim');
                        } else {
                          Navigator.pop(context);
                          ShowToast.show(message: 'Terjadi kesalahan');
                        }
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(DateTime.now().year - 1),
                                lastDate: DateTime(DateTime.now().year + 1),
                              ).then((value) {
                                if (value != null) {
                                  from = value;
                                  _fromDateController.text =
                                      ConvertDateTime.dateTimeWithoutClock(
                                          value);
                                }
                              });
                            },
                            child: CustomTextField(
                              enabled: false,
                              controller: _fromDateController,
                              hintText: 'From',
                              obscureText: false,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(DateTime.now().year - 1),
                                lastDate: DateTime(DateTime.now().year + 1),
                              ).then((value) {
                                if (value != null) {
                                  until = value;
                                  _untilDateController.text =
                                      ConvertDateTime.dateTimeWithoutClock(
                                          value);
                                }
                              });
                            },
                            child: CustomTextField(
                              enabled: false,
                              controller: _untilDateController,
                              hintText: 'Until',
                              obscureText: false,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        ButtonPrimary(
                          buttonText: 'Filter',
                          buttonPressed: () async {
                            LoadingIndicator.show(context);
                            await context
                                .read<ReportCubit>()
                                .filterReport(from: from, until: until);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.report.data.transaction.length,
                      itemBuilder: (context, index) {
                        var data = state.report.data.transaction[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: DetailTransaction(
                                        idTransaction: data.id,
                                        title: data.meja,
                                        page: 'list transaction'),
                                    type: PageTransitionType.rightToLeft));
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.only(
                                bottom:
                                    data == state.report.data.transaction.last
                                        ? 0
                                        : 16),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              data.meja,
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
                                              color: Colors.green,
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
                                        ],
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
                                        NumberFormat.currency(
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
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            : LinearProgressIndicator(
                minHeight: 1,
                backgroundColor: Colors.blue,
              ),
      ),
    );
  }
}
