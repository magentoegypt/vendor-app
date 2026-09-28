import 'package:flutter/material.dart';


class SaleStatsWidget extends StatelessWidget {
  final title;
  final amount;
  final Color? color;
  final Gradient? gradient;

  const SaleStatsWidget({
    super.key,
    required this.title,
    required this.amount,
    this.color,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: color ?? Theme.of(context).primaryColorLight,
          gradient: gradient,
        ),
        height: 120,
        // The small blue tab that sat in the top-right corner is gone: it had
        // no function and covered the label in Arabic.
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: gradient != null
                      ? Colors.white
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 5),
              // One line whatever the amount: "AED 24,993.00" used to break
              // before ".00". Long amounts shrink to fit the card instead.
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  amount,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: gradient != null
                            ? Colors.white
                            : Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
