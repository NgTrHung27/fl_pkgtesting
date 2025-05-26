import 'package:easy_localization/easy_localization.dart';
import 'package:fl_pkgtesting/constants/key_translate.dart';
import 'package:fl_pkgtesting/themes/colors.dart';
import 'package:flutter/material.dart';

typedef ItemBuilder<T> = Widget? Function(
  MultiSelectDialogItem<T> item,
  bool? checked,
  ValueChanged<bool?>? onChangeItem,
);

typedef HeaderBuilder<T> = Widget? Function(
  Function() onSubmitTap,
  Function(String?, String?, String?)? onSearch,
);

class MultiSelectDialogItem<T> {
  const MultiSelectDialogItem(
    this.value,
    this.label,
    this.detail,
  );

  final T value;
  final String? label;
  final T detail;
}

class MultiSelectDialog<T> extends StatefulWidget {
  final List<MultiSelectDialogItem<T>>? items;
  final List<T>? initialSelectedValues;
  final List<T> unModifiledValues;
  final String? okButtonLabel;
  final String? cancelButtonLabel;
  final TextStyle? labelStyle;
  final ShapeBorder? dialogShapeBorder;
  final Color? checkBoxCheckColor;
  final Color? checkBoxActiveColor;
  final ItemBuilder<T>? itemBuilder;
  final HeaderBuilder<T>? headerBuilder;
  final String valueField;
  final bool isSinglePicker;
  final bool required;
  final String title;
  final ValueChanged<List<T>>? onSubmit;
  final EdgeInsetsGeometry? paddingItem;
  final bool isClearSeleted;
  final ValueChanged<List<T>>? onFieldSubmitted; // Add by Quang Thanh to handle on Submit to easy access value

  const MultiSelectDialog({
    super.key,
    this.items,
    this.initialSelectedValues,
    required this.valueField,
    this.okButtonLabel,
    this.cancelButtonLabel,
    this.labelStyle,
    this.dialogShapeBorder,
    this.checkBoxActiveColor,
    this.checkBoxCheckColor,
    this.itemBuilder,
    this.isSinglePicker = false,
    this.headerBuilder,
    this.onSubmit,
    this.paddingItem,
    required this.title,
    this.isClearSeleted = false,
    this.unModifiledValues = const [],
    this.required = false,
    this.onFieldSubmitted,
  });

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<T>();
}

