import 'package:flutter/material.dart';
import 'package:pokeapi_wrapper/pokeapi_wrapper.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({super.key, required this.unselectedTypes});

  final Set<String> unselectedTypes;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Filter"),
      content: SizedBox(
        width: double.maxFinite,
        child: FilterDialogBody(
          unselectedTypes: unselectedTypes,
          onChanged: (name, value) {
            if (!value) {
              unselectedTypes.add(name);
            } else {
              unselectedTypes.remove(name);
            }
          },
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(unselectedTypes);
          },
        ),
      ],
    );
  }
}

class FilterDialogBody extends FutureBuilderWidget<List<TypeApiResource>> {
  final void Function(String type, bool value) onChanged;

  final Set<String> unselectedTypes;
  const FilterDialogBody(
      {super.key, required this.onChanged, required this.unselectedTypes});

  @override
  Future<Either<Error, List<TypeApiResource>>> get future =>
      PokeApi.getTypeList();

  @override
  Widget onWaiting(BuildContext context) => const CircularProgressIndicator();

  @override
  Widget onError(BuildContext context, Error error) =>
      Container(color: Colors.white);

  @override
  Widget onSuccess(BuildContext context, List<TypeApiResource> value) =>
      ListView.builder(
        itemCount: value.length,
        itemBuilder: (context, index) => _FilterDialogItem(
          value[index],
          onChanged: onChanged,
          unselectedTypes: unselectedTypes,
        ),
      );
}

class _FilterDialogItem extends FutureBuilderWidget<Type> {
  final TypeApiResource typeApiResource;
  final void Function(String type, bool value) onChanged;
  final Set<String> unselectedTypes;
  const _FilterDialogItem(this.typeApiResource,
      {required this.onChanged, required this.unselectedTypes});

  @override
  Future<Either<Error, Type>> get future => typeApiResource.getType();

  @override
  Widget onError(BuildContext context, Error error) {
    return const Text("Error while loading");
  }

  @override
  Widget onSuccess(BuildContext context, Type value) {
    bool checked = !unselectedTypes.contains(value.name);

    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return CheckboxListTile(
          value: checked,
          title: Text(value.name),
          onChanged: (v) {
            onChanged(value.name, v ?? false);
            setState(() {
              checked = !checked;
            });
          },
        );
      },
    );
  }

  @override
  Widget onWaiting(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
