import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/order_model.dart';

class OrderCountdownTimer extends StatefulWidget {
  final OrderStatus status;
  final DateTime endDate;
  final bool shouldRun, displayClock;

  const OrderCountdownTimer({
    super.key,
    required this.status,
    required this.endDate,
    this.displayClock = false,
    this.shouldRun = true,
  });

  @override
  State<OrderCountdownTimer> createState() => _OrderCountdownTimerState();
}

class _OrderCountdownTimerState extends State<OrderCountdownTimer> {
  late Duration totalDuration;
  late Duration remaining;
  Timer? timer; // ✅ nullable

  @override
  void initState() {
    super.initState();
    totalDuration = widget.endDate.difference(DateTime.now());
    _updateRemaining();

    if (widget.shouldRun) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateRemaining();
      });
    }
  }

  void _updateRemaining() {
    final now = DateTime.now();
    setState(() {
      remaining = widget.endDate.difference(now);
      if (remaining.isNegative) {
        remaining = Duration.zero;
        timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF007BFF);

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(remaining.inHours);
    final minutes = twoDigits(remaining.inMinutes.remainder(60));
    final seconds = twoDigits(remaining.inSeconds.remainder(60));

    String timeText = remaining.inMinutes >= 60
        ? "$hours:$minutes:$seconds"
        : "$minutes:$seconds";

    final progress = remaining.inSeconds > 0
        ? remaining.inSeconds / totalDuration.inSeconds
        : 0.0;

    final isCritical = remaining.inMinutes < 5;
    final clockColor = isCritical ? Colors.red : primaryBlue;
    final clockInsideColor = isCritical ? Colors.red : Colors.black;
    final clockBGColor = isCritical
        ? Colors.red.withOpacity(0.1)
        : Colors.grey.shade300;
    final textColor = isCritical ? Colors.red : Colors.black;

    return Row(
      spacing: 12,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.displayClock)
          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  backgroundColor: clockBGColor,
                  valueColor: AlwaysStoppedAnimation<Color>(clockColor),
                ),
                Icon(Icons.access_time, size: 16, color: clockInsideColor),
              ],
            ),
          ),
        Text(
          progress == 0 && widget.status == OrderStatus.pickup
              ? S.current.ready_to_pickup
              : timeText,
          style: TextStyle(
            fontWeight: widget.displayClock ? FontWeight.bold : FontWeight.w600,
            fontSize: widget.displayClock ? 16 : 15,
            color: progress == 0 && widget.status == OrderStatus.pickup
                ? Colors.orange
                : textColor,
          ),
        ),
      ],
    );
  }
}
