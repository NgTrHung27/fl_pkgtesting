// ignore_for_file: overridden_fields, annotate_overrides

import 'dart:convert';

import 'package:fl_pkgtesting/themes/colors.dart';
import 'package:fl_pkgtesting/widgets/selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

typedef WidgetBuilder<T> = Widget? Function(
  T selectedList,
);

class MultiSelectFormFieldCG extends FormBuilderFieldDecoration<dynamic> {
  final String title;
  final Widget hintWidget;
  final bool required;
  final String errorText;
  final List<Map<String, dynamic>> dataSource;
  final List<dynamic> unModifiledValues;
  final String textField;
  final String valueField;
  final Function? change;
  final Function? open;
  final Function? close;
  final Widget? leading;
  final Widget? trailing;
  final String okButtonLabel;
  final String cancelButtonLabel;
  final Color? fillColor;
  final InputBorder? border;
  final TextStyle? chipLabelStyle;
  final Color? chipBackGroundColor;
  final TextStyle dialogTextStyle;
  final ShapeBorder dialogShapeBorder;
  final Color? checkBoxCheckColor;
  final Color? checkBoxActiveColor;
  final bool enabled;
  final String name;
  final TextStyle? titleStyle;
  final ItemBuilder? itemBuilder;
  final WidgetBuilder? widgetBuilder;
  final HeaderBuilder? headerBuilder;
  final bool isSinglePicker;
  final ValueChanged<List>? onSubmit;
  final EdgeInsetsGeometry? paddingItem;
  final bool isClearSelected;
  final bool filled;

