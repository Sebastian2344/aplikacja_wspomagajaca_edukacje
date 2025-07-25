import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/create_or_edit_quiz_cubit.dart';

class BackToList extends StatelessWidget {
  const BackToList({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          context.read<CreateOrEditQuizCubit>().returnToQuizList();
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back));
  }
}
