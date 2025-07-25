import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/create_or_edit_quiz_cubit.dart';

class ButtonBack extends StatelessWidget {
  const ButtonBack({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pop();
          context.read<CreateOrEditQuizCubit>().backToInitial();
        },
        icon: const Icon(Icons.arrow_back));
  }
}
