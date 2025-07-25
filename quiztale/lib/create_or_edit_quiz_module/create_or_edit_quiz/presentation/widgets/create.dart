import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../quiz_panel/presentation/widgets/create_quiz_widget.dart';
import '../../cubit/create_or_edit_quiz_cubit.dart';

class Create extends StatelessWidget {
  const Create({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateOrEditQuizCubit, CreateOrEditQuizState>(
      listener: (context, state) {
        if (state is SuccessCreate) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.text)));
          context.read<CreateOrEditQuizCubit>().backToInitial();
          Navigator.of(context).pop();
        }
        if (state is CreateQuizError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error.error)));
          context.read<CreateOrEditQuizCubit>().backToInitial();
        }
      },
      child: const CreateQuizWidget(),
    );
  }
}
