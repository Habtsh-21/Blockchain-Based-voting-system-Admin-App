import 'dart:async';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blockchain_based_national_election_admin_app/core/widgets/gradient_button.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class Control extends ConsumerStatefulWidget {
  const Control({super.key});

  @override
  ConsumerState<Control> createState() => _ControlState();
}

class _ControlState extends ConsumerState<Control> {
  DateTime? startTime;
  DateTime? endTime;
  late Timer _timer;
  bool _isSettingTime = false;
 ContractProviderState? _previousState;


  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startTime = ref.watch(contractProvider.notifier).startTime();
      endTime = ref.watch(contractProvider.notifier).endTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatDuration(Duration? d) {
    if (d == null) return "--:--:--";
    if (d.isNegative) return "00:00:00";

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  Duration? timeUntil(DateTime? targetTime) {
    if (targetTime == null) return null;
    return targetTime.difference(DateTime.now());
  }

  Future<DateTime?> pickDateTime({
    required bool isStart,
  }) async {
    if (_isSettingTime) return null;
    _isSettingTime = true;

    try {
      final now = DateTime.now();

      final date = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: now.add(const Duration(days: 365)),
        cancelText: 'Cancel',
        confirmText: 'Select',
        helpText: 'Select ${isStart ? 'start' : 'end'} date',
      );
      if (date == null) return null;

      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        cancelText: 'Cancel',
        confirmText: 'OK',
        helpText: 'Select ${isStart ? 'start' : 'end'} time',
      );
      if (time == null) return null;

      return DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    } finally {
      _isSettingTime = false;
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "Not set";
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  Future<void> _showSimpleTimeDialog() async {
    DateTime? tempStart = startTime;
    DateTime? tempEnd = endTime;
    ContractProviderState contractState = ref.watch(contractProvider);

 if (_previousState != contractState && contractState is VotePauseExcutedState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Success!',
          textColor: Colors.black,
          text: 'trxHash:${contractState.txHash}',
          borderRadius: 0,
          barrierColor: Colors.black.withOpacity(0.2),
        );
        ref.read(contractProvider.notifier).resetState();
      });
    }
      _previousState = contractState;
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Set Election Times'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final selected = await pickDateTime(
                        isStart: true,
                      );
                      if (selected != null) {
                        setStateDialog(() => tempStart = selected);
                      }
                    },
                    child: Text(
                      tempStart == null
                          ? 'Set Start Time'
                          : 'Start: ${_formatDateTime(tempStart)}',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final selected = await pickDateTime(
                        isStart: false,
                      );
                      if (selected != null) {
                        setStateDialog(() => tempEnd = selected);
                      }
                    },
                    child: Text(
                      tempEnd == null
                          ? 'Set End Time'
                          : 'End: ${_formatDateTime(tempEnd)}',
                    ),
                  ),
                  if (tempStart != null &&
                      tempEnd != null &&
                      tempStart!.isAfter(tempEnd!))
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Start must be before end',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final state = ref.watch(contractProvider);
                    final isDisabled = tempStart == null ||
                        tempEnd == null ||
                        tempStart!.isAfter(tempEnd!) ||
                        state is TimeSettingState;

                    return ElevatedButton(
                      onPressed: isDisabled
                          ? null
                          : () async {
                              final notifier =
                                  ref.read(contractProvider.notifier);
                              await notifier.setTime(tempStart!, tempEnd!);

                              if (mounted) {
                                final newState = ref.read(contractProvider);
                                if (newState is TimeSettedState) {
                                  setState(() {
                                    startTime = tempStart;
                                    endTime = tempEnd;
                                  });
                                  Navigator.pop(context);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: state is TimeSettingState
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text('Submit'),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isVoting = startTime != null &&
        endTime != null &&
        now.isAfter(startTime!) &&
        now.isBefore(endTime!);
    final hasNotStarted = startTime != null && now.isBefore(startTime!);

    ContractProviderState contractState = ref.watch(contractProvider);
    bool currentState = ref.read(contractProvider.notifier).isVotingPaused();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Election Control"),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => ref.read(contractProvider.notifier).fatchAllData(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh data',
          )
        ],
        centerTitle: true,
        elevation: 4,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTimeCard(
                            title: 'Time Until Start',
                            duration: timeUntil(startTime),
                            isActive: hasNotStarted,
                          ),
                          const SizedBox(width: 16),
                          _buildTimeCard(
                            title: 'Time Remaining',
                            duration: timeUntil(endTime),
                            isActive: isVoting,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Election Schedule",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildTimeRow("Start:", _formatDateTime(startTime)),
                            const SizedBox(height: 8),
                            _buildTimeRow("End:", _formatDateTime(endTime)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GradientButton(
                      text: contractState is TimeSettingState
                          ? const Center(child: CircularProgressIndicator())
                          : const Text('Set Time'),
                      onPress: () => _showSimpleTimeDialog(),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isVoting
                            ? Colors.green.withOpacity(0.1)
                            : hasNotStarted
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isVoting
                              ? Colors.green
                              : hasNotStarted
                                  ? Colors.blue
                                  : Colors.red,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isVoting
                                ? Icons.check_circle
                                : hasNotStarted
                                    ? Icons.access_time
                                    : Icons.error,
                            color: isVoting
                                ? Colors.green
                                : hasNotStarted
                                    ? Colors.blue
                                    : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isVoting
                                ? "Voting in Progress"
                                : startTime == null || endTime == null
                                    ? "Please set both start and end times"
                                    : hasNotStarted
                                        ? "Voting will start soon"
                                        : "Voting has ended",
                            style: TextStyle(
                              color: isVoting
                                  ? Colors.green
                                  : hasNotStarted
                                      ? Colors.blue
                                      : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentState ? "Vote Paused" : "Vote Not Paused",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: MaterialButton(
                                  onPressed: () async {
                                    bool currentState = ref
                                        .read(contractProvider.notifier)
                                        .isVotingPaused();
                                    await ref
                                        .read(contractProvider.notifier)
                                        .pause(!currentState);
                                  },
                                  color:
                                      currentState ? Colors.green : Colors.red,
                                  child: contractState is VotePausingState
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : Text(currentState ? 'Resume' : "Pause"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeCard({
    required String title,
    required Duration? duration,
    required bool isActive,
  }) {
    return Expanded(
      child: Card(
        elevation: 2,
        color: isActive ? Colors.indigo.shade50 : Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        color: isActive ? Colors.indigo : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      formatDuration(duration),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.indigo : Colors.grey,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: value == "Not set" ? Colors.grey : Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
