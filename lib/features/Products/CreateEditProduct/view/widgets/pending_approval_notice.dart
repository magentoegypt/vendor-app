import 'package:flutter/material.dart';

import '../../../../../core/config/locator.dart';

/// Says why the form shows a product as it was: its latest edit waits for the
/// admin (Pending Update), or the new product has yet to be approved (Pending
/// New). QA read the old details on reopening as the edit reverting.
class PendingApprovalNotice extends StatelessWidget {
  const PendingApprovalNotice({super.key, required this.approval});

  /// The product's approval value ('1' Pending New, '4' Pending Update); any
  /// other value shows nothing.
  final String? approval;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final message = approval == '4'
        ? texts.pendingChangesNotice
        : approval == '1'
            ? texts.pendingNewNotice
            : null;
    if (message == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.hourglass_top, size: 20, color: Colors.orange.shade800),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: TextStyle(fontSize: 14, color: Colors.orange.shade900)),
          ),
        ],
      ),
    );
  }
}