  MultiSelectFormFieldCG({
    super.key,
    super.onSaved,
    super.onChanged,
    super.validator,
    super.initialValue,
    this.unModifiledValues = const [],
    AutovalidateMode autovalidate = AutovalidateMode.disabled,
    this.title = 'Title',
    this.titleStyle,
    this.hintWidget = const Text('Tap to select one or more'),
    this.required = false,
    this.errorText = 'Please select one or more options',
    this.leading,
    required this.dataSource,
    required this.textField,
    required this.valueField,
    required this.name,
    this.change,
    this.open,
    this.close,
    this.okButtonLabel = 'OK',
    this.cancelButtonLabel = 'CANCEL',
    this.fillColor,
    this.border,
    this.trailing,
    this.chipLabelStyle,
    this.enabled = true,
    this.chipBackGroundColor,
    this.onSubmit,
    this.dialogTextStyle = const TextStyle(color: Colors.black),
    this.paddingItem,
    this.dialogShapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(0.0)),
    ),
    this.checkBoxActiveColor,
    this.checkBoxCheckColor,
    this.itemBuilder,
    this.widgetBuilder,
    this.headerBuilder,
    this.isSinglePicker = false,
    this.isClearSelected = false,
    this.filled = false,
  }) : super(
          autovalidateMode: autovalidate,
          name: name,
          builder: (FormFieldState state) {
            List<String> buildSelectedOptionsList(state) {
              try {
                List<String> selectedOptions = [];

                if (state.value != null) {
                  List<dynamic> values;

                  if (state.value is String) {
                    try {
                      values = jsonDecode(state.value);
                    } catch (e) {
                      values = [state.value];
                    }
                  } else if (state.value is List) {
                    values = state.value;
                  } else {
                    values = [];
                  }

                  for (var item in values) {
                    if (item == "" || item == null) continue;
                    var existingItem = dataSource.singleWhere(((itm) {
                      if (item is int) {
                        return (itm[valueField] == item.toString());
                      } else {
                        return (itm[valueField] == item);
                      }
                    }), orElse: () => {});

                    if (existingItem[textField] != null && existingItem[textField] != '') {
                      selectedOptions.add(existingItem[textField]);
                    }
                  }
                }
                return selectedOptions;
              } catch (e) {
                return [];
              }
            }

            Widget? builder = widgetBuilder?.call(state.value);
            return InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: !enabled
                  ? null
                  : () async {
                      List? initialSelected;
                      if (state.value is String) {
                        try {
                          initialSelected =
                              List<String>.from(jsonDecode(state.value as String).map((item) => item.toString()));
                        } catch (e) {
                          initialSelected ??= [];
                        }
                      } else {
                        initialSelected = state.value;
                      }
                      initialSelected ??= [];

                      final items = <MultiSelectDialogItem<dynamic>>[];
                      for (var item in dataSource) {
                        items.add(MultiSelectDialogItem(item[valueField], item[textField], item));
                      }
                      List<dynamic>? selectedValues = await showModalBottomSheet<List>(
                        context: state.context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return MultiSelectDialog(
                            paddingItem: paddingItem,
                            onSubmit: onSubmit,
                            okButtonLabel: okButtonLabel,
                            cancelButtonLabel: cancelButtonLabel,
                            items: items,
                            initialSelectedValues: initialSelected,
                            labelStyle: dialogTextStyle,
                            dialogShapeBorder: dialogShapeBorder,
                            checkBoxActiveColor: checkBoxActiveColor,
                            checkBoxCheckColor: checkBoxCheckColor,
                            itemBuilder: itemBuilder,
                            headerBuilder: headerBuilder,
                            valueField: valueField,
                            isSinglePicker: isSinglePicker,
                            title: title,
                            isClearSeleted: isClearSelected,
                            unModifiledValues: unModifiledValues,
                            required: required,
                          );
                        },
                      );
                      if (FocusManager.instance.primaryFocus?.hasFocus == true) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                      if (selectedValues != null) {
                        state.didChange(selectedValues);
                        state.save();
                        if (onSubmit != null) onSubmit(selectedValues);
                      }
                    },
              child: builder ??
                  InputDecorator(
                    decoration: InputDecoration(
                      errorText: state.hasError ? state.errorText : null,
                      errorMaxLines: 4,
                      fillColor: fillColor ?? Theme.of(state.context).canvasColor,
                      filled: fillColor != null ? true : false,
                      // Fix Radius mockup by Hoang Nguyen on 03-04-2024
                      border: border ??
                          OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: grey7Color, width: 1),
                          ),
                      disabledBorder: border ??
                          OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: grey7Color, width: 1),
                          ),
                      enabledBorder: border ??
                          OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: grey7Color, width: 1),
                          ),
                      focusedBorder: border ??
                          OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xff3B72F2), width: 1),
                          ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    isEmpty: state.value == null || state.value == '' || state.value.length == 0,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: (state.value == null || state.value.length == 0)
                                  ? Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: Text(
                                            title,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: titleStyle ??
                                                const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: grey8Color,
                                                  height: 22 / 16,
                                                ),
                                          ),
                                        ),
                                        required
                                            ? Padding(
                                                padding: const EdgeInsets.only(top: 5, right: 5),
                                                child: Text(
                                                  ' *',
                                                  style: TextStyle(
                                                    color: Colors.red.shade700,
                                                    fontSize: 17.0,
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                title != ''
                                                    ? Text(
                                                        title,
                                                        style: titleStyle ??
                                                            (state.value != null && state.value.length > 0
                                                                ? const TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w400,
                                                                    color: Color(0xff3B72F2),
                                                                  )
                                                                : const TextStyle(
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w400,
                                                                    color: Color(0xff3B72F2),
                                                                  )),
                                                      )
                                                    : Container(),
                                                required
                                                    ? Padding(
                                                        padding: const EdgeInsets.only(top: 5, right: 5),
                                                        child: Text(
                                                          ' *',
                                                          style: TextStyle(
                                                            color: Colors.red.shade700,
                                                            fontSize: 17.0,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ],
                                        ),
                                        state.value != null && state.value.length > 0
                                            ? Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                                child: state.value != null && state.value.length > 0
                                                    ? RichText(
                                                        text: TextSpan(
                                                          children: buildSelectedOptionsList(state)
                                                              .asMap()
                                                              .entries
                                                              .map((entry) {
                                                            int idx = entry.key;
                                                            String text = entry.value;

                                                            return TextSpan(
                                                              text: text +
                                                                  (idx < buildSelectedOptionsList(state).length - 1
                                                                      ? ', '
                                                                      : ''),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: idx == 0
                                                                    ? const Color(0xff1B74E4)
                                                                    : raisinBlackColor, // Màu xanh cho phần tử đầu tiên
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      )
                                                    : Container(
                                                        padding: const EdgeInsets.only(top: 4),
                                                        child: hintWidget,
                                                      ),
                                              )
                                            : Container(
                                                alignment: Alignment.centerLeft,
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                child: Text(
                                                  title,
                                                  textAlign: TextAlign.center,
                                                  style: titleStyle ??
                                                      const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w400,
                                                        color: grey8Color,
                                                        height: 22 / 16,
                                                      ),
                                                ),
                                              ),
                                      ],
                                    ),
                            ),
                            const Icon(
                              Icons.expand_more_rounded,
                              color: grey8Color,
                              size: 25,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            );
          },
        );
}
