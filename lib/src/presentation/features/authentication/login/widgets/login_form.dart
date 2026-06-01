part of '../view/login_page.dart';

class _LoginForm extends StatefulWidget {
  const _LoginForm({required this.controller});

  final TextEditingController controller;

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: context.locale.enterPhoneNumber,
          ),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: context.validator.apply([RequiredValidation()]),
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
        ),
      ],
    );
  }
}
