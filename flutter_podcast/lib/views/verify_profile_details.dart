import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_podcast/router.dart';
import 'package:flutter_podcast/services/auth_service.dart';
import 'package:flutter_podcast/utils/constants.dart';
import 'package:flutter_podcast/widgets/constants.dart';
import 'package:flutter_podcast/widgets/flutter_podcast_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:string_validator/string_validator.dart' as validator;

class UpdateProfileDetails extends StatefulWidget {
  final FlutterPodcastUser user;
  final String title;
  const UpdateProfileDetails(
      {Key? key, required this.user, required this.title})
      : super(key: key);

  @override
  State<UpdateProfileDetails> createState() => _UpdateProfileDetailsState();
}

class _UpdateProfileDetailsState extends State<UpdateProfileDetails> {
  late final TextEditingController _nameController;
  final FocusNode _nameNode = FocusNode();

  String? _nameErrors;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.user.user.displayName);
    _nameErrors = _verifyName(widget.user.user.displayName ?? '');
    _nameController.addListener(() => _updateNameErrors());
  }

  void _updateNameErrors() {
    setState(() {
      _nameErrors = _verifyName(_nameController.text);
    });
  }

  bool get _canSubmit => _nameErrors == null && !_isLoading;

  String? _verifyName(String value) {
    if (value.isEmpty) {
      return 'Please enter a name';
    }
    List<String> errors = <String>[];
    if (!validator.isAlpha(value)) {
      errors.add('Only letters with no spaces are allowed ');
    }

    if (value.length < 3) {
      errors.add('Must be at least 3 letters');
    }

    if (errors.isEmpty) {
      return null;
    } else {
      if (errors.length == 1) {
        return errors.first;
      } else {
        final stringBuffer = StringBuffer();
        for (int i = 0; i < errors.length; i++) {
          final element = errors[i];
          stringBuffer.write("(${i + 1}) $element");
          if (i + 1 < errors.length) {
            stringBuffer.write('\n');
          }
        }

        return stringBuffer.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.user.isVerified
            ? IconButton(
                onPressed: () =>
                    context.goNamed(FlutterPodcastMainRouter.kHomeName),
                icon: const Icon(Icons.arrow_back_ios),
              )
            : null,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () => widget.user.signOut(),
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SimpleDialog(
        contentPadding: const EdgeInsets.all(12),
        children: [
          h8SizedBox,
          FlutterPodcastTextField(
            focusNode: _nameNode,
            textInputAction: TextInputAction.done,
            hintText: 'Jane',
            labelText: 'Display Name',
            errorText: _nameErrors,
            onSubmitted: _canSubmit ? (value) => _submit() : null,
            keyboardType: TextInputType.name,
            controller: _nameController,
          ),
          h8SizedBox,
          SizedBox(
            height: 2 * kToolbarHeight,
            child: ClipRRect(
              borderRadius: borderRadius20,
              child: GradientBackground(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.white38,
                              child: InkWell(
                                onTap: () {},
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.male),
                                      w8SizedBox,
                                      Text('male')
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const VerticalDivider(
                            width: 1,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.female),
                                    w8SizedBox,
                                    Text('female')
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.transgender),
                              w8SizedBox,
                              Text(
                                'non-binary',
                                maxLines: 2,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          h8SizedBox,
          SizedBox(
            height: kToolbarHeight,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canSubmit ? _submit : null,
                    child: const Text('submit'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: kToolbarHeight,
            child: _isLoading
                ? const Center(
                    child: LinearProgressIndicator(),
                  )
                : Container(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.help),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Center(child: Text('Info')),
            contentPadding: const EdgeInsets.all(12),
            children: [
              const Text(
                'The more data points we can collect then the better we can suggest podcasts',
              ),
              h8SizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('That\'s weird')),
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Ok')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    _setLoadingState(true);
    try {
      if (_nameErrors != null) {
        throw _nameErrors!;
      }
      await widget.user.user.updateDisplayName(_nameController.text);
      await AuthService.instance.syncUserInformation();
      context.goNamed(FlutterPodcastMainRouter.kHomeName);
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('An Error Occurred'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                child: Text(
                  e.toString(),
                ),
              ),
              SizedBox(
                height: kToolbarHeight,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ok'),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
    _setLoadingState(false);
  }

  void _setLoadingState(bool loadingEvent) {
    if (mounted) {
      setState(() {
        _isLoading = loadingEvent;
      });
    }
  }
}
