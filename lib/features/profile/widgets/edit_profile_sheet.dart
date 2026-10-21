// import 'package:flutter/material.dart';

// import '../../../core/app_colors.dart';
// import '../../../core/app_theme.dart';
// import '../../../core/state/user_controller.dart';
// import '../../../core/utils/validators.dart';
// import '../../../core/widgets/app_text_field.dart';
// import '../../onboarding/widgets/onboarding_buttons.dart';

// /// بيفتح ورقة سفلية لتعديل الاسم والإيميل (بنفس قواعد التحقق بتاعة التسجيل).
// Future<void> showEditProfileSheet(BuildContext context) {
//   return showModalBottomSheet<void>(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: AppColors.surface,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
//     ),
//     builder: (_) => const _EditProfileForm(),
//   );
// }

// class _EditProfileForm extends StatefulWidget {
//   const _EditProfileForm();

//   @override
//   State<_EditProfileForm> createState() => _EditProfileFormState();
// }

// class _EditProfileFormState extends State<_EditProfileForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameCtrl = TextEditingController(text: UserController.instance.name.value);
//   final _emailCtrl = TextEditingController(text: UserController.instance.email.value);

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _emailCtrl.dispose();
//     super.dispose();
//   }

//   void _save() {
//     if (!(_formKey.currentState?.validate() ?? false)) return;
//     UserController.instance
//         .setProfile(name: _nameCtrl.text.trim(), email: _emailCtrl.text.trim());
//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.fromLTRB(
//           20, 14, 20, 22 + MediaQuery.of(context).viewInsets.bottom),
//       child: Form(
//         key: _formKey,
//         autovalidateMode: AutovalidateMode.onUserInteraction,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: AppColors.surfaceHigh,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text('Edit Profile', style: AppText.heading(20, weight: FontWeight.w700)),
//             const SizedBox(height: 18),
//             AppTextField(
//               label: 'Full Name',
//               controller: _nameCtrl,
//               hint: 'Fatma Hassan',
//               prefixIcon: Icons.person_outline,
//               textInputAction: TextInputAction.next,
//               validator: Validators.fullName,
//             ),
//             const SizedBox(height: 16),
//             AppTextField(
//               label: 'Email Address',
//               controller: _emailCtrl,
//               hint: 'you@example.com',
//               prefixIcon: Icons.mail_outline,
//               keyboardType: TextInputType.emailAddress,
//               textInputAction: TextInputAction.done,
//               validator: Validators.email,
//             ),
//             const SizedBox(height: 22),
//             PrimaryButton(label: 'Save changes', onPressed: _save),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/state/user_controller.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../onboarding/widgets/onboarding_buttons.dart';

/// بيفتح ورقة سفلية لتعديل الاسم (الإيميل للعرض فقط). التعديل بيتحفظ في السحابة تلقائيًا.
Future<void> showEditProfileSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (_) => const _EditProfileForm(),
  );
}

class _EditProfileForm extends StatefulWidget {
  const _EditProfileForm();

  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: UserController.instance.name.value);
  final _emailCtrl = TextEditingController(text: UserController.instance.email.value);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    UserController.instance
        .setProfile(name: _nameCtrl.text.trim());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
          20, 14, 20, 22 + MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Edit Profile', style: AppText.heading(20, weight: FontWeight.w700)),
            const SizedBox(height: 18),
            AppTextField(
              label: 'Full Name',
              controller: _nameCtrl,
              hint: 'Fatma Hassan',
              prefixIcon: Icons.person_outline,
              textInputAction: TextInputAction.next,
              validator: Validators.fullName,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Email Address',
              controller: _emailCtrl,
              hint: 'you@example.com',
              prefixIcon: Icons.mail_outline,
              readOnly: true, // الإيميل هو هوية الحساب في Firebase — مش بيتعدل من هنا.
            ),
            const SizedBox(height: 22),
            PrimaryButton(label: 'Save changes', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
