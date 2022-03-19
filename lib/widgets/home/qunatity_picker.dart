import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuantityPicker extends StatefulWidget {
  final double? width, height;
  final int minValue, maxValue, initValue;
  final Color? backgroundColor, textColor;
  final Function(int, QuantityAction)? quantittyChanged;
  const QuantityPicker({
    Key? key,
    this.width,
    this.height,
    this.minValue = 0,
    this.maxValue = 999,
    this.initValue = 0,
    this.quantittyChanged,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  State<QuantityPicker> createState() => _QuantityPickerState();
}

class _QuantityPickerState extends State<QuantityPicker> {
  late final _QuantityNotifier _quantityNotifier;
  int _currentValue = 0;
  @override
  void initState() {
    super.initState();
    _currentValue = widget.initValue;
    _quantityNotifier = _QuantityNotifier(_currentValue);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentValue != widget.initValue) {
      _currentValue = widget.initValue;
    }
    if (_currentValue != _quantityNotifier._value) {
      _quantityNotifier.reset(newValue: _currentValue);
    }
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 35,
      decoration: BoxDecoration(
          color: widget.backgroundColor ?? const Color(0xFF4BB050),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
                onTap: () {
                  if (_currentValue <= widget.minValue) {
                    return;
                  }
                  _currentValue--;
                  _quantityNotifier.value = _currentValue;
                  _quantityUpdated(QuantityAction.DECREMENT);
                },
                child: Center(
                    child: Icon(Icons.remove,
                        color: widget.textColor ?? Colors.white))),
          ),
          Expanded(
              child: Center(
                  child: ChangeNotifierProvider<_QuantityNotifier>.value(
            value: _quantityNotifier,
            child: Builder(builder: (context) {
              final _provider = context.watch<_QuantityNotifier>();
              return Text(
                '${_provider.value}',
                style: TextStyle(
                    fontSize: 16, color: widget.textColor ?? Colors.white),
              );
            }),
          ))),
          Expanded(
              child: InkWell(
            onTap: () {
              if (_currentValue >= widget.maxValue) {
                return;
              }
              _currentValue++;
              _quantityNotifier.value = _currentValue;
              _quantityUpdated(QuantityAction.INCREMENT);
            },
            child: Center(
                child:
                    Icon(Icons.add, color: widget.textColor ?? Colors.white)),
          )),
        ],
      ),
    );
  }

  void _quantityUpdated(QuantityAction quantityAction) {
    widget.quantittyChanged?.call(_currentValue, quantityAction);
  }

  @override
  void dispose() {
    _quantityNotifier.dispose();
    super.dispose();
  }
}

enum QuantityAction { INCREMENT, DECREMENT }

class _QuantityNotifier extends ChangeNotifier {
  int _value = 0;

  _QuantityNotifier(this._value);

  int get value => _value;
  set value(newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }

  void reset({newValue = 0}) {
    _value = newValue;
  }
}