class _MultiSelectDialogState<T> extends State<MultiSelectDialog<T>> {
  List<T> _selectedValues = <T>[];
  List<MultiSelectDialogItem<T>> resultList = <MultiSelectDialogItem<T>>[];

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues!);
    }
    resultList.addAll(widget.items!);
    // Add logic sort by Hoang Nguyen
    resultList.sort((a, b) {
      bool aSelected = _selectedValues.contains(a.value);
      bool bSelected = _selectedValues.contains(b.value);

      if (aSelected && bSelected) {
        return _selectedValues.indexOf(a.value) - _selectedValues.indexOf(b.value);
      }

      if (aSelected && !bSelected) {
        return -1;
      }

      if (!aSelected && bSelected) {
        return 1;
      }

      return 0;
    });
    // End
  }

  void _onItemCheckedChange(T itemValue, bool? checked) {
    setState(() {
      if (checked == null) return;

      if (!checked && widget.unModifiledValues.contains(itemValue)) return;

      if (widget.isSinglePicker) {
        if (checked) {
          _selectedValues = [itemValue];
        } else {
          if (!widget.required || (widget.required && _selectedValues.length > 1)) _selectedValues.remove(itemValue);
        }
        _onSubmitTap();
      } else {
        if (checked) {
          _selectedValues.add(itemValue);
        } else {
          if (!widget.required || (widget.required && _selectedValues.length > 1)) _selectedValues.remove(itemValue);
        }
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() async {
    if (widget.onFieldSubmitted != null) widget.onFieldSubmitted!(_selectedValues); //modified by Quang Thanh
    Navigator.pop(context, _selectedValues);
  }

  void _onSearch(String? key, String? fieldSearch, String? matchCondition) {
    List<MultiSelectDialogItem<T>> result = [];
    if (fieldSearch != null && fieldSearch == 'users_department') {
      result = widget.items!.where((e) {
        Map? detailMap = e.detail as Map?;
        if (detailMap != null && detailMap.containsKey(fieldSearch)) {
          final normalizedKey = matchCondition;
          final normalizedLabel = detailMap[fieldSearch].toString();
          final regex = RegExp(RegExp.escape(normalizedKey!), caseSensitive: false);
          return regex.hasMatch(normalizedLabel);
        }

        return false;
      }).toList();

      if (key != null && key.isNotEmpty) {
        result = result.where((e) {
          Map? detailMap = e.detail as Map?;
          return detailMap != null &&
              ((detailMap['full_name'] != null &&
                      detailMap.containsKey('full_name') &&
                      detailMap['full_name']!.toString().toLowerCase().contains(key.toLowerCase())) ||
                  (detailMap['email1'] != null &&
                      detailMap.containsKey('email1') &&
                      detailMap['email1']!.toString().toLowerCase().contains(key.toLowerCase())) ||
                  (detailMap['email'] != null &&
                      detailMap.containsKey('email') &&
                      detailMap['email']!.toString().toLowerCase().contains(key.toLowerCase())));
        }).toList();
      }
    } else if ((matchCondition == null || matchCondition.isEmpty) && key != null) {
      result = widget.items!.where((e) {
        Map? detailMap = e.detail as Map?;
        return detailMap != null &&
            ((detailMap['full_name'] != null &&
                    detailMap.containsKey('full_name') &&
                    detailMap['full_name']!.toString().toLowerCase().contains(key.toLowerCase())) ||
                (detailMap['email1'] != null &&
                    detailMap.containsKey('email1') &&
                    detailMap['email1']!.toString().toLowerCase().contains(key.toLowerCase())) ||
                (detailMap['email'] != null &&
                    detailMap.containsKey('email') &&
                    detailMap['email']!.toString().toLowerCase().contains(key.toLowerCase())));
      }).toList();
    }
    setState(() {
      resultList = result;
    });
  }

  _onClearSelected() {
    if (_selectedValues.isNotEmpty) {
      setState(() {
        _selectedValues.removeWhere((element) => !widget.unModifiledValues.contains(element));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    Widget? headerWidget = widget.headerBuilder?.call(_onSubmitTap, (key, fieldSearch, matchCondition) {
      _onSearch(key, fieldSearch, matchCondition);
    });
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: 0.6 * maxHeight + MediaQuery.of(context).viewInsets.bottom,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Container(
                height: 8,
                width: 50,
                decoration: BoxDecoration(
                  color: grey7Color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            headerWidget ??
                Container(
                  color: Colors.white,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: _onCancelTap,
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: grey4Color,
                            ),
                          ),
                          !widget.isSinglePicker
                              ? TextButton(
                                  onPressed: _onSubmitTap,
                                  child: Text(
                                    doneKey.tr(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
            if (widget.isClearSeleted && _selectedValues.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 10),
                child: Material(
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onTap: () {
                          _onClearSelected();
                        },
                        splashColor: grey2Color,
                        child: Text(
                          "${unTickAllKey.tr()} (${_selectedValues.length})",
                          style: const TextStyle(
                            color: primaryColor,
                            // fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        )),
                  ),
                ),
              ),
            Expanded(
              child: resultList.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(noDataKey.tr()),
                    )
                  : ListView.builder(
                      padding: MediaQuery.of(context).viewInsets.bottom > 0
                          ? EdgeInsets.only(bottom: maxHeight * 0.3)
                          : EdgeInsets.zero,
                      itemCount: resultList.length,
                      itemBuilder: (context, index) {
                        return _buildItem(resultList[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(MultiSelectDialogItem<T> item) {
    final checked = _selectedValues.contains(item.value);

    Widget? itemWidget = widget.itemBuilder?.call(
      item,
      checked,
      (checked) {
        _onItemCheckedChange(
          item.value,
          checked,
        );
      },
    );

    if (itemWidget != null) {
      return itemWidget;
    }

    return Container(
      padding: widget.paddingItem ?? const EdgeInsets.only(left: 16, right: 16, bottom: 10),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: checked ? Border.all(width: 1.0, color: primaryColor) : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: CheckboxListTile(
          value: checked,
          title: Text(
            item.label ?? "",
            style: widget.labelStyle,
          ),
          tileColor: Colors.white,
          activeColor: widget.checkBoxActiveColor ?? Colors.transparent,
          checkColor: widget.checkBoxCheckColor ?? primaryColor,
          side: WidgetStateBorderSide.resolveWith(
            (states) => const BorderSide(color: Colors.white),
          ),
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (checked) => _onItemCheckedChange(item.value, checked),
        ),
      ),
    );
  }
}
